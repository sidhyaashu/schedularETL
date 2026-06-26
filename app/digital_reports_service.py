import os
import re
import logging
import io
import time
from datetime import datetime
from zoneinfo import ZoneInfo
from ftplib import FTP
from sqlalchemy import text

from app.config import settings
from app.db import ENGINE
from app.ingestion_log import start_ingestion_log, finish_ingestion_log

logger = logging.getLogger("DigitalReports")

# Optional Azure Blob Storage import wrap
HAS_AZURE = False
try:
    from azure.storage.blob import BlobServiceClient
    HAS_AZURE = True
except ImportError:
    logger.warning("azure-storage-blob package not installed. Azure Blob upload will not be available.")

def get_now() -> datetime:
    return datetime.now(ZoneInfo(settings.timezone))

def get_already_downloaded_files() -> set[str]:
    """Retrieve all successfully downloaded file names from the database."""
    query = text("SELECT file_name FROM digital_reports WHERE status = 'SUCCESS'")
    with ENGINE.connect() as conn:
        result = conn.execute(query)
        return {row[0] for row in result}

def save_digital_report_metadata(fincode: int, report_type: str, year_end: int, file_name: str, path_or_url: str, status: str, error_message: str | None = None) -> None:
    """Upsert digital report metadata into the database."""
    query = text("""
        INSERT INTO digital_reports (fincode, report_type, year_end, file_name, azure_blob_url, status, error_message, downloaded_at)
        VALUES (:fincode, :report_type, :year_end, :file_name, :path_or_url, :status, :error_message, now())
        ON CONFLICT (fincode, report_type, year_end)
        DO UPDATE SET
            file_name = EXCLUDED.file_name,
            azure_blob_url = EXCLUDED.azure_blob_url,
            status = EXCLUDED.status,
            error_message = EXCLUDED.error_message,
            downloaded_at = now();
    """)
    with ENGINE.begin() as conn:
        conn.execute(query, {
            "fincode": fincode,
            "report_type": report_type,
            "year_end": year_end,
            "file_name": file_name,
            "path_or_url": path_or_url,
            "status": status,
            "error_message": error_message
        })

def upload_to_azure(file_data: bytes, blob_name: str) -> str:
    """Upload PDF data to Azure Blob Storage and return the URL."""
    if not HAS_AZURE:
        raise RuntimeError("Azure Blob Storage package is not installed.")
    
    blob_service_client = BlobServiceClient.from_connection_string(settings.azure_storage_connection_string)
    container_client = blob_service_client.get_container_client(settings.azure_storage_container_name)
    
    # Ensure container exists
    try:
        container_client.create_container()
    except Exception:
        # Container already exists or other error handled by client library
        pass
        
    blob_client = container_client.get_blob_client(blob_name)
    blob_client.upload_blob(file_data, overwrite=True)
    return str(blob_client.url)

def save_to_local_fallback(file_data: bytes, year: str, file_name: str) -> str:
    """Save PDF file locally as fallback and return local path/URI."""
    fallback_dir = os.path.join("data", "digital_reports", year)
    os.makedirs(fallback_dir, exist_ok=True)
    
    file_path = os.path.join(fallback_dir, file_name)
    with open(file_path, "wb") as f:
        f.write(file_data)
        
    # Standard format to represent local fallback paths
    return f"local://{file_path}"

def sync_local_to_azure_if_live() -> None:
    """Check if Azure credentials are set, and upload any locally stored fallback PDFs to Azure Blob Storage."""
    if not (HAS_AZURE and settings.azure_storage_connection_string):
        return

    logger.info("Azure connection string is live. Checking for local fallback files to synchronize...")
    
    query = text("""
        SELECT fincode, report_type, year_end, file_name, azure_blob_url 
        FROM digital_reports 
        WHERE status = 'SUCCESS' AND azure_blob_url LIKE 'local://%'
    """)
    
    local_records = []
    with ENGINE.connect() as conn:
        result = conn.execute(query)
        for row in result:
            local_records.append({
                "fincode": row[0],
                "report_type": row[1],
                "year_end": row[2],
                "file_name": row[3],
                "azure_blob_url": row[4]
            })
            
    if not local_records:
        logger.info("No local fallback files found to sync.")
        return
        
    logger.info(f"Found {len(local_records)} local fallback files. Starting sync to Azure...")
    
    success_count = 0
    for record in local_records:
        local_path = record["azure_blob_url"].replace("local://", "")
        if not os.path.exists(local_path):
            logger.warning(f"Local file not found at {local_path} for fincode {record['fincode']}. Skipping.")
            continue
            
        try:
            with open(local_path, "rb") as f:
                file_data = f.read()
                
            # e.g., year_end is 202503, YYYY is 2025
            year = str(record["year_end"])[:4]
            blob_name = f"{year}/{record['file_name']}"
            
            # Upload to Azure
            azure_url = upload_to_azure(file_data, blob_name)
            
            # Update database
            update_query = text("""
                UPDATE digital_reports 
                SET azure_blob_url = :azure_url, downloaded_at = now()
                WHERE fincode = :fincode AND report_type = :report_type AND year_end = :year_end
            """)
            with ENGINE.begin() as conn:
                conn.execute(update_query, {
                    "azure_url": azure_url,
                    "fincode": record["fincode"],
                    "report_type": record["report_type"],
                    "year_end": record["year_end"]
                })
                
            # Clean up local file to free up space
            try:
                os.remove(local_path)
            except Exception as e:
                logger.warning(f"Could not remove local file {local_path} after upload: {e}")
                
            success_count += 1
            logger.info(f"Synchronized {record['file_name']} to Azure successfully.")
            
        except Exception as e:
            logger.error(f"Failed to synchronize {record['file_name']} to Azure: {e}")
            
    logger.info(f"Local to Azure synchronization completed: {success_count}/{len(local_records)} files uploaded successfully.")

def process_digital_reports(target_date: str | None = None) -> dict:
    """
    Incremental download pipeline for Digital Reports:
    1. Discovers year directories on FTP under /DigitalReport/
    2. Filters out files already successfully stored in PostgreSQL
    3. Downloads and stores new files incrementally
    4. Logs metrics to ingestion_run_logs
    """
    # Auto-synchronize any pending local files if Azure goes live
    try:
        sync_local_to_azure_if_live()
    except Exception as e:
        logger.error(f"Error running local fallback sync: {e}")

    started_time = time.time()
    tz = ZoneInfo(settings.timezone)
    now_dt = datetime.now(tz)
    resolved_date = target_date or now_dt.strftime("%d%m%Y")
    
    # Resolve DB date representation
    db_date = datetime.strptime(resolved_date, "%d%m%Y").date()
    
    # Start DB run log
    log_id = start_ingestion_log(ENGINE, "DigitalReport", db_date)
    
    rows_received = 0
    rows_inserted = 0
    rows_updated = 0
    rows_deleted = 0
    rows_unchanged = 0
    rows_rejected = 0
    rejected_fincodes = []
    
    ftp = None
    try:
        # Load successfully downloaded files to prevent duplicate operations
        existing_success_files = get_already_downloaded_files()
        
        # Connect to FTP
        logger.info(f"Connecting to FTP server {settings.ftp_url} on port {settings.ftp_port}")
        ftp = FTP()
        ftp.connect(settings.ftp_url, settings.ftp_port, timeout=settings.api_timeout_seconds)
        ftp.login(settings.ftp_user, settings.ftp_password)
        ftp.prot_p() # Standard secure data connection setup (optional for plain FTP but safe to call)
        
        # Discover year directories
        ftp.cwd("/DigitalReport")
        dirs = ftp.nlst()
        year_dirs = [d for d in dirs if re.match(r"^\d{4}$", d)]
        
        if not year_dirs:
            # Fallback to current year if nlst() returns empty due to permissions
            year_dirs = [str(now_dt.year)]
            logger.warning(f"No year directories found on FTP. Fallback to current year: {year_dirs}")
            
        logger.info(f"Discovered year directories on FTP: {year_dirs}")
        
        # Naming pattern: {Fincode}-{ReportType}-{YearEnd}.pdf
        filename_pattern = re.compile(r"^(\d+)-([a-zA-Z0-9]+)-(\d{6})\.pdf$", re.IGNORECASE)
        
        files_to_process = []
        for year in sorted(year_dirs):
            try:
                ftp.cwd(f"/DigitalReport/{year}")
                year_files = ftp.nlst()
                for filename in year_files:
                    match = filename_pattern.match(filename)
                    if match:
                        rows_received += 1
                        if filename in existing_success_files:
                            rows_unchanged += 1
                        else:
                            files_to_process.append((year, filename, match))
            except Exception as e:
                logger.error(f"Error scanning directory for year {year}: {e}")
                
        total_to_process = len(files_to_process)
        logger.info(f"Digital Reports scan: total_files={rows_received}, already_downloaded={rows_unchanged}, new_to_download={total_to_process}")
        
        # Process files incrementally
        for idx, (year, filename, match) in enumerate(files_to_process, 1):
            fincode = int(match.group(1))
            report_type = match.group(2).upper()
            year_end = int(match.group(3))
            
            ftp.cwd(f"/DigitalReport/{year}")
            
            buf = io.BytesIO()
            try:
                # Download from FTP
                ftp.retrbinary(f"RETR {filename}", buf.write)
                file_data = buf.getvalue()
                
                # Upload to Azure or local fallback
                blob_name = f"{year}/{filename}"
                if HAS_AZURE and settings.azure_storage_connection_string:
                    try:
                        storage_url = upload_to_azure(file_data, blob_name)
                        logger.info(f"Uploaded {filename} to Azure Blob Storage successfully.")
                    except Exception as upload_err:
                        logger.error(f"Azure upload failed for {filename}, attempting local fallback: {upload_err}")
                        storage_url = save_to_local_fallback(file_data, year, filename)
                else:
                    storage_url = save_to_local_fallback(file_data, year, filename)
                    
                # Save metadata to DB
                save_digital_report_metadata(fincode, report_type, year_end, filename, storage_url, "SUCCESS")
                rows_inserted += 1
                
            except Exception as err:
                error_msg = str(err)
                logger.error(f"Failed processing file {filename}: {error_msg}")
                try:
                    save_digital_report_metadata(fincode, report_type, year_end, filename, "", "FAILED", error_message=error_msg[:500])
                except Exception as db_err:
                    logger.error(f"Failed to record FAILED status for {filename} in database: {db_err}")
                
                rows_rejected += 1
                rejected_fincodes.append(fincode)
                
            if idx % 100 == 0 or idx == total_to_process:
                logger.info(f"Progress: {idx}/{total_to_process} files processed ({rows_inserted} succeeded, {rows_rejected} failed)")
                
        status = "SUCCESS" if rows_rejected == 0 else "WARNINGS"
        if rows_received == 0:
            status = "NO_CONTENT"
            
        finish_ingestion_log(
            engine=ENGINE,
            log_id=log_id,
            status=status,
            http_status=200,
            rows_received=rows_received,
            rows_inserted=rows_inserted,
            rows_updated=rows_updated,
            rows_deleted=rows_deleted,
            rows_unchanged=rows_unchanged,
            rows_rejected=rows_rejected,
            rejected_fincodes=rejected_fincodes
        )
        
        duration = int(time.time() - started_time)
        logger.info(f"Digital Reports pipeline completed in {duration}s. Status={status}, received={rows_received}, downloaded={rows_inserted}, skipped={rows_unchanged}, failed={rows_rejected}")
        
        return {
            "status": status,
            "rows_received": rows_received,
            "processed_rows": rows_inserted,
            "rows_rejected": rows_rejected,
            "error_message": None
        }
        
    except Exception as e:
        error_msg = str(e)
        logger.exception(f"Digital Reports pipeline failed: {error_msg}")
        finish_ingestion_log(
            engine=ENGINE,
            log_id=log_id,
            status="FAILED",
            error_message=error_msg
        )
        return {
            "status": "FAILED",
            "rows_received": rows_received,
            "processed_rows": rows_inserted,
            "rows_rejected": rows_rejected,
            "error_message": error_msg
        }
    finally:
        if ftp:
            try:
                ftp.quit()
            except Exception:
                pass

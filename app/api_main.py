import gc
import time
from datetime import datetime
from zoneinfo import ZoneInfo
from typing import Any
from sqlalchemy.engine import Engine
from app.accord_client import fetch_accord_feed
from app.column_renames import apply_column_renames
from app.config import PRIMARY_KEYS, settings
from app.db import ENGINE
from app.ingestion_log import finish_ingestion_log, start_ingestion_log
from app.logger import logger
from app.merge_service import process_dataframe
from app.normalizer import normalize_dataframe, payload_to_dataframe
from app.utils import parse_ddmmyyyy, resolve_table_name
from app.validation_service import validate_payload_df


def _result(
    feed_name: str,
    status: str,
    http_status: int | None = None,
    rows_received: int = 0,
    processed_rows: int = 0,
    rows_rejected: int = 0,
    rejected_fincodes: list[Any] | None = None,
    error_message: str | None = None,
) -> dict[str, Any]:
    return {
        "feed_name": feed_name,
        "status": status,
        "http_status": http_status,
        "rows_received": rows_received,
        "processed_rows": processed_rows,
        "rows_rejected": rows_rejected,
        "rejected_fincodes": rejected_fincodes or [],
        "error_message": error_message,
    }


def resolve_requested_date(target_date: str | None = None):
    tz = ZoneInfo(settings.timezone)
    date_ddmmyyyy = target_date or settings.api_date or datetime.now(tz).strftime("%d%m%Y")
    return date_ddmmyyyy, parse_ddmmyyyy(date_ddmmyyyy)


def _generate_payload_chunks(payload: Any, chunk_size: int):
    import pandas as pd
    if isinstance(payload, pd.DataFrame):
        for start in range(0, len(payload), chunk_size):
            yield payload.iloc[start:start + chunk_size]
        return

    if isinstance(payload, dict):
        table = payload.get("Table")
        if not isinstance(table, list):
            raise ValueError("Payload 'Table' must be a list")
        for start in range(0, len(table), chunk_size):
            yield table[start:start + chunk_size]
        return

    if isinstance(payload, str):
        lines = payload.splitlines()
        for start in range(0, len(lines), chunk_size):
            yield lines[start:start + chunk_size]
        return

    # Iterator/generator of lines (like response.iter_lines())
    chunk = []
    for line in payload:
        chunk.append(line)
        if len(chunk) >= chunk_size:
            yield chunk
            chunk = []
    if chunk:
        yield chunk


def process_single_feed(feed_name: str, engine: Engine = ENGINE, target_date: str | None = None) -> dict[str, Any]:
    date_ddmmyyyy, requested_date = resolve_requested_date(target_date)
    log_id = start_ingestion_log(engine, feed_name, requested_date)
    started = time.time()
    logger.info(f"Processing feed={feed_name}, date={date_ddmmyyyy}")

    try:
        table_name = resolve_table_name(engine, feed_name)
        if not table_name:
            msg = f"No DB table found for feed={feed_name}"
            finish_ingestion_log(engine, log_id, "TABLE_NOT_FOUND", error_message=msg)
            return _result(feed_name, "TABLE_NOT_FOUND", error_message=msg)

        http_status, payload = fetch_accord_feed(feed_name, date_ddmmyyyy)

        if http_status == 204:
            finish_ingestion_log(engine, log_id, "NO_CONTENT", http_status=204)
            return _result(feed_name, "NO_CONTENT", http_status=204)

        if http_status in (403, 404):
            msg = f"Accord API returned HTTP {http_status}"
            finish_ingestion_log(engine, log_id, "API_ERROR", http_status=http_status, error_message=msg)
            return _result(feed_name, "API_ERROR", http_status=http_status, error_message=msg)

        if payload is None:
            msg = f"HTTP {http_status} but payload empty"
            finish_ingestion_log(engine, log_id, "EMPTY", http_status=http_status, error_message=msg)
            return _result(feed_name, "EMPTY", http_status=http_status, error_message=msg)

        total_rows_received = 0
        total_processed_rows = 0
        total_rows_rejected = 0
        all_rejected_fincodes = []
        is_first_chunk = True

        chunk_size = settings.etl_batch_size

        for payload_chunk in _generate_payload_chunks(payload, chunk_size):
            df_chunk = payload_to_dataframe(payload_chunk)
            if df_chunk.empty:
                continue

            df_chunk, renames = apply_column_renames(df_chunk, feed_name, return_applied=True)
            if renames and is_first_chunk:
                logger.info(f"{feed_name}: applied renames={renames}")

            df_chunk = normalize_dataframe(df_chunk)
            chunk_rows = len(df_chunk)
            total_rows_received += chunk_rows

            pk_cols = PRIMARY_KEYS.get(table_name.lower(), [])
            if is_first_chunk:
                validation = validate_payload_df(df_chunk, table_name, pk_cols)
                for warning in validation["warnings"]:
                    logger.warning(f"{feed_name}: {warning}")

                if not validation["valid"]:
                    msg = "; ".join(validation["errors"])
                    finish_ingestion_log(
                        engine,
                        log_id,
                        "VALIDATION_FAILED",
                        http_status=http_status,
                        rows_received=total_rows_received,
                        error_message=msg,
                    )
                    return _result(feed_name, "VALIDATION_FAILED", http_status=http_status, rows_received=total_rows_received, error_message=msg)
                is_first_chunk = False

            merge = process_dataframe(engine, table_name, df_chunk, feed_name)
            total_processed_rows += int(merge["rows_upserted"]) + int(merge["rows_deleted"])
            total_rows_rejected += merge["rows_rejected"]
            all_rejected_fincodes.extend(merge["rejected_fincodes"])

            del df_chunk
            gc.collect()

        if total_rows_received == 0:
            finish_ingestion_log(engine, log_id, "EMPTY", http_status=http_status)
            return _result(feed_name, "EMPTY", http_status=http_status)

        finish_ingestion_log(
            engine,
            log_id,
            "SUCCESS",
            http_status=http_status,
            rows_received=total_rows_received,
            processed_rows=total_processed_rows,
            rejected_fincodes=all_rejected_fincodes,
        )

        logger.info(
            f"SUCCESS {feed_name}: received={total_rows_received}, processed={total_processed_rows}, "
            f"rejected={total_rows_rejected}, duration={int(time.time() - started)}s"
        )

        return _result(
            feed_name,
            "SUCCESS",
            http_status=http_status,
            rows_received=total_rows_received,
            processed_rows=total_processed_rows,
            rows_rejected=total_rows_rejected,
            rejected_fincodes=all_rejected_fincodes,
        )

    except Exception as e:
        msg = str(e)
        finish_ingestion_log(engine, log_id, "FAILED", error_message=msg)
        logger.exception(f"FAILED {feed_name}: {msg}")
        return _result(feed_name, "FAILED", error_message=msg)

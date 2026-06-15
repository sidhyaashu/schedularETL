import json
from pathlib import Path
from typing import Any
from sqlalchemy import text
from sqlalchemy.engine import Engine
from app.config import settings
from app.logger import logger


def _default_engine() -> Engine:
    """Lazy import of ENGINE to avoid circular dependency at module load time."""
    from app.db import ENGINE
    return ENGINE


def create_log_tables(engine: Engine | None = None) -> None:
    engine = engine or _default_engine()
    sql_path = Path(__file__).resolve().parent.parent / "sql" / "ingestion_log_tables.sql"
    with engine.begin() as conn:
        conn.execute(text(sql_path.read_text(encoding="utf-8")))
    logger.info("Ingestion log table ready")


def start_ingestion_log(engine: Engine, feed_name: str, requested_date) -> int:
    with engine.begin() as conn:
        log_id = conn.execute(
            text("""
                INSERT INTO ingestion_run_logs (feed_name, requested_date, status, started_at)
                VALUES (:feed_name, :requested_date, 'STARTED', now())
                RETURNING id
            """),
            {"feed_name": feed_name, "requested_date": requested_date},
        ).scalar_one()
    return int(log_id)


def finish_ingestion_log(
    engine: Engine,
    log_id: int,
    status: str,
    http_status: int | None = None,
    rows_received: int = 0,
    processed_rows: int = 0,
    rows_inserted: int = 0,
    rows_updated: int = 0,
    rows_deleted: int = 0,
    rows_unchanged: int = 0,
    rows_rejected: int = 0,
    rejected_fincodes: list[Any] | None = None,
    error_message: str | None = None,
) -> None:
    rejected_fincodes = rejected_fincodes or []
    # processed_rows = total rows that caused a DB change (inserts + updates + deletes)
    effective_processed = processed_rows or (rows_inserted + rows_updated + rows_deleted)
    with engine.begin() as conn:
        conn.execute(
            text("""
                UPDATE ingestion_run_logs
                SET status            = :status,
                    http_status       = :http_status,
                    rows_received     = :rows_received,
                    processed_rows    = :processed_rows,
                    rows_inserted     = :rows_inserted,
                    rows_updated      = :rows_updated,
                    rows_deleted      = :rows_deleted,
                    rows_unchanged    = :rows_unchanged,
                    rows_rejected     = :rows_rejected,
                    rejected_fincodes = CAST(:rejected_fincodes AS jsonb),
                    error_message     = :error_message,
                    finished_at       = now()
                WHERE id = :log_id
            """),
            {
                "log_id":            log_id,
                "status":            status,
                "http_status":       http_status,
                "rows_received":     rows_received,
                "processed_rows":    effective_processed,
                "rows_inserted":     rows_inserted,
                "rows_updated":      rows_updated,
                "rows_deleted":      rows_deleted,
                "rows_unchanged":    rows_unchanged,
                "rows_rejected":     rows_rejected,
                "rejected_fincodes": json.dumps(rejected_fincodes, default=str),
                "error_message":     error_message,
            },
        )


def cleanup_old_ingestion_logs(engine: Engine | None = None) -> int:
    engine = engine or _default_engine()
    with engine.begin() as conn:
        result = conn.execute(
            text("""
                DELETE FROM ingestion_run_logs
                WHERE started_at < now() - (:days || ' days')::interval
            """),
            {"days": settings.ingestion_log_retention_days},
        )
    deleted = int(result.rowcount or 0)
    logger.info(f"Ingestion log cleanup: deleted={deleted}, retention_days={settings.ingestion_log_retention_days}")
    return deleted


def cleanup_stale_started_logs(engine: Engine | None = None) -> int:
    engine = engine or _default_engine()
    with engine.begin() as conn:
        result = conn.execute(
            text("""
                UPDATE ingestion_run_logs
                SET status = 'ABANDONED',
                    error_message = 'Service restarted or terminated unexpectedly',
                    finished_at = now()
                WHERE status = 'STARTED'
            """)
        )
    abandoned = int(result.rowcount or 0)
    if abandoned > 0:
        logger.info(f"Ingestion log startup cleanup: marked {abandoned} stale logs as ABANDONED")
    return abandoned



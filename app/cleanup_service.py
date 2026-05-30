from app.db import ENGINE
from app.ingestion_log import cleanup_old_ingestion_logs


def cleanup_logs() -> int:
    return cleanup_old_ingestion_logs(ENGINE)

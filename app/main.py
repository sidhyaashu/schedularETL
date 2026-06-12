
import os
import sys
from app.db import ENGINE, wait_for_db, run_auto_migration
from app.ingestion_log import create_log_tables, cleanup_stale_started_logs
from app.logger import logger
from app.scheduler import start_scheduler
from app.api_main import process_single_feed
from app.config import COMPANY_MASTER_FEEDS, RESULTS_FEEDS, EOD_FEEDS


def run_missed_company_master_on_startup() -> None:
    """If the current local time is past the morning schedule hour (e.g. 10 AM)
    and no Company_master runs have occurred for the resolved target date,
    execute it once immediately."""
    from datetime import datetime
    from zoneinfo import ZoneInfo
    from app.config import settings
    from app.api_main import process_single_feed, resolve_requested_date
    from sqlalchemy import text

    tz = ZoneInfo(settings.timezone)
    now_dt = datetime.now(tz)
    
    _, requested_date = resolve_requested_date()

    # Check if the scheduled morning run time has passed
    if now_dt.hour > settings.company_master_morning_hour or (
        now_dt.hour == settings.company_master_morning_hour
        and now_dt.minute >= int(settings.company_master_morning_minutes)
    ):
        with ENGINE.connect() as conn:
            cnt = conn.execute(
                text("""
                    SELECT COUNT(*) FROM ingestion_run_logs
                    WHERE feed_name = 'Company_master'
                      AND requested_date = :requested_date
                      AND status IN ('SUCCESS', 'STARTED', 'NO_CONTENT')
                """),
                {"requested_date": requested_date}
            ).scalar()

        if cnt == 0:
            logger.info(f"Startup check: Company_master morning run was missed for date {requested_date}. Executing immediate run...")
            try:
                process_single_feed("Company_master")
            except Exception as e:
                logger.error(f"Failed to run missed Company_master morning feed: {e}")


def main() -> None:
    logger.info("Starting scheduler + ingestion service")
    wait_for_db(ENGINE)
    create_log_tables(ENGINE)
    cleanup_stale_started_logs(ENGINE)
    run_auto_migration(ENGINE)
    
    # Clear the table name cache to ensure any newly migrated tables are visible
    from app.utils import _get_public_tables_mapping
    _get_public_tables_mapping.cache_clear()
    
    if os.getenv("RUN_ONCE") == "true" or "--run-once" in sys.argv:
        logger.info("[TEST-RUN] Run-once mode activated. Ingesting all feeds immediately...")
        all_feeds = COMPANY_MASTER_FEEDS + RESULTS_FEEDS + EOD_FEEDS
        success_count = 0
        failed_feeds = []

        for feed in all_feeds:
            try:
                res = process_single_feed(feed)
                status = res.get("status")
                if status in ("SUCCESS", "NO_CONTENT"):
                    success_count += 1
                else:
                    failed_feeds.append((feed, status, res.get("error_message")))
            except Exception as e:
                failed_feeds.append((feed, "ERROR", str(e)))

        logger.info("========================================")
        logger.info(f"[TEST-RUN] Completed: {success_count}/{len(all_feeds)} feeds succeeded.")
        if failed_feeds:
            logger.error(f"[TEST-RUN] Failed feeds: {failed_feeds}")
            sys.exit(1)
        else:
            logger.info("[TEST-RUN] All feeds completed successfully!")
            sys.exit(0)

    run_missed_company_master_on_startup()
    start_scheduler()


if __name__ == "__main__":
    main()


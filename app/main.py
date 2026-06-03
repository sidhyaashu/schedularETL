
import os
import sys
from app.db import ENGINE, wait_for_db, run_auto_migration
from app.ingestion_log import create_log_tables, cleanup_stale_started_logs
from app.logger import logger
from app.scheduler import start_scheduler
from app.api_main import process_single_feed
from app.config import COMPANY_MASTER_FEEDS, RESULTS_FEEDS, EOD_FEEDS


def main() -> None:
    logger.info("Starting scheduler + ingestion service")
    wait_for_db(ENGINE)
    create_log_tables(ENGINE)
    cleanup_stale_started_logs(ENGINE)
    run_auto_migration(ENGINE)
    
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

    start_scheduler()


if __name__ == "__main__":
    main()


from __future__ import annotations
from zoneinfo import ZoneInfo
from datetime import datetime, timedelta
from apscheduler.schedulers.blocking import BlockingScheduler
from app.api_main import process_single_feed
from app.cleanup_service import cleanup_logs
from app.config import COMPANY_MASTER_FEEDS, EOD_FEEDS, RESULTS_FEEDS, settings
from app.logger import logger


CONSOLIDATED_PAIRS = {
    "Finance_bs": "Finance_cons_bs",
    "Finance_pl": "Finance_cons_pl",
    "Finance_cf": "Finance_cons_cf",
    "Finance_fr": "Finance_cons_fr",
    "company_equity": "company_equity_cons",
}


def get_now() -> datetime:
    return datetime.now(ZoneInfo(settings.timezone))


def _run_company_master() -> None:
    target_date = settings.api_date or get_now().strftime("%d%m%Y")
    for feed in COMPANY_MASTER_FEEDS:
        process_single_feed(feed, target_date=target_date)


def _run_results(window_label: str) -> None:
    allowed = {x.strip() for x in settings.results_retry_allowed_windows.split(",") if x.strip()}
    if window_label not in allowed:
        logger.info(f"Results: window '{window_label}' not in allowed list — skipped")
        return

    target_date = settings.api_date or get_now().strftime("%d%m%Y")
    for feed in RESULTS_FEEDS:
        process_single_feed(feed, target_date=target_date)


def _run_eod_feed(feed_name: str) -> None:
    target_date = settings.api_date or get_now().strftime("%d%m%Y")
    process_single_feed(feed_name, target_date=target_date)
    
    # Check if there is a dependent consolidated feed to run sequentially
    cons_feed = CONSOLIDATED_PAIRS.get(feed_name)
    if cons_feed:
        logger.info(f"Triggering consolidated feed {cons_feed} sequentially after standalone {feed_name} completion")
        process_single_feed(cons_feed, target_date=target_date)


def register_jobs(scheduler: BlockingScheduler) -> None:
    # Company Master morning runs (e.g., 10:05 AM and 10:35 AM)
    scheduler.add_job(_run_company_master, "cron", hour=settings.company_master_morning_hour, minute=settings.company_master_morning_minutes, id="company_master_morning_1", replace_existing=True, max_instances=1, coalesce=True)
    scheduler.add_job(_run_company_master, "cron", hour=settings.company_master_morning_hour, minute=settings.company_master_morning_2_minutes, id="company_master_morning_2", replace_existing=True, max_instances=1, coalesce=True)
    
    # Company Master night runs (e.g., 10:35 PM and 11:05 PM)
    scheduler.add_job(_run_company_master, "cron", hour=settings.company_master_night_hour, minute=settings.company_master_night_minutes, id="company_master_night_1", replace_existing=True, max_instances=1, coalesce=True)
    scheduler.add_job(_run_company_master, "cron", hour=settings.company_master_night_2_hour, minute=settings.company_master_night_2_minutes, id="company_master_night_2", replace_existing=True, max_instances=1, coalesce=True)
    
    # Results runs
    scheduler.add_job(lambda: _run_results(str(get_now().hour)), "cron", hour=f"{settings.results_start_hour}-{settings.results_end_hour}", minute=settings.results_minute, id="results_hourly", replace_existing=True, max_instances=1, coalesce=True)
    scheduler.add_job(lambda: _run_results("final"), "cron", hour=settings.results_final_hour, minute=settings.results_final_minute, id="results_final", replace_existing=True, max_instances=1, coalesce=True)

    base = get_now().replace(hour=settings.eod_start_hour, minute=settings.eod_start_minute, second=0, microsecond=0)
    minute_offset = 0
    for feed in EOD_FEEDS:
        # We skip scheduling consolidated feeds separately since they are triggered sequentially by their standalone counterparts
        if feed in CONSOLIDATED_PAIRS.values():
            continue
        run_dt = base + timedelta(minutes=minute_offset)
        scheduler.add_job(lambda f=feed: _run_eod_feed(f), "cron", hour=run_dt.hour, minute=run_dt.minute, id=f"eod_{feed.lower()}", replace_existing=True, max_instances=1, coalesce=True)
        minute_offset += 1

    scheduler.add_job(cleanup_logs, "cron", hour=0, minute=30, id="cleanup_old_ingestion_logs", replace_existing=True, max_instances=1, coalesce=True)


def start_scheduler() -> None:
    scheduler = BlockingScheduler(timezone=settings.timezone)
    register_jobs(scheduler)
    logger.info("Scheduler started")
    for job in scheduler.get_jobs():
        next_run = getattr(job, "next_run_time", None)
        logger.info(f"Registered job: id={job.id}, next_run_time={next_run}")
    scheduler.start()

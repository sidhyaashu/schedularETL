from __future__ import annotations
from zoneinfo import ZoneInfo
from collections import defaultdict
from datetime import datetime, timedelta
from typing import Any
from apscheduler.schedulers.blocking import BlockingScheduler
from app.api_main import process_single_feed
from app.cleanup_service import cleanup_logs
from app.config import COMPANY_MASTER_FEEDS, EOD_FEEDS, RESULTS_FEEDS, parse_int_list, settings
from app.logger import logger

RETRY_BUDGET: dict[str, int] = defaultdict(int)


def get_now() -> datetime:
    return datetime.now(ZoneInfo(settings.timezone))


def _today_key() -> str:
    return get_now().strftime("%Y-%m-%d")


def _budget_key(category: str, feed_name: str) -> str:
    if category == "company_master":
        return f"{_today_key()}:company_master"
    return f"{_today_key()}:{category}:{feed_name}"


def _can_retry(category: str, feed_name: str, max_extra_hits: int) -> bool:
    return RETRY_BUDGET[_budget_key(category, feed_name)] < max_extra_hits


def _mark_retry(category: str, feed_name: str) -> None:
    RETRY_BUDGET[_budget_key(category, feed_name)] += 1


def _is_no_content(result: dict[str, Any]) -> bool:
    return result.get("status") == "NO_CONTENT"


def _schedule_retry(
    scheduler: BlockingScheduler,
    *,
    feed_name: str,
    category: str,
    run_date: datetime,
    attempt: int,
    max_extra_hits: int,
    retry_offsets: list[int],
) -> None:
    if not _can_retry(category, feed_name, max_extra_hits):
        logger.warning(f"Retry budget exhausted: category={category}, feed={feed_name}")
        return

    _mark_retry(category, feed_name)
    job_id = f"retry_{category}_{feed_name.lower()}_{_today_key()}_{attempt}_{int(run_date.timestamp())}"

    def _job() -> None:
        logger.info(f"Running retry: category={category}, feed={feed_name}, attempt={attempt}")
        result = process_single_feed(feed_name)
        if _is_no_content(result):
            next_attempt = attempt + 1
            if next_attempt <= len(retry_offsets):
                _schedule_retry(
                    scheduler,
                    feed_name=feed_name,
                    category=category,
                    run_date=get_now() + timedelta(minutes=retry_offsets[next_attempt - 1]),
                    attempt=next_attempt,
                    max_extra_hits=max_extra_hits,
                    retry_offsets=retry_offsets,
                )
        else:
            logger.info(f"Retry stopped: category={category}, feed={feed_name}, status={result.get('status')}")

    scheduler.add_job(_job, "date", run_date=run_date, id=job_id, replace_existing=True, max_instances=1, coalesce=True)
    logger.info(f"Scheduled retry: category={category}, feed={feed_name}, attempt={attempt}, run_date={run_date}")


def _run_company_master(scheduler: BlockingScheduler) -> None:
    offsets = parse_int_list(settings.company_master_extra_retry_minutes)
    for feed in COMPANY_MASTER_FEEDS:
        result = process_single_feed(feed)
        if _is_no_content(result) and offsets:
            _schedule_retry(
                scheduler,
                feed_name=feed,
                category="company_master",
                run_date=get_now() + timedelta(minutes=offsets[0]),
                attempt=1,
                max_extra_hits=settings.company_master_max_extra_hits,
                retry_offsets=offsets,
            )


def _run_results(scheduler: BlockingScheduler, window_label: str) -> None:
    allowed = {x.strip() for x in settings.results_retry_allowed_windows.split(",") if x.strip()}
    if window_label not in allowed:
        return

    results = [process_single_feed(feed) for feed in RESULTS_FEEDS]
    offsets = parse_int_list(settings.results_extra_retry_minutes)
    if not offsets:
        return

    for result in results:
        if _is_no_content(result):
            _schedule_retry(
                scheduler,
                feed_name=result["feed_name"],
                category="results",
                run_date=get_now() + timedelta(minutes=offsets[0]),
                attempt=1,
                max_extra_hits=settings.results_max_extra_hits,
                retry_offsets=offsets,
            )


def _run_eod_feed(scheduler: BlockingScheduler, feed_name: str) -> None:
    result = process_single_feed(feed_name)
    offsets = parse_int_list(settings.eod_retry_offsets_minutes)
    if _is_no_content(result) and offsets:
        _schedule_retry(
            scheduler,
            feed_name=feed_name,
            category="eod",
            run_date=get_now() + timedelta(minutes=offsets[0]),
            attempt=1,
            max_extra_hits=settings.eod_max_extra_hits_per_feed,
            retry_offsets=offsets,
        )


def register_jobs(scheduler: BlockingScheduler) -> None:
    # Company Master morning runs (e.g., 10:01 AM and 10:30 AM)
    scheduler.add_job(lambda: _run_company_master(scheduler), "cron", hour=settings.company_master_morning_hour, minute=settings.company_master_morning_minutes, id="company_master_morning_1", replace_existing=True, max_instances=1, coalesce=True)
    scheduler.add_job(lambda: _run_company_master(scheduler), "cron", hour=settings.company_master_morning_hour, minute=settings.company_master_morning_2_minutes, id="company_master_morning_2", replace_existing=True, max_instances=1, coalesce=True)
    
    # Company Master night runs (e.g., 10:31 PM and 11:00 PM)
    scheduler.add_job(lambda: _run_company_master(scheduler), "cron", hour=settings.company_master_night_hour, minute=settings.company_master_night_minutes, id="company_master_night_1", replace_existing=True, max_instances=1, coalesce=True)
    scheduler.add_job(lambda: _run_company_master(scheduler), "cron", hour=settings.company_master_night_2_hour, minute=settings.company_master_night_2_minutes, id="company_master_night_2", replace_existing=True, max_instances=1, coalesce=True)
    scheduler.add_job(lambda: _run_results(scheduler, str(get_now().hour)), "cron", hour=f"{settings.results_start_hour}-{settings.results_end_hour}", minute=settings.results_minute, id="results_hourly", replace_existing=True, max_instances=1, coalesce=True)
    scheduler.add_job(lambda: _run_results(scheduler, "final"), "cron", hour=settings.results_final_hour, minute=settings.results_final_minute, id="results_final", replace_existing=True, max_instances=1, coalesce=True)

    base = get_now().replace(hour=settings.eod_start_hour, minute=settings.eod_start_minute, second=0, microsecond=0)
    for idx, feed in enumerate(EOD_FEEDS):
        run_dt = base + timedelta(minutes=idx)
        scheduler.add_job(lambda f=feed: _run_eod_feed(scheduler, f), "cron", hour=run_dt.hour, minute=run_dt.minute, id=f"eod_{feed.lower()}", replace_existing=True, max_instances=1, coalesce=True)

    scheduler.add_job(cleanup_logs, "cron", hour=0, minute=30, id="cleanup_old_ingestion_logs", replace_existing=True, max_instances=1, coalesce=True)


def start_scheduler() -> None:
    scheduler = BlockingScheduler(timezone=settings.timezone)
    register_jobs(scheduler)
    logger.info("Scheduler started")
    for job in scheduler.get_jobs():
        next_run = getattr(job, "next_run_time", None)
        logger.info(f"Registered job: id={job.id}, next_run_time={next_run}")
    scheduler.start()

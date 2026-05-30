import time
from typing import Any
import requests
from app.config import FEED_SECTIONS, settings


def resolve_section(feed_name: str) -> str:
    return FEED_SECTIONS.get(feed_name, "Fundamental")


def fetch_accord_feed(filename: str, date_ddmmyyyy: str) -> tuple[int, Any]:
    # ── Test / mock mode ────────────────────────────────────────────────────
    if settings.accord_mode == "mock":
        from app.mock_accord_client import fetch_accord_feed as _mock
        return _mock(filename, date_ddmmyyyy)
    # ── Production: real HTTP call ───────────────────────────────────────────
    backoff = [settings.api_retry_backoff_1, settings.api_retry_backoff_2, settings.api_retry_backoff_3]

    for attempt in range(settings.api_max_retries):
        try:
            response = requests.get(
                settings.accord_base_url,
                params={
                    "filename": filename,
                    "date": date_ddmmyyyy,
                    "section": resolve_section(filename),
                    "sub": "",
                    "token": settings.accord_api_token,
                },
                timeout=(settings.api_connect_timeout_seconds, settings.api_read_timeout_seconds),
                stream=True,
            )

            if response.status_code == 200:
                return 200, response.iter_lines()
            if response.status_code == 204:
                return 204, None
            if response.status_code in (403, 404):
                return response.status_code, None
            if response.status_code in (429, 500, 502, 503, 504) and attempt < settings.api_max_retries - 1:
                time.sleep(backoff[min(attempt, len(backoff) - 1)])
                continue

            raise RuntimeError(f"Unexpected API status={response.status_code}, body={response.text[:500]}")

        except (requests.exceptions.Timeout, requests.exceptions.ConnectionError) as e:
            if attempt < settings.api_max_retries - 1:
                time.sleep(backoff[min(attempt, len(backoff) - 1)])
                continue
            raise RuntimeError(f"Request failed after {settings.api_max_retries} attempts: {e}") from e

    raise RuntimeError("API failed after retries")

import time
from typing import Any
import requests
from app.config import FEED_SECTIONS, settings


def resolve_section(feed_name: str) -> str:
    return FEED_SECTIONS.get(feed_name, "Fundamental")


def fetch_accord_feed(filename: str, date_ddmmyyyy: str) -> tuple[int, Any]:
    # ── Production: real HTTP call ───────────────────────────────────────────
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

        raise RuntimeError(f"Unexpected API status={response.status_code}, body={response.text[:500]}")

    except (requests.exceptions.Timeout, requests.exceptions.ConnectionError) as e:
        raise RuntimeError(f"Request failed: {e}") from e


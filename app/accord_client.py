import random
import time
from typing import Any
import requests
from app.config import FEED_SECTIONS, settings
from app.logger import logger


def resolve_section(feed_name: str) -> str:
    return FEED_SECTIONS.get(feed_name, "Fundamental")


def fetch_accord_feed(filename: str, date_ddmmyyyy: str) -> tuple[int, Any]:
    # ── Production: real HTTP call ───────────────────────────────────────────
    backoff = [
        settings.api_retry_backoff_1,
        settings.api_retry_backoff_2,
        settings.api_retry_backoff_3,
    ]
    max_retries = settings.api_max_retries

    for attempt in range(max_retries + 1):
        response = None
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
                # Return the full response object, NOT iter_lines().
                # The caller must close it.
                return 200, response

            # For status codes 204, 403, 404, these are terminal and we do not retry.
            # We must close the response before returning.
            if response.status_code == 204:
                response.close()
                return 204, None
            if response.status_code in (403, 404):
                response.close()
                return response.status_code, None

            # For retryable HTTP status codes: 429, 500, 502, 503, 504
            if response.status_code in (429, 500, 502, 503, 504) and attempt < max_retries:
                response.close()
                base_backoff = backoff[min(attempt, len(backoff) - 1)]
                # Add random jitter between 0.1 and 1.0 seconds
                jitter = random.uniform(0.1, 1.0)
                sleep_time = max(0.1, base_backoff + jitter)
                logger.warning(
                    f"API returned status {response.status_code} for feed {filename}. "
                    f"Retrying in {sleep_time:.2f}s (attempt {attempt + 1}/{max_retries})...."
                )
                time.sleep(sleep_time)
                continue

            # Unexpected/unhandled non-200 status code: close response and raise
            msg = f"Unexpected API status={response.status_code}, body={response.text[:500]}"
            response.close()
            raise RuntimeError(msg)

        except requests.exceptions.RequestException as e:
            if response is not None:
                try:
                    response.close()
                except Exception:
                    pass
            
            if attempt < max_retries:
                base_backoff = backoff[min(attempt, len(backoff) - 1)]
                # Add random jitter between 0.1 and 1.0 seconds
                jitter = random.uniform(0.1, 1.0)
                sleep_time = max(0.1, base_backoff + jitter)
                logger.warning(
                    f"Request failed for feed {filename}: {e}. "
                    f"Retrying in {sleep_time:.2f}s (attempt {attempt + 1}/{max_retries})...."
                )
                time.sleep(sleep_time)
                continue
            raise RuntimeError(f"Request failed after {max_retries} retries: {e}") from e

    raise RuntimeError("API failed after max retries")


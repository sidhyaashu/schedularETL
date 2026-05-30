"""
mock_accord_client.py
─────────────────────
Simulates the Accord API by reading from local data/*.txt files.

The .txt files provided by Accord use a streaming NDJSON format:

    Line 1  : {"Table":[{...first row...}
    Middle  : ,{...row...}
    Last    : ]}

This module reconstructs those lines into a proper Python dict
  {"Table": [...]}
and returns (200, payload) exactly as accord_client.fetch_accord_feed does,
so the rest of the pipeline (api_main, merge_service, etc.) is unchanged.

Environment variables consumed (all set in .env.test or .env):
    MOCK_DATA_DIR   – folder containing the .txt files  (default: "data")
    MOCK_ROW_LIMIT  – max rows to return per feed, 0 = all  (default: 0)
"""

import json
import os
from pathlib import Path
from typing import Any

from app.config import settings
from app.logger import logger


def _data_path(feed_name: str) -> Path:
    """Resolve the .txt file path for a given feed name."""
    base = Path(settings.mock_data_dir)
    # Try exact name first, then case-insensitive scan
    candidate = base / f"{feed_name}.txt"
    if candidate.exists():
        return candidate
    for f in base.glob("*.txt"):
        if f.stem.lower() == feed_name.lower():
            return f
    return candidate  # Return non-existent path; caller handles missing


def _iter_file_lines(path: Path, row_limit: int):
    """
    Yields lines from the file, preserving the original formatting.
    If row_limit is set, stops yielding after reaching row_limit.
    """
    row_count = 0
    with path.open(encoding="utf-8", errors="replace") as fh:
        for line in fh:
            yield line
            
            # Count rows to enforce row_limit
            stripped = line.strip()
            if "{" in stripped:
                row_count += 1
                if row_limit > 0 and row_count >= row_limit:
                    # Yield the closing bracket so the stream remains valid JSON
                    yield "]}"
                    break


def fetch_accord_feed(
    filename: str, date_ddmmyyyy: str
) -> tuple[int, Any]:
    """
    Mock implementation of accord_client.fetch_accord_feed.

    Returns:
        (200, generator)         – file found, returning raw lines stream
        (204, None)              – file not found (simulates "no data today")
    """
    path = _data_path(filename)

    if not path.exists():
        logger.warning(
            f"[MOCK] No data file found for feed={filename} "
            f"(looked for {path}). Returning 204 No Content."
        )
        return 204, None

    row_limit = settings.mock_row_limit
    limit_msg = f", row_limit={row_limit}" if row_limit > 0 else " (full file)"
    logger.info(f"[MOCK] Reading feed={filename} from {path}{limit_msg}")

    return 200, _iter_file_lines(path, row_limit)

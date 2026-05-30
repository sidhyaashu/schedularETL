import json
from typing import Any
import pandas as pd


def normalize_column_name(name: str) -> str:
    return str(name).strip().lower()


def payload_to_dataframe(payload: Any) -> pd.DataFrame:
    if not payload:
        return pd.DataFrame()

    # Case 1: Parsed dictionary (e.g. from legacy response.json())
    if isinstance(payload, dict):
        table = payload.get("Table")
        if table is None:
            raise ValueError("Payload missing 'Table' key")
        if not isinstance(table, list):
            raise ValueError("Payload 'Table' must be a list")
        return pd.DataFrame(table)

    # Case 2: DataFrame already
    if isinstance(payload, pd.DataFrame):
        return payload

    # Case 3: Raw string
    if isinstance(payload, str):
        lines = payload.splitlines()
    else:
        # Case 4: Iterable/stream of lines (bytes or strings)
        lines = payload

    rows: list[dict[str, Any]] = []
    for raw_line in lines:
        if isinstance(raw_line, bytes):
            line = raw_line.decode("utf-8", errors="replace").strip()
        else:
            line = raw_line.strip()

        if not line or line in ("{", "}", "]}", "]}"):
            continue

        # Strip the leading {"Table":[ on the first row
        if line.startswith('{"Table":['):
            line = line[len('{"Table":['):]

        # Strip trailing ]} if present (last line of some files)
        if line.endswith("]}"):
            line = line[:-2]

        # Strip leading comma separator
        if line.startswith(","):
            line = line[1:]

        line = line.strip()
        if not line:
            continue

        try:
            row = json.loads(line)
            rows.append(row)
        except json.JSONDecodeError:
            # Skip malformed lines silently
            continue

    return pd.DataFrame(rows)


def normalize_dataframe(df: pd.DataFrame) -> pd.DataFrame:
    df = df.copy()
    df.columns = [normalize_column_name(c) for c in df.columns]
    df = df.loc[:, ~pd.Index(df.columns).duplicated()]
    df = df.replace(r"^\s*$", None, regex=True)
    if "flag" in df.columns:
        df["flag"] = df["flag"].astype(str).str.upper().str.strip()
    return df

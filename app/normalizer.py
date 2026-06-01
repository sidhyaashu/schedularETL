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

        if not line or line in ("{", "}", "]}", "]", "[", "[]", "[]}"):
            continue

        # Check for standard single-line JSON (starts with {"Table":[ and ends with ]})
        if line.startswith('{"Table":[') and line.endswith(']}'):
            # Strip {"Table":[ from start and ]} from end
            line_content = line[len('{"Table":['):-2].strip()
            if not line_content:
                continue
            try:
                # Wrap in brackets to make it a valid JSON array
                chunk_rows = json.loads("[" + line_content + "]")
                if isinstance(chunk_rows, list):
                    rows.extend(chunk_rows)
                else:
                    rows.append(chunk_rows)
                continue
            except json.JSONDecodeError:
                # Fallback to standard line parsing
                pass

        # Strip trailing comma separator (helpful for prettified JSON arrays)
        if line.endswith(","):
            line = line[:-1].strip()

        # Strip the leading {"Table":[ on the first row of NDJSON
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
            if isinstance(row, list):
                rows.extend(row)
            else:
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

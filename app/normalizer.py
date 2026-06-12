import json
from typing import Any
import pandas as pd
from app.logger import logger


def normalize_column_name(name: str) -> str:
    return str(name).strip().lower()


def payload_to_dataframe(payload: Any) -> pd.DataFrame:
    if not payload:
        return pd.DataFrame()

    # Case 1: Parsed dictionary (e.g. from legacy response.json())
    if isinstance(payload, dict):
        if any(k.lower() in ("message", "error") for k in payload):
            msg_val = str(payload.get("Message", payload.get("message", payload.get("Error", payload.get("error", ""))))).strip().lower()
            if "no data found" in msg_val or "no record found" in msg_val or "error" in msg_val:
                return pd.DataFrame()
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
        try:
            parsed = json.loads(payload)
            if isinstance(parsed, dict):
                if any(k.lower() in ("message", "error") for k in parsed):
                    msg_val = str(parsed.get("Message", parsed.get("message", parsed.get("Error", parsed.get("error", ""))))).strip().lower()
                    if "no data found" in msg_val or "no record found" in msg_val or "error" in msg_val:
                        return pd.DataFrame()
                if "Table" in parsed:
                    table = parsed["Table"]
                    if isinstance(table, list):
                        return pd.DataFrame(table)
            elif isinstance(parsed, list):
                if len(parsed) == 1 and isinstance(parsed[0], dict):
                    item = parsed[0]
                    if any(k.lower() in ("message", "error") for k in item):
                        msg_val = str(item.get("Message", item.get("message", item.get("Error", item.get("error", ""))))).strip().lower()
                        if "no data found" in msg_val or "no record found" in msg_val or "error" in msg_val:
                            return pd.DataFrame()
                return pd.DataFrame(parsed)
        except json.JSONDecodeError:
            pass
        lines = payload.splitlines()
    else:
        # Case 4: Iterable/stream of lines (bytes or strings)
        lines = payload

    rows: list[dict[str, Any]] = []
    processed_lines = []
    skipped_count = 0
    
    for raw_line in lines:
        processed_lines.append(raw_line)
        if isinstance(raw_line, dict):
            if any(k.lower() in ("message", "error") for k in raw_line):
                msg_val = str(raw_line.get("Message", raw_line.get("message", raw_line.get("Error", raw_line.get("error", ""))))).strip().lower()
                if "no data found" in msg_val or "no record found" in msg_val or "error" in msg_val:
                    continue
            rows.append(raw_line)
            continue
        elif isinstance(raw_line, bytes):
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
            if isinstance(row, dict):
                if any(k.lower() in ("message", "error") for k in row):
                    msg_val = str(row.get("Message", row.get("message", row.get("Error", row.get("error", ""))))).strip().lower()
                    if "no data found" in msg_val or "no record found" in msg_val or "error" in msg_val:
                        continue
            if isinstance(row, list):
                rows.extend(row)
            else:
                rows.append(row)
        except json.JSONDecodeError:
            skipped_count += 1
            continue

    if skipped_count > 0:
        logger.warning(f"payload_to_dataframe: skipped {skipped_count} malformed JSON lines")

    if not rows and processed_lines:
        try:
            decoded_lines = []
            for l in processed_lines:
                if isinstance(l, bytes):
                    decoded_lines.append(l.decode("utf-8", errors="replace"))
                else:
                    decoded_lines.append(str(l))
            full_text = "".join(decoded_lines)
            
            parsed = json.loads(full_text)
            if isinstance(parsed, dict):
                if any(k.lower() in ("message", "error") for k in parsed):
                    msg_val = str(parsed.get("Message", parsed.get("message", parsed.get("Error", parsed.get("error", ""))))).strip().lower()
                    if "no data found" in msg_val or "no record found" in msg_val or "error" in msg_val:
                        return pd.DataFrame()
                if "Table" in parsed:
                    table = parsed["Table"]
                    if isinstance(table, list):
                        return pd.DataFrame(table)
            elif isinstance(parsed, list):
                if len(parsed) == 1 and isinstance(parsed[0], dict):
                    item = parsed[0]
                    if any(k.lower() in ("message", "error") for k in item):
                        msg_val = str(item.get("Message", item.get("message", item.get("Error", item.get("error", ""))))).strip().lower()
                        if "no data found" in msg_val or "no record found" in msg_val or "error" in msg_val:
                            return pd.DataFrame()
                return pd.DataFrame(parsed)
        except json.JSONDecodeError:
            pass

    return pd.DataFrame(rows)


def normalize_dataframe(df: pd.DataFrame) -> pd.DataFrame:
    df = df.copy()
    df.columns = [normalize_column_name(c) for c in df.columns]
    df = df.loc[:, ~pd.Index(df.columns).duplicated()]
    df = df.replace(r"^\s*$", None, regex=True)
    if "flag" not in df.columns:
        df["flag"] = "A"
    else:
        df["flag"] = df["flag"].astype(str).str.upper().str.strip()
    return df

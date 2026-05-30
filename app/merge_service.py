import csv
import io
import time
import uuid
from typing import Any
import pandas as pd
from sqlalchemy import inspect, text
from sqlalchemy.engine import Engine
from sqlalchemy.sql.sqltypes import BigInteger, Float, Integer, Numeric, SmallInteger
from app.config import PRIMARY_KEYS, settings
from app.logger import logger


def _csv_buffer(df: pd.DataFrame, columns: list[str]) -> io.StringIO:
    selected = df.loc[:, columns].copy()
    for col in selected.columns:
        if selected[col].dtype == object:
            col_series = selected[col].astype(str).str.strip()
            mask = col_series.str.lower().isin(("<na>", "nan", "none", "")) | selected[col].isna()
            selected[col] = col_series.where(~mask, "")
    buf = io.StringIO()
    selected.to_csv(buf, index=False, header=False, lineterminator="\n", na_rep="", quoting=csv.QUOTE_MINIMAL)
    buf.seek(0)
    return buf


def _normalize_for_db(df: pd.DataFrame, table_name: str, db_columns_info: list[dict[str, Any]]) -> tuple[pd.DataFrame, list[str]]:
    df = df.copy()
    df.columns = [str(c).strip().lower() for c in df.columns]
    df = df.loc[:, ~pd.Index(df.columns).duplicated()]
    df = df.replace(r"^\s*$", None, regex=True)

    db_columns = {c["name"].lower(): c["type"] for c in db_columns_info}
    db_cols = list(db_columns.keys())
    keep_cols = [c for c in df.columns if c in db_columns or c == "flag"]
    if not keep_cols:
        raise ValueError(f"No valid columns after schema filtering for table={table_name}")

    df = df.loc[:, keep_cols].copy()
    if "flag" not in df.columns:
        # Vendor payload omitted the flag column — default every row to 'A' (add/update).
        # This is safe: without a flag the API never intends deletions, so treating
        # all rows as upserts is the correct fallback per the Accord spec.
        logger.warning(
            f"{table_name}: 'flag' column absent from payload; "
            "defaulting all rows to flag='A'"
        )
        df["flag"] = "A"

    for col in df.columns:
        col_type = db_columns.get(col)
        if isinstance(col_type, (Integer, BigInteger, SmallInteger)):
            df[col] = pd.to_numeric(df[col], errors="coerce").astype("Int64")
        elif isinstance(col_type, (Numeric, Float)):
            df[col] = pd.to_numeric(df[col], errors="coerce")

    df = df.where(pd.notnull(df), None)
    df["flag"] = df["flag"].astype(str).str.upper().str.strip()

    final_cols = [c for c in db_cols if c in df.columns]
    if "flag" not in final_cols and "flag" in df.columns:
        final_cols.append("flag")

    seen: set[str] = set()
    final_cols = [c for c in final_cols if not (c in seen or seen.add(c))]
    return df.loc[:, final_cols], db_cols


def _reject_missing_pk(df: pd.DataFrame, pk_cols: list[str]) -> tuple[pd.DataFrame, list[Any]]:
    if df.empty:
        return df, []

    missing = pd.Series(False, index=df.index)
    for pk in pk_cols:
        if pk not in df.columns:
            raise ValueError(f"PK column missing after filtering: {pk}")
        missing = missing | df[pk].isna() | (df[pk].astype(str).str.strip() == "")

    rejected = df.loc[missing].copy()
    clean = df.loc[~missing].copy()

    if "fincode" in rejected.columns:
        fincodes = [
            v for v in rejected["fincode"].dropna().astype(str).unique().tolist()
            if v.lower() not in ("nan", "none", "<na>")
        ]
    else:
        fincodes = []

    return clean, fincodes


def _copy_to_staging(conn: Any, df: pd.DataFrame, staging_table: str, cols: list[str]) -> None:
    cursor = conn.connection.cursor()
    try:
        buffer = _csv_buffer(df, cols)
        cols_sql = ", ".join(f'"{c}"' for c in cols)
        cursor.copy_expert(
            f'''COPY "{staging_table}" ({cols_sql}) FROM STDIN WITH (FORMAT CSV, NULL '')''',
            buffer,
        )
    finally:
        cursor.close()


def _delete_sql(target: str, staging: str, pk_cols: list[str]) -> str:
    join_cond = " AND ".join([f't."{pk}" = s."{pk}"' for pk in pk_cols])
    pk_not_null = " AND ".join([f's."{pk}" IS NOT NULL' for pk in pk_cols])
    return f'''DELETE FROM "{target}" t USING "{staging}" s WHERE s.flag = 'D' AND {pk_not_null} AND {join_cond}'''


def _upsert_sql(target: str, staging: str, target_cols: list[str], pk_cols: list[str]) -> str:
    col_list = ", ".join(f'"{c}"' for c in target_cols)
    conflict_cols = ", ".join(f'"{c}"' for c in pk_cols)
    non_pk = [c for c in target_cols if c not in pk_cols]

    if non_pk:
        update_set = ",\n            ".join([f'"{c}" = EXCLUDED."{c}"' for c in non_pk])
        change = " OR ".join([f'EXCLUDED."{c}" IS DISTINCT FROM t."{c}"' for c in non_pk])
        action = f'''DO UPDATE SET {update_set} WHERE {change}'''
    else:
        action = "DO NOTHING"

    pk_order = ", ".join(f's."{c}"' for c in pk_cols)
    select_cols = ", ".join(f's."{c}"' for c in target_cols)

    return f'''
        INSERT INTO "{target}" AS t ({col_list})
        SELECT {select_cols}
        FROM (
            SELECT DISTINCT ON ({pk_order}) *
            FROM "{staging}" s
            WHERE s.flag IN ('A', 'O')
            ORDER BY {pk_order}
        ) s
        ON CONFLICT ({conflict_cols}) {action}
    '''


def _process_chunk(conn: Any, table_name: str, chunk: pd.DataFrame, insert_cols: list[str], pk_cols: list[str], target_has_flag: bool) -> tuple[int, int]:
    staging = f"stg_{table_name.lower()}_{uuid.uuid4().hex[:10]}"
    conn.execute(text(f'CREATE TEMP TABLE "{staging}" (LIKE "{table_name}" INCLUDING DEFAULTS)'))
    if not target_has_flag:
        conn.execute(text(f'ALTER TABLE "{staging}" ADD COLUMN flag TEXT'))
        
    _copy_to_staging(conn, chunk, staging, insert_cols)

    deleted = 0
    upserted = 0
    del_candidates = int(conn.execute(text(f'''SELECT COUNT(*) FROM "{staging}" WHERE flag = 'D' ''')).scalar() or 0)
    up_candidates = int(conn.execute(text(f'''SELECT COUNT(*) FROM "{staging}" WHERE flag IN ('A','O') ''')).scalar() or 0)

    if del_candidates:
        deleted = int(conn.execute(text(_delete_sql(table_name, staging, pk_cols))).rowcount or 0)
    if up_candidates:
        target_cols = [c for c in insert_cols if c != "flag"] if not target_has_flag else insert_cols
        upserted = int(conn.execute(text(_upsert_sql(table_name, staging, target_cols, pk_cols))).rowcount or 0)

    conn.execute(text(f'DROP TABLE IF EXISTS "{staging}"'))
    return upserted, deleted


def process_dataframe(engine: Engine, table_name: str, df: pd.DataFrame, feed_name: str) -> dict[str, Any]:
    pk_cols = PRIMARY_KEYS.get(table_name.lower())
    if not pk_cols:
        raise ValueError(f"No PRIMARY_KEYS configured for table={table_name}")

    inspector = inspect(engine)
    df, db_cols = _normalize_for_db(df, table_name, inspector.get_columns(table_name))
    df, rejected_fincodes = _reject_missing_pk(df, pk_cols)

    if not df.empty:
        df = df.drop_duplicates(subset=[pk.lower() for pk in pk_cols], keep="last")

    if df.empty:
        return {"rows_upserted": 0, "rows_deleted": 0, "rows_rejected": len(rejected_fincodes), "rejected_fincodes": rejected_fincodes}

    insert_cols = [c for c in db_cols if c in df.columns]
    if "flag" in df.columns and "flag" not in insert_cols:
        insert_cols.append("flag")

    target_has_flag = "flag" in db_cols
    total_upserted = 0
    total_deleted = 0

    with engine.begin() as conn:
        for start in range(0, len(df), settings.etl_batch_size):
            chunk = df.iloc[start:start + settings.etl_batch_size].copy()
            upserted, deleted = _process_chunk(conn, table_name, chunk, insert_cols, pk_cols, target_has_flag)
            total_upserted += upserted
            total_deleted += deleted
            logger.debug(f"{feed_name}: batch {min(start + len(chunk), len(df))}/{len(df)}, upserted={total_upserted}, deleted={total_deleted}")
            if settings.etl_batch_sleep > 0:
                time.sleep(settings.etl_batch_sleep)

    return {"rows_upserted": total_upserted, "rows_deleted": total_deleted, "rows_rejected": len(rejected_fincodes), "rejected_fincodes": rejected_fincodes}

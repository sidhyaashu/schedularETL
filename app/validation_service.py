from typing import Any
import pandas as pd


def validate_payload_df(df: pd.DataFrame, table_name: str, pk_cols: list[str]) -> dict[str, Any]:
    errors: list[str] = []
    warnings: list[str] = []

    if df is None:
        return {"valid": False, "errors": ["DataFrame is None"], "warnings": []}

    if df.empty:
        warnings.append(f"{table_name}: DataFrame is empty")
        return {"valid": True, "errors": errors, "warnings": warnings}

    df_cols = set(str(c).lower() for c in df.columns)

    if "flag" not in df_cols:
        warnings.append(f"{table_name}: column 'flag' is missing from payload; defaulting all rows to flag='A'")

    missing_pk = [pk for pk in pk_cols if pk.lower() not in df_cols]
    if missing_pk:
        errors.append(f"{table_name}: missing PK columns: {missing_pk}")

    return {"valid": not errors, "errors": errors, "warnings": warnings}

from typing import Literal, overload
import pandas as pd
from app.config import COLUMN_RENAMES


def normalize_column_name(name: str) -> str:
    return str(name).strip().lower()


@overload
def apply_column_renames(df: pd.DataFrame, feed_name: str, return_applied: Literal[False] = False) -> pd.DataFrame: ...


@overload
def apply_column_renames(df: pd.DataFrame, feed_name: str, return_applied: Literal[True]) -> tuple[pd.DataFrame, dict[str, str]]: ...


def apply_column_renames(df: pd.DataFrame, feed_name: str, return_applied: bool = False):
    rename_map = COLUMN_RENAMES.get(feed_name.lower(), {})
    if not rename_map:
        return (df, {}) if return_applied else df

    incoming_map = {normalize_column_name(col): col for col in df.columns}
    actual: dict[str, str] = {}

    for source_normalized, target_col in rename_map.items():
        actual_source = incoming_map.get(source_normalized)
        if actual_source:
            actual[actual_source] = target_col

    if actual:
        df = df.rename(columns=actual)

    return (df, actual) if return_applied else df

from datetime import datetime
from functools import lru_cache
from sqlalchemy import inspect
from sqlalchemy.engine import Engine


def parse_ddmmyyyy(date_str: str):
    return datetime.strptime(date_str, "%d%m%Y").date()


@lru_cache(maxsize=None)
def _get_public_tables_mapping(engine: Engine) -> dict[str, str]:
    """Cache the mapping of lowercase name -> exact catalog name. Called once per engine lifetime."""
    inspector = inspect(engine)
    return {t.lower(): t for t in inspector.get_table_names(schema="public")}


def resolve_table_name(engine: Engine, feed_name: str) -> str | None:
    """Return the exact-cased table name matching feed_name, or None if not found.

    Uses a cached schema lookup so repeated calls within the same process
    do not re-query pg_catalog on every feed run.
    """
    mapping = _get_public_tables_mapping(engine)
    return mapping.get(feed_name.lower())

import time
from sqlalchemy import create_engine, text
from sqlalchemy.engine import Engine
from app.config import settings
from app.logger import logger


def build_engine() -> Engine:
    return create_engine(
        settings.database_url,
        echo=False,
        future=True,
        pool_pre_ping=True,
        pool_recycle=1800,
        pool_size=5,
        max_overflow=5,
        connect_args={"connect_timeout": 10, "options": "-c timezone=Asia/Kolkata"},
    )


ENGINE = build_engine()


def wait_for_db(engine: Engine = ENGINE, retries: int = 20, delay: int = 3) -> None:
    for attempt in range(1, retries + 1):
        try:
            with engine.connect() as conn:
                conn.execute(text("SELECT 1"))
            logger.info("Database connection successful")
            return
        except Exception as e:
            logger.warning(f"Waiting for DB... {attempt}/{retries} | {e}")
            time.sleep(delay)
    raise RuntimeError("Database connection failed")


def run_auto_migration(engine: Engine) -> None:
    import re
    from pathlib import Path
    from sqlalchemy import inspect

    logger.info("Running auto database migrations...")
    
    # 1. Get list of existing tables in public schema
    inspector = inspect(engine)
    try:
        existing_tables = {t.lower() for t in inspector.get_table_names(schema="public")}
    except Exception as e:
        logger.error(f"Failed to inspect database tables: {e}")
        return

    # 2. Scan schemas/ directory for .sql files
    schemas_dir = Path("schemas")
    if not schemas_dir.exists():
        logger.warning("schemas/ directory not found, skipping migrations.")
        return

    sql_files = list(schemas_dir.glob("*.sql"))
    if not sql_files:
        logger.info("No SQL schema files found in schemas/.")
        return

    logger.info(f"Found {len(sql_files)} SQL schema files. Checking table existence...")

    for f in sql_files:
        table_name = f.stem
        # Check if this table already exists (case-insensitive match)
        if table_name.lower() in existing_tables:
            continue
        
        logger.info(f"Table '{table_name}' not found. Executing {f}...")
        try:
            sql_content = f.read_text(encoding="utf-8")
            # Remove SQL comments
            sql_content = re.sub(r'--.*', '', sql_content)
            # Clean trailing comma before closing parenthesis
            sql_content = re.sub(r',\s*\)', ')', sql_content)
            
            # Execute the table creation SQL in its own transaction
            with engine.begin() as conn:
                conn.execute(text(sql_content))
            logger.info(f"Successfully created table '{table_name}'.")
        except Exception as e:
            logger.error(f"Failed to execute schema file {f}: {e}")
            raise

import logging
import os
import sys


def build_logger(name: str = "scheduler_ingestion") -> logging.Logger:
    level_name = os.getenv("LOG_LEVEL", "INFO").upper()
    level = getattr(logging, level_name, logging.INFO)
    logger = logging.getLogger(name)
    logger.setLevel(level)
    logger.propagate = False
    if not logger.handlers:
        handler = logging.StreamHandler(sys.stdout)
        handler.setLevel(level)
        formatter = logging.Formatter(
            "%(asctime)s | %(levelname)-7s | %(name)s | %(message)s",
            datefmt="%Y-%m-%d %H:%M:%S",
        )
        handler.setFormatter(formatter)
        logger.addHandler(handler)
    return logger


logger = build_logger()

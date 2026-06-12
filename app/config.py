import os
from dataclasses import dataclass, field
from dotenv import load_dotenv
from app.logger import logger

load_dotenv()


def require_env(name: str) -> str:
    value = os.getenv(name)
    if not value:
        raise RuntimeError(f"{name} is required")
    return value


def parse_int_list(value: str) -> list[int]:
    """Parse a comma-separated string of integers, skipping malformed tokens."""
    result = []
    for token in value.split(","):
        token = token.strip()
        if not token:
            continue
        try:
            result.append(int(token))
        except ValueError:
            logger.warning(f"parse_int_list: ignoring non-integer token '{token}'")
    return result


@dataclass(frozen=True)
class Settings:
    # Use field(default_factory=...) so require_env is called at instantiation
    # time (when Settings() is constructed), not at class/module import time.
    # This prevents a race condition with load_dotenv() in tests and import chains.
    database_url: str = field(default_factory=lambda: require_env("DATABASE_URL"))
    accord_api_token: str = field(default_factory=lambda: require_env("ACCORD_API_TOKEN"))
    accord_base_url: str = os.getenv(
        "ACCORD_BASE_URL",
        "https://contentapi.accordwebservices.com/RawData/GetRawDataJSON",
    )
    timezone: str = os.getenv("TIMEZONE", "Asia/Kolkata")
    api_date: str = os.getenv("API_DATE", "").strip()
    api_max_retries: int = int(os.getenv("API_MAX_RETRIES", "2"))
    api_retry_backoff_1: int = int(os.getenv("API_RETRY_BACKOFF_1", "2"))
    api_retry_backoff_2: int = int(os.getenv("API_RETRY_BACKOFF_2", "5"))
    api_retry_backoff_3: int = int(os.getenv("API_RETRY_BACKOFF_3", "10"))
    api_timeout_seconds: int = int(os.getenv("API_TIMEOUT_SECONDS", "60"))
    api_connect_timeout_seconds: int = int(os.getenv("API_CONNECT_TIMEOUT_SECONDS", "15"))
    api_read_timeout_seconds: int = int(os.getenv("API_READ_TIMEOUT_SECONDS", "30"))
    etl_batch_size: int = int(os.getenv("ETL_BATCH_SIZE", "10000"))
    etl_batch_sleep: float = float(os.getenv("ETL_BATCH_SLEEP", "0"))
    ingestion_log_retention_days: int = int(os.getenv("INGESTION_LOG_RETENTION_DAYS", "30"))
    company_master_morning_hour: int = int(os.getenv("COMPANY_MASTER_MORNING_HOUR", "10"))
    company_master_morning_minutes: str = os.getenv("COMPANY_MASTER_MORNING_MINUTES", "1")
    company_master_morning_2_minutes: str = os.getenv("COMPANY_MASTER_MORNING_2_MINUTES", "30")
    company_master_night_hour: int = int(os.getenv("COMPANY_MASTER_NIGHT_HOUR", "22"))
    company_master_night_minutes: str = os.getenv("COMPANY_MASTER_NIGHT_MINUTES", "31")
    company_master_night_2_hour: int = int(os.getenv("COMPANY_MASTER_NIGHT_2_HOUR", "23"))
    company_master_night_2_minutes: str = os.getenv("COMPANY_MASTER_NIGHT_2_MINUTES", "0")
    company_master_extra_retry_minutes: str = os.getenv("COMPANY_MASTER_EXTRA_RETRY_MINUTES", "1,5,10,20")
    company_master_max_extra_hits: int = int(os.getenv("COMPANY_MASTER_MAX_EXTRA_HITS", "6"))
    results_start_hour: int = int(os.getenv("RESULTS_START_HOUR", "9"))
    results_end_hour: int = int(os.getenv("RESULTS_END_HOUR", "23"))
    results_minute: int = int(os.getenv("RESULTS_MINUTE", "1"))
    results_final_hour: int = int(os.getenv("RESULTS_FINAL_HOUR", "23"))
    results_final_minute: int = int(os.getenv("RESULTS_FINAL_MINUTE", "31"))
    results_retry_allowed_windows: str = os.getenv("RESULTS_RETRY_ALLOWED_WINDOWS", "9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,final")
    results_extra_retry_minutes: str = os.getenv("RESULTS_EXTRA_RETRY_MINUTES", "10")
    results_max_extra_hits: int = int(os.getenv("RESULTS_MAX_EXTRA_HITS", "5"))
    eod_start_hour: int = int(os.getenv("EOD_START_HOUR", "22"))
    eod_start_minute: int = int(os.getenv("EOD_START_MINUTE", "31"))
    eod_retry_offsets_minutes: str = os.getenv("EOD_RETRY_OFFSETS_MINUTES", "10,30,60")
    eod_max_extra_hits_per_feed: int = int(os.getenv("EOD_MAX_EXTRA_HITS_PER_FEED", "3"))



settings = Settings()

FEED_SECTIONS = {
    "company_equity": "CompanyEquity",
    "company_equity_cons": "CompanyEquity",
}

COMPANY_MASTER_FEEDS = ["Company_master"]
RESULTS_FEEDS = ["Resultsf_IND_Ex1", "Resultsf_IND_Cons_Ex1"]
EOD_FEEDS = [
    "Industrymaster_Ex1", "Housemaster", "Stockexchangemaster", "Registrarmaster",
    "Shp_catmaster_2", "Companyaddress", "Board", "Registrardata", "Complistings",
    "Finance_bs", "Finance_cons_bs", "Finance_pl", "Finance_cons_pl", "Finance_cf",
    "Finance_cons_cf", "Finance_fr", "Finance_cons_fr", "company_equity",
    "company_equity_cons", "Shpsummary", "Shp_details", "Monthlyprice", "Nse_Monthprice",
]

PRIMARY_KEYS = {
    "company_master": ["fincode"],
    "industrymaster_ex1": ["ind_code"],
    "housemaster": ["house_code"],
    "stockexchangemaster": ["stk_id"],
    "registrarmaster": ["registrarno"],
    "shp_catmaster_2": ["shp_catid"],
    "companyaddress": ["fincode"],
    "board": ["fincode", "yrc", "serialno", "dirtype_id"],
    "registrardata": ["fincode", "registrarno"],
    "complistings": ["fincode", "stk_id"],
    "finance_bs": ["fincode", "year_end", "type"],
    "finance_cons_bs": ["fincode", "year_end", "type"],
    "finance_pl": ["fincode", "year_end", "type"],
    "finance_cons_pl": ["fincode", "year_end", "type"],
    "finance_cf": ["fincode", "year_end", "type"],
    "finance_cons_cf": ["fincode", "year_end", "type"],
    "finance_fr": ["fincode", "year_end", "type"],
    "finance_cons_fr": ["fincode", "year_end", "type"],
    "resultsf_ind_ex1": ["fincode", "result_type", "date_end"],
    "resultsf_ind_cons_ex1": ["fincode", "result_type", "date_end"],
    "company_equity": ["fincode"],
    "company_equity_cons": ["fincode"],
    "shpsummary": ["fincode", "date_end"],
    "shp_details": ["fincode", "date_end", "srno"],
    "monthlyprice": ["fincode", "month", "year"],
    "nse_monthprice": ["fincode", "month", "year"],
}

COLUMN_RENAMES = {
    "finance_bs": {"outstanding_forward_exchange_contract": "outstanding_forward_exchange_contra"},
    "finance_cons_bs": {"outstanding_forward_exchange_contract": "outstanding_forward_exchange_contra"},
    "resultsf_ind_ex1": {
        "interest coverage ratio": "interest_coverage_ratio",
        "inventory turnover ratio": "inventory_turnover_ratio",
        "dividend per share": "dividend_per_share",
        "deebtor turnover ratio": "debtor_turnover_ratio",
        "debtor turnover ratio": "debtor_turnover_ratio",
        "debt/equity ratio": "debt_equity_ratio",
        "dividend payout ratio": "dividend_payout_ratio",
        "return on capital employed": "return_on_capital_employed",
    },
    "resultsf_ind_cons_ex1": {
        "interest coverage ratio": "interest_coverage_ratio",
        "inventory turnover ratio": "inventory_turnover_ratio",
        "dividend per share": "dividend_per_share",
        "deebtor turnover ratio": "debtor_turnover_ratio",
        "debtor turnover ratio": "debtor_turnover_ratio",
        "debt/equity ratio": "debt_equity_ratio",
        "dividend payout ratio": "dividend_payout_ratio",
        "return on capital employed": "return_on_capital_employed",
    },
}

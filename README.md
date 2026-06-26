# Accord Ingestion Scheduler & ETL Pipeline

A production-grade, highly efficient, and memory-safe ETL pipeline that ingests, normalizes, and upserts financial data feeds from the Accord API into a PostgreSQL database.

---

## 🚀 Key Features

* **Flexible JSON/NDJSON Parser**: Streams and processes records line-by-line using Python generators, keeping the memory footprint low. Supports standard single-line JSON, multi-line prettified JSON arrays, and streaming NDJSON formats.
* **Auto-Migrations**: Inspects the database catalog on startup and executes missing SQL schemas from the `schemas/` directory dynamically, with automatic cleanup of trailing SQL syntax anomalies.
* **Dual-Stage Deduplication**: Drops duplicate records within the current batch in Pandas, followed by a database-level `ON CONFLICT` merge query to prevent double-inserting unchanged data.
* **Staggered EOD Scheduling**: Launches the 25 End-of-Day feeds spaced 1 minute apart to prevent network and database CPU spikes.
* **Sequential Consolidated Execution**: Sequentially runs consolidated feeds immediately after standalone counterpart feeds complete successfully, reducing API load and ensuring schema ordering (e.g., `Finance_cons_bs` runs immediately after `Finance_bs`).
* **Startup Recovery Check**: Automatically detects missed scheduled morning runs of `Company_master` on service startup and triggers an immediate execution.
* **Ingestion Diagnostics**: Logs every run state, row count, and error traceback in a central database audit table (`ingestion_run_logs`) with an automatic retention cleanup.

---

## 📁 Project Structure

```text
schedularETL/
├── app/
│   ├── __init__.py
│   ├── accord_client.py       # Accord API connection, streaming fetch, retry logic
│   ├── api_main.py            # Primary ingestion coordinator and chunk processor
│   ├── cleanup_service.py     # Background job for purging expired logs
│   ├── column_renames.py      # Column renaming dictionary application logic
│   ├── config.py              # Configuration settings, primary keys, and column renames mapping
│   ├── db.py                  # Database connection, pooling, and startup auto-migrations
│   ├── ingestion_log.py       # Metrics logger for tracking pipeline execution runs
│   ├── logger.py              # Centralized logging configuration
│   ├── main.py                # Main script entry point (starts scheduler or runs once)
│   ├── merge_service.py       # High performance raw SQL upsert/delete operations
│   ├── normalizer.py          # Generator-based JSON parser and dataframe normalizer
│   ├── scheduler.py           # APScheduler cron schedule and pipeline sequencing logic
│   ├── utils.py               # Shared utility functions and database helper cache
│   └── validation_service.py  # Incoming data validation and schema-compliance checks
├── schemas/                   # SQL files defining the 28 financial tables
│   ├── Board.sql
│   ├── Company_master.sql
│   └── ...
├── sql/
│   └── ingestion_log_tables.sql # Logging and audit tables schema definition
├── tests/
│   ├── test_scenarios.py          # Core pipeline scenario and validation tests
│   ├── test_end_to_end_pipeline.py# Mocked E2E pipeline flow for Company_master
│   ├── test_production_fincode.py  # Production simulation and metrics test
│   ├── test_advanced_pipeline.py  # Full 28-feed integration and penetration test suite
│   └── test_related_parties.py    # RelatedParties_Transaction integration test suite
├── docker-compose.yml         # Production deployment configuration
├── Dockerfile                 # Application Docker builder
├── requirements.txt           # Python application dependencies
└── README.md                  # System documentation
```

---

## 🛠️ Local Development & Running

### 1. Configure the `.env` file
Create a `.env` file in the root directory. Configure it with your database credentials and Accord API token:

```ini
DATABASE_URL=postgresql+psycopg2://username:password@host:5432/financial_db?sslmode=require
ACCORD_API_TOKEN=your_accord_production_token
```

### 2. Run Directly on Host (Python)
Make sure dependencies are installed:
```bash
pip install -r requirements.txt
```
To start the scheduled listener:
```bash
python -m app.main
```

To trigger a manual run-once execution (ingests all feeds immediately):
```bash
python -m app.main --run-once
```

---

## ⚙️ Environment Configuration Reference

The following environment variables can be configured inside the `.env` file:

| Variable | Default Value | Description |
| :--- | :--- | :--- |
| `DATABASE_URL` | *Required* | Connection string for PostgreSQL database. |
| `ACCORD_API_TOKEN` | *Required* | Bearer/Access token for Accord Web Services. |
| `ACCORD_BASE_URL` | `https://contentapi.accordwebservices.com/RawData/GetRawDataJSON` | Accord feed fetch URL. |
| `TIMEZONE` | `Asia/Kolkata` | Timezone for scheduler triggers. |
| `API_DATE` | *(Empty)* | Manual date override in `DDMMYYYY` format (e.g. `12062026`) for back-filling historical data. |
| `API_MAX_RETRIES` | `2` | Number of times to retry failed requests. |
| `API_RETRY_BACKOFF_1` | `2` | Backoff delay (seconds) on first retry. |
| `API_RETRY_BACKOFF_2` | `5` | Backoff delay (seconds) on second retry. |
| `API_RETRY_BACKOFF_3` | `10` | Backoff delay (seconds) on third retry. |
| `API_TIMEOUT_SECONDS` | `60` | Request timeout limit. |
| `API_CONNECT_TIMEOUT_SECONDS` | `15` | TCP connection establishment timeout. |
| `API_READ_TIMEOUT_SECONDS` | `30` | Stream read timeout limit. |
| `ETL_BATCH_SIZE` | `10000` | Chunk size of rows to parse and merge at a time. |
| `ETL_BATCH_SLEEP` | `0` | Delay (seconds) between processing chunks (0 for max performance). |
| `INGESTION_LOG_RETENTION_DAYS` | `30` | Clean-up threshold for removing old execution run logs. |
| `COMPANY_MASTER_MORNING_HOUR` | `10` | Starting hour for morning Company_master feeds (24h format). |
| `COMPANY_MASTER_MORNING_MINUTES` | `1` | First morning run minute for Company_master. |
| `COMPANY_MASTER_MORNING_2_MINUTES` | `30` | Second morning run minute for Company_master. |
| `COMPANY_MASTER_NIGHT_HOUR` | `22` | Starting hour for night Company_master feeds. |
| `COMPANY_MASTER_NIGHT_MINUTES` | `31` | First night run minute for Company_master. |
| `COMPANY_MASTER_NIGHT_2_HOUR` | `23` | Second night run hour. |
| `COMPANY_MASTER_NIGHT_2_MINUTES` | `0` | Second night run minute. |
| `RESULTS_START_HOUR` | `9` | Hourly checked start window hour for Results feeds. |
| `RESULTS_END_HOUR` | `23` | Hourly checked end window hour for Results feeds. |
| `RESULTS_MINUTE` | `1` | Minute at which hourly results feeds are pulled. |
| `RESULTS_FINAL_HOUR` | `23` | Final results feed check hour. |
| `RESULTS_FINAL_MINUTE` | `31` | Final results feed check minute. |
| `EOD_START_HOUR` | `22` | Daily starting hour for EOD feeds. |
| `EOD_START_MINUTE` | `31` | Daily starting minute for EOD feeds. |

---

## 📦 Production Deployment (Docker Compose)

### 1. Start the Production Service
Build and run the container in the background (detached mode):
```bash
# Build the production image
docker compose build

# Launch the container in the background
docker compose up -d
```
The container will auto-restart if it crashes (`restart: unless-stopped`).

### 2. Trigger an Immediate Ingestion Run (Docker Run-Once)
To trigger a manual run-once sequence through Docker Compose:
```bash
docker compose run --rm scheduler_ingestion python -m app.main --run-once
```

---

## 🕒 Cron Timing, Staggering & Sequencing

In production, feeds are requested from Accord based on their daily publish times:

1. **Company Master (`Company_master`)**: Runs 4 times a day:
   * Morning runs at `10:01 AM` and `10:30 AM`
   * Night runs at `10:31 PM` and `11:00 PM`
   * **Missed Run Startup Check**: If the container is restarted/started after `10:01 AM` and no runs have yet been logged for the day, an immediate `Company_master` sync is triggered on startup to recover.
2. **Results (`Resultsf_IND_Ex1`, `Resultsf_IND_Cons_Ex1`)**: Checked hourly at minute `1` between 9:00 AM and 11:00 PM, plus a final run at `11:31 PM`.
3. **End of Day (EOD) Feeds (25 feeds)**: Run once daily starting at `10:31 PM`.
   * **Staggering**: The scheduler launches standalone EOD feeds exactly **1 minute apart** (e.g., `22:31`, `22:32`, `22:33`...) to balance API connections.
   * **Sequencing**: Consolidated feeds (`Finance_cons_bs`, `Finance_cons_pl`, `Finance_cons_cf`, `Finance_cons_fr`, `company_equity_cons`, and `RelatedParties_Transaction_Cons`) are not scheduled individually. Instead, they are triggered **sequentially** immediately after their corresponding standalone feeds finish successfully.

---

## 🔄 Ingestion & AOD Processing Logic

Accord uses the `flag` field to signal changes. The pipeline processes `A` (Add), `O` (Original/Update), and `D` (Delete) rows as follows:

```
[Raw JSON Feed] ──> [Pandas: Drop Duplicates (Keep Last)] ──> [Temp Staging Table]
                                                                      │
                                 ┌────────────────────────────────────┴────────────────────────────────────┐
                                 ▼                                                                         ▼
                       [flag = 'D' (Delete)]                                                    [flag = 'A' or 'O' (Upsert)]
                                 │                                                                         │
  DELETE FROM target WHERE target.pk = staging.pk                         INSERT INTO target AS t ON CONFLICT (pk) DO UPDATE SET ...
                                                                          WHERE EXCLUDED.col IS DISTINCT FROM t.col
```

1. **Deduplication**: In Pandas, records are deduplicated based on their primary keys, keeping only the **last** occurrence. Since feeds are chronological, the last occurrence holds the final daily state (e.g., if a record was updated and then deleted, only the deletion remains).
2. **Deletion (`D`)**: Staging rows with `flag = 'D'` delete corresponding rows in the destination table matching the primary key.
3. **Upsert (`A` / `O`)**: Staging rows with `flag = 'A'` or `flag = 'O'` are inserted into the destination table. On primary key conflict, an update is triggered **only** if the incoming values differ from current database values (`IS DISTINCT FROM`).
4. **Column Renaming**: Raw incoming API keys are mapped automatically to standard schema definitions. For instance, `outstanding_forward_exchange_contract` is renamed to `outstanding_forward_exchange_contra` to fit within character limits.
5. **Empty Feed Handling**: Empty dictionary responses (e.g. `{"Message": "No Data Found"}`) are intercepted during the streaming download phase and resolve gracefully as `EMPTY` (or `NO_CONTENT`) without failing or raising validation errors.

---

## 📊 Ingestion Run Logs Schema

Every ingestion cycle writes a tracking record into the `ingestion_run_logs` table. Old logs are automatically purged at midnight (`00:30`) if they exceed `INGESTION_LOG_RETENTION_DAYS`.

| Column | Data Type | Description |
| :--- | :--- | :--- |
| `id` | `SERIAL` (PK) | Auto-incrementing identifier for the run log. |
| `feed_name` | `VARCHAR(100)` | The name of the Accord feed file processed (e.g., `Company_master`). |
| `requested_date` | `DATE` | The business date parameter used for the API request. |
| `status` | `VARCHAR(50)` | Current execution status. Can be:<br>- `STARTED`: The run is in progress.<br>- `SUCCESS`: Ingestion finished successfully.<br>- `NO_CONTENT`: API returned 204 (file not ready yet).<br>- `EMPTY`: API returned 200 OK but with an empty/no record payload.<br>- `API_ERROR`: API returned a network or auth error (403/404).<br>- `VALIDATION_FAILED`: Payload schema or data validation failed.<br>- `TABLE_NOT_FOUND`: Target database table does not exist.<br>- `FAILED`: Ingestion crashed due to a runtime exception. |
| `http_status` | `INTEGER` | The HTTP status code returned by the Accord API (e.g., `200`, `204`, `403`). |
| `rows_received` | `INTEGER` | The total number of records parsed from the raw API payload stream. |
| `rows_inserted` | `INTEGER` | The number of rows newly inserted into the database. |
| `rows_updated` | `INTEGER` | The number of rows modified due to changing values. |
| `rows_deleted` | `INTEGER` | The number of rows removed from the target database. |
| `rows_unchanged` | `INTEGER` | The number of incoming rows identical to current database states (skipped). |
| `rejected_fincodes` | `JSONB` | JSON array containing keys of records rejected due to missing or invalid primary keys. |
| `error_message` | `TEXT` | Detailed traceback or error description if the run failed. |
| `started_at` | `TIMESTAMPTZ` | Timestamp when the ingestion run was initiated. |
| `finished_at` | `TIMESTAMPTZ` | Timestamp when the ingestion run concluded. |

---

## 🧪 Testing Suite (Integration & Penetration Tests)

The repository includes a comprehensive, automated test suite designed to validate the reliability, schema alignment, and CRUD processing accuracy of the pipeline.

### Test Scenarios Covered
* **Type-Safe Mock Data Generation**: Leverages SQLAlchemy's inspector to read active tables in the PostgreSQL database at runtime, dynamically identifying column datatypes (integers, strings, booleans, dates) to assemble schema-compliant payloads.
* **CRUD Phase Assertions**: Simulates CRUD requests by issuing a sequence of operations:
  * **Phase 1 (Insert)**: Inserts 100 new mock company records (`FLAG = 'A'`) and verifies they appear in the database.
  * **Phase 2 (Update/Unchanged)**: Re-sends the 100 records, modifying fields on 50 of them (`FLAG = 'O'`) and leaving the other 50 unchanged (`FLAG = 'A'`), asserting `rows_updated = 50` and `rows_unchanged = 50`.
  * **Phase 3 (Delete)**: Issues a payload deleting 30 records (`FLAG = 'D'`), validating `rows_deleted = 30` and verifying 70 remain.
  * **Phase 4 (Teardown)**: Cleans all mock IDs to ensure production tables return to a clean state.
* **Column Renaming Integrity**: Sends payloads using unrenamed original API keys and verifies that the system applies configurations correctly to match target schemas.
* **Empty Payload Handling**: Emulates `{"Message": "No Data Found"}` payload cases to verify status updates to `EMPTY` are logged properly without exception.

### Running the Tests

To run tests within the Docker environment (recommended):
```bash
# Run the complete integration and penetration test suite (28 feeds)
docker compose run --rm scheduler_ingestion python tests/test_advanced_pipeline.py

# Run Scenario-based tests (Insert, Update, Delete, Deduplication, Validation check)
docker compose run --rm scheduler_ingestion python tests/test_scenarios.py

# Run Mock End-to-End Pipeline test
docker compose run --rm scheduler_ingestion python tests/test_end_to_end_pipeline.py

# Run simulation test targeting production fincodes
docker compose run --rm scheduler_ingestion python tests/test_production_fincode.py

# Run Related Parties Transactions integration test (with volume mount)
docker compose run --rm -v /home/azureuser/schedularETL/tests:/app/tests scheduler_ingestion python tests/test_related_parties.py
```

To run tests locally on the host machine (assumes PostgreSQL is running and environment variable configs are set in `.env`):
```bash
python tests/test_scenarios.py
python tests/test_end_to_end_pipeline.py
python tests/test_production_fincode.py
python tests/test_advanced_pipeline.py
python tests/test_related_parties.py
```
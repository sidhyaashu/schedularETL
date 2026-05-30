# Accord Ingestion Scheduler & ETL Pipeline

A production-grade, highly efficient, and memory-safe ETL pipeline that ingests, normalizes, and upserts financial data feeds from the Accord API into a PostgreSQL database.

---

## 🚀 Key Features

* **Streaming NDJSON Parser**: Streams and processes records line-by-line using Python generators, keeping the memory footprint low even when processing files over 1GB (e.g., `Shpsummary` and `Shp_details`).
* **Auto-Migrations**: Inspects the database catalog on startup and executes missing SQL schemas from the `schemas/` directory dynamically, with automatic cleanup of trailing SQL syntax anomalies.
* **Dual-Stage Deduplication**: Drops duplicate records within the current batch in Pandas, followed by a database-level `ON CONFLICT` merge query to prevent double-inserting unchanged data.
* **Staggered EOD Scheduling**: Launches the 23 End-of-Day feeds spaced 1 minute apart to prevent network and database CPU spikes.
* **Ingestion Diagnostics**: Logs every run state, row count, and error traceback in a central database audit table (`ingestion_run_logs`) with an automatic retention cleanup.

---

## 🛠️ Getting Started (Local Development & Testing)

The test environment uses local sample files under the `data/` directory to simulate the Accord API. It restricts row ingestion to `500` rows per file for fast cycle times.

### 1. Spin up the Test Environment (Docker)
This starts a PostgreSQL database (port `5435`) and the scheduler service in mock mode:
```bash
docker compose --profile test up --build
```

### 2. Trigger an Immediate Test Run (Run-Once Mode)
If you do not want to wait for the cron schedule times during testing, you can trigger a sequential ingestion of all 26 feeds immediately:
```bash
docker compose --profile test run scheduler_test python -m app.main --run-once
```

### 3. Run Locally (Without Docker)
Make sure you have a local PostgreSQL instance running and configured in `.env`.

* **Windows Command Prompt (CMD)**:
  ```cmd
  set ACCORD_MODE=mock
  set MOCK_ROW_LIMIT=500
  python -m app.main
  ```

* **Windows PowerShell**:
  ```powershell
  $env:ACCORD_MODE="mock"
  $env:MOCK_ROW_LIMIT="500"
  python -m app.main
  ```

* **Linux/macOS**:
  ```bash
  ACCORD_MODE=mock MOCK_ROW_LIMIT=500 python -m app.main
  ```

---

## 📦 Production Deployment

### 1. Configure the `.env` file
Create a `.env` file in the root directory. Configure it with your production database credentials and Accord token. Make sure `ACCORD_MODE` is set to `real`:

```ini
DATABASE_URL=postgresql+psycopg2://username:password@host:5432/financial_db?sslmode=require
ACCORD_API_TOKEN=your_accord_production_token
ACCORD_MODE=real
# (For full configuration parameters, refer to the .env.example file)
```

### 2. Start the Production Service
Run the container in detached (background) mode under the `prod` profile:
```bash
# Build the production image
docker compose --profile prod build

# Launch the container in the background
docker compose --profile prod up -d
```
The container will auto-restart if it crashes (`restart: unless-stopped`).

---

## 🕒 Cron Timing & Staggering

In production, feeds are requested from Accord based on their daily publish times:

1. **Company Master (`Company_master`)**: Runs 4 times a day (Morning runs at `10:01 AM` and `10:30 AM`; Night runs at `10:31 PM` and `11:00 PM`).
2. **Results (`Resultsf_IND_Ex1`, `Resultsf_IND_Cons_Ex1`)**: Checked hourly at minute `1` between 9:00 AM and 11:00 PM (e.g. `15:01`, `18:01`...), plus a final run at `11:31 PM`.
3. **End of Day (EOD) Feeds (23 feeds)**: Run once daily starting at `10:31 PM`. The scheduler staggers them **1 minute apart** (e.g., `22:31`, `22:32`, `22:33`...) to load balance connections.

---

## 🔄 Ingestion & AOD Processing Logic

Accord uses the `flag` field to signal changes. The pipeline processes `A` (Add), `O` (Original/Update), and `D` (Delete) rows as follows:

```
[Raw NDJSON Feed] ──> [Pandas: Drop Duplicates (Keep Last)] ──> [Temp Staging Table]
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

---

## 📊 Ingestion Run Logs Schema

Every ingestion cycle writes a tracking record into the `ingestion_run_logs` table.

| Column | Data Type | Description |
| :--- | :--- | :--- |
| `id` | `SERIAL` (PK) | Auto-incrementing identifier for the run log. |
| `feed_name` | `VARCHAR(100)` | The name of the Accord feed file processed (e.g., `Company_master`). |
| `requested_date` | `DATE` | The business date parameter used for the API request. |
| `status` | `VARCHAR(50)` | Current execution status. Can be:<br>- `STARTED`: The run is in progress.<br>- `SUCCESS`: Ingestion finished successfully.<br>- `NO_CONTENT`: API returned 204 (file not ready yet).<br>- `API_ERROR`: API returned a network or auth error (403/404).<br>- `VALIDATION_FAILED`: Payload schema or data validation failed.<br>- `TABLE_NOT_FOUND`: Target database table does not exist.<br>- `FAILED`: Ingestion crashed due to a runtime exception. |
| `http_status` | `INTEGER` | The HTTP status code returned by the Accord API (e.g., `200`, `204`, `403`). |
| `rows_received` | `INTEGER` | The total number of records parsed from the raw API payload stream. |
| `processed_rows` | `INTEGER` | The total number of database records modified (inserted + updated + deleted). |
| `rejected_fincodes` | `JSONB` | JSON array containing fincodes of records rejected due to missing or invalid primary keys. |
| `error_message` | `TEXT` | Detailed traceback or error description if the run failed. |
| `started_at` | `TIMESTAMPTZ` | Timestamp when the ingestion run was initiated. |
| `finished_at` | `TIMESTAMPTZ` | Timestamp when the ingestion run concluded. |
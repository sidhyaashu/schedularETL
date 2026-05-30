CREATE TABLE IF NOT EXISTS ingestion_run_logs (
    id BIGSERIAL PRIMARY KEY,
    feed_name TEXT NOT NULL,
    requested_date DATE NOT NULL,
    status TEXT NOT NULL,
    http_status INT,
    rows_received BIGINT DEFAULT 0,
    processed_rows BIGINT DEFAULT 0,
    rejected_fincodes JSONB DEFAULT '[]'::jsonb,
    error_message TEXT,
    started_at TIMESTAMP NOT NULL DEFAULT now(),
    finished_at TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_ingestion_run_logs_requested_date
ON ingestion_run_logs(requested_date);

CREATE INDEX IF NOT EXISTS idx_ingestion_run_logs_feed_date
ON ingestion_run_logs(feed_name, requested_date);

CREATE INDEX IF NOT EXISTS idx_ingestion_run_logs_started_at
ON ingestion_run_logs(started_at);

CREATE INDEX IF NOT EXISTS idx_ingestion_run_logs_status
ON ingestion_run_logs(status);

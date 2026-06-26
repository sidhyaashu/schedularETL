CREATE TABLE digital_reports (
    -- Composite Primary Key
    FINCODE                 INT NOT NULL,                          -- Company Fincode
    REPORT_TYPE             VARCHAR(5) NOT NULL,                   -- Report Type (A/C/D/G/M/N)
    YEAR_END                INT NOT NULL,                          -- Year End YYYYMM (e.g. 202503)
    
    -- File Info
    FILE_NAME               VARCHAR(255) NOT NULL,                 -- PDF file name on remote server
    AZURE_BLOB_URL          VARCHAR(512),                          -- Path/URL in Azure Blob Storage or Local fallback
    
    -- Status
    STATUS                  VARCHAR(20) NOT NULL,                  -- SUCCESS / FAILED
    ERROR_MESSAGE           TEXT,                                  -- Error trace if FAILED
    DOWNLOADED_AT           TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP, -- Timestamp of download
    
    -- Constraints
    PRIMARY KEY (FINCODE, REPORT_TYPE, YEAR_END)
);

-- Total Column Count: 8

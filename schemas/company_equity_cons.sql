CREATE TABLE company_equity_cons (
    -- Primary Key
    FINCODE                 INT PRIMARY KEY NOT NULL,              -- Fincode
    
    -- Basic Information
    YEAR_END                INT,                                    -- Year end
    No_Shs_Subscribed       NUMERIC(18,0),                          -- No of shares subscribed
    
    -- Equity Information
    Latest_Equity           FLOAT,                                  -- Latest Equity
    Latest_Reserve          FLOAT,                                  -- Latest Reserve
    
    -- Market Data
    PRICE                   FLOAT,                                  -- Price
    MCAP                    FLOAT,                                  -- Mcap
    YIELD                   FLOAT,                                  -- Dividend Yield
    
    -- Share Information
    FV                      FLOAT,                                  -- Face Value
    BOOKNAVPERSHARE         FLOAT,                                  -- Book Value
    
    -- TTM (Trailing Twelve Months) Data
    TTM_YEAREND             INT,                                    -- TTM Year end
    TTMEPS                  FLOAT,                                  -- TTM EPS
    TTMPE                   FLOAT,                                  -- TTM PE
    
    -- Valuation Ratios
    Price_Sales             FLOAT,                                  -- Price to Sales
    EV_Sales                FLOAT,                                  -- EV to Sales
    MCAP_Sales              FLOAT,                                  -- Mcap to Sales
    EV                      FLOAT,                                  -- Enterprice Value
    Price_BV                FLOAT,                                  -- Price to book value
    EV_EBITDA               FLOAT,                                  -- Ev to EBIDTA
    
    -- Cash EPS Data
    TTMCEPS                 FLOAT,                                  -- TTM CEPS
    Price_CEPS              FLOAT,                                  -- Price to CEPS
    
    -- Market Information
    PriceDate               TIMESTAMP,                               -- Price Date
    STK_Exchange            VARCHAR(25),                           -- Stock Exchange
    
    -- Status
    Flag                    VARCHAR(1),                            -- Updation Flag
);


-- Total Column Count: 24

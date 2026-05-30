CREATE TABLE Company_Master (
    -- Primary Key
    FINCODE                 INT PRIMARY KEY NOT NULL,              -- AFPL's Company Code
    
    -- BSE Information
    SCRIPCODE               INT,                                    -- BSE Scrip Code
    SCRIP_NAME              VARCHAR(35),                           -- BSE Script Name
    SCRIP_GROUP             VARCHAR(3),                            -- BSE Scrip Group
    Bse_Scrip_ID            VARCHAR(100),                          -- BSE Scrip ID
    Bse_sublisting          VARCHAR(50),                           -- BSE Sublisting
    
    -- Company Information
    COMPNAME                VARCHAR(255),                          -- Company Long Name
    S_NAME                  VARCHAR(100),                          -- Company Short Name
    CIN                     VARCHAR(255),                          -- CIN
    
    -- Industry/Sector Information
    IND_CODE                INT,                                    -- AFPL's sector / Industry Code
    industry                VARCHAR(100),                          -- Industry name
    
    -- Business House Information
    HSE_CODE                INT,                                    -- AFPL's Business House Code
    house                   VARCHAR(50),                           -- HOUSE
    
    -- NSE Information
    SYMBOL                  VARCHAR(20),                           -- NSE Script Code
    SERIES                  VARCHAR(2),                            -- NSE Scrip Series
    securitytoken           INT,                                    -- NSE Security Token
    Nse_sublisting          VARCHAR(50),                           -- NSE Sublisting
    
    -- Security Information
    ISIN                    VARCHAR(20),                           -- ISIN Number
    FV                      FLOAT,                                  -- Face Value
    
    -- Financial Format
    RFORMAT                 VARCHAR(5),                            -- Result Format
    FFORMAT                 VARCHAR(5),                            -- Finance Format
    
    -- Company Leadership
    CHAIRMAN                VARCHAR(50),                           -- Chairman
    MDIR                    VARCHAR(100),                          -- Managing Director
    COSEC                   VARCHAR(100),                          -- Company Secretary
    
    -- Incorporation Details
    INC_MONTH               VARCHAR(15),                           -- Incorporation Month
    INC_YEAR                VARCHAR(4),                            -- Incorporated Year
    
    -- Status Information
    Status                  VARCHAR(15),                           -- Company Status Details (Active / In-active etc)
    Sublisting              VARCHAR(50),                           -- Sublisting
    FLAG                    VARCHAR(1)                             -- Updation Flag
);


-- Total Column Count: 29

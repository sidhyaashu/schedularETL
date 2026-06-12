CREATE TABLE Monthlyprice (
    -- Composite Primary Key
    Fincode                 INT NOT NULL,                          -- AFPL's Company Code
    Month                   INT NOT NULL,                          -- Month in digit
    Year                    INT NOT NULL,                          -- Year
    
    -- Security Information
    SCripCode               INT,                                    -- BSE Scrip Code
    
    -- Price Information
    Open                    FLOAT,                                  -- Open price of the month
    high                    FLOAT,                                  -- High price of the month
    low                     FLOAT,                                  -- Low price of the month
    Close                   FLOAT,                                  -- Close price of the month
    
    -- Volume and Value
    Volume                  NUMERIC,                               -- Total Volume for the month
    Value                   FLOAT,                                  -- Total Value for the month
    
    -- Status
    flag                    VARCHAR(1),                            -- Updation Flag
    
    -- Constraints
    PRIMARY KEY (Fincode, Month, Year)
);


-- Total Column Count: 11

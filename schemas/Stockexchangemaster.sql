CREATE TABLE Stockexchangemaster (
    -- Primary Key
    STK_ID                  INT PRIMARY KEY NOT NULL,              -- AccordFintech's Stock Exchange Code
    
    -- Stock Exchange Information
    STK_NAME                VARCHAR(100),                          -- Stock Exchange Name
    
    -- Status
    Flag                    VARCHAR(1)                             -- Updation Flag
);


-- Total Column Count: 3

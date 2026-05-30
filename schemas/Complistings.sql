CREATE TABLE Complistings (
    -- Composite Primary Key
    FINCODE                 INT NOT NULL,                          -- AccordFintech's Company Code
    STK_ID                  INT NOT NULL,                          -- AccordFintech's Stock Exchange Code (from Stockexchangemaster table)
    
    -- Status
    FLAG                    VARCHAR(1),                            -- Updation Flag
    
    -- Constraints
    PRIMARY KEY (FINCODE, STK_ID),
);


-- Total Column Count: 3

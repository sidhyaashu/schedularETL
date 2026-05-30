CREATE TABLE Board (
    -- Composite Primary Key
    FINCODE                 INT NOT NULL,                          -- AccordFintech's Company Code
    YRC                     INT NOT NULL,                          -- Financial Year End
    SERIALNO                INT NOT NULL,                          -- Sequential Serial Number of the entry
    DIRTYPE_ID              INT NOT NULL,                          -- Designation ID
    
    -- Display Order
    SRNO                    INT,                                    -- Serial Number in which the data should be displayed
    
    -- Director Information
    EFFECT_DATE             TIMESTAMP,                              -- Effective Date
    DIRNAME                 VARCHAR(255),                          -- Director's Name
    DirectorId              INT,                                    -- Director Name Code
    Reported_DSG            VARCHAR(255),                          -- Reported Designation
    Independent             VARCHAR(100),                          -- Independent
    
    -- Remuneration Information
    DIRREM                  FLOAT,                                  -- Directors Remuneration
    REM_UNIT                FLOAT,                                  -- Remuneration Units
    
    -- Status
    FLAG                    VARCHAR(1),                            -- Updation Flag
    
    -- Constraints
    PRIMARY KEY (FINCODE, YRC, SERIALNO, DIRTYPE_ID),
);


-- Total Column Count: 13

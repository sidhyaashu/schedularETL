CREATE TABLE Companyaddress (
    -- Primary Key
    FINCODE                 INT PRIMARY KEY NOT NULL,              -- AccordFintech's Company Code
    
    -- Address Information
    ADD1                    VARCHAR(500),                          -- Company Registered Address 1
    ADD2                    VARCHAR(500),                          -- Company Registered Address 2
    ADD3                    VARCHAR(500),                          -- Company Registered Address 3
    
    -- Location Details
    CITY_NAME               VARCHAR(50),                           -- City
    PINCODE                 VARCHAR(20),                           -- PIN code
    STATE_NAME              VARCHAR(50),                           -- State
    
    -- Contact Information
    PHONE                   VARCHAR(500),                          -- Telephone Numbers
    FAX_NO                  VARCHAR(150),                          -- Fax Number
    WEBSITE                 VARCHAR(150),                          -- Web site
    E_MAIL                  VARCHAR(150),                          -- Email Address
    
    -- Status
    Flag                    VARCHAR(1),                            -- Updation Flag
    
    -- Constraints
);


-- Total Column Count: 12

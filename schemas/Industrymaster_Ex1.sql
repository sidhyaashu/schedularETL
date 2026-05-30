CREATE TABLE Industrymaster_Ex1 (
    -- Primary Key
    Ind_code                INT PRIMARY KEY NOT NULL,              -- AccordFintech's Industry Code
    
    -- Industry Information
    Industry                VARCHAR(100),                          -- Industry Name
    Ind_shortname           VARCHAR(100),                          -- Industry short name
    
    -- Sector Information
    Sector                  VARCHAR(100),                          -- SECTOR
    Sector_code             INT,                                    -- Sector code
    
    -- Status
    Flag                    VARCHAR(1)                             -- Updation Flag
);


-- Total Column Count: 6

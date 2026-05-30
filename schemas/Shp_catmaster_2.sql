CREATE TABLE Shp_catmaster_2 (
    -- Primary Key
    SHP_CATID               INT PRIMARY KEY NOT NULL,              -- Shareholders category ID
    
    -- Category Information
    SHP_CATNAME             VARCHAR(255),                          -- Shareholders category Name
    SUB_CATEGORY            VARCHAR(255),                          -- Shareholders sub category Name
    
    -- Status
    Flag                    VARCHAR(1)                             -- Updation Flag
);


-- Total Column Count: 4

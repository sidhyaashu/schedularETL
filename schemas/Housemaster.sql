CREATE TABLE Housemaster (
    -- Primary Key
    HOUSE_CODE              INT PRIMARY KEY NOT NULL,              -- AccordFintech's Business House Code
    
    -- House Information
    HOUSE                   VARCHAR(50),                           -- House Name
    
    -- Status
    Flag                    VARCHAR(1)                             -- Updation Flag
);


-- Total Column Count: 3

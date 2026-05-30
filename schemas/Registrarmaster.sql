CREATE TABLE Registrarmaster (
    -- Primary Key
    RegistrarNo             INT PRIMARY KEY NOT NULL,              -- Registrar Master Code
    
    -- Registrar Information
    RegistrarName           VARCHAR(255),                          -- Registrar Name
    
    -- Address Information
    RegAddress              VARCHAR(255),                          -- Address 1
    RegistrarAddress1       VARCHAR(255),                          -- Address 2
    RegistrarAddress2       VARCHAR(255),                          -- Address 3
    RegistrarAddress3       VARCHAR(255),                          -- Address 4
    
    -- Contact Information
    RegistrarPhone          VARCHAR(255),                          -- Telephone Number
    RegistrarFax            VARCHAR(255),                          -- Fax Number
    RegistrarEMail          VARCHAR(255),                          -- Email Id
    RegistrarWebSite        VARCHAR(255),                          -- Website URL
    
    -- Status
    Flag                    VARCHAR(1)                             -- Updation Flag
);


-- Total Column Count: 11

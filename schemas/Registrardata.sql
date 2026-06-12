CREATE TABLE Registrardata (
    -- Composite Primary Key
    FINCODE                 INT NOT NULL,                          -- AccordFintech's Company Code
    RegistrarNo             INT NOT NULL,                          -- Registrar No (from Registrarmaster table)
    
    -- Status
    Flag                    VARCHAR(1),                            -- Updation Flag
    
    -- Constraints
    PRIMARY KEY (FINCODE, RegistrarNo)
);


-- Total Column Count: 3

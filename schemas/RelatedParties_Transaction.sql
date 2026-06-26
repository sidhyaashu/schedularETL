CREATE TABLE RelatedParties_Transaction (
    -- Composite Primary Key
    FINCODE                             INT NOT NULL,                          -- AFPL’s Company Code
    YEAR_END                            INT NOT NULL,                          -- YEAR END
    SRNO                                INT NOT NULL,                          -- SRNO
    
    -- Transaction Information
    Type                                VARCHAR(1),                            -- Type
    Transactions                        VARCHAR(200),                          -- Transactions
    Party                               VARCHAR(200),                          -- Party
    
    -- Party Details / Values
    SubsidiaryDirect                    FLOAT,                                  -- SubsidiaryDirect
    SubsidiaryIndirect                  FLOAT,                                  -- SubsidiaryIndirect
    Associates                          FLOAT,                                  -- Associates
    Joint_ventures                      FLOAT,                                  -- Joint Ventures
    Key_Management_Personnel            FLOAT,                                  -- Key Management Personnel
    Relatives_Key_Management_Personnel  FLOAT,                                  -- Relatives Key Management Personnel
    Other_Specify                       VARCHAR(200),                          -- Other Specify
    Other                               FLOAT,                                  -- Other
    Total                               FLOAT,                                  -- Total
    Group_Companies                     FLOAT,                                  -- Group Companies
    Holding_Companies                   FLOAT,                                  -- Holding Companies
    Promoters                           FLOAT,                                  -- Promoters
    Unit                                INT,                                    -- Unit
    Enterprises_Under_Managements       FLOAT,                                  -- Enterprises Under Managements
    
    -- Status
    flag                                VARCHAR(1),                            -- Updation Flag
    
    -- Constraints
    PRIMARY KEY (FINCODE, YEAR_END, SRNO)
);

CREATE TABLE Shp_details (
    -- Composite Primary Key
    FINCODE                 INT NOT NULL,                          -- Company Code
    DATE_END                INT NOT NULL,                          -- Date End
    SRNO                    INT NOT NULL,                          -- Serial Number
    
    -- Shareholder Information
    SHP_CATID               INT,                                    -- Shareholders category ID
    NAME                    VARCHAR(255),                          -- Name
    
    -- Shareholding Details
    PERCENTAGE              FLOAT,                                  -- Percentage
    NO_OF_SHARES            FLOAT,                                  -- No. of shares
    
    -- Pledge Information
    PledgeEncumberedNoofShares FLOAT,                               -- Pledge No of Shares
    PledgeEncumberedPercentage FLOAT,                               -- Pledge Percentage
    
    -- Status
    Flag                    VARCHAR(1),                            -- Updation Flag
    
    -- Constraints
    PRIMARY KEY (FINCODE, DATE_END, SRNO)
);


-- Total Column Count: 10

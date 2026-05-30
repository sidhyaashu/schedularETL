CREATE TABLE Finance_cf (
    -- Composite Primary Key
    FINCODE                 INT NOT NULL,                          -- Accord Company Code
    Year_end                INT NOT NULL,                          -- Year End
    type                    VARCHAR(1) NOT NULL,                   -- To indicate type of the balancesheet (S = Standalone, C = Consolidated)
    
    -- Basic Information
    No_Months               INT,                                    -- No. of Months balncesheet
    Unit                    VARCHAR(50),                           -- To indicate figures are in which unit
    
    -- Cash Flow Statement
    Profit_bef_tax          FLOAT,                                  -- Profit_bef_tax
    Adjustment_total        FLOAT,                                  -- Adjustment_total
    Change_WC_total         FLOAT,                                  -- Change_WC_total
    Tax_paid                FLOAT,                                  -- Tax_paid
    Other_Dir_exps          FLOAT,                                  -- Other_Dir_exps
    Cash_from_Operation     FLOAT,                                  -- Cash_from_Operation
    Cash_from_Investment    FLOAT,                                  -- Cash_from_Investment
    Cash_from_Financing     FLOAT,                                  -- Cash_from_Financing
    FExchDiff               FLOAT,                                  -- FExchDiff
    Net_Cash_inflow_outflow FLOAT,                                  -- Net_Cash_inflow_outflow
    Opening_cash            FLOAT,                                  -- Opening_cash
    Cash_amalgmation        FLOAT,                                  -- Cash_amalgmation
    Cash_subsidiaries       FLOAT,                                  -- Cash_subsidiaries
    Traslation_adj_Subsidiaries FLOAT,                              -- Traslation_adj_Subsidiaries
    Effect_foreign_exchange FLOAT,                                  -- Effect_foreign_exchange
    Closing_cash            FLOAT,                                  -- Closing_cash
    Cashflow_after_WC       FLOAT,                                  -- Cashflow_after_WC
    
    -- Status
    Flag                    VARCHAR(1),                            -- Updation Flag
    
    -- Constraints
    PRIMARY KEY (FINCODE, Year_end, type),
);


-- Total Column Count: 23

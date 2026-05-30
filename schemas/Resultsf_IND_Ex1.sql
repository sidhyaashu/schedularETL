CREATE TABLE Resultsf_IND_Ex1 (
    -- Composite Primary Key
    Fincode                 INT NOT NULL,                          -- Company Code
    Result_Type             VARCHAR(2) NOT NULL,                   -- Result Type (Q-Quarterly, QR-Quarterly revised, H-Halfyearly, HR-Halfyearly revised, A-Annual, AR-Annual revised)
    Date_End                INT NOT NULL,                          -- Date End
    
    -- Basic Information
    NoOfMonths              INT,                                    -- No of Months
    
    -- Revenue and Income
    Net_Sales               FLOAT,                                  -- Total Revenue from Operations
    Gross_Sale              FLOAT,                                  -- Interest Income
    Excise_Duty             FLOAT,                                  -- GST
    Other_NetSales          FLOAT,                                  -- Income from Operations_net
    Job_Works               FLOAT,                                  -- Other Operating Income
    Other_Income            FLOAT,                                  -- Other Income
    Dividend_Income         FLOAT,                                  -- Dividend Income
    Export_Incentives       FLOAT,                                  -- Export Incentives
    Foreign_exchange_gain   FLOAT,                                  -- Foreign Exchange Gain
    Profit_Investment       FLOAT,                                  -- Profit on sale of Investments
    Other_Interest_income   FLOAT,                                  -- Interest Income
    rental_income           FLOAT,                                  -- Lease / Rental Income
    Sale_Shares_Units       FLOAT,                                  -- Profit on sale of Share
    Prov_written_back       FLOAT,                                  -- Provision Written Back
    Sale_Assets             FLOAT,                                  -- Profit on sale of Asset
    Other_Other_Income      FLOAT,                                  -- Other Income
    Total_Income            FLOAT,                                  -- Total Income
    
    -- Expenditure
    Expenditure             FLOAT,                                  -- Total Expenditure
    Inc_Dec_Inventory       FLOAT,                                  -- (Increase) / Decrease In Stocks
    Excise                  FLOAT,                                  -- Excise Duty
    Raw_Material_Cost       FLOAT,                                  -- Raw Material Cost
    PURCHASE_FIN_GOOD       FLOAT,                                  -- Purchase of Finished Goods
    Mfg_Exps                FLOAT,                                  -- Manufacturing Expenses
    Electricity_Power_Fuel  FLOAT,                                  -- Electricity , Power & Fuel Cost
    Exployee_Cost           FLOAT,                                  -- Employees Cost
    Interest                FLOAT,                                  -- Interest
    Depreciation            FLOAT,                                  -- Depreciation
    Gen_AdminExpenses       FLOAT,                                  -- General Administration Expenses
    Selling_Dist_Expenses   FLOAT,                                  -- Selling & Distribution Expenses
    Misc_Expenses           FLOAT,                                  -- Misc Expenses
    Loss_Foreign_exchange   FLOAT,                                  -- Loss_Foreign_exchange
    LossForeignExchangeLoan FLOAT,                                  -- Loss_Foreign_exchange_loan
    Expence_Capitalised     FLOAT,                                  -- Expenses Capitalised
    
    -- Profit Calculations
    PB_ExItem_SATax         FLOAT,                                  -- Profit before Exceptional Items, Share of Associates and tax
    Exception_Items         FLOAT,                                  -- Exceptional Items
    Exc_foreign_exch_gain   FLOAT,                                  -- Foreign Exchange Gain/Loss
    Exc_other               FLOAT,                                  -- Other Exceptional items
    PB_SATax                FLOAT,                                  -- Profit before Share of Associates and tax
    Shares_Associate        FLOAT,                                  -- Share of (loss)/profit in Associates and Joint Ventures
    Pbt                     FLOAT,                                  -- Profit before tax
    
    -- Tax Information
    Tax                     FLOAT,                                  -- Tax
    Curr_tax                FLOAT,                                  -- Current Tax
    Def_tax                 FLOAT,                                  -- Deferred Tax
    Fringe_benefits         FLOAT,                                  -- Fringe Benefit Tax
    Prior_Period_Tax        FLOAT,                                  -- Prior Period / Year Tax
    Mat_Credit              FLOAT,                                  -- MAT Credit
    Other_Tax               FLOAT,                                  -- Other Tax
    
    -- Profit After Tax
    Pat                     FLOAT,                                  -- Profit after Tax
    Pbt_DiscOperations      FLOAT,                                  -- Profit before tax from discontinued operations
    TaxExp_DiscOperations   FLOAT,                                  -- Tax expense of discontinued operations
    Discontinued_Op         FLOAT,                                  -- Profit for the period from discontinued operations
    Other_related_items     FLOAT,                                  -- Other related Items
    Net_Profit              FLOAT,                                  -- Profit for the period
    
    -- Comprehensive Income
    Other_CompIncome        FLOAT,                                  -- Other Comprehensive Incomes (Net of tax )
    Items_NotClassif_PL     FLOAT,                                  -- Items that will not be reclassified to profit or loss
    IT_Items_NotClassif_PL  FLOAT,                                  -- Income tax relating to items that will not be reclassified to profit or loss
    Items_Classif_PL        FLOAT,                                  -- Items that will be reclassified to profit or loss
    IT_Items_Classif_PL     FLOAT,                                  -- Income tax relating to Items that will be reclassified to profit or loss
    MININT_COMPINCOME       FLOAT,                                  -- Minority Interest Comprehensive Income
    OthCinc_Other           FLOAT,                                  -- Other
    TOTAL_COMPINCOME        FLOAT,                                  -- Total Comprehensive Income
    
    -- Ownership Breakdown
    NetProfit_OwnOfParent   FLOAT,                                  -- Owners of the Parent
    NetProfit_NonContInt    FLOAT,                                  -- Non-controlling interests
    Other_CompInc_OwnOfParent FLOAT,                                -- Owners of the Parent
    Other_CompInc_NonContInt FLOAT,                                 -- Non-controlling interests
    TotalCompIncome_OwnOfParent FLOAT,                              -- Owners of the Parent
    Minority_interest       FLOAT,                                  -- Non-controlling interests
    
    -- Equity Information
    Equity_Cap              FLOAT,                                  -- Equity Capital
    Fv                      FLOAT,                                  -- Face Value (In Rs)
    Reserves                FLOAT,                                  -- Reserves
    
    -- EPS Calculations
    EPSAbs                  FLOAT,                                  -- Calculated EPS (Unit.Curr.)
    EPSAnn                  FLOAT,                                  -- Calculated EPS Annualised (Unit.Curr.)
    Adj_eps_abs             FLOAT,                                  -- Adj Calculated EPS (Unit.Curr.)
    Adj_eps_ann             FLOAT,                                  -- Adj Calculated EPS Annualised (Unit.Curr.)
    eps_basic               FLOAT,                                  -- Basic EPS
    eps_diluted_extraord    FLOAT,                                  -- Diluted EPS
    
    -- Margin Ratios
    PBIDTMEXOI              FLOAT,                                  -- PBIDTM% (Excl OI)
    PBIDTM                  FLOAT,                                  -- PBIDTM%
    PBDTM                   FLOAT,                                  -- PBDTM%
    PBTM                    FLOAT,                                  -- PBTM%
    PATM                    FLOAT,                                  -- PATM%
    
    -- Banking Income
    Rev_Div_Income          FLOAT,                                  -- Dividend Income
    Rev_Fee_Comm            FLOAT,                                  -- Fees and Commission Income
    Rev_Gain_Fairvalue      FLOAT,                                  -- Gain on Fair value changes
    Rev_Gain_finassets      FLOAT,                                  -- Gain on de-recognised of Financial Instruments / Loans
    Inc_Inv                 FLOAT,                                  -- Profit on sale of Investments
    Int_Bal                 FLOAT,                                  -- Interest on Balances With RBI  Other Inter Bank Funds
    Int_Adv                 FLOAT,                                  -- Interest / Discount on Advances / Bills
    Int_Others              FLOAT,                                  -- Others
    
    -- Banking Expenses
    Operating_Ex            FLOAT,                                  -- Operating Expenses
    Prov_Emp                FLOAT,                                  -- Payment To  Provisions For Employees
    Other_Exp               FLOAT,                                  -- Other Operating Expenses
    Operating_Profit        FLOAT,                                  -- Operating Profit before Prov.& Cont.
    Pac                     FLOAT,                                  -- Provisions and Contingencies
    EI                      FLOAT,                                  -- Extraordinary Items
    PPI                     FLOAT,                                  -- Prior Period Items
    
    -- Banking Ratios
    Govt_Percent_Of_Shares  FLOAT,                                  -- % of Shares held by Govt
    Cap_Ratio_Percent       FLOAT,                                  -- Capital Adeqacy Ratio Basel II
    Cap_Ratio_Percent3      FLOAT,                                  -- Capital Adeqacy Ratio Basel III
    Tier1basel3             FLOAT,                                  -- Tier I Basel III
    Tier2basel3             FLOAT,                                  -- Tier 2 Basel III
    Gross_Net_Npa           FLOAT,                                  -- Gross / Net NPA
    NPA_Gross               FLOAT,                                  -- Amount of Gross NPA
    NPA_Net                 FLOAT,                                  -- Amount of Net NPA
    Perc_Gross_Net_Npa      FLOAT,                                  -- Percentage of Gross/Net NPA
    NPA_Net_perc            FLOAT,                                  -- % of Net NPAs
    NPA_Gross_perc          FLOAT,                                  -- % of Gross NPAs
    Roa                     FLOAT,                                  -- Return on Assets
    
    -- Shareholding Information
    Prom_No_Of_Shares       FLOAT,                                  -- Number of Public Share Holding
    Prom_Percent_Of_Shares  FLOAT,                                  -- % of Public Share Holding
    eps_basic_extraord      FLOAT,                                  -- Basic EPS before Extraordinary Items
    eps_diluted             FLOAT,                                  -- Diluted EPS before Extraordinary Items
    Promoter_NOS            FLOAT,                                  -- Promoters No of Shares
    Encumbered_NOS          FLOAT,                                  -- Encumbered No of Shares
    percentage_pledgedpromoter FLOAT,                               -- Encumbered % of Promoter Holdings
    Percentage_PledgedCapital FLOAT,                                -- Encumbered % of Share Capital
    NonPledgedEncum         FLOAT,                                  -- Non Encumbered
    NonPledged_NOS          FLOAT,                                  -- Non Encumbered No of Shares
    Percentage_NonPledgedPromoter FLOAT,                            -- Non Encumbered % of Promoter Holdings
    Percentage_NonPledgedCapital FLOAT,                             -- Non Encumbered % of Share Capital
    
    -- Banking Metrics
    CASA                    FLOAT,                                  -- CASA%
    CASA_AMOUNT             FLOAT,                                  -- CASA Amount
    NIM                     FLOAT,                                  -- NIM %
    GROSS_PROFIT            FLOAT,                                  -- Gross Profit
    PREF_CAP                FLOAT,                                  -- Preference Capital
    Misc_expd_woff          FLOAT,                                  -- Misc. Expenses Written off
    Consolidated_net_profit FLOAT,                                  -- Consolidated Net Profit
    NOTES                   TEXT,                                  -- Note
    
    -- Additional Ratios
    return_on_capital_employed  FLOAT,                               -- Return on Capital Employed (ignore this field)
    Debt_Equity_Ratio       FLOAT,                                  -- Debt/Equity Ratio
    Interest_Coverage_Ratio FLOAT,                                  -- Interest Coverage Ratio
    Inventory_Turnover_Ratio FLOAT,                                 -- Inventory Turnover Ratio
    Debtor_Turnover_Ratio   FLOAT,                                  -- Debtor Turnover Ratio
    Dividend_per_share      FLOAT,                                  -- Dividend per share
    Dividend_payout_ratio   FLOAT,                                  -- Dividend payout ratio
    Other_Adjustments       FLOAT,                                  -- Other Adjustments
    pbidtxoi                FLOAT,                                  -- PBIDT (Excl OI)
    OPERATING_PROFIT_MARGIN FLOAT,                                  -- Operating Profit Magin (ignore this field. You can refer PBIDTM field)
    NET_PROFIT_MARGIN       FLOAT,                                  -- Net Profit Margin (ignore this field. You can refer PATM field)
    
    -- Balance Sheet Items
    Cash_bank               FLOAT,                                  -- Cash and Cash Equivalents
    Debtors                 FLOAT,                                  -- Debtors
    Inventory               FLOAT,                                  -- Inventory
    Loans_adv               FLOAT,                                  -- Loans and Advances
    
    -- Shareholding Aggregates
    nsGrandTotal            FLOAT,                                  -- Number of shares outstanding
    nsTotalpublic           FLOAT,                                  -- nsTotalpublic
    tpTotalpublic           FLOAT,                                  -- tpTotalpublic
    
    -- Banking Coverage
    Provisions_Coverage     FLOAT,                                  -- Provisions Coverage %
    
    -- Banking Infrastructure
    No_of_ATMs              FLOAT,                                  -- No of ATMs
    No_of_Branches          FLOAT,                                  -- No of Branches
    Tier_I_Basel_II         FLOAT,                                  -- Tier I Basel II
    Tier_2_Basel_II         FLOAT,                                  -- Tier 2 Basel II
    No_of_Employes          FLOAT,                                  -- No of Employes
    
    -- Status
    Flag                    VARCHAR(1),                            -- Updation Flag
    
    -- Constraints
    PRIMARY KEY (Fincode, Result_Type, Date_End),
);


-- Total Column Count: 157

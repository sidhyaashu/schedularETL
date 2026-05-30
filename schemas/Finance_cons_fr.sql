CREATE TABLE Finance_cons_fr (
    -- Composite Primary Key
    FINCODE                 INT NOT NULL,                          -- Accord Company Code
    Year_end                INT NOT NULL,                          -- Year End
    TYPE                    VARCHAR(1) NOT NULL,                   -- To indicate type of the balancesheet (S = Standalone, C = Consolidated)
    
    -- Per Share Ratios
    Reported_EPS            FLOAT,                                  -- Reported EPS
    Adjusted_EPS            FLOAT,                                  -- Adjusted EPS
    CEPS                    FLOAT,                                  -- Cash Earnings per share
    DPS                     FLOAT,                                  -- Dividend Per share
    Book_NAV_Share          FLOAT,                                  -- Book NAV Share
    
    -- Profitability Ratios
    Tax_Rate                FLOAT,                                  -- Tax Rate
    Core_EBITDA_Margin      FLOAT,                                  -- Core EBITDA Margin
    EBIT_Margin             FLOAT,                                  -- EBIT Margin
    Pre_Tax_Margin          FLOAT,                                  -- Pre Tax Margin
    PAT_Margin              FLOAT,                                  -- PAT Margin
    Cash_Profit_Margin      FLOAT,                                  -- Cash Profit Margin
    
    -- Return Ratios
    ROA                     FLOAT,                                  -- Return On Assets
    ROE                     FLOAT,                                  -- Return On Equity
    ROCE                    FLOAT,                                  -- Return On Capital Employed
    
    -- Turnover Ratios
    Asset_Turnover          FLOAT,                                  -- Asset Turnover
    Sales_Fixed_Asset       FLOAT,                                  -- Sales Fixed Asset
    Working_Capital_Sales   FLOAT,                                  -- Working Capital Sales
    Fixed_Capital_Sales     FLOAT,                                  -- Fixed Capital Sales
    
    -- Working Capital Ratios
    Receivable_days         FLOAT,                                  -- Receivable days
    Inventory_Days          FLOAT,                                  -- Inventory_Days
    Payable_days            FLOAT,                                  -- Payable_days
    
    -- Valuation Ratios
    PER                     FLOAT,                                  -- Price earning ratio
    PCE                     FLOAT,                                  -- Price to cash earnings
    Price_Book              FLOAT,                                  -- Price_Book
    Yield                   FLOAT,                                  -- Dividend Yield
    
    -- Enterprise Value Ratios
    EV_Net_Sales            FLOAT,                                  -- EV to Net Sales
    EV_Core_EBITDA          FLOAT,                                  -- EV to Core EBITDA
    EV_EBIT                 FLOAT,                                  -- EV to EBIT
    EV_CE                   FLOAT,                                  -- EV to Capital Employed
    MCap_Sales              FLOAT,                                  -- MCap to Sales
    
    -- Growth Ratios
    Net_Sales_Growth        FLOAT,                                  -- Net Sales Growth
    PBIDT_Excl_OI_Growth    FLOAT,                                  -- PBIDT to Excl OI Growth
    Core_EBITDA_Growth      FLOAT,                                  -- Core EBITDA Growth
    EBIT_Growth             FLOAT,                                  -- EBIT Growth
    PAT_Growth              FLOAT,                                  -- PAT Growth
    Adj_PAT_Growth          FLOAT,                                  -- Adj PAT Growth
    Adj_EPS_Growth          FLOAT,                                  -- Adj EPS Growth
    Reported_EPS_Growth     FLOAT,                                  -- Reported EPS Growth
    
    -- Leverage Ratios
    Total_Debt_Equity       FLOAT,                                  -- Total Debt Equity
    Current_Ratio           FLOAT,                                  -- Current Ratio
    Quick_Ratio             FLOAT,                                  -- Quick Ratio
    Interest_Cover          FLOAT,                                  -- Interest Cover ratio
    Total_Debt_Mcap         FLOAT,                                  -- Total Debt to Mcap
    
    -- Banking Ratios
    Yield_Adv               FLOAT,                                  -- Yield Adv
    Yield_Inv               FLOAT,                                  -- Yield Inv
    Cost_Liab               FLOAT,                                  -- Cost Liab
    NIM                     FLOAT,                                  -- Net Interest margin
    Int_Spread              FLOAT,                                  -- Interest Spread ratio
    Cost_IncRatio           FLOAT,                                  -- Cost Income ratio
    Core_Cost_IncRatio      FLOAT,                                  -- Core Cost Income ratio
    OpCost_Asset            FLOAT,                                  -- Operating Cost to Asset
    Adj_PER                 FLOAT,                                  -- Adj PER
    Tier1Ratio              FLOAT,                                  -- Tier1Ratio
    Tier2Ratio              FLOAT,                                  -- Tier2Ratio
    CAR                     FLOAT,                                  -- CAR
    
    -- Additional Growth Ratios
    CoreOpIncomeGrowth      FLOAT,                                  -- Operating income growth
    EPSGrowth               FLOAT,                                  -- EPS Growth
    BVPSGrowth              FLOAT,                                  -- BVPS Growth
    Adv_Growth              FLOAT,                                  -- Advances Growth
    
    -- Banking Specific Ratios
    LoanDeposits            FLOAT,                                  -- Loan to Deposits
    CashDeposits            FLOAT,                                  -- Cash to Deposits
    InvestmentDeposits      FLOAT,                                  -- Investment to Deposits
    IncLoanDeposits         FLOAT,                                  -- IncLoan to Deposits
    GrossNPA                FLOAT,                                  -- Gross NPA %
    NetNPA                  FLOAT,                                  -- Net NPA %
    Ownersfund_total_Source FLOAT,                                  -- Ownersfund total Source
    
    -- Efficiency Ratios
    Fixed_Assets_TA         FLOAT,                                  -- Gross sales to Net block
    Inventory_TR            FLOAT,                                  -- Inventory TR (ignore this field)
    Dividend_PR_NP          FLOAT,                                  -- Dividend PR NP
    Dividend_PR_CP          FLOAT,                                  -- Dividend PR CP
    Earning_Retention_Ratio FLOAT,                                  -- Earning Retention Ratio
    Cash_Earnings_Retention FLOAT,                                  -- Cash Earnings Retention
    Price_BV                FLOAT,                                  -- Price BV
    Return_Sales            FLOAT,                                  -- Return Sales
    Debt_TA                 FLOAT,                                  -- Debt TA
    EV                      FLOAT,                                  -- Enterprise value (Units will be as per Annual Financial data of specific company)
    PriceSalesRatio         FLOAT,                                  -- PriceSalesRatio (Ignore this field)
    EV_EBITA                FLOAT,                                  -- EV EBITA (Ignore this field)
    
    -- Cash Flow Ratios
    CF_PerShare             FLOAT,                                  -- CF PerShare
    PCF_RATIO               FLOAT,                                  -- PCF RATIO
    FCF_Share               FLOAT,                                  -- FCF Share
    PFCF_Ratio              FLOAT,                                  -- PFCF Ratio
    FCF_Yield               FLOAT,                                  -- FCF Yield
    SCF_Ratio               FLOAT,                                  -- SCF Ratio
    
    -- Additional Ratios
    GPM                     FLOAT,                                  -- GPM. Ignore this field.
    SalesToTotalAssets      FLOAT,                                  -- Sales To Total Assets
    SalesToCurrentAssets    FLOAT,                                  -- Sales To Current Assets
    
    -- Capital Adequacy Ratios (Basel I)
    Total_CAR_baseI         FLOAT,                                  -- Total CAR baseI
    TI_CAR_baseI            FLOAT,                                  -- TI CAR baseI
    TII_CAR_baseI           FLOAT,                                  -- TII CAR baseI
    Total_CAR               FLOAT,                                  -- Total CAR
    TI_CAR                  FLOAT,                                  -- TI CAR
    TII_CAR                 FLOAT,                                  -- TII CAR
    
    -- NPA Ratios
    NPA_Gross               FLOAT,                                  -- Gross NPA Amount
    NPA_Net                 FLOAT,                                  -- Net NPA Amount
    NPA_Advances            FLOAT,                                  -- Net NPA %
    
    -- Profitability Breakdown
    NetProfit_To_PBT        FLOAT,                                  -- NetProfit To PBT
    PBT_To_PBIT             FLOAT,                                  -- PBT To PBIT
    PBIT_To_Sales           FLOAT,                                  -- PBIT To Sales
    NetProfit_To_Sales      FLOAT,                                  -- NetProfit To Sales
    NetSales_To_TotalAssets FLOAT,                                  -- NetSales To TotalAssets
    Return_On_Assets        FLOAT,                                  -- Return On Assets. Ignore this field and refer ROA field.
    Assets_To_Equity        FLOAT,                                  -- Assets To Equity
    Return_On_Equity        FLOAT,                                  -- Return On Equity
    Interest_To_Debt        FLOAT,                                  -- Interest To Debt
    Debt_To_Assets          FLOAT,                                  -- Debt To Assets
    Interest_To_Assets      FLOAT,                                  -- Interest To Assets
    ROE_After_Interest      FLOAT,                                  -- ROE After Interest
    Dividend_Payout_Per     FLOAT,                                  -- Dividend Payout Per
    OtherIncome_To_NetWorth FLOAT,                                  -- OtherIncome To NetWorth
    ROA_After_Interest      FLOAT,                                  -- ROA After Interest
    ROE_Before_OtherInc     FLOAT,                                  -- ROE Before OtherInc
    ROE_After_OtherInc      FLOAT,                                  -- ROE After OtherInc
    ROE_After_Tax_Rate      FLOAT,                                  -- ROE After Tax Rate
    
    -- Banking Ratios (Continued)
    Credit_Deposit          FLOAT,                                  -- Credit to Deposit
    InterestExpended_InterestEarned FLOAT,                          -- InterestExpended to InterestEarned
    InterestIncome_TotalFunds FLOAT,                                -- InterestIncome to TotalFunds
    InterestExpended_TotalFunds FLOAT,                              -- InterestExpended to TotalFunds
    NetInterestIncome_TotalFunds FLOAT,                             -- NetInterestIncome to TotalFunds
    CASA                    FLOAT,                                  -- CASA
    
    -- Turnover Ratios
    Inventory_Turnover      FLOAT,                                  -- Inventory Turnover
    Debtors_Turnover        FLOAT,                                  -- Debtors Turnover
    
    -- Adjusted Ratios
    Adj_PE                  FLOAT,                                  -- Adj PE
    Adjusted_bv             FLOAT,                                  -- Adjusted bv
    Adj_DPS                 FLOAT,                                  -- Adj DPS
    
    -- Growth Ratios (Continued)
    Networth_Growth         FLOAT,                                  -- Networth Growth
    CE_Growth               FLOAT,                                  -- CE Growth (ignore this field)
    GB_Growth               FLOAT,                                  -- GB Growth (ignore this field)
    PBDT_Growth             FLOAT,                                  -- PBDT Growth
    PBIT_Growth             FLOAT,                                  -- PBIT Growth
    PBT_Growth              FLOAT,                                  -- PBT Growth
    CP_Growth               FLOAT,                                  -- CP Growth (ignore this field)
    Exports_Growth          FLOAT,                                  -- Exports Growth
    Imports_Growth          FLOAT,                                  -- Imports Growth
    MCap_Growth             FLOAT,                                  -- MCap Growth
    
    -- Margin Ratios
    EBIDTAM                 FLOAT,                                  -- EBIDTAM
    PBDTM                   FLOAT,                                  -- PBDTM
    
    -- Additional Ratios
    LT_Debt_Equity_Ratio    FLOAT,                                  -- LT Debt Equity Ratio
    ROIC                    FLOAT,                                  -- ROIC
    
    -- Capital Adequacy Ratios (Basel III)
    Total_car_b             FLOAT,                                  -- Total CAR (Basel III)
    TI_CAR_b                FLOAT,                                  -- Tier - 1 (Basel III)
    TII_CAR_b               FLOAT,                                  -- Tier - 2 (Basel III)
    
    -- Status
    Flag                    VARCHAR(1),                            -- Updation Flag
    
    -- Constraints
    PRIMARY KEY (FINCODE, Year_end, TYPE),
);


-- Total Column Count: 146

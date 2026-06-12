CREATE TABLE Finance_pl (
    -- Composite Primary Key
    FINCODE                 INT NOT NULL,                          -- Accord Company Code
    Year_end                INT NOT NULL,                          -- Year End
    TYPE                    VARCHAR(1) NOT NULL,                   -- To indicate type of the balancesheet (S = Standalone, C = Consolidated)
    
    -- Basic Information
    No_Months               INT,                                    -- No. of Months balncesheet
    Unit                    VARCHAR(50),                           -- To indicate figures are in which unit
    
    -- Income Statement
    Interest_earned         FLOAT,                                  -- Interest_earned
    Other_income            FLOAT,                                  -- Other Income
    Total_income            FLOAT,                                  -- Total Income
    Interest                FLOAT,                                  -- Interest
    Operating_expenses      FLOAT,                                  -- Varchar(50)
    Provisions_contigency   FLOAT,                                  -- Provisions and Contingencies
    Tax                     FLOAT,                                  -- Income tax
    Total                   FLOAT,                                  -- Total (total expenditure for banks)
    Profit_after_tax        FLOAT,                                  -- Profit After Tax
    extra_items             FLOAT,                                  -- Extra items
    Profit_Brought_forward  FLOAT,                                  -- Profit Balance B/F
    Minority_interest       FLOAT,                                  -- Minority Interest
    Share_Associate         FLOAT,                                  -- Share of Associate
    Other_ConsItems         FLOAT,                                  -- Other Consolidated Items
    Consolidated_NetProfit  FLOAT,                                  -- Consolidated Net Profit
    Adj_Net_profit          FLOAT,                                  -- Adjustments to PAT
    Extr_Items              FLOAT,                                  -- Extra items
    PNLBF                   FLOAT,                                  -- Profit brought forward
    Profit_availble_appr    FLOAT,                                  -- APPROPRIATIONS
    Appropriation           FLOAT,                                  -- Appropriations
    Dividend_perc           FLOAT,                                  -- Equity Dividend %
    Reported_EPS            FLOAT,                                  -- Reported EPS
    
    -- Sales and Revenue
    Gross_sales             FLOAT,                                  -- Gross_sales
    Net_sales               FLOAT,                                  -- Net Sales
    Inc_Dec_Inventory       FLOAT,                                  -- Increase/Decrease in Stock
    Raw_matrs_consumed      FLOAT,                                  -- Raw Material Consumed
    Employees               FLOAT,                                  -- Employee Cost
    Other_Mfg_Exps          FLOAT,                                  -- Other Manufacturing Expenses
    Sellg_Admn_Exps         FLOAT,                                  -- Selling, Administration and Other Expenses
    Misc_exps               FLOAT,                                  -- Miscellaneous Expenses
    Pre_Op_exps             FLOAT,                                  -- Less: Expenses Capitalised
    Total_expendiure        FLOAT,                                  -- Total Expenditure
    Operating_profit        FLOAT,                                  -- Operating Profit
    Depreciation            FLOAT,                                  -- Depreciation
    Profit_before_exception FLOAT,                                  -- Profit_before_exception
    ExceptionalIncome_Expenses FLOAT,                               -- Exceptional Income / Expenses
    Profit_before_tax       FLOAT,                                  -- Profit Before Tax
    Taxation                FLOAT,                                  -- Provision for Tax
    Profit_available_appropriation FLOAT,                           -- Profit Available for appropriations
    Total_gross_sales       FLOAT,                                  -- Sales Turnover
    Excise                  FLOAT,                                  -- Less: Excise
    Power_Fuel              FLOAT,                                  -- Power & Fuel Cost
    Gross_profits           FLOAT,                                  -- Gross_profits
    inter_div_trf           FLOAT,                                  -- Less: Inter divisional transfers
    Sales_return            FLOAT,                                  -- Less: Sales Returns
    Sellg_Exps              FLOAT,                                  -- Selling and Distribution Expenses
    Cost_SW                 FLOAT,                                  -- Cost of Software development
    Provision_investment    FLOAT,                                  -- Provision for investments
    Provision_advances      FLOAT,                                  -- Provision for advances
    Provision_other         FLOAT,                                  -- Others
    Curr_tax                FLOAT,                                  -- Current Income Tax
    Def_tax                 FLOAT,                                  -- Deferred Tax
    Fringe_benefits         FLOAT,                                  -- Fringe Benefit tax
    Wealth_tax              FLOAT,                                  -- Wealth Tax
    Interest_advances_Bills FLOAT,                                  -- Interest/Discount on advances/Bills
    Job_works               FLOAT,                                  -- Job works
    Service_income          FLOAT,                                  -- Service income
    Opening_RM              FLOAT,                                  -- Opening Raw Materials
    Purchases_RM            FLOAT,                                  -- Purchases Raw Materials
    Closing_RM              FLOAT,                                  -- Closing Raw Materials
    Purchases_FG            FLOAT,                                  -- Other Direct Purchases / Brought in cost
    Electricity             FLOAT,                                  -- Electricity & Power
    Oils_fuels              FLOAT,                                  -- Aircraft Fuel
    Coals                   FLOAT,                                  -- Coals etc
    Salaries                FLOAT,                                  -- Salaries, Wages & Bonus
    Providend_fund_contri   FLOAT,                                  -- Contributions to EPF & Pension Funds
    Staff_welfare           FLOAT,                                  -- Workmen and Staff Welfare Expenses
    sub_contract            FLOAT,                                  -- sub contract
    processing_charges      FLOAT,                                  -- Processing Charges
    repairs_maintenance     FLOAT,                                  -- Repairs and Maintenance
    UpKeep_maintenance      FLOAT,                                  -- UpKeep maintenance
    UpKeep_service          FLOAT,                                  -- UpKeep_service
    rent_rates_taxes        FLOAT,                                  -- Rent , Rates & Taxes
    Insurance               FLOAT,                                  -- Insurance
    priting_stationery      FLOAT,                                  -- Printing and stationery
    professional_charges    FLOAT,                                  -- Professional and legal fees
    travelling              FLOAT,                                  -- Traveling and conveyance
    Advertising             FLOAT,                                  -- Advertisement & Sales Promotion
    Commission_incentives   FLOAT,                                  -- Sales Commissions & Incentives
    freight_forwardings     FLOAT,                                  -- Freight and Forwarding
    Handling_clearing       FLOAT,                                  -- Handling and Clearing Charges
    Bad_debts               FLOAT,                                  -- Bad debts /advances written off
    Prov_Doubtfull_debts    FLOAT,                                  -- Provision for doubtful debts
    Loss_Fixed_assets       FLOAT,                                  -- Loss on disposal of fixed assets(net)
    Loss_Foreign_exchange   FLOAT,                                  -- Loss on foreign exchange fluctuations
    Loss_sale_Investment    FLOAT,                                  -- Loss on sale of non-trade current investments
    Interest_income         FLOAT,                                  -- Interest Received
    Dividend_income         FLOAT,                                  -- Dividend Received
    Profit_FA               FLOAT,                                  -- Profit on sale of Fixed Assets
    Profit_Investment       FLOAT,                                  -- Profits on sale of Investments
    Prov_written_back       FLOAT,                                  -- Provision Written Back
    Foreign_exchange_gain   FLOAT,                                  -- Foreign Exchange Gains
    Interest_deb            FLOAT,                                  -- InterestonDebenture / Bonds
    Interest_Term_loans     FLOAT,                                  -- Interest on Term Loan
    Interest_fixed_deposits FLOAT,                                  -- Intereston Fixed deposits
    Bank_charges            FLOAT,                                  -- Bank Charges etc
    Appropriation_General_Reserve FLOAT,                            -- General Reserves
    Proposed_Equity_devided FLOAT,                                  -- Proposed Equity Dividend
    Corp_Divd_tax           FLOAT,                                  -- Corporate dividend tax
    EPS                     FLOAT,                                  -- Earnings Per Share
    Adj_Eps                 FLOAT,                                  -- Adjusted EPS
    
    -- Additional Income Items
    Interest_RBI            FLOAT,                                  -- Interest on balances with RBI and other Interbank funds
    Interest_investment     FLOAT,                                  -- Income on investments
    Income_JV_subs          FLOAT,                                  -- Income earned from subsidiaries/joint venture
    Rent_income             FLOAT,                                  -- Rent / Lease Income
    Interest_RBI_borrowings FLOAT,                                  -- Interest on RBI / inter-bank borrowings
    Interest_other          FLOAT,                                  -- Other Interest
    Depreciation_leased_assets FLOAT,                               -- Depreciation on leased assets
    Auditor_payment         FLOAT,                                  -- Auditor's fees and expenses
    Telephone               FLOAT,                                  -- Communication Expenses
    repairs_other_admin     FLOAT,                                  -- Repairs and Maintenance
    Statutory_reserve       FLOAT,                                  -- Transfer to Statutory Reserve
    Appropriation_Revenue_Reserve FLOAT,                            -- Appropriation to Revenue Reserve
    Other_appropriation     FLOAT,                                  -- Appropriation to Other Reserves
    Sale_Shares_Units       FLOAT,                                  -- Sale of Shares / Units
    Interest_earned_loan    FLOAT,                                  -- Interest income
    Portfolio_mgt_income    FLOAT,                                  -- Portfolio management services
    Dividend_earned         FLOAT,                                  -- Dividend income
    Brokerage_commission    FLOAT,                                  -- Brokerages & commissions
    Processing_fees         FLOAT,                                  -- Processing fees and other charges
    Depository_charges      FLOAT,                                  -- Depository Charges
    Security_trasaction_tax FLOAT,                                  -- Security Transaction tax
    Software_technical_charges FLOAT,                               -- Software & Technical expenses
    Provision_contigency    FLOAT,                                  -- Provisions for contingencies
    provision_NPA           FLOAT,                                  -- Provisions against NPAs
    Other_interest_income   FLOAT,                                  -- Other Interest Income
    Commision               FLOAT,                                  -- Other Commission
    Discounts               FLOAT,                                  -- Discounts
    Other_Investmnet_income FLOAT,                                  -- Income from investments
    Sales                   FLOAT,                                  -- Income from Medical Services
    Income_Diagnostic       FLOAT,                                  -- Income from Medical Services
    Cash_discount           FLOAT,                                  -- Less: Concession / Free Treatment
    Consultant_changes      FLOAT,                                  -- Consultant / Inhouse Fees
    Packing_materials       FLOAT,                                  -- Packing Material Consumed
    freight_outward         FLOAT,                                  -- Freight outwards
    Room_restaurents        FLOAT,                                  -- Rooms / Restaurant / Banquets
    Communication_income    FLOAT,                                  -- Communication Services
    Foods_beverage_Sales    FLOAT,                                  -- Food & Beverages
    Linen_Room_supplies     FLOAT,                                  -- Linen & Room Supplies
    Catering_supplies       FLOAT,                                  -- Catering Supplies
    Laundry_washing_expenses FLOAT,                                 -- Laundry & Washing Expenses
    music_banquest_restaurants FLOAT,                               -- Music,Banquets and Restaurants
    packing_expemses        FLOAT,                                  -- Packing expenses
    Sales_property_development FLOAT,                               -- Revenue from property development
    Broadcasting_revenue    FLOAT,                                  -- Broadcasting Revenue
    Adverisement_revenue    FLOAT,                                  -- Advertising Revenue
    Licence_income          FLOAT,                                  -- License income
    Subscription_income     FLOAT,                                  -- Subscription income
    Contents_film_income    FLOAT,                                  -- Income from content / Event Shows/ Films
    Program_production_exps FLOAT,                                  -- Program Production Expenses
    Telecastin_expenses     FLOAT,                                  -- Telecasting Expenses
    Programs_Films_right    FLOAT,                                  -- Programs and Films rights
    Transmission_EPC        FLOAT,                                  -- Transmission EPC Business
    Wheeling_Transmission   FLOAT,                                  -- Wheeling & Transmission Charges recoverable
    Power_Purchased         FLOAT,                                  -- Cost of power purchased
    Power_project_cost      FLOAT,                                  -- Power Project Expenses
    wheeling_charges        FLOAT,                                  -- Wheeling & Transmission Charges Payable
    Spare_consumed          FLOAT,                                  -- Cost of Elastimold , Store & Spares Consumed
    Sub_contract_charges    FLOAT,                                  -- Sub Contract Charges
    Development_rights      FLOAT,                                  -- Sale of Development Rights
    Development_charges     FLOAT,                                  -- Development Charges
    Income_Investment_property FLOAT,                               -- Income From Investment in Properties
    Development_rights_cost FLOAT,                                  -- Development Rights
    Shipbuilding_income     FLOAT,                                  -- Income from ship building & Repairs
    Charter_income          FLOAT,                                  -- Charter Income
    freight_Income          FLOAT,                                  -- Freight and Demurrage
    Stevedoreage_cargo_expenses FLOAT,                              -- Stevedoring,Despatch and Cargo expenses
    Port_charges            FLOAT,                                  -- Port,Light and canal Dues
    Sale_licenses           FLOAT,                                  -- Sale of Equipments & licenses
    Traded_sw               FLOAT,                                  -- Software Purchase
    Tech_fees               FLOAT,                                  -- Technical sub-contractors
    Traing_exps             FLOAT,                                  -- Training Expenses
    Software_licences       FLOAT,                                  -- Software License cost
    Travels_SW              FLOAT,                                  -- Travel Expenses
    Insurance_SW            FLOAT,                                  -- Overseas Group Health Insurance
    Visa_charges            FLOAT,                                  -- Visa & Other Charges
    Contract_Support_SW     FLOAT,                                  -- Post contract support services
    rates_taxes             FLOAT,                                  -- Rates & Taxes
    Sales_scrap             FLOAT,                                  -- Excess Baggage & Cancellation Charges
    Export_benefits         FLOAT,                                  -- Export Benefits
    Subsidy_incentives      FLOAT,                                  -- Subsidy / Grants / Incentives
    freight_inward          FLOAT,                                  -- Landing, Parkingand Navigation charges
    Hire_charges_mfg        FLOAT,                                  -- Aircrafts / Engines Lease & HireCharges
    Donation                FLOAT,                                  -- Donations
    Interest_Other_income   FLOAT,                                  -- Others
    Commission              FLOAT,                                  -- Commission,exchange and brokerage
    Power_fuel_cost         FLOAT,                                  -- Cost of Fuel
    royalty                 FLOAT,                                  -- License, Royalty and Spectrum Charges
    Project_expenses        FLOAT,                                  -- Internet / Band width and Port Charges
    
    -- Status
    flag                    VARCHAR(1),                            -- Updation Flag
    
    -- Constraints
    PRIMARY KEY (FINCODE, Year_end, TYPE)
);

-- Total Column Count: 195

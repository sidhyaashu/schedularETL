CREATE TABLE Shpsummary (
    -- Composite Primary Key
    FINCODE                 INT NOT NULL,                          -- Company Code
    DATE_END                BIGINT NOT NULL,                       -- Shareholding As on Date
    
    -- Promoter - Indian - Individuals / Hindu Undivided Family
    nhINDindivd             FLOAT,                                  -- Sharehoders - Promoter - Indian - Individuals / Hindu Undivided Family
    nsINDindivd             FLOAT,                                  -- No of Shares - Promoter - Indian - Individuals / Hindu Undivided Family
    dpINDindivd             FLOAT,                                  -- Demat - Promoter - Indian - Individuals / Hindu Undivided Family
    tpINDindivd             FLOAT,                                  -- % - Promoter - Indian - Individuals / Hindu Undivided Family
    
    -- Promoter - Indian - Central Government/State Government(s)
    nhINDcgovt              FLOAT,                                  -- Sharehoders - Promoter - Indian - Central Government/State Government(s)
    nsINDcgovt              FLOAT,                                  -- No of Shares - Promoter - Indian - Central Government/State Government(s)
    dpINDcgovt              FLOAT,                                  -- Demat - Promoter - Indian - Central Government/State Government(s)
    tpINDcgovt              FLOAT,                                  -- % - Promoter - Indian - Central Government/State Government(s)
    
    -- Promoter - Indian - Bodies Corporate
    nhINDbodyCorp           FLOAT,                                  -- Sharehoders - Promoter - Indian - Bodies Corporate
    nsINDbodyCorp           FLOAT,                                  -- No of Shares - Promoter - Indian - Bodies Corporate
    dpINDbodyCorp           FLOAT,                                  -- Demat - Promoter - Indian - Bodies Corporate
    tpINDbodyCorp           FLOAT,                                  -- % - Promoter - Indian - Bodies Corporate
    
    -- Promoter - Indian - Financial Institutions / Banks
    nhINDFIBankcc           FLOAT,                                  -- Sharehoders - Promoter - Indian - Financial Institutions / Banks
    nsINDFIBankcc           FLOAT,                                  -- No of Shares - Promoter - Indian - Financial Institutions / Banks
    dpINDFIBankcc           FLOAT,                                  -- Demat - Promoter - Indian - Financial Institutions / Banks
    tpINDFIBankcc           FLOAT,                                  -- % - Promoter - Indian - Financial Institutions / Banks
    
    -- Promoter - Indian - Other
    nhINDOther              FLOAT,                                  -- Sharehoders - Promoter - Indian - Other
    nsINDOther              FLOAT,                                  -- No of Shares - Promoter - Indian - Other
    dpINDOther              FLOAT,                                  -- Demat - Promoter - Indian - Other
    tpINDOther              FLOAT,                                  -- % - Promoter - Indian - Other
    
    -- Promoter - Indian - Sub Total
    nhINDSubtotal           FLOAT,                                  -- Sharehoders - Promoter - Indian - Sub Total
    nsINDSubtotal           FLOAT,                                  -- No of Shares - Promoter - Indian - Sub Total
    dpINDSubtotal           FLOAT,                                  -- Demat - Promoter - Indian - Sub Total
    tpINDSubtotal           FLOAT,                                  -- % - Promoter - Indian - Sub Total
    
    -- Promoter - Foreign - Non-Residents Individuals / Foreign Individuals
    nhFNRIFN                FLOAT,                                  -- Sharehoders - Promoter - Foreign - Non-Residents Individuals / Foreign Individuals
    nsFNRIFN                FLOAT,                                  -- No of Shares - Promoter - Foreign - Non-Residents Individuals / Foreign Individuals
    dpFNRIFN                FLOAT,                                  -- Demat - Promoter - Foreign - Non-Residents Individuals / Foreign Individuals
    tpFNRIFN                FLOAT,                                  -- % - Promoter - Foreign - Non-Residents Individuals / Foreign Individuals
    
    -- Promoter - Foreign - Bodies Corporate
    nhFbodyCorp             FLOAT,                                  -- Sharehoders - Promoter - Foreign - Bodies Corporate
    nsFbodyCorp             FLOAT,                                  -- No of Shares - Promoter - Foreign - Bodies Corporate
    dpFbodyCorp             FLOAT,                                  -- Demat - Promoter - Foreign - Bodies Corporate
    tpFbodyCorp             FLOAT,                                  -- % - Promoter - Foreign - Bodies Corporate
    
    -- Promoter - Foreign - Institutions
    nhFInstitution          FLOAT,                                  -- Sharehoders - Promoter - Foreign - Institutions
    nsFInstitution          FLOAT,                                  -- No of Shares - Promoter - Foreign - Institutions
    dpFInstitution          FLOAT,                                  -- Demat - Promoter - Foreign - Institutions
    tpFInstitution          FLOAT,                                  -- % - Promoter - Foreign - Institutions
    
    -- Promoter - Foreign - Other
    nhFOther                FLOAT,                                  -- Sharehoders - Promoter - Foreign - Other
    nsFOther                FLOAT,                                  -- No of Shares - Promoter - Foreign - Other
    dpFOther                FLOAT,                                  -- Demat - Promoter - Foreign - Other
    tpFOther                FLOAT,                                  -- % - Promoter - Foreign - Other
    
    -- Promoter - Foreign - Sub Total
    nhFSubtotal             FLOAT,                                  -- Sharehoders - Promoter - Foreign - Sub Total
    nsFSubtotal             FLOAT,                                  -- No of Shares - Promoter - Foreign - Sub Total
    dpFSubtotal             FLOAT,                                  -- Demat - Promoter - Foreign - Sub Total
    tpFSubtotal             FLOAT,                                  -- % - Promoter - Foreign - Sub Total
    
    -- Promoter - Total
    nhFtotalpromoter        FLOAT,                                  -- Sharehoders - Promoter - Total
    nsFtotalpromoter        FLOAT,                                  -- No of Shares - Promoter - Total
    dpFtotalpromoter        FLOAT,                                  -- Demat - Promoter - Total
    tpFtotalpromoter        FLOAT,                                  -- % - Promoter - Total
    
    -- Public - Institutions - Mutual Funds / UTI
    nhINMFUTI               FLOAT,                                  -- Sharehoders - Public - Institutions - Mutual Funds / UTI
    nsINMFUTI               FLOAT,                                  -- No of Shares - Public - Institutions - Mutual Funds / UTI
    dpINMFUTI               FLOAT,                                  -- Demat - Public - Institutions - Mutual Funds / UTI
    tpINMFUTI               FLOAT,                                  -- % - Public - Institutions - Mutual Funds / UTI
    
    -- Public - Institutions - Financial Institutions / Banks
    nhINFIBanks             FLOAT,                                  -- Sharehoders - Public - Institutions - Financial Institutions / Banks
    nsINFIBanks             FLOAT,                                  -- No of Shares - Public - Institutions - Financial Institutions / Banks
    dpINFIBanks             FLOAT,                                  -- Demat - Public - Institutions - Financial Institutions / Banks
    tpINFIBanks             FLOAT,                                  -- % - Public - Institutions - Financial Institutions / Banks
    
    -- Public - Institutions - Insurance Companies
    nhINInsurance           FLOAT,                                  -- Sharehoders - Public - Institutions - Insurance Companies
    nsINInsurance           FLOAT,                                  -- No of Shares - Public - Institutions - Insurance Companies
    dpINInsurance           FLOAT,                                  -- Demat - Public - Institutions - Insurance Companies
    tpINInsurance           FLOAT,                                  -- % - Public - Institutions - Insurance Companies
    
    -- Public - Institutions - Foreign Institutional Investors
    nhINFII                 FLOAT,                                  -- Sharehoders - Public - Institutions - Foreign Institutional Investors
    nsINFII                 FLOAT,                                  -- No of Shares - Public - Institutions - Foreign Institutional Investors
    dpINFII                 FLOAT,                                  -- Demat - Public - Institutions - Foreign Institutional Investors
    tpINFII                 FLOAT,                                  -- % - Public - Institutions - Foreign Institutional Investors
    
    -- Public - Institutions - Venture Capital Funds
    nhINVenCap              FLOAT,                                  -- Sharehoders - Public - Institutions - Venture Capital Funds
    nsINVenCap              FLOAT,                                  -- No of Shares - Public - Institutions - Venture Capital Funds
    dpINVenCap              FLOAT,                                  -- Demat - Public - Institutions - Venture Capital Funds
    tpINVenCap              FLOAT,                                  -- % - Public - Institutions - Venture Capital Funds
    
    -- Public - Institutions - Foreign Venture Capital Investors
    nhINForVenCap           FLOAT,                                  -- Sharehoders - Public - Institutions - Foreign Venture Capital Investors
    nsINForVenCap           FLOAT,                                  -- No of Shares - Public - Institutions - Foreign Venture Capital Investors
    dpINForVenCap           FLOAT,                                  -- Demat - Public - Institutions - Foreign Venture Capital Investors
    tpINForVenCap           FLOAT,                                  -- % - Public - Institutions - Foreign Venture Capital Investors
    
    -- Public - Institutions - Central Government / State Government
    nhINcgovt               FLOAT,                                  -- Sharehoders - Public - Institutions - Central Government / State Government(s)
    nsINcgovt               FLOAT,                                  -- No of Shares - Public - Institutions - Central Government / State Government(s)
    dpINcgovt               FLOAT,                                  -- Demat - Public - Institutions - Central Government / State Government(s)
    tpINcgovt               FLOAT,                                  -- % - Public - Institutions - Central Government / State Government(s)
    
    -- Public - Institutions - Foreign Financial Institutions / Banks
    nhINForFinIns           FLOAT,                                  -- Sharehoders - Public - Institutions - Foreign Financial Institutions / Banks
    nsINForFinIns           FLOAT,                                  -- No of Shares - Public - Institutions - Foreign Financial Institutions / Banks
    dpINForFinIns           FLOAT,                                  -- Demat - Public - Institutions - Foreign Financial Institutions / Banks
    tpINForFinIns           FLOAT,                                  -- % - Public - Institutions - Foreign Financial Institutions / Banks
    
    -- Public - Institutions - State Finance Corporation
    nhINStateFinCorp        FLOAT,                                  -- Sharehoders - Public - Institutions - State Finance Corporation
    nsINStateFinCorp        FLOAT,                                  -- No of Shares - Public - Institutions - State Finance Corporation
    dpINStateFinCorp        FLOAT,                                  -- Demat - Public - Institutions - State Finance Corporation
    tpINStateFinCorp        FLOAT,                                  -- % - Public - Institutions - State Finance Corporation
    
    -- Public - Institutions - Foreign Bodies DR
    nhINForBody             FLOAT,                                  -- Sharehoders - Public - Institutions - Foreign Bodies DR
    nsINForBody             FLOAT,                                  -- No of Shares - Public - Institutions - Foreign Bodies DR
    dpINForBody             FLOAT,                                  -- Demat - Public - Institutions - Foreign Bodies DR
    tpINForBody             FLOAT,                                  -- % - Public - Institutions - Foreign Bodies DR
    
    -- Public - Institutions - Other
    nhINOther               FLOAT,                                  -- Sharehoders - Public - Institutions - Other
    nsINOther               FLOAT,                                  -- No of Shares - Public - Institutions - Other
    dpINOther               FLOAT,                                  -- Demat - Public - Institutions - Other
    tpINOther               FLOAT,                                  -- % - Public - Institutions - Other
    
    -- Public - Institutions - Sub Total
    nhINSubtotal            FLOAT,                                  -- Sharehoders - Public - Institutions - Sub Total
    nsINSubtotal            FLOAT,                                  -- No of Shares - Public - Institutions - Sub Total
    dpINSubtotal            FLOAT,                                  -- Demat - Public - Institutions - Sub Total
    tpINSubtotal            FLOAT,                                  -- % - Public - Institutions - Sub Total
    
    -- Public - Non-Institutions - Bodies Corporate
    nhNINbodyCorp           FLOAT,                                  -- Sharehoders - Public - Non-Institutions - Bodies Corporate
    nsNINbodyCorp           FLOAT,                                  -- No of Shares - Public - Non-Institutions - Bodies Corporate
    dpNINbodyCorp           FLOAT,                                  -- Demat - Public - Non-Institutions - Bodies Corporate
    tpNINbodyCorp           FLOAT,                                  -- % - Public - Non-Institutions - Bodies Corporate
    
    -- Public - Non-Institutions - Individuals
    nhNINIndivd             FLOAT,                                  -- Sharehoders - Public - Non-Institutions - Individuals
    nsNINIndivd             FLOAT,                                  -- No of Shares - Public - Non-Institutions - Individuals
    dpNINIndivd             FLOAT,                                  -- Demat - Public - Non-Institutions - Individuals
    tpNINIndivd             FLOAT,                                  -- % - Public - Non-Institutions - Individuals
    
    -- Public - Non-Institutions - Individual shareholders up to Rs. 1 lakh
    nhNINIndivd1lac         FLOAT,                                  -- Sharehoders - Public - Non-Institutions - Individual shareholders holding nominal share capital up to Rs. 1 lakh
    nsNINIndivd1lac         FLOAT,                                  -- No of Shares - Public - Non-Institutions - Individual shareholders holding nominal share capital up to Rs. 1 lakh
    dpNINIndivd1lac         FLOAT,                                  -- Demat - Public - Non-Institutions - Individual shareholders holding nominal share capital up to Rs. 1 lakh
    tpNINIndivd1lac         FLOAT,                                  -- % - Public - Non-Institutions - Individual shareholders holding nominal share capital up to Rs. 1 lakh
    
    -- Public - Non-Institutions - Individual shareholders in excess of Rs. 1 lakh
    nhNINIndivd1lacmore     FLOAT,                                  -- Sharehoders - Public - Non-Institutions - Individual shareholders holding nominal share capital in excess of Rs. 1 lakh
    nsNINIndivd1lacmore     FLOAT,                                  -- No of Shares - Public - Non-Institutions - Individual shareholders holding nominal share capital in excess of Rs. 1 lakh
    dpNINIndivd1lacmore     FLOAT,                                  -- Demat - Public - Non-Institutions - Individual shareholders holding nominal share capital in excess of Rs. 1 lakh
    tpNINIndivd1lacmore     FLOAT,                                  -- % - Public - Non-Institutions - Individual shareholders holding nominal share capital in excess of Rs. 1 lakh
    
    -- Public - Non-Institutions - Clearing Members
    nhNINClearMemb          FLOAT,                                  -- Sharehoders - Public - Non-Institutions - Clearing Members
    nsNINClearMemb          FLOAT,                                  -- No of Shares - Public - Non-Institutions - Clearing Members
    dpNINClearMemb          FLOAT,                                  -- Demat - Public - Non-Institutions - Clearing Members
    tpNINClearMemb          FLOAT,                                  -- % - Public - Non-Institutions - Clearing Members
    
    -- Public - Non-Institutions - Non Resident Indians
    nhNINNRI                FLOAT,                                  -- Sharehoders - Public - Non-Institutions - Non Resident Indians
    nsNINNRI                FLOAT,                                  -- No of Shares - Public - Non-Institutions - Non Resident Indians
    dpNINNRI                FLOAT,                                  -- Demat - Public - Non-Institutions - Non Resident Indians
    tpNINNRI                FLOAT,                                  -- % - Public - Non-Institutions - Non Resident Indians
    
    -- Public - Non-Institutions - Directors & their Relatives & Friends
    nhNINDirector           FLOAT,                                  -- Sharehoders - Public - Non-Institutions - Directors & their Relatives & Friends
    nsNINDirector           FLOAT,                                  -- No of Shares - Public - Non-Institutions - Directors & their Relatives & Friends
    dpNINDirector           FLOAT,                                  -- Demat - Public - Non-Institutions - Directors & their Relatives & Friends
    tpNINDirector           FLOAT,                                  -- % - Public - Non-Institutions - Directors & their Relatives & Friends
    
    -- Public - Non-Institutions - Foreign Collaborators
    nhNINFornColl           FLOAT,                                  -- Sharehoders - Public - Non-Institutions - Foreign Collaborators
    nsNINFornColl           FLOAT,                                  -- No of Shares - Public - Non-Institutions - Foreign Collaborators
    dpNINFornColl           FLOAT,                                  -- Demat - Public - Non-Institutions - Foreign Collaborators
    tpNINFornColl           FLOAT,                                  -- % - Public - Non-Institutions - Foreign Collaborators
    
    -- Public - Non-Institutions - Foreign Mutual Fund
    nhNINFornMF             FLOAT,                                  -- Sharehoders - Public - Non-Institutions - Foreign Mutual Fund
    nsNINFornMF             FLOAT,                                  -- No of Shares - Public - Non-Institutions - Foreign Mutual Fund
    dpNINFornMF             FLOAT,                                  -- Demat - Public - Non-Institutions - Foreign Mutual Fund
    tpNINFornMF             FLOAT,                                  -- % - Public - Non-Institutions - Foreign Mutual Fund
    
    -- Public - Non-Institutions - Trusts
    nhNINTrusts             FLOAT,                                  -- Sharehoders - Public - Non-Institutions - Trusts
    nsNINTrusts             FLOAT,                                  -- No of Shares - Public - Non-Institutions - Trusts
    dpNINTrusts             FLOAT,                                  -- Demat - Public - Non-Institutions - Trusts
    tpNINTrusts             FLOAT,                                  -- % - Public - Non-Institutions - Trusts
    
    -- Public - Non-Institutions - Hindu Undivided Families
    nhNINHUF                FLOAT,                                  -- Sharehoders - Public - Non-Institutions - Hindu Undivided Families
    nsNINHUF                FLOAT,                                  -- No of Shares - Public - Non-Institutions - Hindu Undivided Families
    dpNINHUF                FLOAT,                                  -- Demat - Public - Non-Institutions - Hindu Undivided Families
    tpNINHUF                FLOAT,                                  -- % - Public - Non-Institutions - Hindu Undivided Families
    
    -- Public - Non-Institutions - Foreign Corporate Bodies
    nhNINFornCorpBody       FLOAT,                                  -- Sharehoders - Public - Non-Institutions - Foreign Corporate Bodies
    nsNINFornCorpBody       FLOAT,                                  -- No of Shares - Public - Non-Institutions - Foreign Corporate Bodies
    dpNINFornCorpBody       FLOAT,                                  -- Demat - Public - Non-Institutions - Foreign Corporate Bodies
    tpNINFornCorpBody       FLOAT,                                  -- % - Public - Non-Institutions - Foreign Corporate Bodies
    
    -- Public - Non-Institutions - Shares in transit
    nhNINShareIntransit     FLOAT,                                  -- Sharehoders - Public - Non-Institutions - Shares in transit
    nsNINShareIntransit     FLOAT,                                  -- No of Shares - Public - Non-Institutions - Shares in transit
    dpNINShareIntransit     FLOAT,                                  -- Demat - Public - Non-Institutions - Shares in transit
    tpNINShareIntransit     FLOAT,                                  -- % - Public - Non-Institutions - Shares in transit
    
    -- Public - Non-Institutions - Market Maker
    nhNINMktMaker           FLOAT,                                  -- Sharehoders - Public - Non-Institutions - Market Maker
    nsNINMktMaker           FLOAT,                                  -- No of Shares - Public - Non-Institutions - Market Maker
    dpNINMktMaker           FLOAT,                                  -- Demat - Public - Non-Institutions - Market Maker
    tpNINMktMaker           FLOAT,                                  -- % - Public - Non-Institutions - Market Maker
    
    -- Public - Non-Institutions - ESOP/ESOS/ESPS
    nhNINEmployees          FLOAT,                                  -- Sharehoders - Public - Non-Institutions - ESOP/ESOS/ESPS
    nsNINEmployees          FLOAT,                                  -- No of Shares - Public - Non-Institutions - ESOP/ESOS/ESPS
    dpNINEmployees          FLOAT,                                  -- Demat - Public - Non-Institutions - ESOP/ESOS/ESPS
    tpNINEmployees          FLOAT,                                  -- % - Public - Non-Institutions - ESOP/ESOS/ESPS
    
    -- Public - Non-Institutions - Societies
    nhNINSociety            FLOAT,                                  -- Sharehoders - Public - Non-Institutions - Societies
    nsNINSociety            FLOAT,                                  -- No of Shares - Public - Non-Institutions - Societies
    dpNINSociety            FLOAT,                                  -- Demat - Public - Non-Institutions - Societies
    tpNINSociety            FLOAT,                                  -- % - Public - Non-Institutions - Societies
    
    -- Public - Non-Institutions - Escrow Account
    nhNINEscrow             FLOAT,                                  -- Sharehoders - Public - Non-Institutions - Escrow Account
    nsNINEscrow             FLOAT,                                  -- No of Shares - Public - Non-Institutions - Escrow Account
    dpNINEscrow             FLOAT,                                  -- Demat - Public - Non-Institutions - Escrow Account
    tpNINEscrow             FLOAT,                                  -- % - Public - Non-Institutions - Escrow Account
    
    -- Public - Non-Institutions - Any Other
    nhNINother              FLOAT,                                  -- Sharehoders - Public - Non-Institutions - Any Other
    nsNINother              FLOAT,                                  -- No of Shares - Public - Non-Institutions - Any Other
    dpNINother              FLOAT,                                  -- Demat - Public - Non-Institutions - Any Other
    tpNINother              FLOAT,                                  -- % - Public - Non-Institutions - Any Other
    
    -- Public - Non-Institutions - Sub Total
    nhNINSubtotal           FLOAT,                                  -- Sharehoders - Public - Non-Institutions - Sub Total
    nsNINSubtotal           FLOAT,                                  -- No of Shares - Public - Non-Institutions - Sub Total
    dpNINSubtotal           FLOAT,                                  -- Demat - Public - Non-Institutions - Sub Total
    tpNINSubtotal           FLOAT,                                  -- % - Public - Non-Institutions - Sub Total
    
    -- Public - Total
    nhTotalpublic           FLOAT,                                  -- Sharehoders - Public - Total
    nsTotalpublic           FLOAT,                                  -- No of Shares - Public - Total
    dpTotalpublic           FLOAT,                                  -- Demat - Public - Total
    tpTotalpublic           FLOAT,                                  -- % - Public - Total
    
    -- Total Promoter & Public
    nhTotalprompublic       FLOAT,                                  -- Sharehoders - Total Promoter & Publics
    nsTotalprompublic       FLOAT,                                  -- No of Shares - Total Promoter & Publics
    dpTotalprompublic       FLOAT,                                  -- Demat - Total Promoter & Publics
    tpTotalprompublic       FLOAT,                                  -- % - Total Promoter & Publics
    
    -- Custodians - DRs
    nhCustodianDRs          FLOAT,                                  -- Sharehoders - Custodians
    nsCustodianDRs          FLOAT,                                  -- No of Shares - Custodians
    dpCustodianDRs          FLOAT,                                  -- Demat - Custodians
    tpCustodianDRs          FLOAT,                                  -- % - Custodians
    
    -- Custodians - American Depository Receipts
    nhADR                   FLOAT,                                  -- Sharehoders - Custodians - American Depository Receipts
    nsADR                   FLOAT,                                  -- No of Shares - Custodians - American Depository Receipts
    dpADR                   FLOAT,                                  -- Demat - Custodians - American Depository Receipts
    tpADR                   FLOAT,                                  -- % - Custodians - American Depository Receipts
    
    -- Custodians - GDRs
    nhGDR                   FLOAT,                                  -- Sharehoders - Custodians - GDRs
    nsGDR                   FLOAT,                                  -- No of Shares - Custodians - GDRs
    dpGDR                   FLOAT,                                  -- Demat - Custodians - GDRs
    tpGDR                   FLOAT,                                  -- % - Custodians - GDRs
    
    -- Custodians - Other
    nhOther                 FLOAT,                                  -- Sharehoders - Custodians - Other
    nsOther                 FLOAT,                                  -- No of Shares - Custodians - Other
    dpOther                 FLOAT,                                  -- Demat - Custodians - Other
    tpOther                 FLOAT,                                  -- % - Custodians - Other
    
    -- Grand Total
    nhGrandTotal            FLOAT,                                  -- Sharehoders - Grand Total
    nsGrandTotal            FLOAT,                                  -- No of Shares - Grand Total
    dpGrandTotal            FLOAT,                                  -- Demat - Grand Total
    tpGrandTotal            FLOAT,                                  -- % - Grand Total
    
    -- Promoter - Indian - Partnership Firms
    nhOtherPrtFirms         FLOAT,                                  -- Sharehoders - Promoter - Indian - Partnership Firms
    nsOtherPrtFirms         FLOAT,                                  -- No of Shares - Promoter - Indian - Partnership Firms
    dpOtherPrtFirms         FLOAT,                                  -- Demat - Promoter - Indian - Partnership Firms
    tpOtherPrtFirms         FLOAT,                                  -- % - Promoter - Indian - Partnership Firms
    
    -- Promoter - Indian - Promoter Group
    nhOtherPromgroup        FLOAT,                                  -- Sharehoders - Promoter - Indian - Promoter Group
    nsOtherPromgroup        FLOAT,                                  -- No of Shares - Promoter - Indian - Promoter Group
    dpOtherPromgroup        FLOAT,                                  -- Demat - Promoter - Indian - Promoter Group
    tpOtherPromgroup        FLOAT,                                  -- % - Promoter - Indian - Promoter Group
    
    -- Promoter - Indian - Employees Welfare Fund
    nhOtherEWF              FLOAT,                                  -- Sharehoders - Promoter - Indian - Employees Welfare Fund
    nsOtherEWF              FLOAT,                                  -- No of Shares - Promoter - Indian - Employees Welfare Fund
    dpOtherEWF              FLOAT,                                  -- Demat - Promoter - Indian - Employees Welfare Fund
    tpOtherEWF              FLOAT,                                  -- % - Promoter - Indian - Employees Welfare Fund
    
    -- Public - Institutions - Stressed Assets Stabilisation Fund
    nhSASF                  FLOAT,                                  -- Sharehoders - Public - Institutions - Stressed Assets Stabilisation Fund
    nsSASF                  FLOAT,                                  -- No of Shares - Public - Institutions - Stressed Assets Stabilisation Fund
    dpSASF                  FLOAT,                                  -- Demat - Public - Institutions - Stressed Assets Stabilisation Fund
    tpSASF                  FLOAT,                                  -- % - Public - Institutions - Stressed Assets Stabilisation Fund
    
    -- Promoter - Indian - Any Other
    nhINDAnyOtherSpecfd     FLOAT,                                  -- Sharehoders - Promoter - Indian - Any Other
    nsINDAnyOtherSpecfd     FLOAT,                                  -- No of Shares - Promoter - Indian - Any Other
    dpINDAnyOtherSpecfd     FLOAT,                                  -- Demat - Promoter - Indian - Any Other
    tpINDAnyOtherSpecfd     FLOAT,                                  -- % - Promoter - Indian - Any Other
    
    -- Public - Institutions - Any Other
    nhINAnyOtherSpecfd      FLOAT,                                  -- Sharehoders - Public - Institutions - Any Other
    nsINAnyOtherSpecfd      FLOAT,                                  -- No of Shares - Public - Institutions - Any Other
    dpINAnyOtherSpecfd      FLOAT,                                  -- Demat - Public - Institutions - Any Other
    tpINAnyOtherSpecfd      FLOAT,                                  -- % - Public - Institutions - Any Other
    
    -- Public - Non-Institutions - Any Other
    nhNINAnyOtherSpecfd     FLOAT,                                  -- Sharehoders - Public - Non-Institutions - Any Other
    nsNINAnyOtherSpecfd     FLOAT,                                  -- No of Shares - Public - Non-Institutions - Any Other
    dpNINAnyOtherSpecfd     FLOAT,                                  -- Demat - Public - Non-Institutions - Any Other
    tpNINAnyOtherSpecfd     FLOAT,                                  -- % - Public - Non-Institutions - Any Other
    
    -- Promoter - Foreign - Any Other
    nhFAnyOtherSpecfd       FLOAT,                                  -- Sharehoders - Promoter - Foreign - Any Other
    nsFAnyOtherSpecfd       FLOAT,                                  -- No of Shares - Promoter - Foreign - Any Other
    dpFAnyOtherSpecfd       FLOAT,                                  -- Demat - Promoter - Foreign - Any Other
    tpFAnyOtherSpecfd       FLOAT,                                  -- % - Promoter - Foreign - Any Other
    
    -- Additional Aggregations
    nshINDSubtotal          FLOAT,                                  -- Number of Shareholders - Promoter - Indian - Sub Total
    nshINDindivd            FLOAT,                                  -- Indian Promoters - Individuals / Hindu Undivided Family
    nshINDcgovt             FLOAT,                                  -- Central Government/State Government(s)
    nshINDbodyCorp          FLOAT,                                  -- Bodies Corporate
    nshINDFIBankcc          FLOAT,                                  -- Financial Institutions / Banks
    nshOtherPrtFirms        FLOAT,                                  -- Partnership Firms
    nshOtherPromgroup       FLOAT,                                  -- Promoter Group
    nshOtherEWF             FLOAT,                                  -- Employees Welfare Fund
    nshINDOther             FLOAT,                                  -- Other
    nshINDAnyOtherSpecfd    FLOAT,                                  -- Any Others (Specify)
    nshFSubtotal            FLOAT,                                  -- Foreign Promoters - Sub Total
    nshFNRIFN               FLOAT,                                  -- Non-Residents Individuals / Foreign Individuals
    nshFbodyCorp            FLOAT,                                  -- Bodies Corporate
    nshFInstitution         FLOAT,                                  -- Institutions
    nshFOther               FLOAT,                                  -- Other
    nshFAnyOtherSpecfd      FLOAT,                                  -- Any Others (Specify)
    nshFtotalpromoter       FLOAT,                                  -- Total of Promoter and Promoter Group
    nshINSubtotal           FLOAT,                                  -- Institutions - Sub Total
    nshINMFUTI              FLOAT,                                  -- Mutual Funds / UTI
    nshINFIBanks            FLOAT,                                  -- Financial Institutions / Banks
    nshINInsurance          FLOAT,                                  -- Insurance Companies
    nshINFII                FLOAT,                                  -- Foreign Institutional Investors
    nshINVenCap             FLOAT,                                  -- Venture Capital Funds
    nshINForVenCap          FLOAT,                                  -- Foreign Venture Capital Investors
    nshINAnyOtherSpecfd     FLOAT,                                  -- Any Others (Specify)
    nshINcgovt              FLOAT,                                  -- Central Government / State Government(s)
    nshINForFinIns          FLOAT,                                  -- Foreign Financial Institutions / Banks
    nshSasF                 FLOAT,                                  -- Stressed Assets Stabilisation Fund
    nshINStateFinCorp       FLOAT,                                  -- State Finance Corporation
    nshINForBody            FLOAT,                                  -- Foreign Bodies DR
    nshINOther              FLOAT,                                  -- Other
    nshNINSubtotal          FLOAT,                                  -- Non-Institutions - Sub Total
    nshNINbodyCorp          FLOAT,                                  -- Bodies Corporate
    nshNINIndivd            FLOAT,                                  -- Individuals
    nshNINIndivd1lac        FLOAT,                                  -- Individual shareholders holding nominal share capital up to Rs. 1 lakh
    nshNINIndivd1lacmore    FLOAT,                                  -- Individual shareholders holding nominal share capital in excess of Rs. 1 lakh
    nshNINAnyOtherSpecfd    FLOAT,                                  -- Any Others (Specify)
    nshNINClearMemb         FLOAT,                                  -- Clearing Members
    nshNINNRI               FLOAT,                                  -- Non Resident Indians
    nshNINDirector          FLOAT,                                  -- Directors & their Relatives & Friends
    nshNINFornColl          FLOAT,                                  -- Foreign Collaborators
    nshNINFornMF            FLOAT,                                  -- Foreign Mutual Fund
    nshNINTrusts            FLOAT,                                  -- Trusts
    nshNINHUF               FLOAT,                                  -- Hindu Undivided Families
    nshNINFornCorpBody      FLOAT,                                  -- Foreign Corporate Bodies
    nshNINShareIntransit    FLOAT,                                  -- Shares in transit
    nshNINMktMaker          FLOAT,                                  -- Market Maker
    nshNINEmployees         FLOAT,                                  -- ESOP/ESOS/ESPS
    nshNINSociety           FLOAT,                                  -- Societies
    nshNINEscrow            FLOAT,                                  -- Escrow Account
    nshNINother             FLOAT,                                  -- Any Other
    nshTotalpublic          FLOAT,                                  -- Total Public Shareholding
    nshTotalprompublic      FLOAT,                                  -- Total of Promoter and Public Shareholding
    nshCustodianDRs         FLOAT,                                  -- Shares held by Custodians and against which Depository Receipts have been issued
    nshADR                  FLOAT,                                  -- ADRs
    nshGDR                  FLOAT,                                  -- GDRs
    nshOther                FLOAT,                                  -- Other
    nshGrandTotal           FLOAT,                                  -- Grand Total
    
    -- Percentage Aggregations
    pshINDSubtotal          FLOAT,                                  -- Indian Promoters %
    pshINDindivd            FLOAT,                                  -- Individuals / Hindu Undivided Family %
    pshINDcgovt             FLOAT,                                  -- Central Government/State Government(s) %
    pshINDbodyCorp          FLOAT,                                  -- Bodies Corporate %
    pshINDFIBankcc          FLOAT,                                  -- Financial Institutions / Banks %
    pshOtherPrtFirms        FLOAT,                                  -- Partnership Firms %
    pshOtherPromgroup       FLOAT,                                  -- Promoter Group %
    pshOtherEWF             FLOAT,                                  -- Employees Welfare Fund %
    pshINDOther             FLOAT,                                  -- Other %
    pshINDAnyOtherSpecfd    FLOAT,                                  -- Any Others (Specify) %
    pshFSubtotal            FLOAT,                                  -- Foreign Promoters %
    pshFNRIFN               FLOAT,                                  -- Non-Residents Individuals / Foreign Individuals %
    pshFbodyCorp            FLOAT,                                  -- Bodies Corporate %
    pshFInstitution         FLOAT,                                  -- Institutions %
    pshFOther               FLOAT,                                  -- Other %
    pshFAnyOtherSpecfd      FLOAT,                                  -- Any Others (Specify) %
    pshFtotalpromoter       FLOAT,                                  -- Total of Promoter and Promoter Group %
    pshINSubtotal           FLOAT,                                  -- Institutions %
    pshINMFUTI              FLOAT,                                  -- Mutual Funds / UTI %
    pshINFIBanks            FLOAT,                                  -- Financial Institutions / Banks %
    pshINInsurance          FLOAT,                                  -- Insurance Companies %
    pshINFII                FLOAT,                                  -- Foreign Institutional Investors %
    pshINVenCap             FLOAT,                                  -- Venture Capital Funds %
    pshINForVenCap          FLOAT,                                  -- Foreign Venture Capital Investors %
    pshINAnyOtherSpecfd     FLOAT,                                  -- Any Others (Specify) %
    pshINcgovt              FLOAT,                                  -- Central Government / State Government(s) %
    pshINForFinIns          FLOAT,                                  -- Foreign Financial Institutions / Banks %
    pshSasF                 FLOAT,                                  -- Stressed Assets Stabilisation Fund %
    pshINStateFinCorp       FLOAT,                                  -- State Finance Corporation %
    pshINForBody            FLOAT,                                  -- Foreign Bodies DR %
    pshINOther              FLOAT,                                  -- Other %
    pshNINSubtotal          FLOAT,                                  -- Non-Institutions %
    pshNINbodyCorp          FLOAT,                                  -- Bodies Corporate %
    pshNINIndivd            FLOAT,                                  -- Individuals %
    pshNINIndivd1lac        FLOAT,                                  -- Individual shareholders holding nominal share capital up to Rs. 1 lakh %
    pshNINIndivd1lacmore    FLOAT,                                  -- Individual shareholders holding nominal share capital in excess of Rs. 1 lakh %
    pshNINAnyOtherSpecfd    FLOAT,                                  -- Any Others (Specify) %
    pshNINClearMemb         FLOAT,                                  -- Clearing Members %
    pshNINNRI               FLOAT,                                  -- Non Resident Indians %
    pshNINDirector          FLOAT,                                  -- Directors & their Relatives & Friends %
    pshNINFornColl          FLOAT,                                  -- Foreign Collaborators %
    pshNINFornMF            FLOAT,                                  -- Foreign Mutual Fund %
    pshNINTrusts            FLOAT,                                  -- Trusts %
    pshNINHUF               FLOAT,                                  -- Hindu Undivided Families %
    pshNINFornCorpBody      FLOAT,                                  -- Foreign Corporate Bodies %
    pshNINShareIntransit    FLOAT,                                  -- Shares in transit %
    pshNINMktMaker          FLOAT,                                  -- Market Maker %
    pshNINEmployees         FLOAT,                                  -- ESOP/ESOS/ESPS %
    pshNINSociety           FLOAT,                                  -- Societies %
    pshNINEscrow            FLOAT,                                  -- Escrow Account %
    pshNINother             FLOAT,                                  -- Any Other %
    pshTotalpublic          FLOAT,                                  -- Total Public Shareholding %
    pshTotalprompublic      FLOAT,                                  -- Total of Promoter and Public Shareholding %
    pshCustodianDRs         FLOAT,                                  -- Shares held by Custodians and against which Depository Receipts have been issued %
    pshADR                  FLOAT,                                  -- ADRs %
    pshOther                FLOAT,                                  -- Other %
    pshGrandTotal           FLOAT,                                  -- Grand Total %
    
    -- Additional Institutions
    nhINAltInvFund          FLOAT,                                  -- Sharehoders - Public - Institutions - Alternate Investment Funds
    nsINAltInvFund          FLOAT,                                  -- No of Shares - Public - Institutions - Alternate Investment Funds
    dpINAltInvFund          FLOAT,                                  -- Demat - Public - Institutions - Alternate Investment Funds
    tpINAltInvFund          FLOAT,                                  -- % - Public - Institutions - Alternate Investment Funds
    
    -- Public - Institutions - Foreign Portfolio Investors
    nhINForeignPortInv      FLOAT,                                  -- Sharehoders - Public - Institutions - Foreign Portfolio Investors
    nsINForeignPortInv      FLOAT,                                  -- No of Shares - Public - Institutions - Foreign Portfolio Investors
    dpINForeignPortInv      FLOAT,                                  -- Demat - Public - Institutions - Foreign Portfolio Investors
    tpINForeignPortInv      FLOAT,                                  -- % - Public - Institutions - Foreign Portfolio Investors
    
    -- Public - Institutions - Provident Funds / Pension Funds
    nhINProviPenFund        FLOAT,                                  -- Sharehoders - Public - Institutions - Provident Funds/ Pension Funds
    nsINProviPenFund        FLOAT,                                  -- No of Shares - Public - Institutions - Provident Funds/ Pension Funds
    dpINProviPenFund        FLOAT,                                  -- Demat - Public - Institutions - Provident Funds/ Pension Funds
    tpINProviPenFund        FLOAT,                                  -- % - Public - Institutions - Provident Funds/ Pension Funds
    
    -- Public - Non-Institutions - NBFCs registered with RBI
    nhNINIndivdNBFC         FLOAT,                                  -- Sharehoders - Public - Non-Institutions - NBFCs registered with RBI
    nsNINIndivdNBFC         FLOAT,                                  -- No of Shares - Public - Non-Institutions - NBFCs registered with RBI
    dpNINIndivdNBFC         FLOAT,                                  -- Demat - Public - Non-Institutions - NBFCs registered with RBI
    tpNINIndivdNBFC         FLOAT,                                  -- % - Public - Non-Institutions - NBFCs registered with RBI
    
    -- Public - Non-Institutions - Employee Trusts
    nhNINIndEmpTrust        FLOAT,                                  -- Sharehoders - Public - Non-Institutions - Employee Trusts
    nsNINIndEmpTrust        FLOAT,                                  -- No of Shares - Public - Non-Institutions - Employee Trusts
    dpNINIndEmpTrust        FLOAT,                                  -- Demat - Public - Non-Institutions - Employee Trusts
    tpNINIndEmpTrust        FLOAT,                                  -- % - Public - Non-Institutions - Employee Trusts
    
    -- Status
    flag                    VARCHAR(1),                            -- Updation Flag
    
    -- Constraints
    PRIMARY KEY (FINCODE, DATE_END)
);


-- Total Column Count: 370

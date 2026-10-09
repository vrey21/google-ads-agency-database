-- =============================================================
-- 04_integrity_tests.sql  |  Proves the business rules are enforced
-- Every INSERT below SHOULD FAIL. Run each statement on its own
-- and read the error message; nothing is changed in the database.
-- =============================================================

USE alamo_digital_marketing;

-- 1:1 rule: a client cannot sign a second contract
-- Expected: duplicate entry error on uq_contract_client
INSERT INTO CONTRACT (ContractID, ClientID, SignedDate, EndDate, MonthlyFee)
VALUES ('CT000099', 'C00001', '2026-09-01', '2027-08-31', 1000.00);

-- Foreign key: a campaign must belong to an existing client
-- Expected: foreign key constraint fails (fk_campaign_client)
INSERT INTO CAMPAIGN (CampaignID, ClientID, CampaignName, Objective, DailyBudget, StartDate)
VALUES ('CA00000099', 'C99999', 'Orphan Campaign', 'Leads', 20.00, '2026-09-01');

-- Domain rule: Google quality score must be between 1 and 10
-- Expected: check constraint violated (ck_agk_quality)
INSERT INTO ADGROUPKEYWORD (AdGroupID, KeywordID, MatchType, MaxCPCBid, QualityScore, DateAdded)
VALUES ('AG00000002', 'KW000007', 'Exact', 1.50, 11, '2026-09-01');

-- Domain rule: invoice status must be Unpaid, Paid or Overdue
-- Expected: check constraint violated (ck_invoice_status)
INSERT INTO INVOICE (InvoiceID, ClientID, InvoiceDate, BillingPeriod, AmountDue, Status)
VALUES ('IN00000099', 'C00001', '2026-09-30', '2026-09', 1500.00, 'Pending');

-- Date rule: a contract cannot end before it is signed
-- Expected: check constraint violated (ck_contract_dates)
INSERT INTO CONTRACT (ContractID, ClientID, SignedDate, EndDate, MonthlyFee)
VALUES ('CT000098', 'C00007', '2026-09-01', '2026-01-01', 750.00);

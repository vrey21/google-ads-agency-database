-- =============================================================
-- 02_sample_data.sql  |  Sample (fictional) data exported from the
-- original Microsoft Access database. Run after 01_schema.sql.
-- =============================================================

USE alamo_digital_marketing;

-- EMPLOYEE (10 rows)
INSERT INTO EMPLOYEE (EmployeeID, FirstName, LastName, Email, HireDate, SupervisorID) VALUES
    ('E00001', 'Victoria', 'Reyna', 'Vreyna@alamoagency.com', '2024-03-01', NULL),
    ('E00002', 'Ashley', 'Luis', 'AshLuis@alamoagency.com', '2025-06-15', 'E00001'),
    ('E00003', 'Daniel', 'Ortiz', 'dortiz@alamoagency.com', '2024-04-12', 'E00001'),
    ('E00004', 'Priya', 'Shah', 'pshah@alamoagency.com', '2024-07-08', 'E00001'),
    ('E00005', 'Marcus', 'Webb', 'mwebb@alamoagency.com', '2024-09-02', 'E00003'),
    ('E00006', 'Elena', 'Cruz', 'ecruz@alamoagency.com', '2025-01-15', 'E00003'),
    ('E00007', 'Tyler', 'Nguyen', 'tnguyen@alamoagency.com', '2025-02-03', 'E00001'),
    ('E00008', 'Sofia', 'Ramirez', 'sramirez@alamoagency.com', '2025-05-19', 'E00007'),
    ('E00009', 'Andre', 'Jackson', 'ajackson@alamoagency.com', '2025-08-25', 'E00007'),
    ('E00010', 'Grace', 'Kim', 'gkim@alamoagency.com', '2025-10-06', 'E00001');

-- ACCOUNTMANAGER (7 rows)
INSERT INTO ACCOUNTMANAGER (EmployeeID, ClientCapacity) VALUES
    ('E00001', 8),
    ('E00003', 6),
    ('E00004', 10),
    ('E00005', 8),
    ('E00007', 12),
    ('E00008', 7),
    ('E00009', 9);

-- ADSPECIALIST (7 rows)
INSERT INTO ADSPECIALIST (EmployeeID, GoogleCertID, CertExpiration) VALUES
    ('E00002', 'GA-4417', '2027-05-31'),
    ('E00003', 'GA-5120', '2027-06-30'),
    ('E00004', 'GA-5288', '2027-08-15'),
    ('E00006', 'GA-6001', '2026-11-30'),
    ('E00007', 'GA-6142', '2028-03-31'),
    ('E00008', 'GA-6377', '2027-01-31'),
    ('E00009', 'GA-6490', '2027-09-30');

-- ANALYST (7 rows)
INSERT INTO ANALYST (EmployeeID, PrimaryTool) VALUES
    ('E00002', 'Looker Studio'),
    ('E00004', 'Google Analytics'),
    ('E00005', 'Looker Studio'),
    ('E00006', 'Excel'),
    ('E00007', 'Looker Studio'),
    ('E00008', 'Power BI'),
    ('E00009', 'Google Analytics');

-- CLIENT (7 rows)
INSERT INTO CLIENT (ClientID, CompanyName, Industry, ContactName, ContactEmail, StartDate) VALUES
    ('C00001', 'San Antonio Dental', 'Dental', 'Priscilla Schultze', 'pris@Sadental.com', '2025-11-01'),
    ('C00002', 'Alamo Family Law', 'Legal', 'Ruben Vega', 'ruben@alamofamilylaw.com', '2026-01-15'),
    ('C00003', 'Cool Breeze AC and Heating', 'Home Services', 'Dana Wells', 'dana@coolbreezeac.com', '2026-02-01'),
    ('C00004', 'Hill Country Roofing', 'Home Services', 'Mark Sutton', 'mark@hillcountryroofing.com', '2026-02-20'),
    ('C00005', 'Pearl Med Spa', 'Health and Beauty', 'Nina Patel', 'nina@pearlmedspa.com', '2026-03-05'),
    ('C00006', 'River Walk Auto Detail', 'Automotive', 'Carlos Mendez', 'carlos@rwautodetail.com', '2026-03-22'),
    ('C00007', 'Tres Leches Bakery', 'Restaurant', 'Lucia Marin', 'lucia@treslechesbakery.com', '2026-04-10');

-- CONTRACT (7 rows)
INSERT INTO CONTRACT (ContractID, ClientID, SignedDate, EndDate, MonthlyFee, Status) VALUES
    ('CT000001', 'C00001', '2025-11-01', '2026-10-31', 1500, 'Active'),
    ('CT000002', 'C00002', '2026-01-15', '2027-01-14', 2200, 'Active'),
    ('CT000003', 'C00003', '2026-02-01', '2027-01-31', 1800, 'Active'),
    ('CT000004', 'C00004', '2026-02-20', '2027-02-19', 1250, 'Active'),
    ('CT000005', 'C00005', '2026-03-05', '2027-03-04', 2500, 'Active'),
    ('CT000006', 'C00006', '2026-03-22', '2027-03-21', 900, 'Active'),
    ('CT000007', 'C00007', '2026-04-10', '2026-10-09', 750, 'Active');

-- ACCOUNTASSIGNMENT (10 rows)
INSERT INTO ACCOUNTASSIGNMENT (EmployeeID, ClientID, RoleOnAccount, AssignedDate, HoursPerWeek) VALUES
    ('E00001', 'C00001', 'Lead', '2025-11-01', 5),
    ('E00001', 'C00002', 'Lead', '2026-01-15', 6),
    ('E00003', 'C00003', 'Lead', '2026-02-01', 5.5),
    ('E00003', 'C00004', 'Lead', '2026-02-20', 4),
    ('E00004', 'C00002', 'Support', '2026-01-20', 2),
    ('E00004', 'C00003', 'Support', '2026-02-05', 2.5),
    ('E00005', 'C00005', 'Lead', '2026-03-05', 7),
    ('E00007', 'C00006', 'Lead', '2026-03-22', 3.5),
    ('E00007', 'C00007', 'Lead', '2026-04-10', 4.5),
    ('E00009', 'C00001', 'Support', '2026-05-01', 3);

-- CAMPAIGN (8 rows)
INSERT INTO CAMPAIGN (CampaignID, ClientID, CampaignName, Objective, DailyBudget, StartDate, Status, SourceCampaignID) VALUES
    ('CA00000001', 'C00001', 'Dental Implants - Search', 'Leads', 40, '2026-01-05', 'Enabled', NULL),
    ('CA00000003', 'C00002', 'Family Law - Search', 'Leads', 55, '2026-01-20', 'Enabled', NULL),
    ('CA00000005', 'C00003', 'AC Repair - Summer Search', 'Leads', 75, '2026-02-10', 'Enabled', NULL),
    ('CA00000006', 'C00004', 'Roofing - Storm Season', 'Leads', 60, '2026-03-01', 'Paused', NULL),
    ('CA00000007', 'C00005', 'Med Spa - Botox Promo', 'Sales', 45, '2026-03-15', 'Enabled', NULL),
    ('CA00000008', 'C00006', 'Auto Detail - Local Traffic', 'Traffic', 25, '2026-04-01', 'Enabled', NULL),
    ('CA00000002', 'C00001', 'Implants - Remarketing', 'Leads', 15, '2026-03-01', 'Enabled', 'CA00000001'),
    ('CA00000004', 'C00002', 'Family Law - Remarketing', 'Leads', 20, '2026-04-01', 'Enabled', 'CA00000003');

-- ADGROUP (8 rows)
INSERT INTO ADGROUP (AdGroupID, CampaignID, AdGroupName, DefaultBid, Status) VALUES
    ('AG00000001', 'CA00000001', 'Implants - San Antonio', 2.5, 'Enabled'),
    ('AG00000002', 'CA00000002', 'Remarketing Audience', 1.25, 'Enabled'),
    ('AG00000003', 'CA00000003', 'Divorce Attorney - Exact', 4.5, 'Enabled'),
    ('AG00000004', 'CA00000004', 'Site Visitors 30 Day', 2, 'Enabled'),
    ('AG00000005', 'CA00000005', 'AC Repair Emergency', 3.75, 'Enabled'),
    ('AG00000006', 'CA00000006', 'Roof Replacement', 3.1, 'Paused'),
    ('AG00000007', 'CA00000007', 'Botox and Fillers', 2.8, 'Enabled'),
    ('AG00000008', 'CA00000008', 'Mobile Detailing', 1.6, 'Enabled');

-- AD (7 rows)
INSERT INTO AD (AdID, AdGroupID, AdType, Headline, DescriptionText, FinalURL, Status) VALUES
    ('AD00000001', 'AG00000001', 'Responsive Search', 'Affordable Dental Implants', 'Free consultation. Payment plans available. Book today.', 'https://SAdental.com/implants', 'Enabled'),
    ('AD00000002', 'AG00000003', 'Responsive Search', 'Divorce Lawyer Near You', 'Free 30-minute consultation. Compassionate family law support. Call today.', 'https://alamofamilylaw.com/divorce', 'Enabled'),
    ('AD00000003', 'AG00000005', 'Responsive Search', 'Same-Day AC Repair', 'Licensed techs available 24/7. Free estimates on new system installs.', 'https://coolbreezeac.com/repair', 'Enabled'),
    ('AD00000004', 'AG00000006', 'Display', 'Free Roof Inspection', 'Storm damage? Get a free inspection and insurance claim help this week.', 'https://hillcountryroofing.com/inspect', 'Paused'),
    ('AD00000005', 'AG00000007', 'Responsive Search', 'Botox Specials This Month', 'Save on Botox and filler packages. Book your consultation online today.', 'https://pearlmedspa.com/specials', 'Enabled'),
    ('AD00000006', 'AG00000008', 'Video', 'Mobile Auto Detailing', 'We come to you. Interior and exterior detail packages start at $89.', 'https://rwautodetail.com/mobile', 'Enabled'),
    ('AD00000007', 'AG00000004', 'Display', 'Still Need a Family Lawyer?', 'Free consultation with an experienced San Antonio family attorney.', 'https://alamofamilylaw.com/consult', 'Enabled');

-- KEYWORD (7 rows)
INSERT INTO KEYWORD (KeywordID, KeywordText, AvgSearchVolume) VALUES
    ('KW000001', 'dental implants san antonio', 1900),
    ('KW000002', 'divorce lawyer san antonio', 2400),
    ('KW000003', 'emergency ac repair', 3100),
    ('KW000004', 'roof replacement cost', 1600),
    ('KW000005', 'botox near me', 5400),
    ('KW000006', 'mobile car detailing', 2900),
    ('KW000007', 'best bakery san antonio', 1200);

-- ADGROUPKEYWORD (7 rows)
INSERT INTO ADGROUPKEYWORD (AdGroupID, KeywordID, MatchType, MaxCPCBid, QualityScore, DateAdded) VALUES
    ('AG00000001', 'KW000001', 'Exact', 3.25, 7, '2026-01-05'),
    ('AG00000003', 'KW000002', 'Exact', 5.75, 8, '2026-01-20'),
    ('AG00000004', 'KW000002', 'Broad', 2.1, 5, '2026-04-01'),
    ('AG00000005', 'KW000003', 'Phrase', 4.25, 9, '2026-02-10'),
    ('AG00000006', 'KW000004', 'Exact', 3.5, 6, '2026-03-01'),
    ('AG00000007', 'KW000005', 'Broad', 3.9, 7, '2026-03-15'),
    ('AG00000008', 'KW000006', 'Phrase', 1.85, 4, '2026-04-01');

-- INVOICE (9 rows)
INSERT INTO INVOICE (InvoiceID, ClientID, InvoiceDate, BillingPeriod, AmountDue, Status, PaidDate) VALUES
    ('IN00000001', 'C00001', '2026-06-30', '2026-06', 1500, 'Paid', '2026-07-05'),
    ('IN00000002', 'C00002', '2026-06-30', '2026-06', 2200, 'Paid', '2026-07-03'),
    ('IN00000003', 'C00003', '2026-06-30', '2026-06', 1800, 'Unpaid', NULL),
    ('IN00000004', 'C00004', '2026-06-30', '2026-06', 1250, 'Overdue', NULL),
    ('IN00000005', 'C00005', '2026-06-30', '2026-06', 2500, 'Paid', '2026-07-08'),
    ('IN00000006', 'C00006', '2026-06-30', '2026-06', 900, 'Unpaid', NULL),
    ('IN00000007', 'C00002', '2026-07-31', '2026-07', 2200, 'Unpaid', NULL),
    ('IN00000008', 'C00003', '2026-07-31', '2026-07', 1800, 'Overdue', NULL),
    ('IN00000009', 'C00007', '2026-07-31', '2026-07', 750, 'Unpaid', NULL);


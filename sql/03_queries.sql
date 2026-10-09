-- =============================================================
-- 03_queries.sql  |  The 10 business queries (F1-F10)
-- Each query answers a specific management question.
-- Run after 01_schema.sql and 02_sample_data.sql.
-- =============================================================

USE alamo_digital_marketing;

-- -------------------------------------------------------------
-- F1. Client contract overview
-- Q: What are every client's contract terms?
-- Concepts: INNER JOIN on a 1:1 relationship
-- -------------------------------------------------------------
SELECT  c.CompanyName,
        c.Industry,
        ct.MonthlyFee,
        ct.Status   AS ContractStatus,
        ct.EndDate  AS ContractEndDate
FROM    CLIENT   c
JOIN    CONTRACT ct ON ct.ClientID = c.ClientID
ORDER BY ct.EndDate;

-- -------------------------------------------------------------
-- F2. Unpaid billing by client
-- Q: Which clients owe money, and how much?
-- Concepts: JOIN, WHERE ... IN, SUM, GROUP BY
-- -------------------------------------------------------------
SELECT  c.CompanyName,
        COUNT(i.InvoiceID) AS OpenInvoices,
        SUM(i.AmountDue)   AS TotalUnpaid
FROM    CLIENT  c
JOIN    INVOICE i ON i.ClientID = c.ClientID
WHERE   i.Status IN ('Unpaid', 'Overdue')
GROUP BY c.ClientID, c.CompanyName
ORDER BY TotalUnpaid DESC;

-- -------------------------------------------------------------
-- F3. Average campaign budget per client
-- Q: How do daily budget levels compare across accounts?
-- Concepts: JOIN, AVG, GROUP BY
-- -------------------------------------------------------------
SELECT  c.CompanyName,
        COUNT(cp.CampaignID)          AS Campaigns,
        ROUND(AVG(cp.DailyBudget), 2) AS AvgDailyBudget
FROM    CLIENT   c
JOIN    CAMPAIGN cp ON cp.ClientID = c.ClientID
GROUP BY c.ClientID, c.CompanyName
ORDER BY AvgDailyBudget DESC;

-- -------------------------------------------------------------
-- F4. Keyword health by ad group
-- Q: Which ad groups have weak keyword quality?
-- Concepts: 3-table JOIN through an associative entity, COUNT, AVG
-- -------------------------------------------------------------
SELECT  ag.AdGroupName,
        COUNT(k.KeywordID)              AS Keywords,
        ROUND(AVG(agk.QualityScore), 1) AS AvgQualityScore
FROM    ADGROUP        ag
JOIN    ADGROUPKEYWORD agk ON agk.AdGroupID = ag.AdGroupID
JOIN    KEYWORD        k   ON k.KeywordID   = agk.KeywordID
GROUP BY ag.AdGroupID, ag.AdGroupName
ORDER BY AvgQualityScore;

-- -------------------------------------------------------------
-- F5. Highest bid in each campaign
-- Q: What is the most we are willing to pay per click in each campaign?
-- Concepts: 4-table JOIN, MAX, GROUP BY
-- -------------------------------------------------------------
SELECT  cp.CampaignName,
        MAX(agk.MaxCPCBid) AS HighestMaxCPCBid
FROM    CAMPAIGN       cp
JOIN    ADGROUP        ag  ON ag.CampaignID = cp.CampaignID
JOIN    ADGROUPKEYWORD agk ON agk.AdGroupID = ag.AdGroupID
JOIN    KEYWORD        k   ON k.KeywordID   = agk.KeywordID
GROUP BY cp.CampaignID, cp.CampaignName
ORDER BY HighestMaxCPCBid DESC;

-- -------------------------------------------------------------
-- F6. Employee supervision report
-- Q: Who reports to whom?
-- Concepts: SELF-JOIN (unary relationship), LEFT JOIN, CONCAT
-- -------------------------------------------------------------
SELECT  CONCAT(e.FirstName, ' ', e.LastName)           AS Employee,
        COALESCE(CONCAT(s.FirstName, ' ', s.LastName),
                 '(no supervisor)')                    AS Supervisor
FROM    EMPLOYEE e
LEFT JOIN EMPLOYEE s ON s.EmployeeID = e.SupervisorID
ORDER BY Supervisor, Employee;

-- -------------------------------------------------------------
-- F7. Certification expiration alert
-- Q: Whose Google Ads certification expires soonest?
-- Concepts: supertype/subtype JOIN, date calculation
-- -------------------------------------------------------------
SELECT  e.FirstName,
        e.LastName,
        a.GoogleCertID,
        a.CertExpiration,
        DATEDIFF(a.CertExpiration, CURDATE()) AS DaysUntilExpiration
FROM    EMPLOYEE     e
JOIN    ADSPECIALIST a ON a.EmployeeID = e.EmployeeID
ORDER BY a.CertExpiration;

-- -------------------------------------------------------------
-- F8. Employee workload
-- Q: How many client accounts is each employee assigned to?
-- Concepts: LEFT JOIN through an associative entity, COUNT, SUM, GROUP BY
-- (LEFT JOIN keeps employees with zero assignments in the list.)
-- -------------------------------------------------------------
SELECT  e.FirstName,
        e.LastName,
        COUNT(c.ClientID)                 AS AssignedClients,
        COALESCE(SUM(aa.HoursPerWeek), 0) AS TotalHoursPerWeek
FROM    EMPLOYEE e
LEFT JOIN ACCOUNTASSIGNMENT aa ON aa.EmployeeID = e.EmployeeID
LEFT JOIN CLIENT            c  ON c.ClientID    = aa.ClientID
GROUP BY e.EmployeeID, e.FirstName, e.LastName
ORDER BY AssignedClients DESC, TotalHoursPerWeek DESC;

-- -------------------------------------------------------------
-- F9. Full ad listing for a campaign
-- Q: What ads are running in a given campaign?
-- Concepts: 3-level hierarchy JOIN, user variable as a parameter
-- Change @campaign to list a different campaign.
-- -------------------------------------------------------------
SET @campaign = 'Family Law - Remarketing';

SELECT  cp.CampaignName,
        ag.AdGroupName,
        a.Headline,
        a.AdType,
        a.Status
FROM    CAMPAIGN cp
JOIN    ADGROUP  ag ON ag.CampaignID = cp.CampaignID
JOIN    AD       a  ON a.AdGroupID   = ag.AdGroupID
WHERE   cp.CampaignName = @campaign
ORDER BY ag.AdGroupName, a.Headline;

-- -------------------------------------------------------------
-- F10. Remarketing lineage
-- Q: Which remarketing campaigns were built from which original campaigns?
-- Concepts: SELF-JOIN (unary relationship)
-- -------------------------------------------------------------
SELECT  r.CampaignName AS RemarketingCampaign,
        s.CampaignName AS SourceCampaign,
        r.StartDate    AS RemarketingStart
FROM    CAMPAIGN r
JOIN    CAMPAIGN s ON s.CampaignID = r.SourceCampaignID
ORDER BY r.StartDate;

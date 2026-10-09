-- =============================================================
-- Alamo Digital Marketing: Google Ads Agency Database
-- 01_schema.sql  |  MySQL 8.0+
-- Creates the database and all 13 tables with primary keys,
-- foreign keys, unique constraints, CHECK constraints and defaults,
-- following the data dictionary in the project report.
-- =============================================================

DROP DATABASE IF EXISTS alamo_digital_marketing;
CREATE DATABASE alamo_digital_marketing;
USE alamo_digital_marketing;

-- -------------------------------------------------------------
-- EMPLOYEE (supertype)
-- Unary relationship: SupervisorID references another employee.
-- -------------------------------------------------------------
CREATE TABLE EMPLOYEE (
    EmployeeID    CHAR(6)      NOT NULL,
    FirstName     VARCHAR(30)  NOT NULL,
    LastName      VARCHAR(30)  NOT NULL,
    Email         VARCHAR(60)  NOT NULL,
    HireDate      DATE         NOT NULL,
    SupervisorID  CHAR(6),
    CONSTRAINT pk_employee PRIMARY KEY (EmployeeID),
    CONSTRAINT uq_employee_email UNIQUE (Email),
    CONSTRAINT fk_employee_supervisor FOREIGN KEY (SupervisorID)
        REFERENCES EMPLOYEE (EmployeeID)
);

-- -------------------------------------------------------------
-- Subtypes of EMPLOYEE (overlapping, partial specialization)
-- Each subtype shares the supertype's primary key.
-- -------------------------------------------------------------
CREATE TABLE ACCOUNTMANAGER (
    EmployeeID      CHAR(6)  NOT NULL,
    ClientCapacity  INT      NOT NULL,
    CONSTRAINT pk_accountmanager PRIMARY KEY (EmployeeID),
    CONSTRAINT fk_accountmanager_employee FOREIGN KEY (EmployeeID)
        REFERENCES EMPLOYEE (EmployeeID),
    CONSTRAINT ck_accountmanager_capacity CHECK (ClientCapacity > 0)
);

CREATE TABLE ADSPECIALIST (
    EmployeeID      CHAR(6)      NOT NULL,
    GoogleCertID    VARCHAR(20),
    CertExpiration  DATE,
    CONSTRAINT pk_adspecialist PRIMARY KEY (EmployeeID),
    CONSTRAINT uq_adspecialist_cert UNIQUE (GoogleCertID),
    CONSTRAINT fk_adspecialist_employee FOREIGN KEY (EmployeeID)
        REFERENCES EMPLOYEE (EmployeeID)
);

CREATE TABLE ANALYST (
    EmployeeID   CHAR(6)      NOT NULL,
    PrimaryTool  VARCHAR(30),
    CONSTRAINT pk_analyst PRIMARY KEY (EmployeeID),
    CONSTRAINT fk_analyst_employee FOREIGN KEY (EmployeeID)
        REFERENCES EMPLOYEE (EmployeeID)
);

-- -------------------------------------------------------------
-- CLIENT
-- -------------------------------------------------------------
CREATE TABLE CLIENT (
    ClientID      CHAR(6)      NOT NULL,
    CompanyName   VARCHAR(60)  NOT NULL,
    Industry      VARCHAR(40),
    ContactName   VARCHAR(50)  NOT NULL,
    ContactEmail  VARCHAR(60)  NOT NULL,
    StartDate     DATE         NOT NULL,
    CONSTRAINT pk_client PRIMARY KEY (ClientID)
);

-- -------------------------------------------------------------
-- CONTRACT (1:1 with CLIENT)
-- The UNIQUE constraint on ClientID enforces "one contract per client".
-- -------------------------------------------------------------
CREATE TABLE CONTRACT (
    ContractID  CHAR(8)        NOT NULL,
    ClientID    CHAR(6)        NOT NULL,
    SignedDate  DATE           NOT NULL,
    EndDate     DATE,
    MonthlyFee  DECIMAL(8,2)   NOT NULL,
    Status      VARCHAR(12)    DEFAULT 'Active',
    CONSTRAINT pk_contract PRIMARY KEY (ContractID),
    CONSTRAINT uq_contract_client UNIQUE (ClientID),
    CONSTRAINT fk_contract_client FOREIGN KEY (ClientID)
        REFERENCES CLIENT (ClientID),
    CONSTRAINT ck_contract_fee    CHECK (MonthlyFee > 0),
    CONSTRAINT ck_contract_dates  CHECK (EndDate IS NULL OR EndDate > SignedDate),
    CONSTRAINT ck_contract_status CHECK (Status IN ('Active', 'Expired', 'Terminated'))
);

-- -------------------------------------------------------------
-- ACCOUNTASSIGNMENT (associative entity: EMPLOYEE M:N CLIENT)
-- -------------------------------------------------------------
CREATE TABLE ACCOUNTASSIGNMENT (
    EmployeeID     CHAR(6)       NOT NULL,
    ClientID       CHAR(6)       NOT NULL,
    RoleOnAccount  VARCHAR(15)   NOT NULL,
    AssignedDate   DATE          NOT NULL,
    HoursPerWeek   DECIMAL(4,1),
    CONSTRAINT pk_accountassignment PRIMARY KEY (EmployeeID, ClientID),
    CONSTRAINT fk_assignment_employee FOREIGN KEY (EmployeeID)
        REFERENCES EMPLOYEE (EmployeeID),
    CONSTRAINT fk_assignment_client FOREIGN KEY (ClientID)
        REFERENCES CLIENT (ClientID),
    CONSTRAINT ck_assignment_hours CHECK (HoursPerWeek > 0)
);

-- -------------------------------------------------------------
-- CAMPAIGN
-- Unary relationship: SourceCampaignID links a remarketing
-- campaign to the campaign it was built from.
-- -------------------------------------------------------------
CREATE TABLE CAMPAIGN (
    CampaignID        CHAR(10)      NOT NULL,
    ClientID          CHAR(6)       NOT NULL,
    CampaignName      VARCHAR(60)   NOT NULL,
    Objective         VARCHAR(20)   NOT NULL,
    DailyBudget       DECIMAL(7,2)  NOT NULL,
    StartDate         DATE          NOT NULL,
    Status            VARCHAR(10)   DEFAULT 'Enabled',
    SourceCampaignID  CHAR(10),
    CONSTRAINT pk_campaign PRIMARY KEY (CampaignID),
    CONSTRAINT fk_campaign_client FOREIGN KEY (ClientID)
        REFERENCES CLIENT (ClientID),
    CONSTRAINT fk_campaign_source FOREIGN KEY (SourceCampaignID)
        REFERENCES CAMPAIGN (CampaignID),
    CONSTRAINT ck_campaign_budget    CHECK (DailyBudget > 0),
    CONSTRAINT ck_campaign_objective CHECK (Objective IN ('Sales', 'Leads', 'Traffic', 'Awareness')),
    CONSTRAINT ck_campaign_status    CHECK (Status IN ('Enabled', 'Paused', 'Ended'))
);

-- -------------------------------------------------------------
-- ADGROUP
-- -------------------------------------------------------------
CREATE TABLE ADGROUP (
    AdGroupID    CHAR(10)      NOT NULL,
    CampaignID   CHAR(10)      NOT NULL,
    AdGroupName  VARCHAR(60)   NOT NULL,
    DefaultBid   DECIMAL(5,2),
    Status       VARCHAR(10)   DEFAULT 'Enabled',
    CONSTRAINT pk_adgroup PRIMARY KEY (AdGroupID),
    CONSTRAINT fk_adgroup_campaign FOREIGN KEY (CampaignID)
        REFERENCES CAMPAIGN (CampaignID),
    CONSTRAINT ck_adgroup_bid    CHECK (DefaultBid > 0),
    CONSTRAINT ck_adgroup_status CHECK (Status IN ('Enabled', 'Paused'))
);

-- -------------------------------------------------------------
-- AD
-- -------------------------------------------------------------
CREATE TABLE AD (
    AdID             CHAR(10)      NOT NULL,
    AdGroupID        CHAR(10)      NOT NULL,
    AdType           VARCHAR(20)   NOT NULL,
    Headline         VARCHAR(30)   NOT NULL,
    DescriptionText  VARCHAR(90)   NOT NULL,
    FinalURL         VARCHAR(120)  NOT NULL,
    Status           VARCHAR(12)   DEFAULT 'Enabled',
    CONSTRAINT pk_ad PRIMARY KEY (AdID),
    CONSTRAINT fk_ad_adgroup FOREIGN KEY (AdGroupID)
        REFERENCES ADGROUP (AdGroupID),
    CONSTRAINT ck_ad_type   CHECK (AdType IN ('Responsive Search', 'Display', 'Video')),
    CONSTRAINT ck_ad_status CHECK (Status IN ('Enabled', 'Paused', 'Disapproved'))
);

-- -------------------------------------------------------------
-- KEYWORD
-- -------------------------------------------------------------
CREATE TABLE KEYWORD (
    KeywordID        CHAR(8)      NOT NULL,
    KeywordText      VARCHAR(80)  NOT NULL,
    AvgSearchVolume  INT,
    CONSTRAINT pk_keyword PRIMARY KEY (KeywordID),
    CONSTRAINT uq_keyword_text UNIQUE (KeywordText),
    CONSTRAINT ck_keyword_volume CHECK (AvgSearchVolume >= 0)
);

-- -------------------------------------------------------------
-- ADGROUPKEYWORD (associative entity: ADGROUP M:N KEYWORD)
-- -------------------------------------------------------------
CREATE TABLE ADGROUPKEYWORD (
    AdGroupID     CHAR(10)      NOT NULL,
    KeywordID     CHAR(8)       NOT NULL,
    MatchType     VARCHAR(10)   NOT NULL,
    MaxCPCBid     DECIMAL(5,2),
    QualityScore  INT,
    DateAdded     DATE          NOT NULL,
    CONSTRAINT pk_adgroupkeyword PRIMARY KEY (AdGroupID, KeywordID),
    CONSTRAINT fk_agk_adgroup FOREIGN KEY (AdGroupID)
        REFERENCES ADGROUP (AdGroupID),
    CONSTRAINT fk_agk_keyword FOREIGN KEY (KeywordID)
        REFERENCES KEYWORD (KeywordID),
    CONSTRAINT ck_agk_matchtype CHECK (MatchType IN ('Broad', 'Phrase', 'Exact')),
    CONSTRAINT ck_agk_bid       CHECK (MaxCPCBid > 0),
    CONSTRAINT ck_agk_quality   CHECK (QualityScore BETWEEN 1 AND 10)
);

-- -------------------------------------------------------------
-- INVOICE
-- -------------------------------------------------------------
CREATE TABLE INVOICE (
    InvoiceID      CHAR(10)      NOT NULL,
    ClientID       CHAR(6)       NOT NULL,
    InvoiceDate    DATE          NOT NULL,
    BillingPeriod  CHAR(7)       NOT NULL,
    AmountDue      DECIMAL(9,2)  NOT NULL,
    Status         VARCHAR(10)   DEFAULT 'Unpaid',
    PaidDate       DATE,
    CONSTRAINT pk_invoice PRIMARY KEY (InvoiceID),
    CONSTRAINT fk_invoice_client FOREIGN KEY (ClientID)
        REFERENCES CLIENT (ClientID),
    CONSTRAINT ck_invoice_amount CHECK (AmountDue > 0),
    CONSTRAINT ck_invoice_status CHECK (Status IN ('Unpaid', 'Paid', 'Overdue'))
);

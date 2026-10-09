# Exports the Access tables to MySQL INSERT statements (requires mdbtools).
# Usage: python3 export_access_to_mysql.py ../original/Alamo_Digital_Marketing.accdb > ../sql/02_sample_data.sql
import csv, subprocess, io, sys, datetime
F = sys.argv[1]
order = ["EMPLOYEE","ACCOUNTMANAGER","ADSPECIALIST","ANALYST","CLIENT","CONTRACT",
         "ACCOUNTASSIGNMENT","CAMPAIGN","ADGROUP","AD","KEYWORD","ADGROUPKEYWORD","INVOICE"]
datecols = {"HireDate","CertExpiration","StartDate","SignedDate","EndDate","AssignedDate","DateAdded","InvoiceDate","PaidDate"}
out = ["-- =============================================================",
       "-- 02_sample_data.sql  |  Sample (fictional) data exported from the",
       "-- original Microsoft Access database. Run after 01_schema.sql.",
       "-- =============================================================", "",
       "USE alamo_digital_marketing;", ""]
def lit(col, v):
    if v == "": return "NULL"
    if col in datecols:
        return "'" + datetime.datetime.strptime(v, "%m/%d/%y %H:%M:%S").strftime("%Y-%m-%d") + "'"
    try:
        float(v); 
        if col not in ("BillingPeriod",) and not v.startswith("0"): return v
    except ValueError: pass
    return "'" + v.replace("'", "''") + "'"
# Self-referencing FKs: insert supervisors/sources first by sorting
for t in order:
    data = subprocess.run(["mdb-export", F, t], capture_output=True, text=True).stdout
    rows = list(csv.DictReader(io.StringIO(data)))
    if t == "EMPLOYEE": rows.sort(key=lambda r: r["SupervisorID"] != "")
    if t == "CAMPAIGN": rows.sort(key=lambda r: r["SourceCampaignID"] != "")
    cols = list(rows[0].keys())
    out.append(f"-- {t} ({len(rows)} rows)")
    out.append(f"INSERT INTO {t} ({', '.join(cols)}) VALUES")
    vals = ["    (" + ", ".join(lit(c, r[c]) for c in cols) + ")" for r in rows]
    out.append(",\n".join(vals) + ";")
    out.append("")
print("\n".join(out))

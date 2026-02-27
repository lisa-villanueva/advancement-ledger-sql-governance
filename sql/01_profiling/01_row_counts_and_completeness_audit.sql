/*
FILE: 01_row_counts_and_uniqueness.sql
FOLDER: 01_profiling
PURPOSE: Initial Data Health Audit for the Advancement Ledger.
SECTIONS:
  1) Table Row Counts
  2) ID Uniqueness & Density
  3) Duplication Drill-Down
  4) Relational Integrity, Orphan Check
  5) Completeness Audit (Nulls)
  6) Financial Outlier Profiling
  7) Date Range/Freshness Check

GOVERNANCE:
   - Validates physical import counts vs. unique financial events.
   - Detects "ghost revenue" or double-counting (Data Density).
   - Verifies relational integrity (Orphan Check) to ensure every gift has a donor.
*/

-- 1) VOLUME & UNIQUENESS AUDIT
-- Purpose: Compare total ledger rows vs. unique gift events.
-- Outcome: total_rows should match unique_gifts.
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT Gift_ID) AS unique_gifts
FROM giving;


-- 2) DATA DENSITY & DUPLICATION CHECK
-- Purpose: Confirms if any Gift_ID appears in multiple rows.
-- Target: 1.0 (Higher than 1.0 indicates data corruption or "inflated" revenue).
SELECT
    ROUND(1.0 * COUNT(*) / COUNT(DISTINCT Gift_ID), 2) AS rows_per_gift_id
FROM giving;


-- 3a) INTEGRITY STATUS CHECK
-- Purpose: Quick pass/fail indicator for documentation/logs.
-- Outcome: Should return 'STATUS: PASS - No Duplicate Gift_IDs' if Density is 1.0.

SELECT
    CASE
        WHEN COUNT(*) = 0 THEN 'STATUS: PASS - No Duplicate Gift_IDs (N/A)'
        ELSE 'STATUS: FAIL - Duplicates Detected (See Drill-Down Below)'
    END AS Integrity_Result
FROM (
    SELECT Gift_ID FROM giving GROUP BY Gift_ID HAVING COUNT(*) > 1
);

-- 3b) SPECIFIC DUPLICATION DRILL-DOWN (Top 10)
-- Purpose: Identifies the exact Gift_IDs causing density issues.
-- Note: Returns 0 rows if Integrity Status is 'PASS'.
SELECT
    Gift_ID,
    COUNT(*) AS occurrences
FROM giving
GROUP BY Gift_ID
HAVING occurrences > 1
ORDER BY occurrences DESC
LIMIT 10;


-- 4) RELATIONAL INTEGRITY (ORPHAN CHECK)
-- Purpose: Ensures every gift is linked to a valid constituent.
-- Outcome: Should be 0. Gifts without donors cannot be receipted or stewarded.
SELECT COUNT(*) AS Orphan_Count
FROM giving
LEFT JOIN donors ON giving.Donor_ID = donors.ID
WHERE donors.ID IS NULL;

-- 5) COMPLETENESS AUDIT
-- Purpose: Identifies if ID is missing value; essential essential for business operations.
-- Outcome: Should be 0 for ID
-- Note: No email or phone in this dataset. In real world execution, add email and phone
SELECT COUNT (*) AS total_records,
 SUM(CASE WHEN ID IS NULL THEN 1 ELSE 0 END) AS missing_donor_ids,
 ROUND(100.0 * SUM(CASE WHEN ID IS NULL OR ID = '' THEN 1 ELSE 0 END) / COUNT(*), 2) AS donor_id_null_rate_pct
FROM donors;

-- 6a) GIFT RANGE SUMMARY: (Numeric Profiling)
-- Purpose: Detects outliers ("fat finger errors") and establishes the "financial shape" of the data.
SELECT 
    MIN(Gift_Amount) AS smallest_gift,
    MAX(Gift_Amount) AS largest_gift,
    AVG(Gift_Amount) AS average_gift,
	COUNT(DISTINCT Gift_Amount) AS distinct_gift_amounts
FROM giving;

-- 6a) Find the name of the donor with largest gift.

SELECT 
    donors.id,
    donors.First_Name,
    donors.Last_Name,
    giving.Gift_ID,
    giving.Gift_Amount
FROM giving
JOIN donors ON giving.Donor_ID = donors.id
ORDER BY giving.Gift_Amount DESC
LIMIT 1;

-- 7) DATA FRESHNESS CHECK
-- Purpose: Determines the time range covered by the gift history.
SELECT 
    MIN(Gift_Date) AS earliest_gift,
    MAX(Gift_Date) AS most_recent_gift
FROM giving;
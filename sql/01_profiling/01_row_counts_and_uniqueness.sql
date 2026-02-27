/* FILE: 01_row_counts_and_uniqueness.sql
   FOLDER: 01_profiling
   PURPOSE: Data Integrity & Relational Audit for Private HS.
   
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
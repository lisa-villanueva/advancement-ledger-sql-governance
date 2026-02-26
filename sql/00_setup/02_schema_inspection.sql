/* 	02_schema_inspection.sql
	OBJECTIVE: Identify the baseline structural integrity of primary tables. Inspect schema, data types, key fields, and basic integrity signals
	ALIGNED TO: My operating princple to "Maintain data integrity through audits and queries".
*/

-- 1. Check for Primary Key Integrity in the Donor Table
SELECT 
    COUNT(*) AS total_records,
    COUNT(DISTINCT ID) AS unique_constituent_ids,
    COUNT(*) - COUNT(DISTINCT ID) AS duplicate_id_count
FROM donors;


-- 2) SQLite version (useful for confirming window function support)
SELECT sqlite_version() AS sqlite_version;


-- 3) Table existence check
SELECT name, type
FROM sqlite_master
WHERE type IN ('table','view')
ORDER BY type, name;


-- 4) Column inventory (names, types, nullability, PK flags)
PRAGMA table_info(donors);
PRAGMA table_info(giving);

-- 5) 
/* PURPOSE: Extracts the "As-Built" Schema from SQLite's system catalog.
GOVERNANCE: 
  1. VALIDATION: Confirms 112-column donor schema committed correctly.
  2. AUDIT: Provides immutable proof of data types (e.g., Gift_Amount as REAL).
  3. RECOVERY: Enables reverse-engineering if original .sql source files are lost.
*/
SELECT sql 
FROM sqlite_master 
WHERE type='table' AND (name='donors' OR name='giving');




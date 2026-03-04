-- Date verification of the data 

-- check how dates are being parsed in the giving table. row by row.  

SELECT
  g.Gift_Date,
  strftime('%Y', DATE(g.Gift_Date)) AS cal_year,
  strftime('%m', DATE(g.Gift_Date)) AS cal_month,
  CASE
    WHEN strftime('%m', DATE(g.Gift_Date)) >= '07'
      THEN CAST(strftime('%Y', DATE(g.Gift_Date)) AS INTEGER) + 1
    ELSE CAST(strftime('%Y', DATE(g.Gift_Date)) AS INTEGER)
  END AS fiscal_year,
  g.Gift_Amount
FROM giving g
WHERE g.Gift_Amount > 0
LIMIT 20;


-- do 2024 and 2025 exist in the DATA

SELECT
  CASE
    WHEN strftime('%m', DATE(g.Gift_Date)) >= '07'
      THEN CAST(strftime('%Y', DATE(g.Gift_Date)) AS INTEGER) + 1
    ELSE CAST(strftime('%Y', DATE(g.Gift_Date)) AS INTEGER)
  END AS fiscal_year,
  COUNT(*) AS gift_rows,
  COUNT(DISTINCT g.Donor_ID) AS donors
FROM giving g
WHERE g.Gift_Amount > 0
GROUP BY fiscal_year
ORDER BY fiscal_year;

-- donor counts for 2 fiscal years, their overlap plus number of donors for only each year without overlap
WITH fy AS (
  SELECT
    g.Donor_ID,
    CASE
      WHEN strftime('%m', DATE(g.Gift_Date)) >= '07'
        THEN CAST(strftime('%Y', DATE(g.Gift_Date)) AS INTEGER) + 1
      ELSE CAST(strftime('%Y', DATE(g.Gift_Date)) AS INTEGER)
    END AS fiscal_year
  FROM giving g
  WHERE g.Gift_Amount > 0
),
fy2024 AS (SELECT DISTINCT Donor_ID FROM fy WHERE fiscal_year = 2024),
fy2025 AS (SELECT DISTINCT Donor_ID FROM fy WHERE fiscal_year = 2025)

SELECT 'FY2024 donors' AS metric, COUNT(*) AS n FROM fy2024
UNION ALL
SELECT 'FY2025 donors', COUNT(*) FROM fy2025
UNION ALL
SELECT 'Both years', COUNT(*) FROM fy2024 a JOIN fy2025 b ON a.Donor_ID = b.Donor_ID
UNION ALL
SELECT 'FY2024 only', COUNT(*) FROM fy2024 a LEFT JOIN fy2025 b ON a.Donor_ID = b.Donor_ID WHERE b.Donor_ID IS NULL
UNION ALL
SELECT 'FY2025 only', COUNT(*) FROM fy2025 b LEFT JOIN fy2024 a ON b.Donor_ID = a.Donor_ID WHERE a.Donor_ID IS NULL;
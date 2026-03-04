-- donor_upgrade_propensity_detail.sql
-- DETAIL VIEW: Individual donors with upgrade signals
-- Shows donors whose giving INCREASED from FY2024 to FY2025 
-- This signals "upgrade potential" for Major Gifts pipeline
-- Proxy for upgrade potential when rating history unavailable
WITH fy2024_giving AS (

SELECT

g.Donor_ID,

d.Rating AS current_rating,

d.donor_type,

SUM(g.Gift_Amount) AS fy2024_total,

COUNT(g.Gift_ID) AS fy2024_gift_count

FROM giving g

JOIN donors d ON g.Donor_ID = d.ID

WHERE CASE

WHEN strftime('%m', DATE(g.Gift_Date)) >= '07'

THEN CAST(strftime('%Y', DATE(g.Gift_Date)) AS INTEGER) + 1

ELSE CAST(strftime('%Y', DATE(g.Gift_Date)) AS INTEGER)

END = 2024

AND g.Gift_Amount > 0

GROUP BY g.Donor_ID, d.Rating, d.donor_type

),


fy2025_giving AS (

SELECT

g.Donor_ID,

SUM(g.Gift_Amount) AS fy2025_total,

COUNT(g.Gift_ID) AS fy2025_gift_count

FROM giving g

WHERE CASE

WHEN strftime('%m', DATE(g.Gift_Date)) >= '07'

THEN CAST(strftime('%Y', DATE(g.Gift_Date)) AS INTEGER) + 1

ELSE CAST(strftime('%Y', DATE(g.Gift_Date)) AS INTEGER)

END = 2025

AND g.Gift_Amount > 0

GROUP BY g.Donor_ID

)



SELECT
  fy24.Donor_ID,
  d.Full_Name,
  fy24.current_rating,
  fy24.donor_type,
  fy24.fy2024_total,
  fy25.fy2025_total,
  (fy25.fy2025_total - fy24.fy2024_total) AS gift_increase,
  ROUND((fy25.fy2025_total - fy24.fy2024_total) * 100.0 / fy24.fy2024_total, 2) AS pct_increase
FROM fy2024_giving fy24
INNER JOIN fy2025_giving fy25 ON fy24.Donor_ID = fy25.Donor_ID
JOIN donors d ON fy24.Donor_ID = d.ID
WHERE fy25.fy2025_total > fy24.fy2024_total
  AND (fy25.fy2025_total - fy24.fy2024_total) >= 500
  AND ((fy25.fy2025_total - fy24.fy2024_total) * 100.0 / fy24.fy2024_total) >= 20
ORDER BY gift_increase DESC;
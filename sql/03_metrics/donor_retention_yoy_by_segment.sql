### QUERY #1: Pure Donor Retention (Rating-Agnostic)

-- Step 1: FY 2024 baseline cohort
WITH fy2024_donors AS (

SELECT DISTINCT

d.ID,

d.Rating,

d.donor_type

FROM donors d

JOIN giving g ON d.ID = g.Donor_ID

WHERE CASE

WHEN strftime('%m', DATE(g.Gift_Date)) >= '07'

THEN CAST(strftime('%Y', DATE(g.Gift_Date)) AS INTEGER) + 1

ELSE CAST(strftime('%Y', DATE(g.Gift_Date)) AS INTEGER)

END = 2024

AND g.Gift_Amount > 0

),

-- Step 2: FY 2025 cohort
fy2025_donors AS (

SELECT DISTINCT

d.ID,

d.Rating,

d.donor_type

FROM donors d

JOIN giving g ON d.ID = g.Donor_ID

WHERE CASE

WHEN strftime('%m', DATE(g.Gift_Date)) >= '07'

THEN CAST(strftime('%Y', DATE(g.Gift_Date)) AS INTEGER) + 1

ELSE CAST(strftime('%Y', DATE(g.Gift_Date)) AS INTEGER)

END = 2025

AND g.Gift_Amount > 0

),


-- Step 3: Retained donors (intersection)
retained_donors AS (

SELECT

fy2024.ID,

fy2024.Rating AS fy2024_rating,

fy2024.donor_type AS fy2024_donor_type,

fy2025.Rating AS fy2025_rating,

fy2025.donor_type AS fy2025_donor_type

FROM fy2024_donors fy2024

INNER JOIN fy2025_donors fy2025

ON fy2024.ID = fy2025.ID -- ⚠️ ONLY match on ID, not rating/type

)

-- Step 4: Calculat Overall retention by FY2024 segment
SELECT

fy2024.Rating AS fy2024_rating,

fy2024.donor_type AS fy2024_donor_type,

COUNT(DISTINCT fy2024.ID) AS baseline_donors,

COUNT(DISTINCT retained.ID) AS retained_donors,

COUNT(DISTINCT fy2024.ID) - COUNT(DISTINCT retained.ID) AS lapsed_donors,

ROUND(COUNT(DISTINCT retained.ID) * 100.0 / COUNT(DISTINCT fy2024.ID), 2) AS retention_rate_pct

FROM fy2024_donors fy2024

LEFT JOIN retained_donors retained

ON fy2024.ID = retained.ID -- ⚠️ Simple match - no rating condition

GROUP BY fy2024.Rating, fy2024.donor_type

ORDER BY fy2024.Rating, fy2024.donor_type;


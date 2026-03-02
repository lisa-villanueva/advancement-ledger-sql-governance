-- donor_upgrade_propensity_fy2024_to_fy2025.sql

-- PURPOSE: "who gave again" but "who's showing major gift potential."

-- Identifies donors whose capacity rating INCREASED from FY2024 to FY2025

-- Satisfies JD Line 42 (prospect research support) & Line 31 (leadership metrics)

-- Issues: returns zero rows due to bug
/*## 🔍 Debugging Exercise: Why Zero Rows?


Question 1: Look at this line in the query:

WHERE fy24.fy2024_rating != fy25.fy2025_rating -- Only those whose rating changed


What assumption am I making about the Rating field in your donors table?


Hint: Think about the temporal dimension. The donors table has ONE row per donor with ONE current Rating value, right?


---


## 🧠 The Core Problem (Data Modeling Issue)


Your donors table looks like this:


| ID | Rating | ... |

|----|--------|-----|

| 12345 | B | (current rating as of data snapshot) |


But we need:

What was donor 12345's rating *during FY2024*?
What was donor 12345's rating *during FY2025*?

The schema doesn't store rating history!


This is a classic Slowly Changing Dimension (SCD) Type 2 problem in data warehousing.
/*

WITH fy2024_donors AS (

SELECT DISTINCT

d.ID,

d.Rating AS fy2024_rating,

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


fy2025_donors AS (

SELECT DISTINCT

d.ID,

d.Rating AS fy2025_rating,

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


rating_changes AS (

SELECT

fy24.ID,

fy24.fy2024_rating,

fy25.fy2025_rating,

fy24.donor_type,

-- Convert letter ratings to numeric for comparison (A=1, B=2, etc.)

(unicode(fy24.fy2024_rating) - unicode('A') + 1) AS fy2024_rating_num,

(unicode(fy25.fy2025_rating) - unicode('A') + 1) AS fy2025_rating_num

FROM fy2024_donors fy24

INNER JOIN fy2025_donors fy25

ON fy24.ID = fy25.ID

WHERE fy24.fy2024_rating != fy25.fy2025_rating -- Only those whose rating changed

)


-- Segment rating changes into Upgrades, Downgrades, and No Change

SELECT

fy2024_rating,

fy2025_rating,

donor_type,

COUNT(DISTINCT ID) AS donor_count,

CASE

WHEN fy2025_rating_num < fy2024_rating_num THEN 'Upgrade' -- A=1 is better than B=2

WHEN fy2025_rating_num > fy2024_rating_num THEN 'Downgrade'

ELSE 'No Change'

END AS rating_movement

FROM rating_changes

GROUP BY fy2024_rating, fy2025_rating, donor_type, rating_movement

ORDER BY rating_movement, fy2024_rating, fy2025_rating;

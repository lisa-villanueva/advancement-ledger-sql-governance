Follow-up analysis: Parent retention by recency of student graduation
-- Are recent parents (graduated 2020-2024) retaining better than legacy parents?


WITH fy2024_parents AS (

SELECT DISTINCT

d.ID,

d.Parent_Year,

d.Rating,

2024 - CAST(d.Parent_Year AS INTEGER) AS years_since_graduation

FROM donors d

JOIN giving g ON d.ID = g.Donor_ID

WHERE d.donor_type = 'Parent'

AND d.Parent_Year IS NOT NULL

AND CASE

WHEN strftime('%m', DATE(g.Gift_Date)) >= '07'

THEN CAST(strftime('%Y', DATE(g.Gift_Date)) AS INTEGER) + 1

ELSE CAST(strftime('%Y', DATE(g.Gift_Date)) AS INTEGER)

END = 2024

AND g.Gift_Amount > 0

),


fy2025_parents AS (

SELECT DISTINCT d.ID

FROM donors d

JOIN giving g ON d.ID = g.Donor_ID

WHERE d.donor_type = 'Parent'

AND CASE

WHEN strftime('%m', DATE(g.Gift_Date)) >= '07'

THEN CAST(strftime('%Y', DATE(g.Gift_Date)) AS INTEGER) + 1

ELSE CAST(strftime('%Y', DATE(g.Gift_Date)) AS INTEGER)

END = 2025

AND g.Gift_Amount > 0

)


SELECT

CASE

WHEN years_since_graduation <= 2 THEN '0-2 years (Recent Grads)'

WHEN years_since_graduation <= 5 THEN '3-5 years'

WHEN years_since_graduation <= 10 THEN '6-10 years'

ELSE '10+ years (Legacy)'

END AS parent_cohort,

COUNT(DISTINCT fy24.ID) AS baseline_parents,

COUNT(DISTINCT fy25
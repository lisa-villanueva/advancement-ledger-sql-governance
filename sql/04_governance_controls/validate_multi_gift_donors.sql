-- VALIDATION: Check for multi-gift donors in same FY
-- This query identifies donors who have made more than one gift in the same fiscal year.
-- To run parameterized, run scripts/validate_multi_gift_donors.py with the fiscal year as an argument.
-- Use in terminal: python scripts/validate_multi_gift_donors.py advancement.db <fiscal_year>

SELECT 
  Donor_ID,
  COUNT(*) as gift_count
FROM giving
WHERE <FY logic>
GROUP BY Donor_ID
HAVING COUNT(*) > 1;

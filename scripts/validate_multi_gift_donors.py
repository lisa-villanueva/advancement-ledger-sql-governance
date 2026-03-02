# validate_multi_gift_donors.py
# parameterized query to find donors with multiple gifts in a fiscal year

import sqlite3
import sys

def validate_multi_gift_donors(db_path, fiscal_year):
    """
    Check for donors with multiple gifts in a given fiscal year.
    
    Args:
        db_path (str): Path to SQLite database
        fiscal_year (int): Target fiscal year (e.g., 2024)
    
    Returns:
        List of tuples: (Donor_ID, gift_count, total_giving)
    """
    
    query = """
    SELECT 
      Donor_ID,
      ? AS fiscal_year,
      COUNT(*) as gift_count,
      SUM(Gift_Amount) as total_fy_giving
    FROM giving
    WHERE CASE
      WHEN strftime('%m', DATE(Gift_Date)) >= '07'
      THEN CAST(strftime('%Y', DATE(Gift_Date)) AS INTEGER) + 1
      ELSE CAST(strftime('%Y', DATE(Gift_Date)) AS INTEGER)
    END = ?
    GROUP BY Donor_ID
    HAVING COUNT(*) > 1
    ORDER BY gift_count DESC;
    """
    
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()
    cursor.execute(query, (fiscal_year, fiscal_year))
    results = cursor.fetchall()
    conn.close()
    
    return results

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python validate_multi_gift_donors.py <db_path> <fiscal_year>")
        sys.exit(1)
    
    db_path = sys.argv[1]
    fiscal_year = int(sys.argv[2])
    
    results = validate_multi_gift_donors(db_path, fiscal_year)
    
    print(f"\n=== Multi-Gift Donors in FY{fiscal_year} ===")
    print(f"Total donors with multiple gifts: {len(results)}\n")
    
    for donor_id, fy, count, total in results[:10]:  # Show top 10
        print(f"Donor {donor_id}: {count} gifts, ${total:,.2f} total")
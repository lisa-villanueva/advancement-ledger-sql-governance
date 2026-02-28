#🎓 School Advancement SQL Governance Ledger

## 📌 Project Overview
This project establishes a robust SQL-based infrastructure for managing 500k donor records and 3.8M transactions, focusing on data integrity and gift accounting standards.

## 🏗️ Data Architecture & Infrastructure
The foundational data for this project is a synthetic high-volume dataset designed for fundraising analytics.

Dataset: [Synthetic Donor Dataset for Fundraising Analytics](https://www.kaggle.com/datasets/dbrown86/synthetic-donor-dataset-for-fundraising-analytics)

Author: [dbrown86](https://www.kaggle.com/dbrown86) (via Kaggle)
Scale: 500,000 Donor Profiles | 3.8M Transactions

Usage Note: To maintain repository performance and adhere to GitHub file size limits, the raw source files (.csv, .db) are excluded from this repository.

This repo demonstrates a modular, scalable approach to SQL database management and data governance.
Key Folders:

/sql: Contains production-grade scripts for initial schema configuration, data profiling, and automated integrity audits.

/automation: Currently houses the AI Agent Specifications used to build Socratic tutors that guided the architectural development of this project. Future Roadmap: This directory will evolve into a full automation suite for the donor ledger system and end-to-end project orchestration.

## 🛡️ Data Governance & Integrity
Duplicate Detection: Description to follow. Used 01_duplicate_column_handling.sql script

Schema Enforcement: TBD

## 📊 Data Health Summary: donors & giving
Audit Date: 2026-02-28Status: 
✅ Verified & Profiled:
1) Completeness Metrics    
| Metric | Result | Action Taken |
| :--- | :--- | :--- |
| **Total Gift Records** | 3,836,541 | Verified via `COUNT(*)` |
| **Missing IDs** | 0 (No Orphan Gifts) | Verified via `LEFT JOIN` Orphan Check |
| **ID Fill Rate** | 100% | Calculated via `donor_id_null_rate_pct` |
| **Largest Gift** | $65,080,456.96 | Identified via `ORDER BY / LIMIT 1` |
| **Top Donor Name** | Janet Young (ID: 1002441) | Verified via `JOIN` on `Donor_ID` |
| **Data Freshness** | 1990-01-01 to 2025-10-22
 | Verified via `MIN/MAX(Gift_Date)` |

2. Financial Distribution
Smallest Gift: $0.0
Largest Gift: $$65,080,456.96 (ID: 947272) --amount need verification
Average Gift: $6774.45
Unique Price Points: 709,595 distinct gift amounts identified.

4. Key Constraints: 
- Verified relationship between donors.id and giving.Donor_ID
- Outliers: Identified the top donor for high-value engagement targeting.


## 🚀 Getting Started
To replicate this environment:

Clone the repo: git clone https://github.com/lisa-villanueva/advancement-ledger-sql-governance.git

Data Setup: CSV files are excluded via .gitignore for security. See above for link to dataset.

Run Sequence: Refer to /sql/00_run_order/RUN_SEQUENCE.md for the execution path.

## 📈 Key Insights & Queries: TBD


## 🛠️ Technical Toolkit
Language: SQL (ANSI Standard)

Version Control: Git/GitHub

Documentation: Markdown

Tools: VS Code, DB Browser for SQLite

## 🧑‍💻 Author
Lisa Villanueva
https://www.linkedin.com/in/villanueva-camarata/
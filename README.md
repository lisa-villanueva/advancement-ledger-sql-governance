🎓 School Advancement SQL Governance Ledger
📌 Project Overview
This project establishes a robust SQL-based infrastructure for managing 500k donor records and 3.8M transactions, focusing on data integrity and gift accounting standards.

🏗️ Data Architecture & Infrastructure
The foundational data for this project is a synthetic high-volume dataset designed for fundraising analytics.
Dataset: Synthetic Donor Dataset for Fundraising Analytics
Author: dbrown86 (via Kaggle)
Scale: 500,000 Donor Profiles | 3.8M Transactions

Usage Note: To maintain repository performance and adhere to GitHub file size limits, the raw source files (.csv, .db) are excluded from this repository.

This repo demonstrates a modular, scalable approach to SQL database management and data governance.
Key Folders:
/sql: Contains production-grade scripts for initial schema configuration, data profiling, and automated integrity audits.

/automation: Currently houses the AI Agent Specifications used to build Socratic tutors that guided the architectural development of this project. Future Roadmap: This directory will evolve into a full automation suite for the donor ledger system and end-to-end project orchestration.

🛡️ Data Governance & Integrity
Duplicate Detection: Description to follow. Used 01_duplicate_column_handling.sql script

Schema Enforcement: TBD

🚀 Getting Started
To replicate this environment:

Clone the repo: git clone https://github.com/lisa-villanueva/advancement-ledger-sql-governance.git

Data Setup: CSV files are excluded via .gitignore for security. See above for link to dataset.

Run Sequence: Refer to /sql/00_run_order/RUN_SEQUENCE.md for the execution path.

📈 Key Insights & Queries: TBD


🛠️ Technical Toolkit
Language: SQL (ANSI Standard)

Version Control: Git/GitHub

Documentation: Markdown

Tools: VS Code, DB Browser for SQLite

🧑‍💻 Author
Lisa Villanueva
https://www.linkedin.com/in/villanueva-camarata/
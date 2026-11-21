# AI Usage Log (Part E1)

| # | AI tool & version | What I asked | Where used | What I changed / verified |
|---|---|---|---|---|
| 1 | Claude (Opus 5.5) | Break down the assignment brief and give a step-by-step plan | Planning (all parts) | Checked each requirement against the brief myself |
| 2 | Claude (Opus 5.5) | Terminal commands to set up the project folder, venv and GitHub repo (Windows PowerShell, then macOS zsh) | Setup | Ran and checked each command myself |
| 3 | Claude (Opus 5.5) | Worked solutions for C1-C3 (ID3) and D1-D2 (Apriori), compiled into a PDF | Parts C and D | Re-did every calculation by hand and compared; noted rounding differences in two weighted-entropy sums |
| 4 | Claude (Opus 5.5) | Practice write-up for Part A (requirements, sources, star schema, ETL, PDPA), diagrams and SQL DDL | Part A | DDL tested on PostgreSQL; to redraw the star schema myself and rewrite text in my own words |
| 5 | Claude (Opus 5.5) | Python code to generate the KlinikSihat dataset (ground_truth.csv) and inject data-quality problems (raw.csv) | Part B1 | Ran the notebook; checked row counts, missing %, duplicates and out-of-range counts against the brief |
| 6 | Claude (Opus 5.5) | Python code to profile raw.csv: summary statistics, missing-value matrix and heatmap, charts, and chi-square / Mann-Whitney tests to classify missingness | Part B2 | Ran the notebook; checked the test results and MCAR/MAR reasoning against the lecture notes |
| 7 | Claude (Opus 5.5) | Python code to clean raw.csv (duplicates, formats, out-of-range values), build the data quality log, impute with median / KNN / MICE and compare RMSE against the ground truth | Parts B3 and B4 | Ran the notebook; checked every fix against ground_truth.csv and the RMSE comparison; chose MICE based on the results |
| 8 | Claude (Opus 5.5) | Python code for Part C: ID3 from scratch to check C1-C3, scikit-learn tree on the loan data with explanation of CART vs ID3 (C4), and the no-show decision tree with depth analysis, metrics and confusion matrix (C5) | Part C | Compared the ID3 output with my hand calculations; ran the notebook; checked the depth curve and metrics; understood why class_weight="balanced" was used |
| 9 | Claude (Opus 5.5) | Python code for D3: mlxtend apriori and association_rules, automatic comparison with my D1-D2 hand results, chart of confidence vs lift, and interpretation of rules | Part D3 | Ran the notebook; confirmed mlxtend matches my hand tables; rewrote business actions in my own words |

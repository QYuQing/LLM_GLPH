# LLM–Guided Label Propagation with Hypergraph for Drug Repurposing
## Running the Code

MATLAB R2017b or later is required.

Each entry script performs 10 runs of 10-fold cross-validation and reports AUPR and AUC on a scale of 0–1. Random seeds range from 2025 to 2034. The original random number generation interface and computational procedure are retained. The final standard deviation is calculated across the mean scores of the 10 runs.

## Correction to Table 2

The corrected values for Table 2 in the published paper are provided below:
| Methods | LRSSL AUPR (%) | LRSSL AUC (%) | C AUPR (%) | C AUC (%) | F AUPR (%) | F AUC (%) |
| --- | --- | --- | --- | --- | --- | --- |
| SCPMF | 3 | 77 | 7 | 74 | 6 | 71 |
| DRWBNCF | 5 | 76 | 23 | 82 | 21 | 81 |
| CDPMF | <u>30</u> | 84 | 33 | 87 | <u>31</u> | <u>87</u> |
| AutoDR | 23 | <u>89</u> | <u>40</u> | <u>89</u> | 29 | 86 |
| DRHGCN | 6 | 85 | 20 | 83 | 11 | 79 |
| HCCF | 1 | 55 | 23 | 82 | 21 | 81 |
| HDGAT | 14 | 75 | 16 | 74 | 12 | 73 |
| DRGBCN | 1 | 56 | 1 | 49 | 1 | 53 |
| Our | **50** | **94** | **51** | **95** | **50** | **94** |

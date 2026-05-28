# Air Quality in Peace & War
### Parma, Italy vs Kyiv, Ukraine — October 2023
**Statistical Modeling Project · University of Parma · 2026**

---

## Project Overview

This project compares particulate air quality (PM2.5 and PM10) between a peaceful city (Parma, Italy) and a city under active war (Kyiv, Ukraine) during a Russian missile attack on October 27, 2023.

We collected 3,600 sensor readings from each city and applied K-Means clustering and linear regression in MATLAB to analyse the difference.

**Key result:** K-Means clustering — given zero context, no labels, no dates — isolated the October 27th missile attack as its own cluster. PM2.5 peak reached 818.85 µg/m³, which is 54× the WHO daily safe limit.

---

## Team

| Name | Role |
|------|------|
| Simran Vishnoi | Data analysis, MATLAB code, presentation |
| Abeer AbuNemer | Data collection, research |
| Emelian Chkaira | Data collection, research |
| Ahmed Elmenyawe | Data collection, research |

**Supervisor:** Prof. Andrea Cilloni · University of Parma

---

## Repository Structure

```
air-quality-peace-war/
│
├── data/
│   ├── parma_collected.mat       # Parma sensor readings (Raspberry Pi + SDS011)
│   ├── kyiv_real.mat             # Kyiv SaveEcoBot station #1651 (Oct 25–31 2023)
│   ├── parma_collected.csv       # Same Parma data in CSV format
│   └── kyiv_real.csv             # Same Kyiv data in CSV format
│
├── code/
│   └── air_quality_analysis.m    # Main MATLAB script (all analysis in one file)
│
├── figures/                      # All MATLAB output charts (PNG)
│   ├── 01_time_series.png
│   ├── 02_elbow_method.png
│   ├── 03_kmeans_clustering.png
│   └── 04_regression_parma.png
│
├── presentation/
│   └── AirQuality_PeaceAndWar.pptx
│
└── README.md
```

---

## Data Sources

| Dataset | Source | Licence |
|---------|--------|---------|
| Parma | Raspberry Pi + SDS011 sensor, collected in Parma parks and bar area | Own data |
| Kyiv | SaveEcoBot open sensor network, station #1651 | CC BY 4.0 |

**Kyiv window extracted:** Oct 25–31, 2023 (3,600 consecutive readings from 2.8M row original file)

---

## How to Run

1. Clone this repository
2. Open MATLAB and navigate to the `code/` folder
3. Make sure the `data/` folder is in your MATLAB path
4. Run `air_quality_analysis.m`

All four figures will generate automatically.

**Requirements:** MATLAB with Statistics and Machine Learning Toolbox

---

## Methods

| Step | Method | MATLAB Function |
|------|--------|-----------------|
| Normalisation | Z-score standardisation | `zscore()` |
| Optimal K selection | Elbow Method (K = 1 to 6) | `kmeans()` |
| Clustering | K-Means, K=3, 30 replicates | `kmeans()` |
| Centroid verification | Group statistics assert check | `grpstats()`, `assert()` |
| Regression | Linear model PM10 ~ PM2.5 | `fitlm()`, `predict()` |

---

## Key Results

| Metric | Parma | Kyiv |
|--------|-------|------|
| PM2.5 Mean (µg/m³) | 5.30 | 10.61 |
| PM2.5 Peak (µg/m³) | 26.2 | **818.85** |
| PM2.5 Std Dev | 4.46 | **33.73** |
| PM10 Mean (µg/m³) | 47.0 | 23.4 |
| WHO PM2.5 Exceedance | 4.7% | 17.2% |
| WHO PM10 Exceedance | **35.8%** | — |

**Regression (Parma only):** PM10 = 3.21 + 7.89 × PM2.5 · R² = 0.45 · p < 0.001

---

## References

1. SaveEcoBot Platform — saveecobot.com · CC BY 4.0
2. Katrenko et al. (2025) — Wartime Air Pollution Kyiv · *Cities* 9(11):477
3. WHO Air Quality Guidelines 2021 — PM2.5: 15 µg/m³, PM10: 45 µg/m³ (24-hr mean)
4. MathWorks MATLAB — Statistics & Machine Learning Toolbox
5. Abulibdeh et al. (2025) — Air pollution in Gaza post-Oct 7 · *Global Environmental Change*, 91, 102975

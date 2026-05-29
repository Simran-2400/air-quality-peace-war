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

- Simran Vishnoi
- Abeer AbuNemer
- Emelian Chkaira
- Ahmed Elmenyawe

---

## Repository Structure

```
air-quality-peace-war/
├── data/
│   ├── parma_collected.mat
│   ├── kyiv_real.mat
│   ├── parma_collected.csv
│   └── kyiv_real.csv
├── code/
│   └── air_quality_analysis.m
├── presentation/
│   └── AirQuality_PeaceAndWar.pptx
└── README.md
```

---

## How to Run

1. Clone this repository
2. Open MATLAB and navigate to the `code/` folder
3. Make sure the `data/` folder is in your MATLAB path
4. Run `air_quality_analysis.m`

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
| PM2.5 Peak (µg/m³) | 26.2 | 818.85 |
| PM2.5 Std Dev | 4.46 | 33.73 |
| PM10 Mean (µg/m³) | 47.0 | 23.4 |
| WHO PM2.5 Exceedance | 4.7% | 17.2% |

**Regression (Parma only):** PM10 = 3.21 + 7.89 × PM2.5 · R² = 0.45 · p < 0.001

---

## Data Sources

| Dataset | Source | Licence |
|---------|--------|---------|
| Parma | Raspberry Pi + SDS011 sensor | Own data |
| Kyiv | SaveEcoBot station #1651 | CC BY 4.0 |

---

## References

1. SaveEcoBot Platform — saveecobot.com · CC BY 4.0
2. Katrenko et al. (2025) — Wartime Air Pollution Kyiv · Cities 9(11):477
3. WHO Air Quality Guidelines 2021
4. Abulibdeh et al. (2025) — Global Environmental Change, 91, 102975

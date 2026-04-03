# rurality (Stata)

Rurality classification and scoring for U.S. counties in Stata.

Merges USDA Rural-Urban Continuum Codes (RUCC 2023) and a composite rurality score onto any dataset by county FIPS code. No more manually downloading and reshaping USDA spreadsheets.

**R package:** [github.com/cwimpy/rurality](https://github.com/cwimpy/rurality)
**Web app:** [rurality.app](https://rurality.app)

## Install

```stata
net install rurality, from("https://raw.githubusercontent.com/cwimpy/rurality-stata/main/")
rurality_install
```

The first command installs the program files. The second downloads the data file (~200KB).

## Usage

```stata
* Basic: adds rurality_score, rurality_class, rurality_rucc
rurality, fips(county_fips)

* Custom variable prefix
rurality, fips(fips_code) generate(rural)

* Add all available variables (density, metro distance, income, age, etc.)
rurality, fips(county_fips) all

* Tabulate results
tab rurality_class
sum rurality_score, detail

* Use in regression
reg outcome rurality_score i.rurality_rucc, robust
```

## Variables Added

By default, three variables are merged:

| Variable | Description |
|---|---|
| `rurality_score` | Composite score (0-100) |
| `rurality_class` | Urban, Suburban, Mixed, Rural, Very Rural |
| `rurality_rucc` | USDA RUCC 2023 (1-9) |

With the `all` option, additional variables include:

| Variable | Description |
|---|---|
| `pop_density` | Population per square mile |
| `land_area_sqmi` | County land area |
| `dist_large_metro` | Distance to nearest large metro (miles) |
| `dist_medium_metro` | Distance to nearest medium metro (miles) |
| `dist_small_metro` | Distance to nearest small metro (miles) |
| `rucc_score` | RUCC score component (0-100) |
| `density_score` | Density score component (0-100) |
| `distance_score` | Distance score component (0-100) |
| `median_income` | ACS 2022 median household income |
| `median_age` | ACS 2022 median age |

## FIPS Codes

The command accepts both numeric and string FIPS variables. Numeric values are automatically zero-padded to 5 digits. If your data has separate state and county FIPS codes, combine them first:

```stata
* From separate state/county codes
gen fips = string(state_fips, "%02.0f") + string(county_fips, "%03.0f")
rurality, fips(fips)
```

## Methodology

The composite rurality score is a weighted average of three components:

| Component | Weight | Source |
|---|---|---|
| RUCC score | 55% | USDA Economic Research Service, 2023 |
| Population density | 28% | Census ACS 2022 5-year estimates |
| Distance to metro | 17% | Haversine distance to nearest metro area |

Scores range from 0 (most urban) to 100 (most rural). See [rurality.app](https://rurality.app) for the full methodology.

## Update Data

To update to the latest data release:

```stata
rurality_install, replace
```

## Citation

If you use this package in published research, please cite:

```
Wimpy, Cameron (2026). rurality: Rurality Classification and Scoring
  for U.S. Counties. Stata package version 0.1.0.
  https://github.com/cwimpy/rurality-stata
```

## Data Sources

- [USDA ERS Rural-Urban Continuum Codes, 2023](https://www.ers.usda.gov/data-products/rural-urban-continuum-codes/)
- [U.S. Census Bureau, American Community Survey 2022 5-Year Estimates](https://www.census.gov/programs-surveys/acs)
- [U.S. Census Bureau, TIGER/Line Shapefiles 2020](https://www.census.gov/geographies/mapping-files/time-series/geo/tiger-line-file.html)

## Author

Cameron Wimpy
Arkansas State University
cwimpy@astate.edu

## License

MIT

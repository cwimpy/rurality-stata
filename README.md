# rurality (Stata)

Rurality classification and scoring for U.S. counties and ZIP codes in Stata.

Merges USDA Rural-Urban Continuum Codes (RUCC 2023), a composite rurality score, and USDA Rural-Urban Commuting Area (RUCA 2020) codes onto any dataset by county FIPS or ZIP code. No more manually downloading and reshaping USDA spreadsheets.

**R package:** [github.com/cwimpy/rurality](https://github.com/cwimpy/rurality)
**Web app:** [rurality.app](https://rurality.app)

## Install

```stata
net install rurality, from("https://raw.githubusercontent.com/cwimpy/rurality-stata/main/")
rurality_install
```

The first command installs the program files. The second downloads the county and RUCA data files (~1.5 MB total).

## Usage

### County lookup (FIPS)

```stata
* Default: adds rurality_score, rurality_class, rurality_rucc
rurality, fips(county_fips)

* Custom variable prefix
rurality, fips(fips_code) generate(rural)

* All available variables (density, metro distance, income, age, etc.)
rurality, fips(county_fips) all

tab rurality_class
reg outcome rurality_score i.rurality_rucc, robust
```

### ZIP / RUCA lookup

```stata
* Adds ruca_primary, ruca_secondary, ruca_state
rurality, zip(zip5)

* Custom prefix
rurality, zip(zip5) generate(rural)
```

### Classify a score

```stata
* Convert a 0-100 score to Urban/Suburban/Mixed/Rural/Very Rural
rurality_classify rurality_score, generate(class)
```

## Variables Added

**County (default):**

| Variable | Description |
|---|---|
| `rurality_score` | Composite score (0-100) |
| `rurality_class` | Urban, Suburban, Mixed, Rural, Very Rural |
| `rurality_rucc` | USDA RUCC 2023 (1-9) |

**County (`all` option) also adds:** population density, land area, metro distances, component scores, median income, median age, state abbreviation, county name, lat/lng, etc.

**ZIP (RUCA):**

| Variable | Description |
|---|---|
| `ruca_primary` | USDA primary RUCA 2020 code (1-10) |
| `ruca_secondary` | USDA secondary RUCA 2020 code |
| `ruca_state` | State abbreviation |

## FIPS Codes

Both numeric and string FIPS variables are accepted. Numeric values are automatically zero-padded to 5 digits. If your data has separate state and county FIPS codes, combine them first:

```stata
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

Scores range from 0 (most urban) to 100 (most rural). The metro distance component uses the full USDA-defined metro list (52 large / 57 medium / 36 small) to avoid misclassifying urban cores outside the national top tier. See [rurality.app](https://rurality.app) for the full methodology.

## Update Data

```stata
rurality_install, replace
```

## Version History

- **0.1.1** — Rebuilt data with full metro list (fixes Denver, Hennepin, Multnomah, Mecklenburg, and similar urban cores previously mis-classified as Suburban). Added `zip()` option for RUCA lookup and `rurality_classify` helper.
- **0.1.0** — Initial release.

## Citation

```
Wimpy, Cameron (2026). rurality: Rurality Classification and Scoring
  for U.S. Counties and ZIP Codes. Stata package version 0.1.1.
  https://github.com/cwimpy/rurality-stata
```

## Data Sources

- [USDA ERS Rural-Urban Continuum Codes, 2023](https://www.ers.usda.gov/data-products/rural-urban-continuum-codes/)
- [USDA ERS Rural-Urban Commuting Area Codes, 2020](https://www.ers.usda.gov/data-products/rural-urban-commuting-area-codes/)
- [U.S. Census Bureau, American Community Survey 2022 5-Year Estimates](https://www.census.gov/programs-surveys/acs)
- [U.S. Census Bureau, TIGER/Line Shapefiles 2020](https://www.census.gov/geographies/mapping-files/time-series/geo/tiger-line-file.html)

## Author

Cameron Wimpy
Arkansas State University
cwimpy@astate.edu

## License

MIT

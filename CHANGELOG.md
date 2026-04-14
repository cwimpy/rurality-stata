# Changelog

## 0.1.1 — 2026-04-14

### Data

- Rebuilt `rurality_data.dta` using the full USDA metro list (52 large /
  57 medium / 36 small). Previous versions used an incomplete top-tier
  list that caused major urban cores outside the top 15 — Denver,
  Hennepin (MN), Multnomah (OR), Mecklenburg (NC), Marion (IN),
  Cuyahoga (OH), and others — to be mis-classified as Suburban.
- Added `ruca_data.dta` (USDA Rural-Urban Commuting Area codes 2020
  for 41,146 ZIP code tabulation areas).

### Features

- `rurality` now accepts `zip(varname)` as an alternative to
  `fips(varname)` for RUCA/ZCTA lookup. Adds `ruca_primary`,
  `ruca_secondary`, and `ruca_state`.
- New `rurality_classify` command converts a numeric rurality score
  (0-100) to an ordered classification string (Urban, Suburban, Mixed,
  Rural, Very Rural).

### Internals

- Merge no longer clobbers user variables that share names with merged
  columns (e.g., `county_fips`). Using-data variables are namespaced
  with `_rdat_` prefix during merge.
- `rurality_install` now fetches both `rurality_data.dta` and
  `ruca_data.dta`.

## 0.1.0 — 2026-04-03

Initial release.

- `rurality, fips(varname)` merges composite rurality score, rurality
  classification, and USDA Rural-Urban Continuum Code (2023) by county
  FIPS.
- `rurality_install` downloads the county data file.

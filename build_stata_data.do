* build_stata_data.do
* Convert county_rurality.csv to Stata .dta format
* Run this after building the CSV from the R package

import delimited using "../rurality/data-raw/county_rurality.csv", clear

* Ensure string FIPS
tostring fips, replace format(%05.0f)
tostring state_fips, replace format(%02.0f)
tostring county_fips, replace format(%03.0f)

* Labels
label variable fips "5-digit county FIPS code"
label variable state_fips "2-digit state FIPS code"
label variable county_fips "3-digit county FIPS code"
label variable state_abbr "State abbreviation"
label variable county_name "County name"
label variable pop_2020 "2020 Census population"
label variable acs_pop "ACS 2022 population estimate"
label variable land_area_sqmi "Land area (sq miles)"
label variable pop_density "Population per sq mile"
label variable rucc_2023 "USDA RUCC 2023 (1-9)"
label variable rucc_description "RUCC description"
label variable omb_designation "OMB metro designation"
label variable lat "County centroid latitude"
label variable lng "County centroid longitude"
label variable dist_large_metro "Distance to nearest large metro (mi)"
label variable dist_medium_metro "Distance to nearest medium metro (mi)"
label variable dist_small_metro "Distance to nearest small metro (mi)"
label variable rucc_score "RUCC score component (0-100)"
label variable density_score "Density score component (0-100)"
label variable distance_score "Distance score component (0-100)"
label variable rurality_score "Composite rurality score (0-100)"
label variable rurality_classification "Rurality classification"
label variable median_income "ACS 2022 median household income"
label variable median_age "ACS 2022 median age"

label data "U.S. County Rurality Data v0.1.0 — rurality.app"

compress
sort fips

save "data/rurality_data.dta", replace

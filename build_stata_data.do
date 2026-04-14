* build_stata_data.do
* Convert county_rurality.csv and ruca2020_zcta.csv to Stata .dta format
* Run this after building the CSVs from the R rurality package.

*------------------------------------------------------------------*
* 1. County rurality data
*------------------------------------------------------------------*
import delimited using "../rurality/data-raw/county_rurality.csv", ///
    varnames(1) stringcols(1 2 3) clear

* Ensure 5-digit zero-padded FIPS
capture confirm string variable fips
if _rc {
    tostring fips, replace format(%05.0f)
}
capture confirm string variable state_fips
if _rc {
    tostring state_fips, replace format(%02.0f)
}
capture confirm string variable county_fips
if _rc {
    tostring county_fips, replace format(%03.0f)
}

* Force numerics (integer-valued columns may be read as string)
foreach v in pop_2020 acs_pop land_area_sqmi pop_density rucc_2023 ///
    lat lng dist_large_metro dist_medium_metro dist_small_metro ///
    rucc_score density_score distance_score rurality_score ///
    median_income median_age {
    capture confirm string variable `v'
    if !_rc {
        destring `v', replace force
    }
}

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

label data "U.S. County Rurality Data v0.1.1 — rurality.app"

compress
sort fips
save "data/rurality_data.dta", replace

*------------------------------------------------------------------*
* 2. RUCA (ZCTA) data
*------------------------------------------------------------------*
import delimited using "../rurality/data-raw/ruca2020_zcta.csv", ///
    varnames(1) stringcols(1 2 3 4) clear

* Raw schema: ZIPCode, State, ZIPCodeType, POName, PrimaryRUCA, SecondaryRUCA
rename zipcode zip
rename state state
rename primaryruca primary_ruca
rename secondaryruca secondary_ruca

capture confirm string variable zip
if _rc {
    tostring zip, replace format(%05.0f)
}
* zero-pad to 5
replace zip = substr("00000", 1, 5 - length(zip)) + zip if length(zip) < 5

destring primary_ruca, replace force
destring secondary_ruca, replace force

keep zip state primary_ruca secondary_ruca
order zip state primary_ruca secondary_ruca

label variable zip "5-digit ZIP/ZCTA code"
label variable state "State abbreviation"
label variable primary_ruca "USDA primary RUCA code (2020)"
label variable secondary_ruca "USDA secondary RUCA code (2020)"

label data "U.S. ZCTA RUCA Codes 2020 — rurality.app"

compress
sort zip
save "data/ruca_data.dta", replace

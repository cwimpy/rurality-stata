*! rurality.ado — Look up rurality scores and RUCC codes for U.S. counties
*! Version 0.1.1 | Cameron Wimpy | 2026
*! https://rurality.app

program define rurality
    version 16.0
    syntax , fips(varname) [GENerate(string) ALL]

    * Default generate prefix
    if "`generate'" == "" local generate "rurality"

    * Find the data file
    capture findfile rurality_data.dta
    if _rc {
        di as error "rurality_data.dta not found."
        di as error "Run {cmd:rurality_install} first to download the data."
        exit 601
    }
    local datapath = r(fn)

    * Create a clean 5-digit string merge key
    quietly {
        capture confirm string variable `fips'
        if _rc {
            * Numeric FIPS
            gen _rmerge_key = string(`fips', "%05.0f")
        }
        else {
            * String FIPS — ensure zero-padded
            gen _rmerge_key = cond(length(`fips') < 5, ///
                substr("00000", 1, 5 - length(`fips')) + `fips', `fips')
        }
    }

    * Load rurality data into a tempfile with matching merge key
    preserve
    quietly {
        use "`datapath'", clear
        rename fips _rmerge_key
        tempfile _rdata
        save `_rdata', replace
    }
    restore

    * Merge
    quietly merge m:1 _rmerge_key using `_rdata', keep(master match) nogenerate

    * Clean up merge key
    quietly drop _rmerge_key

    * Count matches
    quietly count if rurality_score != .
    local nmatched = r(N)

    * Rename merged variables with user prefix
    if "`all'" == "" {
        * Default: just score, classification, and RUCC
        capture rename rurality_score `generate'_score
        capture rename rurality_classification `generate'_class
        capture rename rucc_2023 `generate'_rucc

        * Drop other merged vars we don't need
        capture drop rucc_description omb_designation rucc_score density_score distance_score
        capture drop pop_density land_area_sqmi dist_large_metro dist_medium_metro dist_small_metro
        capture drop state_abbr county_name pop_2020 acs_pop lat lng median_income median_age
        capture drop state_fips county_fips
    }
    else {
        * Rename all with prefix
        foreach v in rurality_score rurality_classification rucc_2023 ///
            rucc_description omb_designation pop_density rucc_score density_score ///
            distance_score dist_large_metro dist_medium_metro dist_small_metro ///
            state_abbr county_name pop_2020 acs_pop lat lng median_income median_age ///
            land_area_sqmi state_fips county_fips {
            capture rename `v' `generate'_`v'
        }
    }

    di as text "Rurality data merged successfully."
    di as text "  Matched: " as result `nmatched' as text " of " as result _N as text " observations"
end

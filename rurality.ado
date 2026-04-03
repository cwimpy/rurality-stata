*! rurality.ado — Look up rurality scores and RUCC codes for U.S. counties
*! Version 0.1.0 | Cameron Wimpy | 2026
*! https://rurality.app

program define rurality
    version 16.0
    syntax , fips(varname) [GENerate(string) ALL Replace]

    * Default generate prefix
    if "`generate'" == "" local generate "rurality"

    * Check if FIPS variable exists
    confirm variable `fips'

    * Preserve original data
    tempfile original
    save `original', replace

    * Load rurality data
    tempfile rurality_data
    capture findfile rurality_data.dta
    if _rc {
        di as error "rurality_data.dta not found."
        di as error "Run {cmd:rurality_install} first to download the data."
        exit 601
    }
    local datapath = r(fn)

    * Save current dataset
    tempfile working
    quietly save `working', replace

    * Prepare FIPS for merging — ensure 5-digit string
    quietly {
        capture confirm string variable `fips'
        if _rc {
            * Numeric FIPS — convert to string
            tostring `fips', gen(_rurality_fips_str) format(%05.0f)
        }
        else {
            * String FIPS — zero-pad
            gen _rurality_fips_str = string(real(`fips'), "%05.0f")
            replace _rurality_fips_str = `fips' if real(`fips') == .
        }
    }

    * Merge
    quietly {
        rename _rurality_fips_str fips
        merge m:1 fips using "`datapath'", keep(master match) nogenerate
        rename fips _rurality_fips_str
        drop _rurality_fips_str
    }

    * Rename merged variables with user prefix
    if "`all'" == "" {
        * Default: just score, classification, and RUCC
        capture rename rurality_score `generate'_score
        capture rename rurality_classification `generate'_class
        capture rename rucc_2023 `generate'_rucc

        * Drop other merged vars
        capture drop rucc_description omb_designation rucc_score density_score distance_score
        capture drop pop_density land_area_sqmi dist_large_metro dist_medium_metro dist_small_metro
        capture drop state_abbr county_name pop_2020 acs_pop lat lng median_income median_age
        capture drop state_fips county_fips
    }
    else {
        * Rename all with prefix
        foreach v of varlist rurality_score rurality_classification rucc_2023 ///
            rucc_description omb_designation pop_density rucc_score density_score ///
            distance_score {
            capture rename `v' `generate'_`v'
        }
    }

    di as text "Rurality data merged successfully."
    di as text "  Matched: " as result r(N_merge) as text " observations"
end

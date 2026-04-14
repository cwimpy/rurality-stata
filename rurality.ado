*! rurality.ado — Look up rurality scores, RUCC codes, and RUCA codes
*! Version 0.1.1 | Cameron Wimpy | 2026
*! https://rurality.app

program define rurality
    version 16.0
    syntax , [fips(varname) zip(varname) GENerate(string) ALL]

    if ("`fips'" == "" & "`zip'" == "") | ("`fips'" != "" & "`zip'" != "") {
        di as error "specify exactly one of {bf:fips()} or {bf:zip()}"
        exit 198
    }

    if "`zip'" != "" {
        _rurality_ruca, zip(`zip') generate(`generate')
        exit
    }

    * ---------- County / FIPS lookup ----------
    if "`generate'" == "" local generate "rurality"

    capture findfile rurality_data.dta
    if _rc {
        di as error "rurality_data.dta not found."
        di as error "Run {cmd:rurality_install} first to download the data."
        exit 601
    }
    local datapath = r(fn)

    quietly {
        capture confirm string variable `fips'
        if _rc {
            gen _rmerge_key = string(`fips', "%05.0f")
        }
        else {
            gen _rmerge_key = cond(length(`fips') < 5, ///
                substr("00000", 1, 5 - length(`fips')) + `fips', `fips')
        }
    }

    * Build a namespaced tempfile so merge never clobbers user's vars
    preserve
    quietly {
        use "`datapath'", clear
        rename fips _rmerge_key
        foreach v of varlist _all {
            if "`v'" != "_rmerge_key" {
                rename `v' _rdat_`v'
            }
        }
        tempfile _rdata
        save `_rdata', replace
    }
    restore

    quietly merge m:1 _rmerge_key using `_rdata', keep(master match) nogenerate
    quietly drop _rmerge_key

    quietly count if _rdat_rurality_score != .
    local nmatched = r(N)

    local _allvars "rurality_score rurality_classification rucc_2023 rucc_description omb_designation pop_density rucc_score density_score distance_score dist_large_metro dist_medium_metro dist_small_metro state_abbr county_name pop_2020 acs_pop lat lng median_income median_age land_area_sqmi state_fips county_fips"

    if "`all'" == "" {
        capture rename _rdat_rurality_score `generate'_score
        capture rename _rdat_rurality_classification `generate'_class
        capture rename _rdat_rucc_2023 `generate'_rucc
        foreach v of local _allvars {
            capture drop _rdat_`v'
        }
    }
    else {
        foreach v of local _allvars {
            capture rename _rdat_`v' `generate'_`v'
        }
    }

    di as text "Rurality data merged successfully."
    di as text "  Matched: " as result `nmatched' as text " of " as result _N as text " observations"
end

program define _rurality_ruca
    syntax , zip(varname) [GENerate(string)]

    if "`generate'" == "" local generate "ruca"

    capture findfile ruca_data.dta
    if _rc {
        di as error "ruca_data.dta not found."
        di as error "Run {cmd:rurality_install} first to download the data."
        exit 601
    }
    local datapath = r(fn)

    quietly {
        capture confirm string variable `zip'
        if _rc {
            gen _rmerge_key = string(`zip', "%05.0f")
        }
        else {
            gen _rmerge_key = cond(length(`zip') < 5, ///
                substr("00000", 1, 5 - length(`zip')) + `zip', `zip')
        }
    }

    preserve
    quietly {
        use "`datapath'", clear
        rename zip _rmerge_key
        foreach v of varlist _all {
            if "`v'" != "_rmerge_key" {
                rename `v' _rdat_`v'
            }
        }
        tempfile _rdata
        save `_rdata', replace
    }
    restore

    quietly merge m:1 _rmerge_key using `_rdata', keep(master match) nogenerate
    quietly drop _rmerge_key

    quietly count if _rdat_primary_ruca != .
    local nmatched = r(N)

    capture rename _rdat_primary_ruca `generate'_primary
    capture rename _rdat_secondary_ruca `generate'_secondary
    capture rename _rdat_state `generate'_state

    di as text "RUCA data merged successfully."
    di as text "  Matched: " as result `nmatched' as text " of " as result _N as text " observations"
end

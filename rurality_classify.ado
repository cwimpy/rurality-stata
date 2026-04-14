*! rurality_classify.ado — Classify a rurality score into ordered categories
*! Version 0.1.1 | Cameron Wimpy | 2026

program define rurality_classify
    version 16.0
    syntax varname(numeric) , GENerate(name) [Replace]

    if "`replace'" != "" {
        capture drop `generate'
    }

    gen str12 `generate' = ""
    quietly {
        replace `generate' = "Very Rural" if `varlist' >= 80 & `varlist' != .
        replace `generate' = "Rural"      if `varlist' >= 60 & `varlist' < 80
        replace `generate' = "Mixed"      if `varlist' >= 40 & `varlist' < 60
        replace `generate' = "Suburban"   if `varlist' >= 20 & `varlist' < 40
        replace `generate' = "Urban"      if `varlist' <  20 & `varlist' != .
    }

    label variable `generate' "Rurality classification"
end

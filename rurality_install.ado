*! rurality_install.ado — Download rurality data files
*! Version 0.1.1 | Cameron Wimpy | 2026

program define rurality_install
    version 16.0
    syntax [, Replace]

    local installdir : sysdir PLUS
    local dstdir "`installdir'r"
    capture mkdir "`dstdir'"

    local files "rurality_data.dta ruca_data.dta"
    local base "https://github.com/cwimpy/rurality-stata/raw/main/data"

    foreach f of local files {
        local dst "`dstdir'/`f'"
        if "`replace'" == "" {
            capture confirm file "`dst'"
            if !_rc {
                di as text "`f' already installed at `dst'"
                continue
            }
        }
        di as text "Downloading `f'..."
        capture copy "`base'/`f'" "`dst'", replace
        if _rc {
            di as error "Failed to download `f' from `base'"
            exit 601
        }
    }

    di as text "Rurality data files installed in `dstdir'"
    di as text "Use {cmd:rurality, fips(varname)} for counties"
    di as text "Use {cmd:rurality, zip(varname)} for ZIP/RUCA codes"
end

*! rurality_install.ado — Download rurality data for use with rurality command
*! Version 0.1.0 | Cameron Wimpy | 2026

program define rurality_install
    version 16.0
    syntax [, Replace]

    * Determine install location
    local installdir : sysdir PLUS
    local datafile "`installdir'r/rurality_data.dta"

    if "`replace'" == "" {
        capture confirm file "`datafile'"
        if !_rc {
            di as text "Rurality data already installed at:"
            di as text "  `datafile'"
            di as text "Use {cmd:rurality_install, replace} to update."
            exit 0
        }
    }

    * Download from GitHub release
    di as text "Downloading rurality data..."
    local url "https://github.com/cwimpy/rurality-stata/raw/main/data/rurality_data.dta"

    capture mkdir "`installdir'r"
    copy "`url'" "`datafile'", replace

    di as text "Rurality data installed successfully."
    di as text "  Location: `datafile'"
    di as text "  Use {cmd:rurality, fips(varname)} to merge onto your data."
end

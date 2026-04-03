{smcl}
{* *! version 0.1.0  Cameron Wimpy  2026}{...}
{viewerjumpto "Syntax" "rurality##syntax"}{...}
{viewerjumpto "Description" "rurality##description"}{...}
{viewerjumpto "Options" "rurality##options"}{...}
{viewerjumpto "Examples" "rurality##examples"}{...}
{viewerjumpto "Author" "rurality##author"}{...}
{title:Title}

{phang}
{bf:rurality} {hline 2} Merge rurality scores and USDA Rural-Urban Continuum Codes onto data by county FIPS code

{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmdab:rurality}
{cmd:,}
{opt fips(varname)}
[{opt gen:erate(string)}
{opt all}
{opt replace}]

{marker description}{...}
{title:Description}

{pstd}
{cmd:rurality} merges county-level rurality data onto the current dataset using
a 5-digit county FIPS code. By default, it adds three variables: a composite
rurality score (0-100), a rurality classification (Urban to Very Rural), and
the USDA Rural-Urban Continuum Code (2023).

{pstd}
The composite score is based on RUCC code (55%), population density (28%),
and distance to the nearest metropolitan area (17%). See {browse "https://rurality.app"}
for full methodology.

{pstd}
Before first use, run {cmd:rurality_install} to download the data file.

{marker options}{...}
{title:Options}

{phang}
{opt fips(varname)} specifies the variable containing 5-digit county FIPS codes.
Both numeric and string FIPS variables are accepted; numeric values are
automatically zero-padded. Required.

{phang}
{opt gen:erate(string)} specifies a prefix for the new variables. Default is
{cmd:rurality}, producing {cmd:rurality_score}, {cmd:rurality_class}, and
{cmd:rurality_rucc}.

{phang}
{opt all} adds all available variables including population density, metro
distances, component scores, median income, and median age.

{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. rurality_install}{p_end}

{pstd}Basic usage{p_end}
{phang2}{cmd:. rurality, fips(county_fips)}{p_end}

{pstd}Add all variables with custom prefix{p_end}
{phang2}{cmd:. rurality, fips(fips_code) generate(rural) all}{p_end}

{pstd}Tabulate results{p_end}
{phang2}{cmd:. tab rurality_class}{p_end}
{phang2}{cmd:. sum rurality_score, detail}{p_end}

{marker author}{...}
{title:Author}

{pstd}
Cameron Wimpy{break}
Arkansas State University{break}
{browse "https://rurality.app"}{break}
cwimpy@astate.edu

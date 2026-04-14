{smcl}
{* *! version 0.1.1  Cameron Wimpy  2026}{...}
{viewerjumpto "Syntax" "rurality##syntax"}{...}
{viewerjumpto "Description" "rurality##description"}{...}
{viewerjumpto "Options" "rurality##options"}{...}
{viewerjumpto "Examples" "rurality##examples"}{...}
{viewerjumpto "Author" "rurality##author"}{...}
{title:Title}

{phang}
{bf:rurality} {hline 2} Merge rurality scores, USDA RUCC codes, and RUCA codes onto data by county FIPS or ZIP code

{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmdab:rurality}
{cmd:,}
{opt fips(varname)}
[{opt gen:erate(string)}
{opt all}]

{p 8 17 2}
{cmdab:rurality}
{cmd:,}
{opt zip(varname)}
[{opt gen:erate(string)}]

{p 8 17 2}
{cmdab:rurality_classify}
{it:scorevar}
{cmd:,}
{opt gen:erate(newvar)}
[{opt r:eplace}]

{marker description}{...}
{title:Description}

{pstd}
{cmd:rurality} merges county-level rurality data onto the current dataset using
a 5-digit county FIPS code, or merges USDA Rural-Urban Commuting Area (RUCA)
codes using a 5-digit ZIP/ZCTA code. Specify exactly one of {opt fips()} or
{opt zip()}.

{pstd}
With {opt fips()}, three variables are added by default: a composite rurality
score (0-100), a rurality classification (Urban to Very Rural), and the USDA
Rural-Urban Continuum Code (2023). The composite score is based on RUCC code
(55%), population density (28%), and distance to the nearest metropolitan area
(17%). See {browse "https://rurality.app"} for full methodology.

{pstd}
With {opt zip()}, the primary and secondary RUCA 2020 codes and the state
abbreviation are added for each ZIP code.

{pstd}
{cmd:rurality_classify} converts a numeric rurality score (0-100) into an
ordered string classification: Urban, Suburban, Mixed, Rural, Very Rural.

{pstd}
Before first use, run {cmd:rurality_install} to download the data files.

{marker options}{...}
{title:Options}

{phang}
{opt fips(varname)} specifies the variable containing 5-digit county FIPS codes.
Both numeric and string FIPS are accepted; numeric values are automatically
zero-padded.

{phang}
{opt zip(varname)} specifies the variable containing 5-digit ZIP or ZCTA codes.
Both numeric and string values are accepted; numeric values are zero-padded.

{phang}
{opt gen:erate(string)} specifies a prefix for the new variables. The default is
{cmd:rurality} (for {opt fips()}) or {cmd:ruca} (for {opt zip()}). With
{opt fips()}, this produces {cmd:rurality_score}, {cmd:rurality_class}, and
{cmd:rurality_rucc} by default.

{phang}
{opt all} (with {opt fips()} only) adds all available variables including
population density, metro distances, component scores, median income, and
median age.

{phang}
{opt replace} (with {cmd:rurality_classify}) replaces {it:newvar} if it exists.

{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. rurality_install}{p_end}

{pstd}County FIPS lookup{p_end}
{phang2}{cmd:. rurality, fips(county_fips)}{p_end}

{pstd}All variables with custom prefix{p_end}
{phang2}{cmd:. rurality, fips(fips_code) generate(rural) all}{p_end}

{pstd}ZIP / RUCA lookup{p_end}
{phang2}{cmd:. rurality, zip(zip5)}{p_end}

{pstd}Classify a score{p_end}
{phang2}{cmd:. rurality_classify rurality_score, generate(class)}{p_end}

{pstd}Tabulate and regress{p_end}
{phang2}{cmd:. tab rurality_class}{p_end}
{phang2}{cmd:. reg outcome rurality_score i.rurality_rucc, robust}{p_end}

{marker author}{...}
{title:Author}

{pstd}
Cameron Wimpy{break}
Arkansas State University{break}
{browse "https://rurality.app"}{break}
cwimpy@astate.edu

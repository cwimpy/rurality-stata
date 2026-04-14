# SSC Submission Notes

Internal checklist and email draft for submitting `rurality` to SSC
(Statistical Software Components archive, maintained by Kit Baum at
Boston College).

## Status check

- [x] Name `rurality` is available (verified via `ssc describe rurality`
      → not found at SSC).
- [x] Package installs and runs end-to-end via `net install` from the
      GitHub repo.
- [x] `rurality_install` fetches the data files from the GitHub release
      on first use.
- [x] Help file covers both `fips()` and `zip()` paths and the
      `rurality_classify` helper.
- [x] `.pkg` lists all code files.

## Files included in the SSC submission

Kit hosts only the code, not the data. The code files are:

- `rurality.ado`
- `rurality_classify.ado`
- `rurality_install.ado`
- `rurality.sthlp`
- `rurality.pkg`

Data files (`rurality_data.dta`, `ruca_data.dta`) stay in the GitHub
repo. `rurality_install` pulls them from:

```
https://github.com/cwimpy/rurality-stata/raw/main/data/
```

This is a common SSC pattern (e.g., `maptile`, `shp2dta`, several
Census-lookup packages) — the SSC package is code-only and pulls
reference data from the author's site when needed.

## Email draft — to Kit Baum

**To:** kit.baum@bc.edu
**Subject:** New package submission: rurality

---

Dear Kit,

I would like to submit a new package, `rurality`, to SSC. The package
provides USDA Rural-Urban Continuum Codes (RUCC 2023), a composite
rurality score, and USDA Rural-Urban Commuting Area codes (RUCA 2020)
for all U.S. counties and ZIP/ZCTA codes, with syntax designed to merge
rurality variables onto an existing dataset by county FIPS or ZIP code.

The package is already distributed via GitHub and has been tested on
Stata 16+ (macOS and Windows). `ssc describe rurality` confirms the
name is available.

The files are at:

  https://github.com/cwimpy/rurality-stata

Direct links for SSC:

- https://raw.githubusercontent.com/cwimpy/rurality-stata/main/rurality.ado
- https://raw.githubusercontent.com/cwimpy/rurality-stata/main/rurality_classify.ado
- https://raw.githubusercontent.com/cwimpy/rurality-stata/main/rurality_install.ado
- https://raw.githubusercontent.com/cwimpy/rurality-stata/main/rurality.sthlp
- https://raw.githubusercontent.com/cwimpy/rurality-stata/main/rurality.pkg

A short package description for the STB/SSC catalog:

> rurality: Rurality classification and scoring for U.S. counties
> and ZIP codes. Provides USDA Rural-Urban Continuum Codes (2023),
> Rural-Urban Commuting Area codes (2020), and a composite rurality
> score (0-100) with an ordered classification (Urban, Suburban,
> Mixed, Rural, Very Rural). Merges onto any dataset by county FIPS
> or ZIP code. A companion R package is on CRAN.

On first use, users run `rurality_install` to download the county and
ZCTA reference data (~1.5 MB total) from the GitHub release; this
keeps the SSC footprint small and lets me push data corrections
without an SSC repush.

Please let me know if you need anything else for the submission.

Thank you,

Cameron Wimpy
Associate Professor and Chair, Department of Government, Law & Policy
Arkansas State University
cwimpy@astate.edu

---

## Post-acceptance tasks

- Announce on Statalist (Kit typically announces, but a follow-up
  note to the list linking to the R package + web app is worthwhile).
- Update the main README to add the `ssc install rurality` option
  alongside the existing `net install` line.
- Tag a release (`v0.1.1`) on GitHub matching the SSC distribution
  date.

## Updating the package on SSC later

Email Kit a new submission with the updated files. Bump the
`Distribution-Date:` line in `rurality.pkg` and the
`*! Version` banner in each `.ado`. Include a short changelog in the
email.

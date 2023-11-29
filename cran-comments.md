## Release summary

New submission
   
Package was archived on CRAN today

Updates since last release:

- Fixed obscure issue with unicode characters in grid names on some linux systems that caused the package to be removed from CRAN
- Updated package infrastructure to reflect latest CRAN policies, etc.

## Test environments

* local OS X install, R 4.3.2
* ubuntu 22.04.3 (on GitHub Actions), R 4.3.2
* win-builder (devel and release)

## R CMD check results

0 errors | 0 warnings | 1 note

Maintainer: 'Ryan Hafen <rhafen@gmail.com>'

New submission

Package was archived on CRAN

CRAN repository db overrides:
  X-CRAN-Comment: Archived on 2023-11-28 as issues were not corrected
    in time.

Found the following (possibly) invalid URLs:
  URL: https://camo.githubusercontent.com/50bf9a4f4861fa11dba4ea66f8f7712eb1b59593/68747470733a2f2f7765622e6c69622e756e632e6564752f6e632d6d6170732f696d616765732f686f74636f756e74796d61702e676966
    From: man/grids.Rd
    Status: 404
    Message: Not Found
  URL: https://github.com/arcruz0
    From: man/grids.Rd
    Status: 429
    Message: Too Many Requests
  URL: https://github.com/eliocamp
    From: man/grids.Rd
    Status: 429
    Message: Too Many Requests
  URL: https://www.axios.com/2017/12/15/the-emoji-states-of-america-1513302318
    From: man/state_ranks.Rd
          inst/doc/geofacet.html
    Status: 403
    Message: Forbidden
  URL: https://countymapsofwashington.com/aapics/washingstate.gif
    From: man/grids.Rd
    Status: 403
    Message: Forbidden
  For content that is 'Moved Permanently', please change http to https,
  add trailing slashes, or replace the old by the new URL.

These URLs are all valid, all use https, and are not redirects. I'm not sure why they are being flagged.

## Reverse dependencies

R CMD check ran successfully on the only reverse dependencies geoAr and geofi.

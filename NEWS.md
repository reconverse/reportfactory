# reportfactory 0.2.0

## Bug fixes
* Fixes (#74) where files generated within the Rmd were not being copied
  over to the output folder.

## Breaking changes
* Following user feedback `compile_reports()` now takes `reports` as a first
  argument and `factory` as the second (previously these were the other way
  round).

# reportfactory 0.1.3

* Implements slightly less strict folder validation.
* Fix for CRAN. One additional test skipped on macs.

# reportfactory 0.1.2

* Fixes for CRAN. Pandoc now listed as a System Requirement and code will error
  if not installed.  Check requiring Pandoc have also now been skipped.

# reportfactory 0.1.1

* Initial release

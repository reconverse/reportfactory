# reportfactory 0.4.0

* `list_deps()` now only checks the `report_sources` and `scripts` folders for
  package dependencies.
* `list_deps()` no longer uses the `checkpoint` package so the dependency has
  been dropped.

# reportfactory 0.3.1

* Fixed `list_deps()`, which was broken due to major changes in the
  `checkpoint` package, which the function relies on.


# reportfactory 0.3.0

* Option added to create an RStudio project file whilst creating a new factory.
* `list_reports()` now looks for both extension `.Rmd` and `.rmd`.
* Added parameter to `compile_reports()` to allow case insensitive report matching.

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

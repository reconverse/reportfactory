## This is a resubmission
Further to Gregor's email on 2020-01-18 I have made the following corrections
to the initial submission:

* Have added \value{} entries for all documentation.
* I have replaced the call to installed.packages() with a call to
  find.packages() as suggested.
* I was unable to find any occurrences of writing to user's home filespace
  within either the tests or the examples.  Within the examples I use tempdir()
  (hidden from the user with \dontshow{}) and within the tests I'm using
  fs::path_temp (using fs here mainly as a sanity check for myself).

## Tested on
* Fedora 33, local R installation, R 4.0.3 (2020-10-10)
* Fedora 33, local R installation, (unstable) (2021-01-14 r79827)
* Windows 10, local R installation, R Under Development

### R CMD check results for above environments
0 errors | 0 warnings | 1 note
* This is a new release.

Further to Brian Ripley's email on 21-01-2020 I have added a System
Requirement on Pandoc along with additional, user facing code, that errors
if it is not installed.  Check's requiring pandoc are now skipped on Solaris.

## Tested on
* Fedora 33, local R installation, R 4.0.3 (2020-10-10)
* Solaris via RHub (unsure of version but I believe it is the current release)
* Fedora 33, local R installation, (unstable) (2021-01-14 r79827)

### R CMD check results for above environments
0 errors | 0 warnings | 1 note

Days since last update: 0 

Hopefully this is ok as at request of Brian Ripley


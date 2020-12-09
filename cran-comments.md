The build is passing on almost all environments I have tested on but for some
reason it is failing on win-builder.  I have tested on 3 different Windows
environments but I'm unable to reproduce the failure.  I'm submitting in the
hope there is a problem with win-builder but please let me know if there is
anything further that I can do.  Further details below:

## Test environments which pass
* Fedora 33, local R installation, R 4.0.3 (2020-10-10)
* Fedora 33, local R installation, R Under Development (2020-12-08 r79595)
* Windows 10, local R installation, R Under Development (2020-12-07 r79587)
* GitHub Actions, Windows, R release
* GitHub Actions, Windows, R devel
* GitHub Actions, macOS,   R release
* GitHub Actions, Ubuntu 20.04, R release
* GitHub Actions, Ubuntu 20.04, R devel

### R CMD check results for above environments
0 errors | 0 warnings | 1 note
* This is a new release.


## Test environment which fails
* win-builder, R Under development (unstable) (2020-12-06 r79580)
Status: 2 ERRORs, 1 NOTE






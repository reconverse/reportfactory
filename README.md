
# Automated Ebola sitrep - DRC 2018 version


## Content of this folder

This is an update from the automated Ebola sitrep used in the Likati outbreak,
DRC, May 2017.

The content includes:

- `data/`: put data files there in the form `data_[yyyy-mm-dd].csv`

- `report_sources`: `Rmd` reports stored in the form `report_[yyyy-mm-dd].Rmd`;
  the date format is very important as it will be used for identifying the
  latest report version

- `report_outputs`: outputs of the compiled reports, typically `.html` files,
named after their sources, with appended date and time of compilation



## Updating reports

Provided all paths in the `.Rmd` sources are specified using `here()`, the
compilation using the following approach should work. The script
`compile_reports.R` contains all useful functions for compiling documents.
`update_reports()` will identify the latest version of the report in
`report_sources`, compile it, and move all resulting files in a separate folder
in `report_outputs`. To update the latest report:


```r
source("compile_reports.R")
update_reports()
```

to recompile all reports:


```r
source("compile_reports.R")
update_reports(all = TRUE)
```

Alternatively, to compile the latest report one can execute the script
`./update_reports` on a linux environment.

Note that manual compilation of each document can still be done the usual way, using `rmarkdown::render`.


<br> <br>

**Copyright**: Thibaut Jombart, 2018
**Contact**: [thibautjombart@gmail.com](mailto:thibautjombart@gmail.com)

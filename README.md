
<!-- README.md is generated from README.Rmd. Please edit that file -->

<!-- badges: start -->

[![Codecov test
coverage](https://codecov.io/gh/reconverse/reportfactory/branch/master/graph/badge.svg)](https://codecov.io/gh/reconverse/reportfactory?branch=master)
[![R-CMD-check](https://github.com/reconverse/reportfactory/workflows/R-CMD-check/badge.svg)](https://github.com/reconverse/reportfactory/actions)
<!-- badges: end -->

# Welcome to reportfactory\!

<br> **<span style="color: red;">NOTE</span>**

This version of {reportfactory} works in a very different way to the
previous unreleased version. For those already using {reportfactory} in
their pipelines you can obtain the old version using the {remotes}
package:

``` r
remotes::install_github("reconverse/reportfactory@old_version")
```

You can also download it directly from
<https://github.com/reconverse/reportfactory/releases/tag/old_version>.

You can install the current version of the package from
[CRAN](https://cran.r-project.org/) with:

``` r
install.packages("reportfactory")
```

The development version can be installed from
[GitHub](https://github.com/) with:

``` r
if (!require(remotes)) {
  install.packages("remotes")
}
remotes::install_github("reconverse/reportfactory", build_vignettes = TRUE)
```

## reportfactory in a nutshell

{reportfactory} is a R package which facilitates workflows for handling
multiple `.Rmd` reports, compiling one or several reports in one go, and
storing outputs in well-organised, timestamped folders. This is
illustrated in the figure below:

<br>
<img src="https://github.com/reconverse/reportfactory/raw/master/artwork/workflow.png" width="100%" alt="workflow">
<br>

There a few key principles it adheres to:

  - *Simple*: only focusses on the compilation of reports with minimum
    overhead for the user.

  - *Non-invasive*: `.Rmd` documents need no alteration to work within
    the factory.

  - *Reproducible*: time-stamped folder structure and customisable
    subfolders make viewing the same report over time a breeze; handling
    of package dependencies facilitates the deployment of factories on
    multiple computers.

  - *Time-saving*: easy compilation of multiple reports using regular
    expressions; book-keeping is handled by the factory and ensures
    that: i) every report is compiled in a clean environment and ii) all
    outputs are stored in a dedicated folder

## Installing the package

To install the development version of the package, use:

``` r
remotes::install_github("reconverse/reportfactory")
```

## Quick start

### Step 1 - Create a new factory

Create and open a new factory. Here, we create the factory with the
default settings. This will create the factory in our current working
directory and then move us in to this new factory.

``` r
library(reportfactory)
new_factory("my_factory")
```

### Step 2 - Add your reports

Here we’ve already created some with most of the default arguments being
set to TRUE (the default). These default settings include both an
example report and some associated data
(`report_sources/example_report.Rmd` and `data/raw/example_data.csv`).
The helper functions below show the state of the factory.

``` r
list_reports()       # list all available report sources
#> [1] "example_report.Rmd"
list_deps()          # list all of the dependencies of the reports
#> [1] "rmarkdown" "fs"        "knitr"
list_outputs()       # currently empty
#> character(0)
```

### Step 3 - Compile report(s)

The `compile_reports()` function can be used to compile a report using
regular expressions matched against the full filename of reports within
the factory.

This ability to use of regular expressions is useful when you’re
actively working on developing your reports but once the factory is
setup we recommend passing full filenames to the function so it is
always clear what will be built.

``` r
compile_reports( 
  reports = "example_report.Rmd"
)
#> >>> Compiling report: example_report
#> All done!
```

Use `list_ouputs()` to view the report outputs.

``` r
list_outputs()
#> [1] "example_report/2021-07-13_T12-16-03/example_report.html"
#> [2] "example_report/2021-07-13_T12-16-03/example_report.Rmd"
```

`compile_reports()` can also be used to pass a set of parameters to use
with a parameterised report (here we use a subfolder argument to
distinguish the parameterised reports).

``` r
compile_reports(
  reports = "example_report.Rmd",
  params = list(graph = FALSE),
  subfolder = "regional"
)
#> >>> Compiling report: example_report
#>       - with parameters: graph = FALSE
#> All done!
list_outputs()
#> [1] "example_report/2021-07-13_T12-16-03/example_report.html"         
#> [2] "example_report/2021-07-13_T12-16-03/example_report.Rmd"          
#> [3] "example_report/regional/2021-07-13_T12-16-04/example_report.html"
#> [4] "example_report/regional/2021-07-13_T12-16-04/example_report.Rmd"
```

Note that reports can also be an integer or a logical vector, in which
case it is interpreted as a subset of files output by list\_reports().
For instance:

  - `compile_reports(reports = c(1, 3))` will compile the first and
    third reports listed by list\_reports(); and
  - `compile_reports(reports = TRUE)` will compile all reports.

### Factory overview

If you want to have an overview of your entire factory then you can use
the `factory_overview()` function:

``` r
factory_overview()
#> /home/tim/github/reconverse/reportfactory/my_factory
#> ├── README.md
#> ├── data
#> │   ├── clean
#> │   └── raw
#> │       └── example_data.csv
#> ├── factory_config
#> ├── my_factory.Rproj
#> ├── outputs
#> │   └── example_report
#> │       ├── 2021-07-13_T12-16-03
#> │       │   ├── example_report.Rmd
#> │       │   └── example_report.html
#> │       └── regional
#> │           └── 2021-07-13_T12-16-04
#> │               ├── example_report.Rmd
#> │               └── example_report.html
#> ├── report_sources
#> │   └── example_report.Rmd
#> └── scripts
```

## Contributing guidelines

Contributions are welcome via **pull requests**.

### Code of Conduct

Please note that the reportfactory project is released with a
[Contributor Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.

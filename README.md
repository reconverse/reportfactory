
<!-- README.md is generated from README.Rmd. Please edit that file -->

[![Travis-CI Build
Status](https://travis-ci.org/reconhub/reportfactory.svg?branch=master)](https://travis-ci.org/reconhub/reportfactory)
[![Build
status](https://ci.appveyor.com/api/projects/status/7h2mgej230dv5r7w/branch/master?svg=true)](https://ci.appveyor.com/project/thibautjombart/reportfactory/branch/master)
[![Coverage
Status](https://codecov.io/github/reconhub/reportfactory/coverage.svg?branch=master)](https://codecov.io/github/reconhub/reportfactory?branch=master)
[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/reportfactory)](https://cran.r-project.org/package=reportfactory)
[![CRAN
Downloads](https://cranlogs.r-pkg.org/badges/reportfactory)](https://cran.r-project.org/package=reportfactory)

# Welcome to reportfactory\!

## reportfactory in a nutshell

{reportfactory} is a lightweight R package which facilitates a workflow
for compiling multiple `.Rmd` reports using `rmarkdown::render()` within
a folder.

There a few key principles it adheres to:

  - *Lightweight* Low dependencies for easy installation in environments
    where internet connections are unreliable.
  - *Reproducible* Time-stamped names and folders make viewing the same
    report over time a breeze.
  - *Time-saving* Easy convenience functions to compile one or many
    reports

![reportfactory
diagram](https://raw.githubusercontent.com/reconhub/reportfactory/master/artwork/workflow.png)

## Installing the package

To install the development version of the package, use:

``` r
remotes::install_github("reconhub/reportfactory")
```

Note that this requires the package `remotes` installed.

## Quick start

### Step 1 - Create a new factory

Create and open a new factory. Here, we create the factory with a
default template but stay in our current activities (set `move_in` to
TRUE to switch projects). Check out more templates at
[reconhub/report\_factories\_templates](https://github.com/reconhub/report_factories_templates).

``` r
library(reportfactory)
factory_proj <- "new_factory"
new_factory(file.path(factory_proj), include_template = TRUE, move_in = FALSE)
#> [1] "new_factory"
```

### Step 2 - Add your reports

Here we’ve already created some with the `include_template` being set to
TRUE (the default). The helper functions below show the state of the
factory.

``` r
list_reports(factory_proj)
#> [1] "example_report_2019-01-31.Rmd"
list_outputs(factory_proj)
#> character(0)
list_deps(factory = factory_proj) # list all needed packages
#> [1] "here"
```

### Step 3 - Compile report(s)

#### Option 1 - A single report

The `compile_report()` function can be used to compile a report using
its name, or a partial match for its name. This is useful when you’re
actively working on developing a single report.

``` r
compile_report("example_report_2019-01-31.Rmd", factory = factory_proj, quiet = TRUE)
```

Use helper functions to see progress.

``` r
list_outputs(factory_proj)
#> character(0)
```

#### Option 2 - All reports with updates

Compile all reports to get their outputs. By default, this just compiles
the most recent versions.

``` r
update_reports(factory_proj)
#> 
#> /// compiling report: 'example_report_2019-01-31'
#> 
#> /// 'example_report_2019-01-31' done!
list_outputs(factory_proj)
#> [1] "example_report_2019-01-31/compiled_2020-03-23_17-38-27/example_report_2019-01-31.html"
```

#### Option 3 - All reports

Compile all reports to get their outputs. By default, this just compiles
the most recent versions.

``` r
update_reports(factory_proj, all = TRUE)
#> 
#> /// compiling report: 'example_report_2019-01-31'
#> 
#> /// 'example_report_2019-01-31' done!
list_outputs(factory_proj)
#> [1] "example_report_2019-01-31/compiled_2020-03-23_17-38-27/example_report_2019-01-31.html"
#> [2] "example_report_2019-01-31/compiled_2020-03-23_17-38-30/example_report_2019-01-31.html"
```

### Step 4 - Consolidate latest outputs

You can now get a single directory of the latest report outputs using:

``` r
ship_reports(factory = factory_proj, most_recent = TRUE)
#> 
#> /// Shipping example_report_2019-01-31 outputs: 
#> 
#> example_report_2019-01-31.html
list.dirs(factory_proj)
#>  [1] "new_factory"                                                                                   
#>  [2] "new_factory/data"                                                                              
#>  [3] "new_factory/data/clean"                                                                        
#>  [4] "new_factory/data/raw"                                                                          
#>  [5] "new_factory/report_outputs"                                                                    
#>  [6] "new_factory/report_outputs/example_report_2019-01-31"                                          
#>  [7] "new_factory/report_outputs/example_report_2019-01-31/compiled_2020-03-23_17-38-27"             
#>  [8] "new_factory/report_outputs/example_report_2019-01-31/compiled_2020-03-23_17-38-30"             
#>  [9] "new_factory/report_sources"                                                                    
#> [10] "new_factory/scripts"                                                                           
#> [11] "new_factory/shipped_2020-03-23_17-38-33"                                                       
#> [12] "new_factory/shipped_2020-03-23_17-38-33/example_report_2019-01-31"                             
#> [13] "new_factory/shipped_2020-03-23_17-38-33/example_report_2019-01-31/compiled_2020-03-23_17-38-30"
```

## Contributing guidelines

Contributions are welcome via **pull requests**.

Please note that this project is released with a [Contributor Code of
Conduct](CONDUCT.md). By participating in this project you agree to
abide by its terms.

# Welcome to this report factory\!

The factory will help you handle multiple `rmarkdown` reports at the
same time. Put your `.Rmd` files in `report_sources`, refer to any
external files in the `.Rmd` using `here::here()`, and you’re sorted.

## How the default factory is organised

  - `report_sources`: (mandatory) put your `.Rmd` documents there
    (subfolders are OK)

  - `data/`: (recommended) put your data in this folder (subfolders are
    OK)
    
      - `data/raw`: to store raw data, as read-only
      - `data/clean`: to store cleaned data

  - `R/`: (recommended) put your external R scripts and functions, used in your
    `.Rmd` reports, in this folder (subfolders are OK)

  - `outputs/`: (automatically created) the factory will store
    report outputs there, using named and time-stamped folders

## How to run the factory: useful commands

  - `list_reports()`: lists reports currently stored in the factory
    (only `.Rmd` source files)

  - `compile_reports()`: compiles one or more reports: An individual report can
    be compiled using the exact file name or a non-ambiguous match; multiple
    reports can be compiled by using a regular expression to match report names;
    all reports can be compiled if the argument is left empty.  Compiled reports
    will be stored in `outputs/`.

## Basic workflow
Below is a basic workflow to get you started.  For more information consult
[https://www.repidemicsconsortium.org/reportfactory/]

1.  create a new factory using `new_factory()` and move into this new
    folder

2.  go to `report_sources/`, write your `.Rmd` report, using the
    provided examples as inspiration; remove the examples files.

3.  check your report by compiling the `.Rmd` manually if needed,
    e.g. `rmarkdown::render("foobar.Rmd")`; once you are
    happy with the results, **make sure you remove all output files from
    the source folder**

4.  run `compile_reports()` to generate all outputs, or
    `compile_reports("foobar")` if you just want to produce time-stamped
    outputs for reports that can be matched via regular expressions by "foobar";
    check results in the folder `outputs/`.

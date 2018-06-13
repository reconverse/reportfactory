
## Compile all documents, or the most recent one

## all: logical, if TRUE all documents are recompiled, otherwise only the most
## recent one is

update_reports <- function(all = FALSE) {
  if (!require("here")) {
    stop("package 'here' is not installed")
  }

  report_sources <- dir(here("report_sources"), pattern = ".Rmd$")
  dates <- sub("^.*_", "", report_sources)
  dates <- sub("[.]Rmd$", "", dates)

  if (all) {
    lapply(dates, compile_report)
  } else {
    latest <- as.character(max(as.Date(dates)))
    compile_report(latest)
  }

}

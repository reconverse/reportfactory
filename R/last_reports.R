
## This function finds the latest reports in the factory.

last_reports <- function() {
if (!require("here")) {
  stop("package 'here' is not installed")
}

  report_sources <- dir(here("report_sources"), pattern = ".Rmd$")
  dates <- sub("^.*_", "", report_sources)
  dates <- sub("[.]Rmd$", "", dates)
  last_date <- as.character(max(as.Date(dates)))
  out <- dir(here(), recursive = TRUE, pattern = last_date)
  out <- unique(sub("~$", "", out))
  out <- out[-grep("^data/", out)]
  out

}

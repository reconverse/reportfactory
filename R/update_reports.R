
## Compile all documents, or the most recent one

## all: logical, if TRUE all documents are recompiled, otherwise only the most
## recent one is

update_reports <- function(all = FALSE, ...) {
  if (!require("here")) {
    stop("package 'here' is not installed")
  }

  odir <- getwd()
  on.exit(setwd(odir))

  report_sources <- list_reports()
  dates <- extract_date(report_sources)
  types <- extract_base(report_sources)

  if (all) {
    lapply(report_sources, compile_report, ...)
  } else {
    sources_by_type <- split(report_sources, types)
    for (e in sources_by_type) {
      index_latest <- which.max(as.Date(extract_date(e)))
      compile_report(e[index_latest], ...)
    }
  }

  invisible(NULL)
}

#' List reports in the factory
#'
#' This function can be used to list available reports stored in the factory, in
#' inside the \code{report_sources} folder (or any subfolder within).
#'
#' @export
#'
#' @inheritParams compile_report
#'
#' @param pattern an optional regular expression used to look for specific
#'   patterns in report names
#' @param ignore_archive when \code{TRUE}, any reports within an `_archive` 
#'   sub-directory are ignored. Set to \code{FALSE} to list these reports.
#'
#' @author Thibaut Jombart \email{thibautjombart@@gmail.com}
#'

list_reports <- function(factory = getwd(), pattern = NULL, ignore_archive = TRUE) {

  odir <- getwd()
  on.exit(setwd(odir))
  setwd(factory)

  out <- dir(find_file("report_sources"),
             recursive = TRUE, pattern = ".Rmd$",
             ignore.case = TRUE, full.names = TRUE)
  if (ignore_archive) {
    # don't include reports that are in an archive
    out <- out[!grepl("_archive/", out)]
  }

  out <- gsub(".*/", "", out)

  if (!is.null(pattern)) {
    out <- grep(pattern, out, value = TRUE)
  }

  out
}

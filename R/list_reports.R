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
#'
#' @author Thibaut Jombart \email{thibautjombart@@gmail.com}
#'

list_reports <- function(factory = getwd(), pattern = NULL) {

  odir <- getwd()
  on.exit(setwd(odir))
  setwd(factory)

  out <- dir(find_file("report_sources"),
             recursive = TRUE, pattern = ".Rmd$",
             ignore.case = TRUE, full.names = TRUE)
  out <- gsub(".*/", "", out)

  if (!is.null(pattern)) {
    out <- grep(pattern, out, value = TRUE)
  }

  class(out) <- c("punchcard", oldClass(out))
  out
}

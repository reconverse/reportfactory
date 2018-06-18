#' List reports in the factory
#'
#' This function can be used to list available reports stored in the factory, in
#' inside the \code{report_sources} folder (or any subfolder within).
#'
#' @export
#'
#' @inheritParams compile_report
#'
#' @author Thibaut Jombart \email{thibautjombart@@gmail.com}
#'

list_reports <- function(factory = getwd()) {

  odir <- getwd()
  on.exit(setwd(odir))
  setwd(factory)

  out <- dir(find_file("report_sources"),
             recursive = TRUE, pattern = ".Rmd$",
             full.names = TRUE)
  out <- gsub(".*/", "", out)
  out
}

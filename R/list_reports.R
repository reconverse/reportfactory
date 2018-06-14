#' List reports in the factory
#'
#' This function can be used to list available reports stored in the factory, in
#' inside the \code{report_sources} folder (or any subfolder within).
#'
#' @export
#'
#' @author Thibaut Jombart \email{thibautjombart@@gmail.com}
#' 

list_reports <- function() {
  out <- dir(root_file("report_sources"),
             recursive = TRUE, pattern = ".Rmd$",
             full.names = TRUE)
  out <- gsub(".*/", "", out)
  out
}

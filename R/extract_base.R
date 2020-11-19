#' Extract the base name of a report, i.e. keep anything before the date
#'
#' This function is used to extract the base names of reports
#'
#'
#' @author Thibaut Jombart \email{thibautjombart@@gmail.com}
#'
#'
#' @param x filenames
#'
#'
#' @noRd
#' @keywords internal
#'
#' @examples
#'
#' \dontrun{
#'
#' x <- "contacts_2017-10-29.Rmd"
#' check <- extract_base(x)
#' print(check)
#' }
#'

extract_base <- function(x) {
  pattern <- ".[0-9]{4}[-_]?[0-9]{2}[-_]?[0-9]{2}.*$"
  out <- gsub(pattern, "", x)
  out <- gsub(".*/", "", out)
  out
}

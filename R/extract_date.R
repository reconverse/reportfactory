
#' Extract the date from a charcter string (vectorised)
#'
#' This function is used to extract a date from a string
#'
#'
#' @author Thibaut Jombart \email{thibautjombart@@gmail.com}
#'
#'
#' @param x A string containing a date
#'
#'
#' @noRd
#' @keywords internal
#'
#' @examples
#'
#' \dontrun{
#'
#' x <- "contacts_2017-10-29"
#' check <- extract_date(x)
#' print(check)
#' }
#'

extract_date <- function(x) {
  date_pattern <- "[0-9]{4}[-_]?[0-9]{2}[-_]?[0-9]{2}"
  as.Date(extract_string(x, date_pattern))
}

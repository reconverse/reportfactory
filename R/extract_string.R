
#' Extract any string from a vector using a regular expression
#'
#'
#' This function can be used to extract any string from a
#' vector by providing a regular expression pattern
#'
#'
#' @author Thibaut Jombart \email{thibautjombart@@gmail.com}
#'
#'
#' @param x a vector containing a string
#'
#'
#' @param pattern a regular expression pattern to be matched
#'
#' @noRd
#' @keywords internal
#'
#' @example
#'
#' \dontrun{
#' x <- "I love RECON"
#' pattern <- "[A-Z]{5}"
#'
#' check <- extract_string(x, pattern)
#' print(check)
#' }
#'

extract_string <- function(x, pattern) {
  m <- regexpr(pattern, x)
  regmatches(x, m)
}

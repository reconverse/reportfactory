
#' Find the root directory of factory
#'
#' This function is used to find the root directory of a factory workflow
#'
#'
#' @author Thibaut Jombart \email{thibautjombart@@gmail.com}
#'
#' 
#' @param x 
#' 
#' 
#' @noRd
#' @keywords internal
#'
#'

# Find the root directory of factory

find_file <- function(x = NULL) {
  root <- rprojroot::find_root(rprojroot::has_file(".here"))
  if (!is.null(x) ) {
    out <- file.path(root, x)
  } else {
    out <- root
  }
  out
}

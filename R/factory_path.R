
#' Find the path to a file in the factory
#'
#' This function is used to define paths to files within a factory. It is 
#' equivalent of `here::here()` working within a factory for programmatic
#' purposes. It does not clash with `here::here()`.
#'
#' @author Thibaut Jombart \email{thibautjombart@@gmail.com}
#'
#' @param x the path to the factory to be used
#'
#' @noRd
#' 
#' @keywords internal
#'

factory_path <- function(x = NULL) {
  root <- rprojroot::find_root(rprojroot::has_file(".here"))
  if (!is.null(x)) {
    out <- file.path(root, x)
  } else {
    out <- root
  }
  out
}

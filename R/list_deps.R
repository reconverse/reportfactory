
#' List dependencies of reprots within
#'
#' This function can be used to list package dependencies based of the reports
#' within the factory. It is a wrapper for \code{checkpoint::scanForPackages}.
#'
#' @export
#'
#' @author Thibaut Jombart \email{thibautjombart@@gmail.com}
#'
#' @param missing A logical indicating if only missing dependencies should be
#'   listed (\code{TRUE}); otherwise, all packages needed in the reports are
#'   listed; defaults to \code{FALSE}
#'
#' @seealso \code{\link{install_deps}} to install dependencies
#'

list_deps <- function(missing = FALSE) {
  deps <- checkpoint::scanForPackages(use.knitr = TRUE,
                                      scan.rnw.with.knitr = TRUE)$pkgs
  if (missing) {
    installed <- utils::installed.packages()[, "Package"]
    deps <- setdiff(deps, installed)
  }

  deps
}

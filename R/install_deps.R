
#' Install dependencies of reports within
#'
#' This function can be used to install package dependencies
#' based on the reports within the factory.
#'
#' @export
#'
#' @author Thibaut Jombart \email{thibautjombart@@gmail.com}
#'
#' @param update A logical indicating if packages which are already installed
#'   should be re-installed (\code{TRUE}); otherwise, only missing packages are
#'   installed; defaults to \code{FALSE}.
#'
#' @param ... Arguments to be passed to \code{install.packages}.
#'
#' @seealso \code{\link{list_deps}} to list dependencies of packages
#'

install_deps <- function(update = FALSE, ...) {

  pkg_to_install <- list_deps(!update)

  if (length(pkg_to_install) > 0L) {
    utils::install.packages(pkg_to_install, ...)
  } else {
    message("All packages needed are already installed.")
  }
}

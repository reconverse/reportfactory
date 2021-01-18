#' Install dependencies of reports within
#'
#' This function can be used to install package dependencies based on the
#' reports within the factory.
#'
#' @inheritParams compile_reports
#' @param update A logical indicating if packages which are already installed
#'   should be re-installed (`TRUE`); otherwise, only missing packages are
#'   installed; defaults to `FALSE`.
#' @param ... Arguments to be passed to `install.packages()`.
#'
#' @return Invisble NULL (called for side effects only).
#'
#' @seealso `list_deps()` to list dependencies of packages
#'
#' @export
install_deps <- function(factory = ".", update = FALSE, ...) {

  pkg_to_install <- list_deps(factory = factory, missing = !update)

  if (length(pkg_to_install)){
    utils::install.packages(pkg_to_install, ...)
  } else {
    message("All packages needed are already installed.")
  }
  invisible(NULL)
}

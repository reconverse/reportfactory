#' List dependencies of reports within a factory
#'
#' This function can be used to list package dependencies based of the reports
#' within the factory. It is a wrapper for \code{checkpoint::scanForPackages}.
#'
#' @inheritParams compile_reports
#' @param missing A logical indicating if only missing dependencies should be
#'   listed (`TRUE`); otherwise, all packages needed in the reports are listed;
#'   defaults to `FALSE`
#'
#' @return A character vector of package dependencies.
#'
#' @export
list_deps <- function(factory = ".", missing = FALSE) {

  tmp <- validate_factory(factory)
  root <- tmp$root

  op <- options(knitr.purl.inline = TRUE)
  on.exit(options(op))

  deps <- checkpoint::scanForPackages(
    project = root,
    use.knitr = TRUE,
    scan.rnw.with.knitr = TRUE
  )
  deps <- deps$pkgs

  if (missing) {
    installed <- basename(find.package(deps))
    deps <- setdiff(deps, installed)
  }

  deps
}

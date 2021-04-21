#' List reports in the factory
#'
#' This function can be used to list available reports stored in the factory, in
#' inside the \code{report_sources} folder (or any subfolder within).
#'
#' @inheritParams compile_reports
#' @param pattern An optional regular expression used to look for specific
#'   patterns in report names.
#' @param ... additional parameters to pass to `grep()`
#'
#' @return A character vector containing the names of the reports in the
#'   specified factory (empty if there were no files).
#'
#' @export
list_reports <- function(factory = ".", pattern = NULL, ...) {

  # validate and get the root / report_sources directories of the factory
  tmp <- validate_factory(factory)
  root <- tmp$root
  report_sources <- tmp$report_sources


  # get a listing of all files and folders in report_sources
  out <- list.files(
    file.path(root, report_sources),
    pattern = "\\.[Rr]md$",
    recursive = TRUE
  )

  # filter with grep
  if (!is.null(pattern)) {
    out <- grep(pattern, out, value = TRUE, ...)
  }

  out
}

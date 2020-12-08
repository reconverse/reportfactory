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
#' @export
list_reports <- function(factory = ".", pattern = NULL, ...) {

  # validate and get the root / report_sources directories of the factory
  tmp <- validate_factory(factory)
  root <- tmp$root
  report_sources <- tmp$report_sources


  # get a listing of all files and folders in report_sources
  out <- fs::path_rel(
    fs::dir_ls(
      fs::path(root, report_sources),
      all = TRUE,
      recurse = TRUE,
      regexp = "\\.Rmd$"
    ),
    fs::path(root, report_sources)
  )
  
  if (!is.null(pattern)) {
    out <- grep(pattern, out, value = TRUE, ...)
  }

  out
}
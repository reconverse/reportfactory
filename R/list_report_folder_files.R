#' List files and timestamps within the report sources folder
#'
#' @inheritParams compile_reports
#' @param directories should directories be listed
#'
#' @noRd
list_report_folder_files <- function(factory = ".", directories = FALSE) {

  # validate and get the root / report_sources directories of the factory
  tmp <- validate_factory(factory)
  root <- tmp$root
  report_sources <- tmp$report_sources

  # get a listing of all files and folders in report_sources
  f <- list.files(
    file.path(root, report_sources),
    recursive = TRUE,
    include.dirs = directories
  )
  f <- file.path(root, report_sources, f)

  data.frame(files = f, modified = file.mtime(f))

}

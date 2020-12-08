#' List outputs of the factory
#'
#' This function can be used to list available report outputs stored in the
#' factory, in inside the `outputs` folder (or any subfolder within).
#'
#' @inheritParams list_reports
#' @export
list_outputs <- function(factory = ".", pattern = NULL, ...) {

  # get the root directory of the factory
  tmp <- validate_factory(factory)
  root <- tmp$root
  outputs <- tmp$outputs

  # get a listing of all files and folders in report_sources
  # out <- fs::path_rel(
  #   fs::dir_ls(
  #     fs::path(root, outputs),
  #     all = TRUE,
  #     recurse = TRUE,
  #     type = "file"
  #   ),
  #   fs::path(root, outputs)
  # )
  out <- list.files(fs::path(root, outputs), recursive = TRUE) 
  
  if (!is.null(pattern)) {
    out <- grep(pattern, out, value = TRUE, ...)
  }

  out
}
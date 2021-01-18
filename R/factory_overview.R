#' Generate an overview of a report factory
#'
#' Print contents of directories in a tree-like format.
#'
#' @param path The path to the report factory or a folder within the desired
#'   factory. Defaults to the current directory.
#' @param ... Additional arguments passed to `fs::dir_tree()`.
#'
#' @return Invisibly returns a character of the files and directories within the
#'   desired folder.
#'
#' @export
factory_overview <- function(path = ".", ...) {

  # check directory is within a factory and set root
  tmp <- validate_factory(path)
  root <- tmp$root

  fs::dir_tree(root, ...)
}

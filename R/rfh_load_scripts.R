#' Load all R scripts in the factory
#'
#' This helper function will load all `.R` scripts within folders `scripts/` and
#' `src/`. All scripts are loaded using `source()` with the argument `local =
#' TRUE` so that the current environment (typically that of the compiled report)
#' will be visible to all sourced scripts.
#'
#' @author Thibaut Jombart (thibautjombart@@gmail.com)
#'
#' @export
#'
#' @param quiet A logical indicating whether messages should be displayed to the
#'   console (`TRUE`, default), or not.
#'
#' @examples
#'
#' ## create random factory
#' odir <- getwd()
#' random_factory()
#'
#' ## load scripts - nothing to load
#' rfh_load_scripts()
#'
#' ## create toy script, try again
#' dir.create("src/")
#' cat("toto <- 1:10", file = "src/toto.R")
#' rfh_load_scripts()
#'
#' ## check that toto exists and is 1:10
#' toto
#'
#' ## restore original working directory
#' setwd(odir)

rfh_load_scripts <- function(quiet = FALSE) {

  ## Approach: we list all .R files in /scripts/ and in /src/, and load all of
  ## them in alphanumeric order; we need to make sure all objects are loaded in
  ## the parent environment. This is achieved using `sys.source` rather than
  ## `source`.

  ## get parent environment
  parent <- parent.frame()

  ## process .R files in scripts/
  path_to_scripts <- find_file("scripts")
  scripts_files <- dir(path_to_scripts,
                       pattern = "[.]R$",
                       recursive = TRUE,
                       full.names = TRUE)
  if (!quiet) {
    if (length(scripts_files)) {
    scripts_txt <- dir(path_to_scripts,
                       pattern = "[.]R$",
                       recursive = TRUE)
    scripts_txt <- paste(scripts_txt, collapse = "\n  ")
    msg <- sprintf("\nLoading the following `.R`  files in `scripts/`:\n  %s",
                   scripts_txt)
    message(msg)
    } else {
      message("\nNo `.R` files in `scripts/`")
    }
  }
  for (file in scripts_files) sys.source(file, envir = parent)

  
  ## process .R files in scr/
  path_to_src <- find_file("src")
  src_files <- dir(path_to_src,
                       pattern = "[.]R$",
                       recursive = TRUE,
                       full.names = TRUE)

  for (file in src_files) source(file, local = TRUE)
  if (!quiet) {
    if (length(src_files)) {
      src_txt <- dir(path_to_src,
                         pattern = "[.]R$",
                         recursive = TRUE)
      src_txt <- paste(src_txt, collapse = "\n  ")
      msg <- sprintf("\nLoading the following `.R`  files in `src/`:\n  %s",
                     src_txt)
      message(msg)
    } else {
      message("\nNo `.R` files in `src/`")
    }
  }
  for (file in src_files) sys.source(file, envir = parent)


  ## nothing to return, bye everyone
  return(invisible(NULL))
  
}

#' Find the path to the root folder within a factory
#'
#' This function is used to find the fully expanded root path within a factory.
#'
#' @param directory the full path to the directory you are interested in.  If
#'   NULL (default) the function assumes you are already in a factory and will
#'   return the address of the containing factory root.
#'
#' @noRd
#' @keywords internal
factory_root <- function(directory = NULL) {
  
  if(!is.null(directory)) {

    if (!fs::file_exists(directory)) {
      stop(
        sprintf("directory '%s' does not exist!\n", directory),
        call. = FALSE
      )
    }

    if (fs::is_file(directory)) {
      stop(
        sprintf("'%s' is a file, not a directory! Please correct\n", directory),
        call. = FALSE)
    }
    
    odir <- setwd(directory)
    on.exit(setwd(odir))
    root <- tryCatch(
      rprojroot::find_root(rprojroot::has_file("factory_config")),
      error = function(e) {
        stop(
          sprintf("directory %s is not part of a report factory.\n", directory),
          call. = FALSE
        )
      }
    )
  } else {
    root <- tryCatch(
      rprojroot::find_root(rprojroot::has_file("factory_config")),
      error = function(e) {
        stop(
          "Cannot find a factory_config file within the current subtree.\n",
          "       Are you in the wrong folder?\n",
          call. = FALSE
        )
      }
    )
  }
  root
}
   
root_file <- function(x = NULL) {
  root <- rprojroot::find_root(rprojroot::has_file(".here"))
  if (!is.null(x) ) {
    out <- file.path(root, x)
  } else {
    out <- root
  }
  normalizePath(out)
}

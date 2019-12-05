
#' Change the path of an existing file
#'
#'
#' This function can be used to move existing files between folder locations.
#'
#'
#' @author Thibaut Jombart \email{thibautjombart@@gmail.com}
#'
#'
#' @param from
#'
#'
#' @param to
#'
#'
#' @noRd
#' @keywords internal
#'
#'

move_file <- function(from, to) {
  dir.create(dirname(to), showWarnings = FALSE, recursive = TRUE)
  file.copy(from, to, overwrite = TRUE)
  unlink(from)
}

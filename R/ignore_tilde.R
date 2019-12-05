
#' Take a vector of characters and removes the ones which end in a tilde
#'
#'
#' @author Thibaut Jombart \email{thibautjombart@@gmail.com}
#'
#'
#' @param x A vector of characters
#'
#'
#' @noRd
#' @keywords internal
#'
#' @example
#'
#' \dontrun{
#'
#' x <- c("contacts_2017-10-29~", "example_2017-10-29")
#' check <- ignore_tilde(x)
#' print(check)
#' }
#'
## This takes a vector of characters and removes the ones ending with a ~

ignore_tilde <- function(x) {
  to_remove <- grep("~$", x)
    if (length(to_remove) > 0L) {
      x <- x[-to_remove]
    }
  x
}

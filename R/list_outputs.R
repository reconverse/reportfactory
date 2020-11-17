
#' List outputs of the factory
#'
#' This function can be used to list available report outputs stored in the
#' factory, in inside the \code{report_outputs} folder (or any subfolder
#' within).
#'
#' @export
#'
#' @author Thibaut Jombart \email{thibautjombart@@gmail.com}
#'
#' @inheritParams list_reports
#'

list_outputs <- function(factory = getwd(), pattern = NULL) {

  odir <- getwd()
  on.exit(setwd(odir))
  setwd(factory)

  out <- dir(factory_path("report_outputs"), recursive = TRUE)

  if (!is.null(pattern)) {
    out <- grep(pattern, out, value = TRUE)
  }

  out
}

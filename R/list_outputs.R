
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
#' @inheritParams compile_report
#'

list_outputs <- function(factory = getwd()) {

  odir <- getwd()
  on.exit(setwd(odir))
  setwd(factory)

  dir(find_file("report_outputs"), recursive = TRUE)
}

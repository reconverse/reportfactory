#' Create a new report factory
#'
#' This function can be used to create a new report factory. By default, the
#' factory is created with a template of report, and the working environment is
#' moved to the newly created factory.
#'
#' @details
#' The default factory includes:
#'
#' \itemize{
#'
#'  \item \code{data/}: a folder storing data
#'
#'  \item \code{report_sources/}: a folder storing the reports, named after the
#' convention described in \code{\link{update_reports}}, and stored in
#' subfolders \code{contacts} and \code{epicurves}
#'
#'  \item \code{.gitignore}: a file used to tell git to ignore the produced
#' outputs in \code{report_outputs}
#'
#'  \item \code{open.Rproj}: an Rproject to open the factory using Rstudio
#'
#'  \item \code{.here}: an empty file used as anchor by \code{\link[here]{here}}
#'
#' }
#'
#' @param destination the name of the report factory folder to be created
#'
#' @param include_template a logical indicating if a template of report
#' and folders structure shoud be added to the factory; defaults to `TRUE`
#'
#' @param move_in a `logical` indicating if the current session should move into
#'   the created factory; defaults to `TRUE`
#'
#' @export
#'
#' @author Thibaut Jombart \email{thibautjombart@@gmail.com}
#'
#' @examples
#'
#' \dontrun{
#' destination <- file.path(tempdir(), "new_factory")
#' destination
#' new_factory(destination)
#' dir()
#'
#' ## check content
#' list_reports()
#' list_outputs()
#'
#' ## check dependencies
#' list_deps()
#' install_deps()
#'
#' ## compile a single report:
#'
#' compile_report("contacts_2017-10-29", quiet = TRUE)
#' list_outputs()
#'
#' ## compile all reports (only most recent versions):
#'
#' update_reports()
#' list_outputs()
#' }

new_factory <- function(destination = "new_factory",
                        include_template = TRUE,
                        move_in = TRUE) {

  ## factory with example data and reports is not the default, but will override
  ## the template if requested

  if (include_template) {
    zip_path <- system.file("factory_template_default.zip",
                            package = "reportfactory")
  } else {
    zip_path <- system.file("factory_template_empty.zip",
                            package = "reportfactory")
  }

  utils::unzip(zipfile = zip_path, exdir = destination)


  if (move_in) {
    setwd(destination)
  }

  return(destination)
}

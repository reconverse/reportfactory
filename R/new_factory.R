#' Create a new report factory
#'
#' This function can be used to create a new report factory, using a template
#' containing data and associated reports as examples. The provided examples use
#' (simulated) infectious disease data, but any other data analysis would work
#' the same. See details for the content of the factory
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
#' @param include_template a logical indicating if a template of report and folders
#'   structure shoud be added to the factory; defaults to \code{TRUE}
#'
#' @param include_examples a logical indicating if examples of reports shoud be
#'   added to the factory; defaults to \code{FALSE}
#'
#' @param move_in a logical indicating if the current session should move into
#'   the created factory; defaults to \code{TRUE}
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
                        include_examples = FALSE,
                        move_in = TRUE) {

  ## factory with example data and reports is not the default, but will override
  ## the template if requested
  
  if (include_examples) {
    zip_path <- system.file("factory_template_with_examples.zip",
                            package = "reportfactory")
  } else if (include_template) {
    zip_path <- system.file("factory_template_default.zip",
                            package = "reportfactory")
  } else {
    zip_path <- system.file("factory_template_empty.zip",
                            package = "reportfactory")
  }

  utils::unzip(zipfile = zip_path, exdir = destination)



  ## dir.create(destination, FALSE, TRUE)

  ## ## copy files: .here, .gitignore
  ## file.copy(
  ##   dir(template_path, pattern = "here", full.names = TRUE, all.files = TRUE),
  ##   destination, copy.mode = TRUE)
  ## file.copy(
  ##   dir(template_path, pattern = "gitignore", full.names = TRUE, all.files = TRUE),
  ##   destination, copy.mode = TRUE)
  ## file.copy(
  ##   dir(template_path, pattern = "README", full.names = TRUE),
  ##   destination, copy.mode = TRUE)

  ## ## copy folders
  ## if (include_examples) {
  ##   file.copy(
  ##     dir(template_path, pattern = "data", full.names = TRUE),
  ##     destination, copy.mode = TRUE, recursive = TRUE)
  ##   file.copy(
  ##     dir(template_path, pattern = "report_sources", full.names = TRUE),
  ##     destination, copy.mode = TRUE, recursive = TRUE)
  ## } else {
  ##   dir.create("report_sources", FALSE, TRUE)
  ## }

  if (move_in) {
    setwd(destination)
  }

  return(destination)
}

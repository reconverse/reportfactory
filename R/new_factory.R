#' Create a new report factory
#'
#' This function can be used to create a new report factory, using a template
#' containing data and associated reports as examples. The provided examples use
#' (simulated) infectious disease data, but any other data analysis would work
#' the same. The factory includes:
#' \itemize{
#'
#'  \item \code{data/}: a folder storing data, with subfolders for
#'  \code{contacts} and \code{linelists} (two types of epidemiological data),
#'  and \code{.xlsx} files within these folders
#'
#'  \item \code{report_sources/): a folder storing the reports, named after the
#' convention described in \code{\link{update_reports}}, and stored in
#' subfolders \code{contacts} and \code{epicurves}
#'
#'  \item \code{.gitignore}: a file used to tell git to ignore the produced
#' outputs in \code{report_outputs}
#'
#'  \item \code{.here}: an empty file used as anchor by \code{\link[here]{here}}
#'
#' }
#'
#' @param destination the name of the report factory folder to be created
#' 
#' @param include_example a logical indicating if examples of reports shoud be
#'   added to the factory; defaults to \code{TRUE}
#'
#' @export
#'
#' @author Thibaut Jombart \email{thibautjombart@@gmail.com}
#' 
new_factory <- function(destination = "new_factory",
                        include_examples = TRUE) {
  path_to_template <- system.file("factory_template", package = "reportfactory")

  odir <- getwd()
  on.exit(setwd(odir))
 
  dir.create(destination)

  ## copy files: .here, .gitignore
  file.copy(
    dir(path_to_template, pattern = ".here", full.names = TRUE),
    destination, copy.mode = TRUE)
  file.copy(
    dir(path_to_template, pattern = ".gitignore", full.names = TRUE),
    destination, copy.mode = TRUE)
  file.copy(
    dir(path_to_template, pattern = "README", full.names = TRUE),
    destination, copy.mode = TRUE)
  
  ## copy folders
  if (include_examples) {
    file.copy(
      dir(path_to_template, pattern = "data", full.names = TRUE),
      destination, copy.mode = TRUE, recursive = TRUE)
    file.copy(
      dir(path_to_template, pattern = "report_sources", full.names = TRUE),
      destination, copy.mode = TRUE, recursive = TRUE)
  } else {
    dir.create("report_sources")
  }

  return(destination)
}

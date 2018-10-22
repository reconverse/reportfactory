#' Create a new report factory
#'
#' This function can be used to create a new report factory, using a template
#' containing data and associated reports as examples. The provided examples use
#' (simulated) infectious disease data, but any other data analysis would work
#' the same. See details for the content of the factory
#'
#' @details
#' The factory includes:
#'
#' \itemize{
#'
#'  \item \code{data/}: a folder storing data, with subfolders for
#'  \code{contacts} and \code{linelists} (two types of epidemiological data),
#'  and \code{.xlsx} files within these folders
#'
#'  \item \code{report_sources/}: a folder storing the reports, named after the
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
#' @param include_examples a logical indicating if examples of reports shoud be
#'   added to the factory; defaults to \code{TRUE}
#'
#' @param move_in a logical indicating if the current session should move into
#'   the created factory; defaults to \code{TRUE}
#'
#' @param overwrite a logical indicating if files in an existing directory are
#'   to be overwritten; defaults to \code{FALSE} indicating that no files are
#'   to be overwritten, preserving the state of the files on your system.
#'
#' @export
#'
#' @author Thibaut Jombart \email{thibautjombart@@gmail.com}, 
#'         Zhian N. Kamvar \email{zkamvar@@gmail.com}
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
                        include_examples = TRUE,
                        move_in = TRUE,
                        overwrite = FALSE) {

  file_path    <- system.file("factory_template", package = "reportfactory")
  file_exists  <- file.exists(destination)
  if (!file_exists) {
    message("  /// Could not find destination. Attempting to create it...")
    file_exists <- dir.create(destination)
    if (!file_exists) {
      msg <- paste("destination", destination, "could not be created.",
                   "If you are not an administrator on this system, this may be",
                   "due to insufficient permissions."
                  )
      stop(msg)
    }
  }
  is_directory <- file_exists && file.info(destination)$isdir
  if (is_directory) {
    the_files <- list.files(file_path,
                            all.files = TRUE,
                            full.names = TRUE,
                            no.. = TRUE)
    if (!include_examples) {
      # Filter out directories
      are_dirs  <- file.info(the_files)$isdir
      the_files <- the_files[!are_dirs]
      dir.create(file.path(destination, "data"))
      dir.create(file.path(destination, "report_sources"))
    }
    copied <- file.copy(from      = the_files,
                        to        = destination,
                        recursive = TRUE,
                        overwrite = overwrite
                       )
    if (!all(copied) && !overwrite) {
      whoops <- the_files[!copied]
      msg <- paste0("The following files were not copied:\n\t",
                    paste(basename(whoops), collapse = "\n\t"),
                    "\n",
                    "If you want these files to be overwritten, use overwrite = TRUE"
                   )
      message(msg)
    } else if (!all(copied)) {
      whoops <- paste(the_files[!copied], collapse = "\n\t")
      stop("Some files were not copied:\n\t", whoops)
    }
  }

  # Renaming dot files

  file.rename(file.path(destination, "_here"), file.path(destination, ".here"))
  file.rename(file.path(destination, "_gitignore"), file.path(destination, ".gitignore"))
  
  if (move_in) {
    oldwd <- getwd()
    msg <- paste0("  /// Changing working directory to ", destination, "\n",
                  "  /// If you want to go back, your can use ",
                    "setwd('", oldwd, "')"
                  )
    message(msg)
    setwd(destination)
  }
  return(destination)
}

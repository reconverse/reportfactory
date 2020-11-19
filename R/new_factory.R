#' Create a new report factory
#'
#' This function can be used to create a new report factory. By default, the
#' factory is created with a template of report, and the working environment is
#' moved to the newly created factory.
#' 
#' @param name the name of the report factory folder to be created.
#' @param path the folder where the report factory should be created.  This
#'   will default to the current working directory.
#' @param include_template a logical indicating if a template of report
#' and folders structure shoud be added to the factory; defaults to `TRUE`
#' @param move_in a `logical` indicating if the current session should move into
#'   the created factory; defaults to `TRUE`
#' @return the report factory folder location (invisibly)
#'
#' @details
#' `new_factory` will create a report factory folder structure that includes:
#' 
#' * `report_sources`: a folder storing the reports, named after the convention
#'   described in `update_reports()`.
#' * `.gitignore`: a file used to tell git to ignore the produced outputs in
#'   `report_outputs()`.
#' * `open.Rproj`: an Rproject file to open the factory when using Rstudio.
#' * `.here`: an empty file used as an anchor by `here::here()`.
#' * `README.md`: instructions on how to use report factory
#' 
#' If `include_template` is TRUE, then the factory will also include:
#' 
#' * `data/raw/`: a folder storing raw data
#' * `data/clean/`: a folder storing cleaned data
#' * `R/`: a folder to store additional code that may be called in reports
#'
#' @examples
#' \dontshow{.old_wd <- setwd(tempdir())}
#' f1 <- new_factory("new_factory_1", move_in = FALSE)
#' f2 <- new_factory("new_factory_2", include_template = FALSE, move_in = TRUE)
#' \dontshow{
#' unlink(f1, recursive = TRUE)
#' unlink(f2, recursive = TRUE)
#' setwd(.old_wd)
#' }
#' @export
new_factory <- function(name = "new_factory",
                        path = ".",
                        include_template = TRUE,
                        move_in = TRUE) {

  # create report factory folder
  root <- file.path(path, name)
  if (file.exists(root)) {
		stop("Directory '", name, "' already exists. Aborting.", call. = FALSE)
	} else {
		dir.create(root, recursive = TRUE)
	}

  # create report sources_folder
  dir.create(file.path(root, "report_sources"))

  # copy over skeleton .gitignore
  copy_skeleton_file("skeleton.gitignore", dest = file.path(root, ".gitignore"))

  # copy over skeleton .Rproj
  copy_skeleton_file(
    "skeleton.Rproj", 
    dest = file.path(root, paste0(name, ".Rproj"))
  )

  # copy over README
  copy_skeleton_file("README.md", dest = root)
	
  # create .here
  file.create(file.path(root, ".here"))

  if (include_template) {
    # create data folders
    clean_folder <- file.path(root, "data", "clean")
    dir.create(clean_folder, recursive = TRUE)
    raw_folder <- file.path(root, "data", "raw")
    dir.create(raw_folder, recursive = TRUE)

    # create scripts folder
    dir.create(file.path(root, "scripts"))

    # copy example report over
    copy_skeleton_file("example_report.Rmd", file.path(root, "report_sources"))
  }

  if (move_in) {
    if (rstudioapi::isAvailable()) {
      rstudioapi::openProject(file.path(root, paste0(name, ".Rproj")))
		} else {
      setwd(root)
    }
  }
  invisible(root)
}


copy_skeleton_file <- function(file, dest) {
  f <- system.file("skeletons", file, package = "reportfactory")
  file.copy(f, dest)
}
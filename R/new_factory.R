#' Create a new report factory
#'
#' This function can be used to create a new report factory. By default, the
#' factory is created with a template of report, and the working environment is
#' moved to the newly created factory.
#'
#' @param factory The name of the report factory to be created.
#' @param path The folder where the report factory should be created.  This
#'   will default to the current directory.
#' @param report_sources The name of the folder to be used for report
#'   templates; defaults to 'report_sources/'.
#' @param outputs The name of the folder to be used for saving the built
#'   reports; defaults to 'outputs/'.
#' @param move_in A `logical` indicating if the current session should move into
#'   the created factory; defaults to `TRUE`. If `use_rproj` is also TRUE and
#'   RStudio is being used then the corresponding project will be opened.
#' @param create_README A `logical` indicating if a 'README' file should be
#'   created; defaults to TRUE.
#' @param create_example_report A `logical` indicating if `new_factory()` should
#'   create an example report in the 'report_sources' folder along with some
#'   example data in the 'data/raw' folder; defaults to TRUE.
#' @param create_data_folders a `logical` indicating if `new_factory()` should
#'   create folders to store data; defaults to TRUE.
#' @param create_scripts_folder a `logical` indicating if `new_factory()` should
#'   create folders to store R scripts; defaults to TRUE.
#' @param use_here a `logical` indicating if `new_factory()` should create
#'   a `.here` file that can be used with `here::here()`; defaults to TRUE.
#' @param use_rproj a `logical` indicating if `new_factory()` should create
#'   a `.Rproj` file that can be used with RStudio; defaults to TRUE.
#' @param create_gitignore a `logical` indicating if `new_factory()` should create
#'   a minimal '.gitignore' file; defaults to TRUE.

#' @return the report factory folder location (invisibly)
#'
#' @details
#' Assuming the default names are used then `new_factory` will create a report
#' factory folder (called "new_factory") that includes:
#'
#' * `report_sources`: a folder for storing the .Rmd reports
#' * `outputs`: a folder storing the compiled reports
#' * `factory_config`: a control file used to anchor a report factory
#'
#' Depending on the values of the logical arguments, the factory may also
#' include:
#'
#' * `README.md`: Example README with instructions on how to use report factory.
#' * `.gitignore`: a file used to tell git to ignore certain files including the
#'   produced outputs in `outputs()`.
#' * `data/raw/`: a folder for storing raw data
#' * `data/raw/example_data.csv`: a set of data for use with the example report
#' * `data/clean/`: a folder for storing cleaned data
#' * `scripts/`: a folder to store additional code that may be called in reports
#' * `report_sources/example_report.Rmd`: an example .Rmd report template
#' * `.here`: a file to anchor calls to `here::here()`
#'
#' @examples
#' \dontshow{.old_wd <- setwd(tempdir())}
#' f1 <- new_factory("new_factory_1", move_in = FALSE)
#' f2 <- new_factory("new_factory_2", move_in = TRUE)
#' \dontshow{
#' unlink(f1, recursive = TRUE)
#' unlink(f2, recursive = TRUE)
#' setwd(.old_wd)
#' }
#'
#' @export
new_factory <- function(factory = "new_factory", path = ".",
                        report_sources = "report_sources",
                        outputs = "outputs", move_in = TRUE,
                        create_README = TRUE, create_example_report = TRUE,
                        create_data_folders = TRUE,
                        create_scripts_folder = TRUE, use_here = TRUE,
                        use_rproj = TRUE, create_gitignore = TRUE) {

  # create report factory folder
  root <- file.path(path, factory)
  if (dir.exists(root)) {
		stop("Directory '", factory, "' already exists. Aborting.", call. = FALSE)
	} else {
		dir.create(root)
	}

  # create report outputs folder
  dir.create(file.path(root, report_sources))

  # create report_sources folder
  dir.create(file.path(root, outputs))

  # create the factory configuration file
  write.dcf(
    x = data.frame(
      name = factory,
      report_sources = report_sources,
      outputs = outputs
    ),
    file = file.path(root, "factory_config")
  )

  # conditionally create the README
  if (create_README) {
    copy_skeleton_file("README.md", dest = root)
  }

    # conditionally create the data folders
  if (create_data_folders) {
    clean_folder <- file.path(root, "data", "clean")
    dir.create(clean_folder, recursive = TRUE)
    raw_folder <- file.path(root, "data", "raw")
    dir.create(raw_folder, recursive = TRUE)
  }

  # conditionally create the scripts folder
  if (create_scripts_folder) {
    dir.create(file.path(root, "scripts"))
  }

  # create .here file
  if (use_here) {
    file.create(file.path(root, ".here"))
  }

  if (use_rproj && rstudioapi::isAvailable()) {
    rstudioapi::initializeProject(root)
  } else if (use_rproj) {
    copy_skeleton_file(
      "skeletonRproj",
      dest = file.path(root, paste0(factory, ".Rproj"))
    )
  }

  # copy over skeleton .gitignore
  if (create_gitignore) {
    copy_skeleton_file("skeleton.gitignore", dest = file.path(root, ".gitignore"))
  }

  # conditionally copy over the example report and data
  if (create_example_report) {
    if (create_data_folders) {
      copy_skeleton_file("example_report.Rmd", file.path(root, report_sources))
      f <- system.file(
        "extdata", "example_data.csv",
        package = "reportfactory",
        mustWork = TRUE
      )
      file.copy(f, raw_folder)
    } else {
      stop("The example report can only be created if create_data_folders = TRUE")
    }
  }

  if (move_in && use_rproj && rstudioapi::isAvailable()) {
    rstudioapi::openProject(file.path(root, paste0(factory, ".Rproj")))
  } else if (move_in) {
    setwd(root)
  }
  invisible(root)
}

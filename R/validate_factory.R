#' Inspect and validate the content of a factory
#'
#' `validate_factory()` can be used to inspect the content of a factory and make
#' everything looks fine. This includes various sanity checks listed in details
#' that will error if a problem is found.
#' 
#' @inheritParams compile_reports
#' @param allow_duplicates A logical indicating duplicate filenames are
#'   allowed across folders.
#'
#' @details
#' Checks run on the factory include:
#'   * the factory directory exists;
#'   * the factory_config file exist;
#'   * all mandatory folders exist - by default these are 'report_sources/'
#'     and 'outputs/';
#'   * (optionally) all .Rmd reports have unique names once outside their
#'     folders.
#' 
#' @return A list with 4 entries:
#'   * root - the root folder path of the factory;
#'   * factory_name - the name of the report factory;
#'   * report_sources - the name of the report_sources folder; and
#'   * outputs - the name of the outputs folder.
#'
#' @export
validate_factory <- function(factory = ".", allow_duplicates = TRUE) {

  # this finds the folder containing factory_config or errors if not possible
  root <- factory_root(factory)

  # load configuration
  config <- as.data.frame(read.dcf(fs::path(root, "factory_config")))

  # the factory name is present in factory_config
  factory_name <- config$name
  if (is.null(factory_name)) {
    stop(
      "'name' is missing from factory_config.\n",
      "       Have you edited the file by mistake?",
      call. = FALSE
    )
  }

  # the factory folder matches the name from factory_config
  folder <- fs::path_split(root)
  folder <- folder[[1]][length(folder[[1]])]
  if (folder != factory_name) {
    stop(
      "Have you renamed the factory?\n",
      sprintf(
        "Expecting factory to be called '%s' not '%s'. Please rename", 
        factory_name,
        folder      
      ),
      call. = FALSE
    )
  }

  # report_sources is present in factory_config
  report_sources <- config$report_sources
  if (is.null(report_sources)) {
    stop(
      "'report_sources' is missing from factory_config.\n",
      "       Have you edited the file by mistake?",
      call. = FALSE
    )
  }

  # the report_source folder matches the name from factory_config
  pth <- fs::path(root, report_sources)
  if (!fs::dir_exists(pth)) {
    stop(
      sprintf(
        "Folder '%s' does not exist.  Have you renamed it by mistake?",
        report_sources
      ),
      call. = FALSE
    )
  }
  
  # outputs is present in factory_config
  outputs <- config$outputs
  if (is.null(outputs)) {
    stop(
      "'outputs' is missing from factory_config.\n",
      "       Have you edited the file by mistake?",
      call. = FALSE
    )
  }

  # the outputs folder matches the name from factory_config
  pth <- fs::path(root, outputs)
  if (!fs::dir_exists(pth)) {
    stop(
      sprintf(
        "Folder '%s' does not exist.  Have you renamed it by mistake?",
        outputs
      ),
      call. = FALSE
    )
  }
    
  # optionally, check for duplicate filenames
  if (!allow_duplicates) {
    # check that all reports are unique
    filepaths <- fs::dir_ls(
      fs::path(root, report_sources),
      type = "file",
      recurse = TRUE,
      regexp = "\\.[rR]md$"
    )

    if (length(filepaths) > 0) {
      filenames <- tolower(fs::path_file(filepaths))
      dups <- duplicated(filenames) | duplicated(filenames, fromLast = TRUE)
      dups <- filepaths[dups]
      if (length(dups) > 0) {
        msg <- sprintf(
          "Be aware that the following reports have duplicated filename:\n%s",
          paste(dups, collapse = "\n")
        )
        stop(msg, call. = FALSE)
      }
    }
  }

  list(
    root = root,
    factory_name = factory_name,
    report_sources = report_sources,
    outputs = outputs
  )
}

#' Inspect and validate the content of a factory
#'
#' `validate_factory()` can be used to inspect the content of a factory and make
#' everything looks fine. This includes various sanity checks listed in details
#' that will error if a problem is found.
#' 
#' @inheritParams compile_reports
#'
#' @details
#' Checks run on the factory include:
#'   * the factory directory exists;
#'   * the factory_config file exist;
#'   * all mandatory folders exist - by default these are 'report_sources/'
#'     and 'outputs/';
#' 
#' @return A list with 4 entries:
#'   * root - the root folder path of the factory;
#'   * factory_name - the name of the report factory;
#'   * report_sources - the name of the report_sources folder; and
#'   * outputs - the name of the outputs folder.
#'
#' @export
validate_factory <- function(factory = ".") {

  # this finds the folder containing factory_config or errors if not possible
  root <- factory_root(factory)

  # load configuration
  config <- as.data.frame(read.dcf(file.path(root, "factory_config")))

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
  folder <- basename(root)
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
  pth <- file.path(root, report_sources)
  if (!dir.exists(pth)) {
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
  pth <- file.path(root, outputs)
  if (!dir.exists(pth)) {
    stop(
      sprintf(
        "Folder '%s' does not exist.  Have you renamed it by mistake?",
        outputs
      ),
      call. = FALSE
    )
  }

  list(
    root = root,
    factory_name = factory_name,
    report_sources = report_sources,
    outputs = outputs
  )
}

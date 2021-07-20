#' List dependencies of reports within a factory
#'
#' This function can be used to list package dependencies based of the reports
#'   and R scripts within the factory.
#'
#' @inheritParams compile_reports
#' @param missing A logical indicating if only missing dependencies should be
#'   listed (`TRUE`); otherwise, all packages needed in the reports are listed;
#'   defaults to `FALSE`.
#' @param check_r If true, R scripts contained within the factory will also be
#'   checked. Note that this will error if the script cannot be parsed.
#' @param exclude_readme If TRUE (default) README files will not be checked for
#'   dependencies.
#'
#' @note This function requires that any R scripts present in the factory are
#'   valid syntax else the function will error.
#'
#' @return A character vector of package dependencies.
#'
#' @export
list_deps <- function(factory = ".", missing = FALSE, check_r = TRUE, exclude_readme = TRUE) {

  tmp <- suppressMessages(validate_factory(factory))
  root <- tmp$root
  config <- as.data.frame(read.dcf(file.path(root, "factory_config")))
  report_sources <- config$report_sources
  root_report_sources <- file.path(root, report_sources)
  root_scripts <- file.path(root, "scripts")
  root_to_check <- c(root_report_sources, root_scripts)

  # Find dependencies in R files
  r_files <- list.files(root_to_check, pattern = "\\.[Rr]$", recursive = TRUE, full.names = TRUE)
  r_files_deps <- character(0)
  if (length(r_files) && check_r) {
    r_files_deps <- list_r_file_deps(r_files)
  }

  # Find dependencies in Rmd files. We knit the files first to ensure only
  # dependencies of code that is actually run are returned.
  op <- options(knitr.purl.inline = TRUE)
  on.exit(options(op))
  rmd_files <- list.files(root_to_check, pattern = "\\.[Rr]md$", recursive = TRUE, full.names = TRUE)
  if (exclude_readme) {
    readme <- list.files(pattern = "README\\.Rmd", recursive = TRUE, ignore.case = TRUE, full.names = TRUE)
    rmd_files <- rmd_files[!rmd_files %in% readme]
  }

  rmd_files_deps <- character(0)
  if (length(rmd_files)) {
    d <- tempdir()
    fd <- sub(pattern = "(.*)\\..*$", replacement = "\\1", basename(rmd_files))
    fd <- vapply(fd, function(x) file.path(d, x), character(1))
    on.exit(unlink(fd), add = TRUE)
    fefil <- tempfile()
    on.exit(unlink(fefil), add = TRUE)
    fe <- file(fefil, "w")
    sink(fe, type = "message")
    mapply(
      function(x,y) try(knitr::purl(input = x, output = y, quiet = TRUE, documentation = 0), silent = TRUE),
      rmd_files,
      fd
    )
    sink(type = "message")
    close(fe)
    rmd_files_deps <- c("rmarkdown", list_r_file_deps(fd))
  }

  deps <- unique(c(r_files_deps, rmd_files_deps))
  if (missing) {
    installed <- basename(find.package(deps))
    deps <- setdiff(deps, installed)
  }

  deps
}

list_r_file_deps <- function(filepaths) {

  dat <- vapply(
    filepaths,
    function(x) paste(as.character(parse(x)), collapse = "\n"),
    character(1)
  )

  colon_string <- r"---{([a-zA-Z][\w.]*)(?=:{2,3})}---"
  colon_greg <- gregexpr(colon_string, dat, perl = TRUE)
  colon_deps <- unlist(regmatches(dat, colon_greg), use.names = FALSE)

  lib_string <- r"{(?<=library\(|require\()([a-zA-Z][\w.]*)}"
  lib_greg <- gregexpr(lib_string, dat, perl = TRUE)
  lib_deps <- unlist(regmatches(dat, lib_greg), use.names = FALSE)

  unique(c(lib_deps, colon_deps))
}

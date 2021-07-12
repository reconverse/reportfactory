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
#'
#' @note This function requires that any R scripts present in the factory are
#'   valid syntax else the function will error.
#'
#' @return A character vector of package dependencies.
#'
#' @export
list_deps <- function(factory = ".", missing = FALSE, check_r = TRUE) {

  tmp <- suppressMessages(validate_factory(factory))
  root <- tmp$root

  # Find dependencies in R files
  r_files <- list.files(root, pattern = "\\.[Rr]$", recursive = TRUE, full.names = TRUE)
  r_files_deps <- character(0)
  if (length(r_files) && check_r) {
    r_files_deps <- list_r_file_deps(r_files)
  }

  # Find dependencies in Rmd files. We knit the files first to ensure only
  # dependencies of code that is actually run are returned.
  op <- options(knitr.purl.inline = TRUE)
  on.exit(options(op))
  rmd_files <- list.files(root, pattern = "\\.[Rr]md$", recursive = TRUE, full.names = TRUE)
  rmd_files_deps <- character(0)
  if (length(rmd_files)) {
    d <- tempdir()
    fd <- sub(pattern = "(.*)\\..*$", replacement = "\\1", basename(rmd_files))
    fd <- vapply(fd, function(x) file.path(d, x), character(1))
    mapply(function(x,y) knitr::purl(input = x, output = y, documentation = 0), rmd_files, fd)
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

  colon_string <- r"---{([a-zA-Z][\w.]*)(?=:){2,3}}---"
  colon_greg <- gregexpr(colon_string, dat, perl = TRUE)
  colon_deps <- unlist(regmatches(dat, colon_greg), use.names = FALSE)

  lib_string <- r"{(?<=library\(|require\()([a-zA-Z][\w.]*)}"
  lib_greg <- gregexpr(lib_string, dat, perl = TRUE)
  lib_deps <- unlist(regmatches(dat, lib_greg), use.names = FALSE)

  unique(c(lib_deps, colon_deps))
}

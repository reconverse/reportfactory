#' List dependencies of reports within a factory
#'
#' This function can be used to list package dependencies based of the reports
#' within the factory. It is a wrapper for \code{checkpoint::scanForPackages}.
#'
#' @inheritParams compile_reports
#' @param missing A logical indicating if only missing dependencies should be
#'   listed (`TRUE`); otherwise, all packages needed in the reports are listed;
#'   defaults to `FALSE`
#'
#' @return A character vector of package dependencies.
#'
#' @export
list_deps2 <- function(factory = ".", missing = FALSE) {

  tmp <- suppressMessages(validate_factory(factory))
  root <- tmp$root

  # Find dependencies in R files
  r_files <- list.files(root, pattern = "\\.[Rr]$", recursive = TRUE, full.names = TRUE)
  r_files_deps <- character(0)
  if (length(r_files)) r_files_deps <- list_r_file_deps(r_files)

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
  dat <- vapply(filepaths, function(x) readChar(x, file.size(x)), character(1))
  lib_string <- gregexec(r"{(?:library|require)\(([a-zA-Z][\w.]*)\)}", dat, perl = TRUE)
  colon_string <- gregexec(r"---{([a-zA-Z][\w.]*)\:{2,3}}---", dat, perl = TRUE)
  lib_deps <- capture_packages(lib_string, dat)
  colon_deps <- capture_packages(colon_string, dat)
  unique(c(lib_deps, colon_deps))
}

capture_packages <- function(greg, dat) {
  pkgs <- regmatches(dat, greg)
  deps <- character()
  any_present <- vapply(pkgs, function(x) length(x) > 0, logical(1))
  if (any(any_present)) {
    pkgs <- pkgs[any_present]
    deps <- unlist(lapply(pkgs, function(x) x[2, ]), use.names = FALSE)
  }
}


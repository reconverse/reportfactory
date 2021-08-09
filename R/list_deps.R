#' List dependencies of reports within a factory
#'
#' List package dependencies based on the reports and scripts within the
#'   report_sources and scripts directories respectively.
#'
#' @inheritParams compile_reports
#' @param missing A logical indicating if only missing dependencies should be
#'   listed (`TRUE`); otherwise, all packages needed in the reports are listed;
#'   defaults to `FALSE`.
#' @param check_r If true, R scripts contained within the factory will also be
#'   checked. Note that this will error if the script cannot be parsed.
#' @param exclude_readme If TRUE (default) README files will not be checked for
#'   dependencies.
#' @param parse_first If `TRUE` code will first be parsed for validity and
#'   unevaluated Rmd chunks will not be checked for dependencies. The default
#'   value is `FALSE` and, in this case, files will simply be checked line by
#'   line for calls to `library`, `require` or use of double, `::`, and triple,
#'   `:::` function calls.
#'
#' @note This function requires that any R scripts present in the factory are
#'   valid syntax else the function will error.
#'
#' @return A character vector of package dependencies.
#'
#' @export
list_deps <- function(factory = ".", missing = FALSE, check_r = TRUE,
                      exclude_readme = TRUE, parse_first = FALSE) {

  tmp <- suppressMessages(validate_factory(factory))
  root <- tmp$root
  config <- as.data.frame(read.dcf(file.path(root, "factory_config")))
  report_sources <- config$report_sources
  root_report_sources <- file.path(root, report_sources)
  root_scripts <- file.path(root, "scripts")
  root_to_check <- c(root_report_sources, root_scripts)

  # List of R files
  r_files <- list.files(
    root_to_check,
    pattern = "\\.[Rr]$",
    recursive = TRUE,
    full.names = TRUE
  )

  # List of Rmd files
  rmd_files <- list.files(
    root_to_check, pattern = "\\.[Rr]md$",
    recursive = TRUE,
    full.names = TRUE
  )
  if (exclude_readme) {
    readme <- list.files(
      pattern = "README\\.Rmd",
      recursive = TRUE,
      ignore.case = TRUE,
      full.names = TRUE
    )
    rmd_files <- rmd_files[!rmd_files %in% readme]
  }

  # Find R file dependencies
  r_files_deps <- character(0)
  if (length(r_files) && check_r) {
    r_files_deps <- list_r_file_deps(r_files, parse = parse_first)
  }

  # Find Rmd file dependencies
  op <- options(knitr.purl.inline = TRUE)
  on.exit(options(op))
  rmd_files_deps <- character(0)
  if (length(rmd_files)) {
    if (parse_first) {
      d <- tempdir()
      fd <- sub(pattern = "(.*)\\..*$", replacement = "\\1", basename(rmd_files))
      fd <- vapply(fd, function(x) file.path(d, x), character(1))
      on.exit(unlink(fd), add = TRUE)
      fefil <- tempfile()
      on.exit(unlink(fefil), add = TRUE)
      fe <- file(fefil, "w")
      sink(fe, type = "message")
      mapply(
        function(x,y) {
          try(
            knitr::purl(input = x, output = y, quiet = TRUE, documentation = 0),
            silent = TRUE
          )
        } ,
        rmd_files,
        fd
      )
      sink(type = "message")
      close(fe)
      rmd_files_deps <- c("rmarkdown", list_r_file_deps(fd, parse = TRUE))
    } else {
      rmd_files_deps <- c("rmarkdown", list_r_file_deps(rmd_files, parse = FALSE))
    }
  }

  # return unique dependencies
  deps <- unique(c(r_files_deps, rmd_files_deps))
  if (missing) {
    installed <- basename(find.package(deps))
    deps <- setdiff(deps, installed)
  }

  deps
}

# -------------------------------------------------------------------------

list_r_file_deps <- function(filepaths, parse = FALSE) {

  if (parse) {
    f <- function(x) paste(as.character(parse(x)), collapse = "\n")
  } else {
    f <- function(x) paste(readLines(x), collapse = "\n")
  }

  dat <- vapply(filepaths, f, character(1))

  colon_string <- r"---{([a-zA-Z][\w.]*)(?=:{2,3})}---"
  colon_greg <- gregexpr(colon_string, dat, perl = TRUE)
  colon_deps <- unlist(regmatches(dat, colon_greg), use.names = FALSE)

  lib_string <- r"{(?<=library\(|require\()([a-zA-Z][\w.]*)}"
  lib_greg <- gregexpr(lib_string, dat, perl = TRUE)
  lib_deps <- unlist(regmatches(dat, lib_greg), use.names = FALSE)

  unique(c(lib_deps, colon_deps))
}

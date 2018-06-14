#' Compile an rmarkdown report
#'
#' This function can be used to compile a report using its name, or a partial
#' match for its name. The full path needs not be specified, but reports are
#' expected to be inside the \code{report_sources} folder (or any subfolder
#' within). Outputs will be generated in a named and time-stamped directory
#' within \code{report_outputs}.
#'
#' @export
#'
#' @author Thibaut Jombart \email{thibautjombart@@gmail.com}
#' 
#' @param file the full path, or a partial, unambiguous match for the Rmd
#'   report to be compiled.
#'
#' @param quiet a logical indicating if messages from rmarkdown compilation
#'   should be displayed; \code{FALSE} by default.
#'
#' @param ... further arguments passed to \code{rmarkdown::render}.
#'

compile_report <- function(file, quiet = TRUE, ...) {
  if (!require("here")) {
    stop("package 'here' is not installed")
  }

  if (length(file) > 1L) {
    stop("more than one report asked from 'compile_report'")
  }

  rmd_path <- grep(".Rmd",
                   dir(here::here("report_sources"),
                       recursive = TRUE, pattern = file,
                       full.names = TRUE),
                   value = TRUE)

  if (length(rmd_path) == 0L) {
    stop(sptrinf("cannot find a source file for %s", file))
  }

  base_name <- extract_base(rmd_path)
  date <- extract_date(file)
  if (is.na(date)) {
    stop(
      sprintf("cannot identify a date in format yyyy-mm-dd in %s", file)
      )
  }

  shorthand <- paste0(base_name, "_", date)

  odir <- getwd()
  on.exit(setwd(odir))
  setwd(here::here("report_sources"))

  files_before <- dir()
  files_before <- unique(sub("~$", "", files_before))

  cat(sprintf("\n/// compiling report: '%s'", shorthand))
  output_file <- rmarkdown::render(rmd_path, quiet = quiet, ...)
  cat(sprintf("\n/// '%s' done!\n", shorthand))

  files_after <- dir(here::here("report_sources"))
  files_after <- unique(sub("~$", "", files_after))
  new_files <- setdiff(files_after,
                       files_before)
  new_files <- unique(c(new_files, output_file))

  if (!dir.exists(here::here("report_ouputs"))) {
    dir.create(here::here("report_ouputs"))
  }
  
  datetime <- sub(" ", "_", as.character(Sys.time()))
  report_dir <- paste0(here("report_outputs"),
                       "/", base_name, "_", date)
  dir.create(report_dir, showWarnings = FALSE)
  output_dir <- paste0(report_dir, "/compiled_", datetime)
  dir.create(output_dir)

  for (file in new_files) {
    destination <- paste(output_dir, file, sep = "/")
    file.rename(file, destination)
  }

}

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
#'   should be displayed; \code{TRUE} by default.
#'
#' @param factory the path to a report factory; defaults to the current working
#'   directory
#'
#' @param ... further arguments passed to \code{rmarkdown::render}.
#'

compile_report <- function(file, quiet = FALSE, factory = getwd(), ...) {

  validate_factory(factory)

  odir <- getwd()
  on.exit(setwd(odir))
  setwd(factory)

  if (length(file) > 1L) {
    stop("more than one report asked from 'compile_report'")
  }

  rmd_path <- grep(".Rmd",
                  dir(find_file("report_sources"),
                      recursive = TRUE, pattern = file,
                      full.names = TRUE),
                  value = TRUE, ignore.case = TRUE)
  rmd_path <- ignore_tilde(rmd_path)

  file_dir <- dirname(rmd_path)

  if (length(rmd_path) == 0L) {
    stop(sprintf("cannot find a source file for %s", file))
  }

  base_name <- extract_base(rmd_path)
  date <- extract_date(file)
  if (is.na(date)) {
    stop(
      sprintf("cannot identify a date in format yyyy-mm-dd in %s", file)
      )
  }

  shorthand <- paste0(base_name, "_", date)
  setwd(file_dir)

  files_before <- list.files(recursive = TRUE)
  files_before <- unique(sub("~$", "", files_before))


  message(sprintf("\n/// compiling report: '%s'", shorthand))
  output_file <- rmarkdown::render(rmd_path, quiet = quiet, ...)
  message(sprintf("\n/// '%s' done!\n", shorthand))

  files_after <- list.files(recursive = TRUE)

  files_after <- unique(ignore_tilde(files_after))
  new_files <- setdiff(files_after,
                       files_before)
  new_files <- c(new_files, sub(file_dir, "", output_file))
  new_files <- unique(new_files)

  if (!dir.exists(find_file("report_outputs"))) {
    dir.create(find_file("report_outputs"), FALSE, TRUE)
  }

  datetime <- sub(" ", "_", as.character(Sys.time()))
  datetime <- gsub(":", "-", datetime)
  report_dir <- file.path(find_file("report_outputs"),
                          paste(base_name, date, sep = "_"))
  dir.create(report_dir, FALSE, TRUE)
  output_dir <- paste0(report_dir, "/compiled_", datetime)
  output_dir <- file.path(report_dir,
                          paste("compiled", datetime, sep = "_"))
  dir.create(output_dir, FALSE, TRUE)

  for (file in new_files) {
    destination <- file.path(output_dir, file)
    move_file(file, destination)
  }

}

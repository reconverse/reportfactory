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
                   value = TRUE)

  file_dir <- locate_file_directory(rmd_path)

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

  files_before <- dir(recursive = TRUE)
  files_before <- unique(sub("~$", "", files_before))


  cat(sprintf("\n/// compiling report: '%s'", shorthand))
  output_file <- rmarkdown::render(rmd_path, quiet = quiet, ...)
  cat(sprintf("\n/// '%s' done!\n", shorthand))

  files_after <- dir(recursive = TRUE)
  files_after <- unique(sub("~$", "", files_after))
  new_files <- setdiff(files_after,
                       files_before)
  new_files <- c(new_files, sub(file_dir, "", output_file))
  new_files <- unique(new_files)

  if (!dir.exists(find_file("report_outputs"))) {
    dir.create(find_file("report_outputs"))
  }

  datetime <- sub(" ", "_", as.character(Sys.time()))
  datetime <- gsub(":", "-", datetime)
  report_dir <- paste0(find_file("report_outputs"),
                       "/", base_name, "_", date)
  dir.create(report_dir, showWarnings = FALSE)
  output_dir <- paste0(report_dir, "/compiled_", datetime)
  dir.create(output_dir)

  for (file in new_files) {
    destination <- paste(output_dir, file, sep = "/")
    file.rename(file, destination)
  }

}

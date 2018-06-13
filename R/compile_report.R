
## This function will compile a report whose path or short name is provided.

#' @param file the full path, or a partial, unambiguous match for the Rmd
#'   report to be compiled
#'
#' @param ... further arguments passed to \code{rmarkdown::render}
#'

compile_report <- function(file, ...) {
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

  base_name <- sub("^.*/", "", rmd_path)
  base_name <- sub(".[0-9]{4}-[0-9]{2}-[0-9]{2}.Rmd", "", base_name)
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

  cat("/// compiling report:", shorthand, "\n")
  rmarkdown::render(rmd_path, ...)
  cat("/// report", shorthand, "done\n")

  files_after <- dir(here::here("report_sources"))
  files_after <- unique(sub("~$", "", files_after))
  new_files <- setdiff(files_after,
                       files_before)

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

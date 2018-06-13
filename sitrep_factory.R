
## Run this script to recompile all reports
if (!require("here")) {
  stop("package 'here' is not installed")
}





## This function will compile a report for a given date, entered as format
## yyyy-mm-dd, e.g. 2018-06-13

compile_report <- function(date) {

  shorthand <- paste0(date, ".Rmd")
  rmd_path <- dir(here::here("report_sources"),
                  pattern = paste0(shorthand, "$"),
                  full.names = TRUE)
  base_name <- sub("^.*/", "", rmd_path)
  base_name <- sub("_[0-9]{4}-[0-9]{2}-[0-9]{2}.Rmd", "", base_name)

  odir <- getwd()
  on.exit(setwd(odir))
  setwd(here::here("report_sources"))

  files_before <- dir()
  files_before <- unique(sub("~$", "", files_before))

  cat("/// compiling report:", shorthand, "\n")
  rmarkdown::render(rmd_path)
  cat("/// report", shorthand, "done\n")

  files_after <- dir(here::here("report_sources"))
  files_after <- unique(sub("~$", "", files_after))
  new_files <- setdiff(files_after,
                       files_before)

  datetime <- sub(" ", "_", as.character(Sys.time()))
  report_dir <- paste0(here("report_outputs"),
                       "/", base_name, "_", date)
  dir.create(report_dir)
  output_dir <- paste0(report_dir, "/compiled_", datetime)
  dir.create(output_dir)

  for (file in new_files) {
    destination <- paste(output_dir, file, sep = "/")
    file.rename(file, destination)
  }

}



## Compile all documents, or the most recent one

## all: logical, if TRUE all documents are recompiled, otherwise only the most
## recent one is

update_reports <- function(all = FALSE) {

  report_sources <- dir(here("report_sources"), pattern = ".Rmd$")
  dates <- sub("^.*_", "", report_sources)
  dates <- sub("[.]Rmd$", "", dates)

  if (all) {
    lapply(dates, compile_report)
  } else {
    latest <- as.character(max(as.Date(dates)))
    compile_report(latest)
  }

}





last_report <- function() {

  report_sources <- dir(here("report_sources"), pattern = ".Rmd$")
  dates <- sub("^.*_", "", report_sources)
  dates <- sub("[.]Rmd$", "", dates)
  last_date <- as.character(max(as.Date(dates)))
  out <- dir(here(), recursive = TRUE, pattern = last_date)
  out <- unique(sub("~$", "", out))
  out <- out[-grep("^data/", out)]
  out

}

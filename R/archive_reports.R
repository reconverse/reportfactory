#' Archive reports before a given date
#'
#' This places reports in a factory under an \code{_archive} directory,
#' preserving their original directory structure.
#'
#' @param factory a working directory that contains a valid reportfactory
#' @param before a Date or POSIXt object indicating the earliest date keep. All
#'   dates before this date will be archived.
#'
#' @export
#' @return a named logical vector of archived reports. Successfully archived
#'   reports will return TRUE and unsuccessfully archived will return FALSE
#'
archive_reports <- function(factory = getwd(), before = NULL) {
  if (is.null(before)) {
    stop("before must not be NULL")
  }
  if (!inherits(before, c("Date", "POSIXt"))) {
    stop("before must be a date")
  }

  validate_factory(factory)

  odir <- getwd()
  on.exit(setwd(odir))
  setwd(factory)


  rmd_path <- grep(".Rmd",
                  dir(factory_path("report_sources"),
                      recursive = TRUE),
                  value = TRUE, ignore.case = TRUE)
  rmd_path <- ignore_tilde(rmd_path)
  rmd_path <- rmd_path[!grepl("_archive/", rmd_path)]
  date <- as.Date(extract_date(basename(rmd_path)))

  to_archive <- rmd_path[date < as.Date(before)]


  wins <- logical(length(to_archive))
  names(wins) <- to_archive
  for (arc in to_archive) {
    suppressWarnings({
      dir.create(file.path(factory, "report_sources", "_archive", dirname(arc)),
                 recursive = TRUE,
                 mode = "0755")
    })
    res <- file.copy(from = file.path(factory, "report_sources", arc),
                     to = file.path(factory, "report_sources", "_archive", arc)
                     )

    if (res) wins[arc] <- TRUE
  }
  res <- file.remove(file.path(factory, "report_sources", to_archive[wins]))
  names(res) <- to_archive[wins]
  res

}

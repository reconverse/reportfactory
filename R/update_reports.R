#' Compile reports within the factory
#'
#' This function is used to compile several reports stored in the factory,
#' inside the \code{report_sources} folder (or any sub-folder within). Outputs
#' will be generated in a named and time-stamped directory within
#' \code{report_outputs}. By default, only the most recent version of each
#' report is compiled, but an option permits to compile all reports. Reports are
#' expected to be \code{rmarkdown} documents (\code{.Rmd} extension), named
#' using the following convention: \code{[name]_[date].Rmd}, where \code{date}
#' must have the format \code{yyy-mm-dd}, for instance 2018-12-01 for the 1st
#' December 2018; \code{[name]} should be any explicit name, without blank
#' spaces or accentuated characters. For instance,
#' \code{bird_phylogeny_2017-04-01.Rmd} or \code{estimation_R_2018-02-04.Rmd}
#' are good file names.
#'
#' @export
#'
#' @author Thibaut Jombart \email{thibautjombart@@gmail.com}
#'
#' @param all a logical indicating if all reports should be compiled; it
#'   defaults to \code{FALSE}, in which case only the latest versions of each
#'   reports will be compiled.
#'
#' @param quiet a logical indicating if messages from R Markdown compilation
#'   should be displayed; \code{FALSE} by default.
#'
#' @param encoding a character string indicating which encoding should be used
#'   when compiling the document; defaults to `"UTF-8"`, which ensures that
#'   non-ascii characters work across different systems
#'
#' @param clean_report_sources a logical indicating if undesirable files and
#'   folders in the `report_sources` folder should be cleaned before
#'   compilation; defaults to `FALSE` (no cleanup)
#'
#' @param remove_cache a logical passed to `clean_report_sources`, indicating if
#'   the `cache` folder should be considered as undesirable in `report_sources`;
#'   defaults to `TRUE`, in which case `cache` will also be removed if
#'   `clean_report_sources` is `TRUE`
#'
#' @param ... further arguments passed to \code{rmarkdown::render}.
#'
#' @inheritParams compile_report
#' @inheritParams list_reports

update_reports <- function(factory = getwd(),
                           all = FALSE,
                           quiet = TRUE,
                           encoding = "UTF-8",
                           ignore_archive = TRUE,
                           clean_report_sources = FALSE,
                           remove_cache = TRUE, ...) {

  validate_factory(factory)

  odir <- getwd()
  on.exit(setwd(odir))
  setwd(factory)

  report_sources <- list_reports(ignore_archive = ignore_archive)
  dates <- extract_date(report_sources)
  types <- extract_base(report_sources)

  if (all) {
    lapply(report_sources,
           compile_report,
           quiet = quiet,
           encoding = encoding,
           clean_report_sources = clean_report_sources,
           remove_cache = remove_cache,
           ...)
  } else {
    sources_by_type <- split(report_sources, types)
    for (e in sources_by_type) {
      index_latest <- which.max(as.Date(extract_date(e)))
      compile_report(e[index_latest],
                     quiet = quiet,
                     encoding = encoding,
                     clean_report_sources = clean_report_sources,
                     remove_cache = remove_cache,
                     ...)
    }
  }

  invisible(NULL)
}

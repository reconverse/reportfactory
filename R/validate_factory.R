
#' Inspect and validate the content of a factory
#'
#' This function can be used to inspect the content of a factory and make sure
#' it looks fine. This includes various sanity checks listed in details. The
#' function returns \code{TRUE} if all checks were done without errors, and
#' \code{FALSE} otherwise; note that warnings do not count as \code{errors} and
#' therefore can result in \code{TRUE} being returned.
#'
#' @details
#' Checks ran on the factory include:
#'
#' \itemize{
#'
#'  \item the directory exists
#'
#'  \item all mandatory files exist: .here, .gitignore
#'
#'  \item all mandatory folders exist: report_sources/
#'
#'  \item all .Rmd reports have unique names once outside their folders (to
#'  avoid conflicts in outputs)
#'
#' }
#'
#'
#' @export
#'
#' @author Thibaut Jombart \email{thibautjombart@@gmail.com}
#'
#' @inheritParams compile_report
#'
#' @param warnings A logical indicating if warnings should be issued; defaults to \code{TRUE}.
#'
#' @param errors A logical indicating if errors should be issued; defaults to \code{TRUE}.
#'
## #' @param quiet A logical indicating if messages should be hidden (\code{FALSE}, default)
## #'   or shown on the console (\code{TRUE})
#'

validate_factory <- function(factory = getwd(),
                             warnings = TRUE,
                             errors = TRUE) {


  ## check that the directory exists

  if (!dir.exists(factory)) {
    if (errors) {
      msg <- sprintf("the directory '%s' does not exist", factory)
      stop(msg)
    }
    return(FALSE)
  }

  odir <- getwd()
  on.exit(setwd(odir))
  setwd(factory)


  ## check that all files and folders are there

  content <- dir(all.files = TRUE)
  check_item <- function(x) {
    is_folder <- length(grep("/$", x)) > 0L
    f <- ifelse(is_folder, dir.exists, file.exists)

    if (!f(x)) {
      if (errors) {
        msg <- sprintf("%s '%s' is missing",
                       ifelse(is_folder, "folder", "file"),
                       x)
        stop(msg)
      }
      return(FALSE)
    } else {
      return(TRUE)
    }
  }
  expected <- c(".here", ".gitignore", "report_sources/")
  content_present <- vapply(expected, check_item, logical(1))
  if (!all(content_present)) {
    return(FALSE)
  }


  ## check that all reports are unique

  is_duplicate <- duplicated(list_reports())

  if (any(is_duplicate)) {
    if (errors){
      culprits <- list_reports()[is_duplicated]
      msg <- sprintf("the following reports are duplicated:\n%s",
                     paste(culprits, collapse = "\n"))
      stop(msg)
    }
    return(FALSE)
  }


  ## check that the report_sources/ only contains `Rmd` files
  files <- list.files("report_sources/", recursive = TRUE)
  is_rmd <- grep("[.]rmd$", tolower(files))
  not_rmd <- setdiff(seq_along(files), is_rmd)
  if (length(not_rmd) > 0L) {
    if (warnings) {
      culprits <- files[not_rmd]
      msg <- sprintf("the following files are not .Rmd:\n%s",
                     paste(culprits, collapse = "\n"),
                     "\nWe recommend only storing .Rmd in report_sources/",
                     "Store data, scripts etc. in separate folders and refer",
                     "to files using e.g. 'here::here(data/my_data.R)'")
      warning("msg")
    }
  }


  return(TRUE)
}

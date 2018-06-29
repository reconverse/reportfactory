
#' Inspect and validate the content of a factory
#'
#' This function can be used to inspect the content of a factory and make sure
#' it looks fine. This includes various sanity checks listed in details. The
#' function returns a list of error and warning messages.
#'
#' @details
#' Checks ran on the factory include (the result of a failure is indicated in brackets):
#'
#' \itemize{
#'
#'  \item the directory exists [error]
#'
#'  \item all mandatory files exist: .here, .gitignore [error]
#'
#'  \item all mandatory folders exist: report_sources/ [error]
#'
#'  \item all .Rmd reports have unique names once outside their folders (to
#'  avoid conflicts in outputs) [warning]
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


  out <- list(warnings = character(0),
              errors = character(0))

  ## check that the directory exists

  if (!dir.exists(factory)) {
      msg <- sprintf("the directory '%s' does not exist", factory)
      stop(msg)
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
      msg <- sprintf("%s '%s' is missing",
                     ifelse(is_folder, "folder", "file"),
                     x)
      out$errors <<- c(out$errors, msg)
    }
  }
  expected <- c(".here", ".gitignore", "report_sources/")
  for (e in expected) {
    check_item(e)
  }


  ## these checks rely on the existence of 'report_sources/'

  if (dir.exists("report_sources")) {
    ## check that all reports are unique


    files <- dir("report_sources",
                 recursive = TRUE, pattern = ".Rmd$",
                 ignore.case = TRUE, full.names = TRUE)
    files <- gsub(".*/", "", files)

    is_duplicated <- duplicated(files)

    if (any(is_duplicated)) {
      if (errors){
        culprits <- files[is_duplicated]
        msg <- sprintf("the following reports are duplicated:\n%s",
                       paste(culprits, collapse = "\n"))
        out$errors <- c(out$errors, msg)
      }

    }


    ## check that the report_sources/ only contains `Rmd` files

    files <- list.files("report_sources/", recursive = TRUE)
    files <- ignore_tilde(files)

    is_rmd <- grep("[.]rmd$", tolower(files))
    not_rmd <- setdiff(seq_along(files), is_rmd)
    if (length(not_rmd) > 0L) {
      if (warnings) {
        culprits <- files[not_rmd]
        msg <- sprintf(
          "the following files in 'report_sources/' are not .Rmd:\n%s",
          paste(culprits, collapse = "\n"),
          "\nWe recommend only storing .Rmd in report_sources/",
          "Store data, scripts etc. in separate folders and refer",
          "to files using e.g. 'here::here(data/my_data.R)'")
        out$warnings <- c(out$warnings, msg)
      }
    }

  }


  if (warnings) {
    if (length(out$warnings) > 0L) {
      msg <- paste(out$warnings, collapse = "\n")
      warning("the following warnings were found:\n", msg)
    }
  }


  if (errors) {
    if (length(out$errors) > 0L) {
      msg <- paste(out$errors, collapse = "\n")
      stop("the following errors were found:\n", msg)
    }
  }


  return(out)
}

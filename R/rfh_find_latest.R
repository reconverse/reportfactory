#' Find latest version of a file
#'
#' This function will scan recursively a directory, looking for files of a given
#' name (or matching a given regular expression). Files need to include a date
#' in a common format (detected automatically). The full path to the most recent
#' file will be returned.
#'
#' @author Thibaut Jombart
#' 
#' @param pattern a character string indicating the name of the file to look for (or
#'   regular expression)
#'
#' @param where the directory in which to look for the file
#'
#' @param quiet a `logical` indicating if messages should be displayed (`TRUE`,
#'   default), or not (`FALSE`)
#'
#' @param ... further arguments passed to [`list.files`](list.files)
#' 
rfh_find_latest <- function(pattern,
                            where = getwd(),
                            quiet = FALSE,
                            ...) {

  # Approach
  #
  # 1. check the directory provided as 'where' and make sure it exists
  #
  # 2. look recursively for 'pattern' in this directory; issue message if there
  # are no matches
  #
  # 3. extract dates as yyyy-mm-yy format for all returned files; issue message if dates are missing
  #
  # 4. return the full path to the latest file


  # step 1  
  if (!dir.exists(where)) {
    msg <- sprintf("directory '%s' does not exist",
                   where)
    stop(msg)
  }

  
  # step 2  
  all_files <- list.files(where, 
                          pattern = pattern,
                          full.names = TRUE,
                          recursive = TRUE,
                          ...)

  if (!length(all_files)) {
    msg <- sprintf("No file matching pattern '%s' found in '%s'",
                   pattern,
                   where)
    if (!quiet) message(msg)
    return(NULL)
  }
  


  # step 3: get dates; note that there could be multiple dates in the full path
  # to a file, and only the one in the basename is used
  base_files <- basename(all_files)
  file_dates <- extract_date(base_files)
  if (all(is.na(file_dates))) {
    msg <- "No 'yyyy-mm-dd' date in files matching requested pattern."
    stop(msg)
  }
  if (any(is.na(file_dates)) && !quiet) {
    msg <- "Some files matching requested pattern have no 'yyyy-mm-dd' date"
    message(msg)
  }
  last_file_index <- which.max(file_dates)
  out <- all_files[last_file_index]

  
  # step 4
  if (!quiet) {
    msg <- sprintf("Found file: '%s'",
                   base_files[last_file_index])
    message(msg)
  }
  out
}

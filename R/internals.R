#' Find the path to the root folder within a factory
#'
#' This function is used to find the fully expanded root path within a factory.
#'
#' @param directory the full path to the directory you are interested in.  If
#'   NULL (default) the function assumes you are already in a factory and will
#'   return the address of the containing factory root.
#'
#' @noRd
factory_root <- function(directory = NULL) {
  
  if(!is.null(directory)) {

    # error if the directory does not exist
    if (!fs::file_exists(directory)) {
      stop(
        sprintf("directory '%s' does not exist!\n", directory),
        call. = FALSE
      )
    }

    # error if directory is a file
    if (fs::is_file(directory)) {
      stop(
        sprintf("'%s' is a file, not a directory! Please correct\n", directory),
        call. = FALSE)
    }
    
    # find the folder that contains the factory_config file and error if it
    # does not exist
    odir <- setwd(directory)
    on.exit(setwd(odir))
    root <- tryCatch(
      rprojroot::find_root(rprojroot::has_file("factory_config")),
      error = function(e) {
        stop(
          sprintf("directory %s is not part of a report factory.\n", directory),
          call. = FALSE
        )
      }
    )
  } else {
    root <- tryCatch(
      rprojroot::find_root(rprojroot::has_file("factory_config")),
      error = function(e) {
        stop(
          "Cannot find a factory_config file within the current subtree.\n",
          "       Are you in the wrong folder?\n",
          call. = FALSE
        )
      }
    )
  }
  root
}
   
#' check whether a vector is "integer-like" to a given precision
#' 
#' @param x vector to check
#' @param tol desired tolerance
#' 
#' @noRd 
is.wholenumber <- function(x, tol = .Machine$double.eps^0.5)  {
  all(abs(x - round(x)) < tol)
}

#' copy a file from the skeleton directory
#' 
#' @param file name of the file you want to copy
#' @param dest destination to copy to
#' 
#' @noRd 
copy_skeleton_file <- function(file, dest) {
  f <- fs::path_package("reportfactory", "skeletons", file)
  fs::file_copy(f, dest)
}


#' Change part of the front yaml matter from an Rmarkdown file
#' 
#' This function was provided on Stack Overflow by user r2evans.
#' link: https://stackoverflow.com/a/62096216
#' user: 
#' @param input_file the .Rmd file
#' @param output_file where to save the changed output
#' @param ... named list of yaml to change
#' 
#' @noRd
change_yaml_matter <- function(input_file, ..., output_file) {
  input_lines <- readLines(input_file, warn = FALSE)
  delimiters <- grep("^---\\s*$", input_lines)
  if (!length(delimiters)) {
    stop("unable to find yaml delimiters")
  } else if (length(delimiters) == 1L) {
    if (delimiters[1] == 1L) {
      stop("cannot find second delimiter, first is on line 1")
    } else {
      # found just one set, assume it is *closing* the yaml matter;
      # fake a preceding line of delimiter
      delimiters <- c(0L, delimiters[1])
    }
  }
  delimiters <- delimiters[1:2]
  yaml_list <- yaml::yaml.load(input_lines[(delimiters[1]+1):(delimiters[2]-1)])

  dots <- list(...)
  yaml_list <- c(yaml_list[ setdiff(names(yaml_list), names(dots)) ], dots)

  output_lines <- c(
    if (delimiters[1] > 0) input_lines[1:(delimiters[1])],
    strsplit(yaml::as.yaml(yaml_list), "\n")[[1]],
    input_lines[ -(1:(delimiters[2]-1)) ]
  )

  if (missing(output_file)) {
    return(output_lines)
  } else {
    writeLines(output_lines, con = output_file)
    return(invisible(output_lines))
  }
}

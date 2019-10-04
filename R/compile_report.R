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
#' @param encoding a character string indicating which encoding should be used
#'   when compiling the document; defaults to `"UTF-8"`, which ensures that
#'   non-ascii characters work across different systems
#'
#' @param factory the path to a report factory; defaults to the current working
#'   directory
#'
#' @param ... further arguments passed to \code{rmarkdown::render}.
#'

compile_report <- function(file, quiet = FALSE, factory = getwd(),
                           encoding = "UTF-8", render_params = list(), ...) {

  ## This function will:
  
  ## 1. identify all files in report_sources prior to the compilation

  ## 2. compile a specific .Rmd file stored in report_sources/

  ## 3. identify all files in report_sources; new ones are those which where not
  ## around at step 1

  ## 4. move all outputs identified in 3. to a dedicated folder in
  ## report_outputs/
  
  validate_factory(factory)

  odir <- getwd()
  on.exit(setwd(odir))
  setwd(factory)

  if (length(file) > 1L) {
    stop("more than one report asked from 'compile_report'")
  }
  rmd_path <- grep(".Rmd",
                  dir(find_file("report_sources"),
                      recursive = TRUE, pattern = sprintf("^%s$", file),
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
  dirs_before <- list.dirs(recursive = TRUE)
  files_before <- unique(sub("~$", "", files_before))


  ## handle optional parameters passed through ...:

  ## we extract `params`, display
  ## some information to the console on parameters used, and generate some text
  ## that will be used to name the output folder
  
  dots <- list(...)
  has_params <- FALSE
  if (length(render_params) > 0) {
    
    ## remove unnamed parameters
    named <- names(render_params) != ""
    render_params <- render_params[named]
    
    if (length(render_params) > 0) {
      has_params <- TRUE

      ## convert the parameter values to txt and abbreviate them for display to
      ## console and for naming the output
      turn_to_character <- function(x, sep = "_") {
        out <- as.character(unlist(x))
        out <- paste(out, collapse = sep)
        out
      }

      params_as_txt_console <- lapply(render_params, turn_to_character, sep = " ")
      params_as_txt <- lapply(render_params, turn_to_character)
      
      long_values <- nchar(params_as_txt) > 8
      params_as_txt_console <- lapply(params_as_txt_console, substr, 1, 8)
      params_as_txt <- lapply(params_as_txt, substr, 1, 8)
      params_as_txt <- sub("-$", "", params_as_txt)
      params_as_txt <- sub("_$", "", params_as_txt)
      

      ## create character strings to be displayed to the console
      txt_display <- paste(names(render_params),
                           params_as_txt_console,
                           sep = ": ")
      txt_display[long_values] <- paste0(txt_display[long_values], "...")
      txt_display <- paste(txt_display, collapse = "\n")

      ## create character strings to be used for file naming
      txt_name_folder <- paste(names(render_params), params_as_txt,
                               sep = "_", collapse = "_")
      txt_name_folder <- sub("_$", "", txt_name_folder)

    }
  }


  ## display messages to the console
  message(sprintf("\n/// compiling report: '%s'", shorthand))
  output_file <- rmarkdown::render(rmd_path,
                                   quiet = quiet,
                                   encoding = encoding,
                                   envir = new.env(), # force clean environment
                                   params = render_params) # params can be passed here
  if (has_params) {
    message(sprintf("// using params: \n%s",
                    txt_display))
  }
  message(sprintf("\n/// '%s' done!\n", shorthand))

  files_after <- list.files(recursive = TRUE)
  dirs_after <- list.dirs(recursive = TRUE)

  files_after <- unique(ignore_tilde(files_after))
  new_files <- setdiff(files_after, files_before)
  new_files <- c(new_files, sub(file_dir, "", output_file))
  new_files <- unique(new_files)
  new_dirs <- unique(basename(setdiff(dirs_after, dirs_before)))

  if (!dir.exists(find_file("report_outputs"))) {
    dir.create(find_file("report_outputs"), FALSE, TRUE)
  }

  datetime <- sub(" ", "_", as.character(Sys.time()))
  datetime <- gsub(":", "-", datetime)
  report_dir <- file.path(find_file("report_outputs"),
                          paste(base_name, date, sep = "_"))
  dir.create(report_dir, FALSE, TRUE)

  ## add txt indicative of params if needed
  if (has_params) {
    output_dir <- paste0(report_dir,
                         "/compiled_",
                         txt_name_folder,
                         "_",
                         datetime)
  } else {
    output_dir <- paste0(report_dir, "/compiled_", datetime)
  }

  dir.create(output_dir, FALSE, TRUE)

  for (file in new_files) {
    destination <- file.path(output_dir, file)
    move_file(file, destination)
  }

  ## remove empty directories
  to_remove <- file.path(new_dirs)
  file.remove(to_remove)

  return(invisible(NULL))
}

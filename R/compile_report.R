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
#' @param params a list that is passed to the `params` argument in
#'   `rmarkdown::render`, which are accessed in the `.Rmd` file with
#'   `params$...`; for instance, if `list(foo = 1:3)` is passed, then the
#'   compilation environment will define an object `params$foo` with value
#'   `1:3`; if defined, the subdirectory name in report-outputs will indicate
#'   the names and first values of `params`; default is an empty list
#'
#' @param clean_report_sources a logical indicating if indesirable files and
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

compile_report <- function(file, quiet = FALSE, factory = getwd(),
                           clean_report_sources = FALSE,
                           remove_cache = TRUE, 
                           encoding = "UTF-8",
                           params = list(), ...) {

  ## This function will:
  
  ## 1. perform cleaning of `report_sources/` if `clean_report_sources = TRUE`;
  ## this will remove pretty much anything that's not an `Rmd` file or a
  ## `README`; this is externalised in the function `clean_report_sources`

  ## 2. check that input file exists; identify all files in `report_sources/`
  ## prior to the compilation, used later to diff post-compilation to identify
  ## new files
  
  ## 3. compile the user-provided report `foo_date[].Rmd` file stored in
  ## `report_sources/`; compilation parameters are passed to
  ## `rmarkdown::render`'s argument `params` through `render_param`; parameters
  ## will also be used to form the output file name, which will display the
  ## parameter names and first values, so the output folder will look like:
  ## `compiled_foo_[foo-values]_bar_[bar-values]_[date]_[time]/`

  ## 4. identify all files in report_sources; new ones are those which where not
  ## around at step 1; this can cause problems when there are left-over outputs
  ## from previous manual compilations inside `report_sources/`; it will be
  ## often safest to use `clean_report_sources = TRUE` so that these left-overs
  ## are removed before step 3

  ## 5. move all outputs identified in step 3 to a dedicated folder in
  ## report_outputs/; this folder will be named after the input report,
  ## e.g. `foo_date/compiled_[date]_[time]/`, and will include `params` if
  ## provided (see point 3).
  
  
  # This is used for logging later in the function 
  log_entry <- as.list(c(as.list(environment()), list(...)))
  log_entry$timestamp <- Sys.time()
  
  validate_factory(factory)

  odir <- getwd()
  on.exit(setwd(odir))
  setwd(factory)

  ## 1. perform cleaning of `report_sources/` 
  if (clean_report_sources) {
    clean_report_sources(quiet = quiet, remove_cache = remove_cache)
  }

  ## 2. check that input file exists and list existing files
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


  ## handle optional parameters passed `params`:
  ## we display some information to the console on parameters used, and generate
  ## some text that will be used to name the output folder
  
  dots <- list(...)
  has_params <- FALSE
  if (length(params) > 0) {
    
    ## remove unnamed parameters
    named <- names(params) != ""
    params <- params[named]
    
    if (length(params) > 0) {
      has_params <- TRUE

      ## convert the parameter values to txt and abbreviate them for display to
      ## console and for naming the output
      turn_to_character <- function(x, sep = "_") {
        out <- as.character(unlist(x))
        out <- paste(out, collapse = sep)
        out
      }

      params_as_txt_console <- lapply(params, turn_to_character, sep = " ")
      params_as_txt <- lapply(params, turn_to_character)

      ## this bit shortens param values which will be used for file names; usual
      ## filesystems (incl. ext3, ext4, NTFS, FAT32) hava a cap of 255
      ## characters for file names; can also have capts on paths (e.g. 4096
      ## characters for ext4) but we only handle the filename bit here. As a
      ## conservative measure, we allow up to 100 characters for params
      
      long_values <- nchar(params_as_txt) > 8
      params_as_txt_console <- lapply(params_as_txt_console, substr, 1, 8)
      params_as_txt <- lapply(params_as_txt, substr, 1, 8)
      params_as_txt <- sub("-$", "", params_as_txt)
      params_as_txt <- sub("_$", "", params_as_txt)
      

      ## create character strings to be displayed to the console
      txt_display <- paste(names(params),
                           params_as_txt_console,
                           sep = ": ")
      txt_display[long_values] <- paste0(txt_display[long_values], "...")
      txt_display <- paste(txt_display, collapse = "\n")

      ## create character strings to be used for file naming
      txt_name_folder <- paste(names(params), params_as_txt,
                               sep = "_", collapse = "_")
      txt_name_folder <- substr(txt_name_folder, 1, 100)
      txt_name_folder <- sub("_$", "", txt_name_folder)

    }
  }


  ## display messages to the console
  message(sprintf("\n/// compiling report: '%s'", shorthand))
  if (has_params) {
    message(sprintf("// using params: \n%s",
                    txt_display))
  }

  ## construct the compilation environment: as 'params' seems underliable, we
  ## pass this info by creating a new clean environment, in which we add a
  ## `params` variable
  compile_env <- new.env()
  compile_env$params <- params
  output_file <- rmarkdown::render(rmd_path,
                                   quiet = quiet,
                                   encoding = encoding,
                                   envir = compile_env) # force clean environment

  message(sprintf("\n/// '%s' done!\n", shorthand))

  
  ## 4. identify all files in report_sources
  files_after <- list.files(recursive = TRUE)
  dirs_after <- list.dirs(recursive = TRUE)

  files_after <- unique(ignore_tilde(files_after))
  new_files <- setdiff(files_after, files_before)
  new_files <- c(new_files, sub(file_dir, "", output_file))
  new_files <- unique(new_files)
  new_dirs <- unique(basename(setdiff(dirs_after, dirs_before)))

  
  ## 5. move all outputs identified in step 3 to a dedicated folder
  if (!dir.exists(find_file("report_outputs"))) {
    dir.create(find_file("report_outputs"), FALSE, TRUE)
  }

  datetime <- sub(" ", "_", as.character(Sys.time()))
  datetime <- gsub(":", "-", datetime)
  report_dir <- file.path(find_file("report_outputs"),
                          paste(base_name, date, sep = "_"))
  dir.create(report_dir, FALSE, TRUE)

  ## add txt indicative of params that were used; only applies if params were
  ## provided
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
  
  output_files <- vector(length(new_files), mode = "list")
  for (i in seq_along(new_files)) {
    file <- new_files[i]
    destination <- file.path(output_dir, file)
    move_file(file, destination)
    output_files[[i]] <- destination
  }
  
  ## remove empty directories
  to_remove <- file.path(new_dirs)
  file.remove(to_remove)
  
  
  # ================
  ### ! KEEP AT END OF FUNCTION ! ###
  ## Logging approach: 
  ## 1. Combine all env variables and args into a list, and add timestamp 
  ## 2. Read exising log rds file (a list of lists)
  ## 3. Add new entry to dataframe with env() on compile_report call
        ## output filenames, and other relevant data
  
  ## Start log code
  log_file_path <- paste(factory, ".compile_log.rds", sep = "/")
  no_log_file <- sum(file.exists(log_file_path, hidden.files = TRUE)) == 0
  if (no_log_file) {
    initialize_log <- list(initialize = TRUE, timestamp = Sys.time())
    saveRDS(initialize_log, log_file_path)
  }
  report_source_file <- c("name" <- output_file)
  log_entry$report_file <- report_source_file
  log_entry$output_files <- output_files 
  current_log <- readRDS(log_file_path)
  if (is.null(current_log[[base_name]])) current_log[[base_name]]
  
  string_time <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
  current_log[[base_name]][[eval(string_time)]] <- log_entry
  saveRDS(current_log, log_file_path)
  
  # End log code
  # ================

  return(invisible(NULL))
}

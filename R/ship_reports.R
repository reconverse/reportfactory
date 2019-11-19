#' #' Collect and ship compiled markdown reports to a single folder
#'
#' Copies output files for log entries that match given conditions to a dated
#' `shipped_[yyyy-mm-dd]` folder
#'     
#' @param factory The path the factory directory, defaults to current directory
#'
#' @param match_exact_type a vector of condition types passed to `filter_log`
#' (dots, file, and/or params) that are to be matched EXACTLY to the log entry 
#' (no entries with missing components of the specified type will be returned)
#' 
#' @param most_recent a logical indicating passed to `filter_log` if only the 
#' last log entry should be returned; `FALSE` by default.
#' 
#' @param outputs_only a logical indicating if only the outputs of a log entry 
#'   should be returned passed to `filter_log`; `FALSE` by default.
#' 
#' @param output_file_types  a vector containing the file types that are to be
#'   returned for each entry passed to `filter_log`
#' 
#' @param ... the arguments that will be used to match and return log entries, 
#'   which should match the structure of the [compile_reports()]
#'   method - passed to `filter_log`
#'
#' @examples
#' 
#' odir <- getwd()
#' 
#' setwd(tempdir())
#' random_factory(include_examples = TRUE)
#' source_name <- "foo"
#' report_source_file_name <- list_reports(pattern = source_name)[1]
#' 
#' dots_args <- list("lots" = data.frame(a = c(10,20)))
#' compile_report(
#'   report_source_file_name, 
#'   quiet = FALSE, 
#'   params = list("other" = "two",
#'                 "more" = list("thing" = "foo")),
#'   extra = dots_args)
#' 
#' compile_report(
#'   report_source_file_name,
#'   quiet = TRUE,
#'   params = list(other = "test"))
#' 
#' compile_report(
#'   report_source_file_name, 
#'   quiet = FALSE, 
#'   params = list("other" = "two",
#'                 "more" = list("thing" = "foo")),
#'   extra = dots_args)
#' 
#' log_file <- readRDS(".compile_log.rds")
#'
#' ship_reports(
#'   params = list("other" = "two"), 
#'   most_recent = TRUE
#' )
#' 
#' setwd(odir)
#'
#' @export
#' 
ship_reports <- function(factory = getwd(), match_exact_type = NULL,
                         most_recent = TRUE, outputs_only = FALSE,
                         output_file_types = c(), ...) {
  
  validate_factory(factory)
  
  odir <- getwd()
  on.exit(setwd(odir))
  setwd(factory)
  
  log_file <- readRDS(".compile_log.rds")

  results <- filter_log(
    log_file,
    match_exact_type =  match_exact_type,
    most_recent = most_recent,
    outputs_only = outputs_only,
    output_file_types = output_file_types,
    ...
  )
  
  if (length(results) > 0) {
    ## Create timestamped "shipped_" directory
    timestamp <- sub(" ", "_", as.character(Sys.time()))
    datetime <- gsub(":", "-", timestamp)
    shipped_dir <- paste0("shipped_", datetime)
    dir.create(shipped_dir)
    
    for (result in results) {
      ## Create source file (sf) sub-directory
      outputs <- unlist(result$output_files)
      sf_pattern <- ".*report_outputs/(.*?)/.*"
      sf_repl <- "\\1"
      sf_dir <- gsub(sf_pattern, sf_repl, result$output_dir)
      sf_dir <- file.path(shipped_dir, sf_dir)
      if (!dir.exists((sf_dir))) dir.create(sf_dir)
      
      ## Create compile sub-directory
      compile_pattern <- ".*\\/"
      compile_repl <- ""
      compile_dir <- gsub(compile_pattern, compile_repl, result$output_dir)
      compile_dir <- file.path(sf_dir, compile_dir)
      if (!dir.exists((compile_dir))) dir.create(compile_dir)
      
      for (output in outputs) {
        if (file.exists(output)) {
          filename <- basename(output)
          destination_dir <- file.path(compile_dir)
          if (!dir.exists(destination_dir)) dir.create(destination_dir)
          file.copy(output, file.path(destination_dir, filename), overwrite = TRUE)
        } else {
          ## Remove outputs from log list that do not exist
          outputs <- outputs[!match(outputs, output, nomatch = 0)]
        }
      }
      ## Print shipped outputs to console
      sf <- gsub(".*report_outputs/(.*?)/.*", "\\1", outputs[[1]])
      msg_header <- paste0("\n/// Shipping ", sf, " outputs: \n")
      outputs_pattern <- ".*\\/"
      outputs_repl <- "\\1"
      short_outputs <- lapply(
        outputs, function(output) gsub(outputs_pattern, outputs_repl, output))
      message_display <- paste(c(msg_header, short_outputs), collapse = "\n")
      message(sprintf(message_display)) 
    }
  } else {
    message("\n/// No entries match the given arguments")
  }
  
  return(invisible(NULL))
}

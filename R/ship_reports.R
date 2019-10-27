#' #' Ship Reports
#'
#' Copies output files for log entries that match given conditions to a dated
#' `shipped_[YYYY-mm-dd]` folder
#'     
#' @param factory The path the factory directory, defaults to current directory
#'
#' @param match_exact_type a vector of condition types passed to `filter_log`
#' (dots, file, and/or params) that are to be matched EXACTLY to the log entry 
#' (no entries with missing components of the specified type will be returned)
#' 
#' @param most_recent a logical indicating passed to `filter_log` if only the 
#' last log entry should be returned; \code{FALSE} by default.
#' 
#' @param outputs_only a logical indicating if only the outputs of a log entry 
#'   should be returned passed to `filter_log`; \code{FALSE} by default.
#' 
#' @param output_file_types  a vector containing the file types that are to be
#'   returned for each entry passed to `filter_log`
#' 
#' @param ... the arguments that will be used to match and return log entries, 
#'   which should match the structure of the \code{reportfactory::compile_reports}
#'   method - passed to `filter_log`
#'
#' @export
#' 
ship_reports <- function(factory = getwd(), match_exact_type = NULL,
                         most_recent = TRUE, outputs_only = FALSE,
                         output_file_types = c(), ...) {
  
  # validate_factory(factory)
  
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
    
    if (!dir.exists((shipped_dir))) dir.create(shipped_dir)
    
    for (result in results) {
      ## Create factory sub-directory
      outputs <- unlist(result$output_files)
      factory_pattern = ".*report_outputs/(.*?)/.*"
      factory_repl <- "\\1"
      factory_dir <- gsub(factory_pattern, factory_repl, result$output_dir)
      factory_dir <- file.path(shipped_dir, factory_dir)
      if (!dir.exists((factory_dir))) dir.create(factory_dir)
      
      ## Create compile sub-directory
      compile_pattern =  ".*\\/"
      compile_repl <- ""
      compile_dir <- gsub(compile_pattern, compile_repl, result$output_dir)
      compile_dir <- file.path(factory_dir, compile_dir)
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
      factory <- gsub(".*report_outputs/(.*?)/.*", "\\1", outputs[[1]])
      msg_header <- paste0("\n/// Shipping ", factory, " outputs: \n")
      outputs_pattern = ".*\\/"
      outputs_repl <- "\\1"
      short_outputs <- lapply(
        outputs, function(output) gsub(outputs_pattern, outputs_repl, output))
      message_display <- paste(c(msg_header, short_outputs), collapse = "\n")
      message(sprintf(message_display)) 
    }
  } else {
    message(sprintf("\n/// No entries match the given arguments"))
  }
  
  return(invisible(NULL))
}

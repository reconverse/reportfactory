#' Filter Log
#'
#' By default the function returns all matches - even if some conditions are 
#'     missing, or there are other log conditions present
#'
#' @export
#' 
#' @param log_file the compile log list (which is located in the root of the 
#'   factory and saved as a .rds file)
#'   
#' @param match_exact_type a vector of condition types (dots, file, and/or params)
#'   that are to be matched EXACTLY to the log entry (no entries with missing
#'   components of the specified type will be returned)
#'   
#' @param most_recent a logical indicating if only the last log entry should
#'   be returned; \code{FALSE} by default.
#'   
#' @param outputs_only a logical indicating if only the outputs of a log entry 
#'   should be returned; \code{FALSE} by default.
#'   
#' @param output_file_types a vector containing the file types that are to be
#'   returned for each entry
#'   
#' @param ... the arguments that will be used to match and return log entries, 
#'   which should match the structure of the \code{reportfactory::compile_reports}
#'   method
#'
#' @return a list of log entries which match the \code{...} arguments and other
#'   parameter input
#'
#' @examples
#' ## This filters a compile log with a set of conditions, which would 
#' ## match the call of the \code{reportfactory::compile_report} function. 
#' 
#' 
#' ## new random factory in temp folder
#' odir <- getwd()
#' new_factory(tempdir(), include_examples = TRUE)
#' 
#' 
#' factory_name = "foo"
#' report_source_file_name <- list_reports(pattern = factory_name)[1]
#' 
#' 
#' ## The log entry for a report created with the following arguments:
#' compile_report(file = report_source_file_name,
#'                quiet = TRUE, 
#'                params = list(other = "test"))
#'                
#' ## The log is saved in the root of the factory
#' log_file <- readRDS(".compile_log.rds")
#'                
#' ## Filter the log file for the entry with the same arguments:
#' filter_log(log_file = log_file,
#'            file = report_source_file_name,
#'            quiet = TRUE,
#'            params = list(other = "test"))
#'        
#' setwd(odir)

filter_log <- function(log_file, match_exact_type = NULL,
                       most_recent = FALSE, outputs_only = FALSE,
                       output_file_types = c(), ...) {
  
  conds <- list(...)
  
  if (!is.null(names(conds))) {
    results <- filter_log_conditions(log_file, match_exact_type, ...)
    # results <- require_log_type(results, match_exact_type, conds)
  } else {
    ## return all log entries if no conds (remove initialize and timestamp)
    results <- log_file[-c(1,2)]
  }
  
  if (most_recent == TRUE & length(results) > 1) {
    ## Assign all but the last result to NULL to remove from list
    ul_results <- unlist(results)
    ul_results_names <- names(ul_results)
    
    name_keys <- grep("compile_init_env.file", ul_results_names, value = TRUE)
    unique_source_files <- unique(ul_results[name_keys])
    
    timestamps_list <- list()
    for (i in 1:length(ul_results)) {
      source_file_name <- unique_source_files[i]
      source_names <- match(ul_results, source_file_name, nomatch = 0)
      source_results <- ul_results[as.logical(source_names)]
      most_recent_result = tail(source_results, n = 1)
      timestamp <- gsub("\\..*","", names(most_recent_result))
      timestamps_list[[source_file_name]] <- timestamp
    }
    
    most_recent_results <- unlist(timestamps_list)
    results <- results[most_recent_results]
  }
  
  if (outputs_only == TRUE) {
    # Assign all but the output_files in entries to NULL to remove other data
    to_remove <- c("compile_init_env", "dots", "timestamp", "output_dir")
    for (k in 1:length(results)) {
      results[[k]][to_remove] <- NULL
    }
  }

  results <- filter_log_output_types(results, output_file_types)
  
  return(results)
}


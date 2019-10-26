# This filters a facotry compile log with a set of conditions, which would 
#   match the call of the compile_report function. For example:
#   
#   The log entry for a report created with the command:
#     `compile_report(file = [source_file_name], quiet = TRUE, 
#       params = list(other = "test"))` 
#   can be filtered in the log file with the command:
#     'filter_log(file = [source_file_name], quiet = TRUE,
#       params = list(other = "test"))``
# 
# The following options are available:
#   
#   * by default the function returns all matches (even if some conditions are 
#     missing, or there are other log conditions present)
#   * the argument 'match_exact_type = c("params", "dots")` will only return 
#     matches that include ALL and ONLY the same params and dots conditions.
#   * outputs_only = TRUE returns only the outputs for the matching log entries
#   * most_recent = TRUE returns only the last matching entry
#   * filter by output file type c(".csv", ".html", ".jpeg", ".pdf", ".png",
#      ".rds", ".rmd", ".xls", ".xlsx")

filter_log <- function(log_file, match_exact_type = NULL,
                       most_recent = FALSE, outputs_only = FALSE,
                       output_file_types = c(), ...) {

  conds <- list(...)
  
  results_list <-  filter_log_conditions(log_file, conds)
  results <- require_log_type(results_list, match_exact_type, conds)

  
  if (most_recent == TRUE) {
    # Assign all but the last result to NULL to remove from list
    results[-length(results)] <- NULL
  }
  
  if (outputs_only == TRUE) {
    # Assign all but the output_files in entries to NULL to remove other data
    to_remove <- c("compile_init_env", "dots", "timestamp")
    for (k in 1:length(results)) {
      results[[k]][to_remove] <- NULL
    }
  }

  results <- filter_log_output_types(results, output_file_types)
  

  return(results)
}


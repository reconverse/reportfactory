## Takes a log list and a vector of `required_conds` (which are passed from 
## the `filter_list` function, and ensures that each log entry contains the 
## only the exact match of the required condition types (params, dots, file, etc)
  
filter_log_require_by_type <- function(log_list, match_exact_type, required_conds) {
  results <- log_list
  to_remove <- c()
  if (length(results) > 0) {
    for (j in seq_along(results)) {
      result <- results[[j]]
      result_ul <- unlist(result)
      ## Remove "compile_init_env" nesting from ul names (for matching)
      names(result_ul) <- gsub("compile_init_env.", "", names(result_ul))
      ## Create list conds in the result that should match the given required conds
      result_required_conds <- lapply(
        match_exact_type, 
        function(type) { result_ul[grep(type, names(result_ul), value = TRUE)] })
      
      required_diff <- setdiff(unlist(result_required_conds), required_conds)
      
      ## Identify index of results to remove if required conditions are not met
      if (length(required_diff) > 0) to_remove <- c(to_remove, j)
    }
  }

  ## Remove results from `to_remove` vector by list index 
  if (length(to_remove) > 0) results <- results[-to_remove]
  
  return(results)
}

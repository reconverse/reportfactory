filter_log <- function(log_file, match_exact_type = NULL,
                       most_recent = FALSE, outputs_only = FALSE, ...) {

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
    n_results <- length(results)
    for (k in 1:n_results) {
      results[[k]][to_remove] <- NULL
    }
  }

  return(results)
}


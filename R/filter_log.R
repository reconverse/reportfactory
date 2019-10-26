filter_log <- function(log_file, match_exact_type = NULL,
                       most_recent = FALSE, outputs_only = FALSE,
                       filter_output_types = c(), ...) {

  conds <- list(...)
  
  results_list <-  filter_log_conditions(log_file, conds)
  results <- require_log_type(results_list, match_exact_type, conds)
  n_results <- length(results)
  
  
  if (most_recent == TRUE) {
    # Assign all but the last result to NULL to remove from list
    results[-length(results)] <- NULL
  }
  
  if (outputs_only == TRUE) {
    # Assign all but the output_files in entries to NULL to remove other data
    to_remove <- c("compile_init_env", "dots", "timestamp")
    for (k in 1:n_results) {
      results[[k]][to_remove] <- NULL
    }
  }

  if (length(filter_output_types) > 0) {
    for (l in 1:length(results)) {
      result <- results[[l]]
      
      output_files <- unlist(result$output_files)
      
      filtered_outputs <- lapply(output_files, function(f) {
        if (grepl("csv", f) == FALSE) { 
          f <- NULL
        } else{
          f
        }
      })
      
      results[[1]]$output_files <- filtered_outputs
    }
  }

  return(results)
}


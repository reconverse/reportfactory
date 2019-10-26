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
      output_files <- result$output_files
      
      to_keep <- list()
      for (t in 1:length(filter_output_types)) {
        type <- filter_output_types[t]
        to_keep[[t]] <- lapply(1:length(output_files), function(f) {
          if (grepl(type,  output_files[[f]])) return(f)
        })
      }
     results[[l]]$output_files <- NULL
     results[[l]]$output_files <- output_files[unlist(to_keep)]
    }
  }

  return(results)
}


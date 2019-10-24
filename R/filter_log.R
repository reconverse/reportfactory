filter_log <- function(log_file, match_exact_type = NULL,
                       most_recent = FALSE, outputs_only = FALSE, ...) {

  conds <- list(...)
  conds <- unlist(conds)
  
  ul <- unlist(log_file)
  ul_names <- names(ul)
  
  timestamps_list <- list()
  for (i in 1:length(conds)) {

    cond <- conds[i]
    key <- names(cond)
    value <- cond[[key]]
    ## find all vector items where the name matches the condition KEY
    matches_key <- ul[grep(key, ul_names)]
    ## find all vector items where the name matches the condition VALUE
    matches_value <- unname(value == matches_key)
    ## find all vector items where the name matches both condition KEY and VALUE
    full_match <- matches_key[matches_value]
    ## find all vector names where the name matches both condition KEY and VALUE
    full_match_names <- names(full_match)
    ## extract timestamps from full names
    timestamps <- lapply(full_match_names, function(name) gsub("\\..*","", name))
    ## unlist full names
    timestamps <- unlist(timestamps)
    ## Add to 
    timestamps_list[[key]] <- timestamps
  }
  
  # timestamps_list <- 
  final_keys <- Reduce(intersect, timestamps_list)
  results <- log_file[final_keys]
  
  if (length(match_exact_type) > 0) {
    for (i in 1:length(results)) {
      
      result <- results[[i]]
      result_ul <- unlist(result)
      result_ul_names <- names(result_ul)
      matches_type_list <- list()
      
      n_match <- length(match_exact_type)
      for (j in 1:n_match) {

        type <- match_exact_type[j]
        matches_type <- result_ul_names[grep(type, result_ul_names)]
        matches_type_list[[type]] <- matches_type
      }
      
      matches_type_ul <- unlist(matches_type_list)
      required_conds <- lapply(
        match_exact_type, 
        function(type) { conds[grep(type, names(conds))] })
      required_conds <- unlist(required_conds)
      if (!(length(matches_type_ul) == length(required_conds))) {
        # message("No log entries match the specified exact parameters")
        ## if not all match, remove from results list
        results[[i]] <- NULL
      }
    }
  }
  
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


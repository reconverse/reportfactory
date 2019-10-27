filter_log_conditions <- function(log_list, match_exact_type, ...) {
  
  conds <- list(...)
  conds <- unlist(conds)
  
  ul <- unlist(log_list)
  ul_names <- names(ul)
  
  
  timestamps_list <- list()
  
  # ==================
  # create vector of required conditions
  required_conds <- lapply(
    match_exact_type, 
    function(type) { conds[grep(type, names(conds))] })
  required_conds <- unlist(required_conds)
  # ==================
  
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
  
    #==================
    # If exact match is required, check for exact match and remove if necessary
    if (length(match_exact_type) > 0) {
      cond_type <- gsub("(.+?)(\\..*)", "\\1", names(cond))
      exact_match_required <- cond_type %in% match_exact_type
      matches_required_cond <- required_conds[names(cond)] == cond
      if (!(exact_match_required & matches_required_cond)) {
        full_match <- NA
      }
    }
    #==================
    
    ## find all vector names where the name matches both condition KEY and VALUE
    full_match_names <- names(full_match)
    ## extract timestamps from full names
    timestamps <- lapply(full_match_names, function(name) gsub("\\..*","", name))
    ## unlist full names
    timestamps <- unlist(timestamps)
    ## Add matched entries by timestamp
    timestamps_list[[key]] <- timestamps
  }

  # Reduce list and keep intersect of timestamps  
  matched_keys <- Reduce(intersect, timestamps_list)
  results <- log_list[matched_keys]
  
  # ===========
  to_remove <- c()
  
  for (ts in timestamps) {
    result_ul <- grep(ul_names, ts)
    browser()
  }
  if (length(results) > 0) {
    for (j in 1:length(results)) {
      result <- results[[j]]
      result_ul <- unlist(result)
      ## Remove "compile_init_env" nesting from ul names (for matching)
      names(result_ul) <- gsub("compile_init_env.", "", names(result_ul))
      ## Create list conds in the result that should match the given required conds
      result_required_conds <- lapply(
        match_exact_type, 
        function(type) { result_ul[grep(type, names(result_ul), value = TRUE)] })

      required_diff <- base::setdiff(unlist(result_required_conds), required_conds)
      
      ## Identify index of results to remove if required conditions are not met
      if (length(required_diff) > 0) to_remove <- c(to_remove, j)
    }
  }
  # ===========
  
  ## Remove results from `to_remove` vector by list index 
  if (length(to_remove) > 0) results <- results[-to_remove]
  return(results)
}

# Filters a log list using args passed from `filter_log`, which
# match args used in `compile_report`. This approaches list filtering
# by unlisting to a vector, and matching by vector names and values.
# Then the results of the filter are again filtered if `match_exact_type`
# is specified. This could probably use a refactor to do all of this in
# one step instead of two, but it works.

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
  
  results <- filter_log_require_by_type(results, match_exact_type, required_conds)
  
  return(results)
}

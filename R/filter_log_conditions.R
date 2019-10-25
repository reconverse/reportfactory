filter_log_conditions <- function(log_list, ...) {
  
  conds <- list(...)
  conds <- unlist(conds)
  
  ul <- unlist(log_list)
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
  
  final_keys <- Reduce(intersect, timestamps_list)
  results <- log_list[final_keys]
  
  return(results)
}

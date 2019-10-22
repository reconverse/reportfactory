filter_log <- function(log_file, ...) {
  conds <- list(...)
  
  params <- conds$params
  dots <- conds$dots
  ul <- unlist(log_file)
  n <- names(ul)
  
  keys_list <- list()
  for (i in (1:length(conds))) {
    cond <- conds[i]
    key <- names(cond[1])
    value <- cond[[key]]
    matches_key <- ul[grep(key, n)]
    matches_value <- unname(value == matches_key)
    full_match <- matches_key[matches_value]
    full_match_names <- names(full_match)
    list_keys <- lapply(full_match_names, function(x) gsub("\\..*","",x))
    keys <- unlist(list_keys)
    keys_list[[i]] <- keys
  }
  
  final_keys <- Reduce(intersect, keys_list)
  
  results <- log_file[final_keys]
  return(results)
}
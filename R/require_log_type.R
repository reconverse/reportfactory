## Takes a log list and a vector of "types" of conditions (which can include
  ## file (report source file name), params, or dots. Returns list of log
  ## entries that match conditions for the required types.
     ## WHen `match_exact_type` is set to `c("params"):
     ## - if searched params are `quiet = TRUE`, and `light = TRUE`, only
     ##    only log entries that include BOTH params will be returned when
     ## - log entries with any matching dots params will be returned, but
     ##   are not required

require_log_type <- function(log_list, match_exact_type = NULL, ...) {
  conds <- unlist(...)

  if (length(match_exact_type) > 0) {
    for (i in 1:length(log_list)) {
      
      log_entry <- log_list[[i]]
      log_entry_ul <- unlist(log_entry)
      log_entry_ul_names <- names(log_entry_ul)
      matches_type_list <- list()
      
      n_match <- length(match_exact_type)
      for (j in 1:n_match) {
        ## match log entries by type (ie, dots, params, file) with grep,
            ## and subset by matches, add to list
        type <- match_exact_type[j]
        matches_type <- log_entry_ul_names[grep(type, log_entry_ul_names)]
        matches_type_list[[type]] <- matches_type
      }
      
      # create list of required conditions by type (ie, dots, params, file)
      matches_type_ul <- unlist(matches_type_list)
      required_conds <- lapply(
        match_exact_type, 
        function(type) { conds[grep(type, names(conds))] })
      required_conds <- unlist(required_conds)
      
      # ensure length of required conditions equals length of matched conditions
      if (!(length(matches_type_ul) == length(required_conds))) {
        # message("No log entries match the specified exact parameters")
        ## if not all match, remove from log_list list
        log_list[[i]] <- NULL
      }
    }
  }
  
  return(log_list)
}

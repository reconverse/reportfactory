## for each source file, add the timestamp of the latest match, and
## subset the log_list with these timestamps

filter_log_most_recent <- function(log_list) {
  ul_log <- unlist(log_list)
  ul_log_names <- names(ul_log)
  
  name_keys <- grep("compile_init_env.file", ul_log_names, value = TRUE)
  unique_source_files <- unique(ul_log[name_keys])
  
  timestamps_list <- list()
  for (i in 1:length(unique_source_files)) {
    ## get source filenames
    source_file_name <- unique_source_files[i]
    source_names <- match(ul_log, source_file_name, nomatch = 0)
    source_log <- ul_log[as.logical(source_names)]
    ## get most recent
    most_recent_result = tail(source_log, n = 1)
    timestamp <- gsub("\\..*","", names(most_recent_result))
    timestamps_list[[source_file_name]] <- timestamp
  }
  
  most_recent_log <- unlist(timestamps_list)
  ## subset by most recent timestamps
  results <- log_list[most_recent_log]
  
  return(results)
}

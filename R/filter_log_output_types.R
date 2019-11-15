## This filters output files to given file types (by file extension)
filter_log_output_types <- function(log_list, output_file_types = c()) {
  if (length(output_file_types) > 0) {
    for (i in seq_along(log_list)) {
      result <- log_list[[i]]
      output_files <- result$output_files
      
      # get index of output files that have a match to the given file extensions
      file_ext_patterns <- paste(output_file_types, collapse = "|")
      to_keep  <- grep(file_ext_patterns, unlist(output_files))
      
      ## Remove original list of output files
      log_list[[i]]$output_files <- NULL
      ## Add only values of keep list to output files
      log_list[[i]]$output_files <- output_files[to_keep]
    }
  }
  
  ## Return log list with filtered output files list
  return(log_list)
}

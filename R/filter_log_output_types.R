filter_log_output_types <- function(log_list, output_file_types = c()) {
  if (length(output_file_types) > 0) {
    for (l in 1:length(log_list)) {
      result <- log_list[[l]]
      output_files <- result$output_files
      
      to_keep <- list()
      for (t in 1:length(output_file_types)) {
        type <- output_file_types[t]
        to_keep[[t]] <- lapply(1:length(output_files), function(f) {
          if (grepl(type,  output_files[[f]])) return(f)
        })
      }
      log_list[[l]]$output_files <- NULL
      log_list[[l]]$output_files <- output_files[unlist(to_keep)]
    }
  }
  
  return(log_list)
}

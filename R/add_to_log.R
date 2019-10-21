add_to_log <- function(current_log, log_entry, log_file_path, string_time) {
  current_log[[string_time]] <- log_entry
  saveRDS(current_log, log_file_path)
  
  return(invisible(NULL))
}

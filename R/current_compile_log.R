current_compile_log <- function(log_file_path = getwd(), base_name, date_string) {
  no_log_file <- !any(file.exists(log_file_path, hidden.files = TRUE))
  if (no_log_file) {
    initialize_log <- list(initialize = TRUE, timestamp = date_string)
    attr(initialize_log, "factory_name") <- base_name
    saveRDS(initialize_log, log_file_path)
  }
  
  current_log <- readRDS(log_file_path)
  return(current_log)
}
  

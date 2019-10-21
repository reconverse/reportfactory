current_compile_log <- function(log_file_path = getwd(), base_name) {
  no_log_file <- sum(file.exists(log_file_path, hidden.files = TRUE)) == 0
  if (no_log_file) {
    initialize_log <- list(initialize = TRUE, timestamp = Sys.time())
    attr(initialize_log, "factory_name") <- base_name
    saveRDS(initialize_log, log_file_path)
  }
  
  current_log <- readRDS(log_file_path)
  return(current_log)
}
  

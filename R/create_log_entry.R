create_log_entry <- function(env_list) {
  log_entry <- list()
  log_entry$compile_init_env <- env_list$compile_init_env
  log_entry$dots <- env_list$dots
  log_entry$timestamp <- env_list$timestamp
  log_entry$report_source_file <- env_list$report_source_file
  log_entry$output_files <- env_list$output_files 
  
  return(log_entry)
}

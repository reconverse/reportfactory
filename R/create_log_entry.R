## This function takes relevant info from an environment object created in the  
##   `compile_reports` function, which is used as a cleaned `.compile_log` entry.
##    This function makes it clear which variables will be logged and contains
##    the logging logic in one place.
## Notes:
##   - `compile_init_env` should be set at the beginning of the `compile_function`
##      to record the arguments and environment when the `compile_reprots` function 
##      is called
##   - `dots` and `timestamp` variables should be set at the beginning of the 
##      compile function, so that they are only called once and used as-needed
##      throughout the function
##   - `report_source_file` and `output_files` are stored as obects in the 
##     `compile_report` environment, and extracted from the env object here

create_log_entry <- function(env_list) {
  log_entry <- list()
  log_entry$compile_init_env <- env_list$compile_init_env
  log_entry$dots <- env_list$dots
  log_entry$timestamp <- env_list$timestamp
  log_entry$report_source_file <- env_list$report_source_file
  log_entry$output_files <- env_list$output_files 
  
  return(log_entry)
}

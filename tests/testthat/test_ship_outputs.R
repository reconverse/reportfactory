context("ship_outputs")


test_that("returns most recent ", {
  skip_on_cran()
  odir <- getwd()
  on.exit(setwd(odir))
  
  setwd(tempdir())
  random_factory(include_examples = TRUE)
  
  factory_path <- getwd()
  log_file <- sample_log_file(here())
  foo_log <- log_file$foo
  log_file_outputs <- foo_log[[nrow(foo_log)]]$output_files
  saveRDS(log_file, ".compile_log.rds")
  
  # ship_outputs(factory_path, params = list("other" = "test"), dots = list())
  recent_outputs <- ship_outputs(factory_path)

  expect_equal(recent_outputs, log_file_outputs)
})
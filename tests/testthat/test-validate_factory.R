library(fs)

test_that("validate factory - config tests", {
  
  f <- new_factory(path = path_temp(), move_in = FALSE)
  on.exit(dir_delete(f))
  config_path <- path(f, "factory_config")
  original_config <- as.data.frame(read.dcf(config_path))
  original_names <- names(original_config)

  tmp <- original_config
  colnames(tmp) <- c("nme", "report_sources", "outputs")
  write.dcf(tmp, config_path)
  expect_error(
    validate_factory(f),
    "'name' is missing from factory_config"
  )

  colnames(tmp) <- c("name", "sources", "outputs")
  write.dcf(tmp, config_path)
  expect_error(
    validate_factory(f),
    "'report_sources' is missing from factory_config"
  )

  colnames(tmp) <- c("name", "report_sources", "utputs")
  write.dcf(tmp, config_path)
  expect_error(
    validate_factory(f),
    "'outputs' is missing from factory_config"
  )

  tmp <- original_config
  tmp$name = "bob"
  write.dcf(tmp, config_path)
  expect_error(
    validate_factory(f),
    "Expecting factory to be called 'bob' not 'new_factory'"
  )

  tmp <- original_config
  tmp$report_sources = "bob"
  write.dcf(tmp, config_path)
  expect_error(
    validate_factory(f),
    "Folder 'bob' does not exist."
  )

  tmp <- original_config
  tmp$outputs = "bob"
  write.dcf(tmp, config_path)
  expect_error(
    validate_factory(f),
    "Folder 'bob' does not exist."
  )
})

test_that("validate factory - duplicate filenames", {
  f <- new_factory(path = path_temp(), move_in = FALSE)
  on.exit(dir_delete(f))
  dir_create(f, "report_sources", "nested")
  file_copy(
    path(f, "report_sources","example_report.Rmd"),
    path(f, "report_sources","nested","example_report.Rmd")
  )
  expect_error(
    validate_factory(f, allow_duplicates = FALSE),
    "Be aware that the following reports have duplicated"
  )
})



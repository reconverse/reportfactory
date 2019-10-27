context("Test ship reports")

odir <- getwd()
on.exit(setwd(odir))

setwd(tempdir())
random_factory(include_examples = TRUE)
source_name <- "foo"
report_source_file_name <- list_reports(pattern = source_name)[1]

dots_args <- list("lots" = data.frame(a = c(10,20)))
compile_report(
  report_source_file_name, 
  quiet = FALSE, 
  params = list("other" = "two",
                "more" = list("thing" = "foo")),
  extra = dots_args)

compile_report(
  report_source_file_name,
  quiet = TRUE,
  params = list(other = "test"))

compile_report(
  report_source_file_name, 
  quiet = FALSE, 
  params = list("other" = "two",
                "more" = list("thing" = "foo")),
  extra = dots_args)

log_file <- readRDS(".compile_log.rds")
length(log_file)

test_that("Report outputs are copied into a folder at factory root", {
  skip_on_cran()
  
  # entries missing some params arguments so should return an empty list
  ship_reports(
    params = list("other" = "two"), 
    most_recent = TRUE
  )
  
  factory_pattern = ".*report_outputs/(.*?)/.*"
  factory_repl <- "\\1"
  compile_pattern =  ".*\\/"
  compile_repl <- ""
  
  entry_output_dir <- log_file[[length(log_file)]]$output_dir
  shipped_dir <- grep("shipped_", list.files(), value = TRUE)[1]
  fact_dir <- gsub(factory_pattern, factory_repl, entry_output_dir)
  comp_dir <- gsub(compile_pattern, compile_repl, entry_output_dir)
  
  destination_dir <- file.path(shipped_dir, fact_dir, comp_dir)
  destination_dir
  expect_true(dir.exists(destination_dir))
  
  shipped_files <- list.files(destination_dir, recursive = TRUE)
  
  expect_equal(length(shipped_files), 6)
})

test_that("displays a message if there are no matches", {
  expect_message(ship_reports(file = "test"),
                 "No entries match the given arguments")
})

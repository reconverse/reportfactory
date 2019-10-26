context("Test ship reports")

odir <- getwd()
on.exit(setwd(odir))

setwd(tempdir())
random_factory(include_examples = TRUE)
factory_name <- "foo"
report_source_file_name <- list_reports(pattern = factory_name)[1]
compile_report(
  report_source_file_name,
  quiet = TRUE,
  params = list(other = "test"))

dots_args <- list("lots" = data.frame(a = c(10,20)))
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
    match_exact = c("params"),
    log_file = log_file,
    params = list("other" = "two")
  )
  
  outputs <- list.files("shared", recursive = TRUE)
  
  expect_equal(length(outputs), 7)
})
  

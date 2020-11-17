## context("Test ship reports")

## odir <- getwd()
## on.exit(setwd(odir))

## setwd(tempdir())
## random_factory()
## source_name <- "foo"
## report_source_file_name <- list_reports(pattern = source_name)[1]

## compile_report(
##   report_source_file_name, 
##   quiet = FALSE, 
##   params = list("other" = "two",
##                 "more" = list("thing" = "foo"))
## )

## compile_report(
##   report_source_file_name,
##   quiet = TRUE,
##   params = list(other = "test"))

## compile_report(
##   report_source_file_name, 
##   quiet = FALSE, 
##   params = list("other" = "two",
##                 "more" = list("thing" = "foo"))
## )

## log_file <- readRDS(".compile_log.rds")
## length(log_file)




## test_that("Report outputs are copied into a folder at factory root", {
##   skip_on_cran()
  
##   ## entries missing some params arguments so should return an empty list
##   ship_reports(
##     params = list("other" = "two"), 
##     most_recent = TRUE
##   )
  
##   factory_pattern <- ".*report_outputs/(.*?)/.*"
##   factory_repl <- "\\1"
##   compile_pattern <- ".*\\/"
##   compile_repl <- ""
  
##   entry_output_dir <- log_file[[length(log_file)]]$output_dir
##   shipped_dir <- grep("shipped_", list.files(), value = TRUE)[1]
##   fact_dir <- gsub(factory_pattern, factory_repl, entry_output_dir)
##   comp_dir <- gsub(compile_pattern, compile_repl, entry_output_dir)
  
##   destination_dir <- file.path(shipped_dir, fact_dir, comp_dir)
##   destination_dir
##   expect_true(dir.exists(destination_dir))
  
##   shipped_files <- list.files(destination_dir, recursive = TRUE)
  
##   expected_files <- c("boxplots-1.pdf", "boxplots-1.png", "foo_2018-06-29.html", 
##                       "outputs_base.csv", "violins-1.pdf", "violins-1.png")

##   expect_equal(sort(expected_files), sort(shipped_files))

## })




## test_that("ships matches of source file name", {
##   ship_reports(file = report_source_file_name)
  
##   shipped_dirs <- grep("shipped_", list.files(), value = TRUE)
##   newest_dir <- shipped_dirs[length(shipped_dirs)]
##   source_name_dir <- grep(source_name, list.files(newest_dir), value = TRUE)
  
##   expect_true(dir.exists(file.path(newest_dir, source_name_dir)))
  
## })

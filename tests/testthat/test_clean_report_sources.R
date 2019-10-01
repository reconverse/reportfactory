

context("Test removal of crap in report_sources/")

test_that("Crap gets removed in report_sources", {

  skip_on_cran()

  setwd(tempdir())
  random_factory(include_examples = FALSE)

  dir.create(file.path("report_sources", "_archive"))
  old_content <- dir("report_sources", all.files = TRUE)
    
  ## add crap
  crap_files <- c("toto.txt",
                  "#toto.Rmd#",
                  "toto.Rmd~",
                  "some_file.html",
                  ".hidden")
  crap_folders <- c("figures",
                    "cache",
                    "outputs_xlsx")
  
  file.create(file.path("report_sources", crap_files))
  sapply(file.path("report_sources", crap_folders), dir.create)

  suppressMessages(clean_report_sources())


  new_content <- dir("report_sources", all.files = TRUE)

  expect_identical(old_content, new_content)

})




test_that("cache is protected from removal if needed", {

  skip_on_cran()

  setwd(tempdir())
  random_factory(include_examples = FALSE)

  dir.create(file.path("report_sources", "cache"))
  old_content <- dir("report_sources", all.files = TRUE)
    
  ## add crap
  crap_files <- c("toto.txt",
                  "#toto.Rmd#",
                  "toto.Rmd~",
                  "some_file.html",
                  ".hidden")
  crap_folders <- c("figures",
                    "outputs_xlsx")
  
  file.create(file.path("report_sources", crap_files))
  sapply(file.path("report_sources", crap_folders), dir.create)

  suppressMessages(clean_report_sources(remove_cache = FALSE))


  new_content <- dir("report_sources", all.files = TRUE)

  expect_identical(old_content, new_content)

})


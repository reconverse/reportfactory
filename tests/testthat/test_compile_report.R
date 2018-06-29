context("Test report compilation")


test_that("Compilation can handle multiple outputs", {

  skip_on_cran()

  id <- paste(sample(c(letters, 0:10), 12, replace = TRUE), collapse = "")
  destination <- file.path(tempdir(), id)
  new_factory(destination)

  compile_report(list_reports(pattern = "foo")[1])
  outputs <- sub("([[:alnum:]_-]+/){2}", "",
                     list_outputs())

  outputs <- sort(outputs)
  ref <- c("figures/boxplots-1.pdf", "figures/boxplots-1.png",
           "figures/violins-1.pdf", "figures/violins-1.png",
           "foo_2018-06-29.html", "outputs_base.csv" )


  expect_identical(ref, outputs)

})

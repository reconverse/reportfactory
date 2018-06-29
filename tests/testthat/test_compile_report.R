context("Test report compilation")


test_that("Compilation can handle multiple outputs", {

  skip_on_cran()

  setwd(tempdir())
  random_factory()

  compile_report(list_reports(pattern = "foo")[1], quiet = TRUE)
  outputs <- sub("([[:alnum:]_-]+/){2}", "",
                     list_outputs())

  outputs <- sort(outputs)
  ref <- c("figures/boxplots-1.pdf", "figures/boxplots-1.png",
           "figures/violins-1.pdf", "figures/violins-1.png",
           "foo_2018-06-29.html", "outputs_base.csv" )


  expect_identical(ref, outputs)

})

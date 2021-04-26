if (require(testthat)) {
  library(reportfactory)
  test_check("reportfactory")
} else {
  warning("'reportfactory' requires 'testthat' for tests")
}



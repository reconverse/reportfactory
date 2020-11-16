
#' Generate 'n' alhapnumeric characters
#'
#' Not exported; returns a ranom set of alphanumeric values of length 'n'.
#' 
#' @param n the number of random alphanumeric characters to use
#' 

random_alphanum <- function(n)  {
  if (missing(n)) {
    msg <- "`n` no provided, with no default"
    stop(msg)
  }
  dict <- c(letters, 0:9)
  paste(sample(dict, size = n, replace = TRUE), collapse = "")
}

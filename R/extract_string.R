extract_string <- function(x, pattern) {
  m <- regexpr(pattern, x)
  regmatches(x, m)
}

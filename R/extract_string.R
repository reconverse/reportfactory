
# Extract any string from a vector using regular expression

extract_string <- function(x, pattern) {
  m <- regexpr(pattern, x)
  regmatches(x, m)
}

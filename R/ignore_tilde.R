
## This takes a vector of characters and removes the ones ending with a ~

ignore_tilde <- function(x) {
  to_remove <- grep("~$", x)
    if (length(to_remove) > 0L) {
      x <- x[-to_remove]
    }
  x
}

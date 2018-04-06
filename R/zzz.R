# use for printing password
redact_string <- function(string, redact_char = "*") {
  redacted <- stringr::str_replace_all(string, ".", redact_char)
  n <- nchar(redacted)
  stringr::str_sub(redacted, 1, min(c(3,n)))
}



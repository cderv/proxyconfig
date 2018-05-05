# use for printing password
redact_string <- function(string, redact_char = "*") {
  redacted <- gsub(".", redact_char, string)
  n <- nchar(redacted)
  strtrim(redacted, min(c(3,n)))
}

# check username
check_username <- function(username, regex = ".*", msg = "incorrect username format") {
  if (!grepl(regex, username)) {
    stop(msg, call. = F)
  }
  invisible(TRUE)
}


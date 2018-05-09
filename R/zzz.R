# check username
check_username <- function(username, regex = ".*", msg = "incorrect username format") {
  if (!grepl(regex, username)) {
    stop(msg, call. = F)
  }
  invisible(TRUE)
}


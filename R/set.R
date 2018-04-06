#' @export
set_proxy <- function(username = NULL, password = NULL, https = TRUE, .noproxy = NULL) {
  # ask for username
  if (is.null(username)) {
    NNI <- read_password("Username")
  }
  # ask for password
  if (is.null(password)) {
    mdp <- read_password("password")
  }

  if (!grepl("^[A-Z][0-9]{5}", username)) {
    stop("NNI should be one uppercase letter followed by 5 integer", call. = F)
  }
  .proxy_name <- "RIADES"
  proxy_url <- proxy[[.proxy_name]]$url
  proxy_port <- proxy[[.proxy_name]]$port
  http_proxy <- build_http_env(proxy_url, proxy_port, username, password)
  Sys.setenv(http_proxy = http_proxy)
  if (isTRUE(https)) {
    https_proxy <- http_proxy
    Sys.setenv(HTTPS_PROXY = https_proxy)
  }
  Sys.setenv(no_proxy = paste(.noproxy, collapse = ", "))
  message("Proxy configured")
  invisible(TRUE)
}


build_http_env <- function(url, port, username, password) {
  paste0("http://", username, ":", password, "@", url, ":", port)
}


unset_proxy <- function(verbose = F) {
  if (!is_proxy_activated(F)) {
    if (verbose) message("Proxy is not activated. Nothing to unset.")
    return(FALSE)
  }
  Sys.unsetenv("http_proxy")
  Sys.unsetenv("no_proxy")
  if (verbose) message("Proxy unset")
  TRUE
}

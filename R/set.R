#' @export
set_proxy <- function(username = NULL, password = NULL,
                      proxy = NULL,
                      noproxy = NULL,
                      https = TRUE) {

  # check proxy is set
  if (is.null(proxy) || !check_proxy(proxy)) {
    stop("You must provide a proxy url of the form <http(s)://url(:port)>",call. = FALSE)
  }

  # ask for username
  if (is.null(username)) {
    NNI <- read_password("Username")
  }
  # ask for password
  if (is.null(password)) {
    mdp <- read_password("password")
  }

  # add habitility to check for username. All pass for now
  check_username(username)

  # build proxy url for environment variable
  http_proxy <- build_http_env(proxy, username, password)

  Sys.setenv(http_proxy = http_proxy)
  if (isTRUE(https)) {
    https_proxy <- http_proxy
    Sys.setenv(HTTPS_PROXY = https_proxy)
  }
  Sys.setenv(no_proxy = paste(.noproxy, collapse = ", "))
  message("Proxy configured")
  invisible(TRUE)
}


build_http_env <- function(proxy, username, password) {
  parsed_proxy <- httr::parse_url(proxy)
  parsed_proxy$username <- username
  parsed_proxy$password <- password
  httr::build_url(parsed_proxy)
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

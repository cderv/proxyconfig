#' Configure the proxy for internet connection
#'
#' @description this will help to set up the proxy configuration using
#'   environment variable
#'   + url of the proxy with port
#'   + authentification if necessary (username and password)
#'   + any domain that proxy should ignore
#'   + activate or not https proxy
#'
#' @section Proxy Environment Variable:
#'
#'   The proxy is set using environment variables
#'   + `HTTP_PROXY`
#'   + `HTTPS_PROXY`
#'   + `NO_PROXY`
#'   The lower case version are also set because some utilities do not understand
#'   upper case environment variable.
#'
#'   This configuration is used by `curl` for internet connection and other
#'   _method_. See _Setting Proxies_ in [base::download.file()]
#'
#' @param proxy a character giving the proxy url
#' @param username character. If `NULL`, user will be prompted
#' @param password character. If `NULL`, user will be prompted
#' @param noproxy character vector of domain that proxy should ignore
#' @param https logical. If `TRUE` *HTTPS_PROXY* will be used
#'
#' @return `TRUE` *invisibly* if no error. Side effects are the environment
#'   variables for proxy being set for the session. You can check them with
#'   [base::Sys.getenv()]
#'
#'   `FALSE` *invisibly* with a warning if a proxy configuration was already set. You need
#'   to unset the configuration with [unset_proxy()] before setting a new one.
#'
#' @examples
#' \dontrun{
#'  set_proxy(proxy = "http://10.132.23.444:3232",
#'            username = "",
#'            password = "",
#'            noproxy = ".mycompany.com",
#'            https = TRUE)
#' is_proxy_activated(verbose = TRUE)
#' }
#' @export
set_proxy <- function(proxy = NULL,
                      username = NULL,
                      password = NULL,
                      noproxy = NULL,
                      https = TRUE) {
  if (is_proxy_activated(FALSE)) {
    warning("A proxy configuration is already set.\n",
            "Please check and unset with unset_proxy() before setting a new one\n")
    return(invisible(FALSE))
  }

  # check proxy is set
  if (is.null(proxy) || !check_proxy(proxy)) {
    stop("You must provide a proxy url of the form <http(s)://url(:port)>",call. = FALSE)
  }

  # ask for username
  if (is.null(username)) {
    username <- read_password("Username")
    if (is.null(username)) {
      message("Operation cancelled")
      return(invisible(FALSE))
    }
  }
  # ask for password
  if (is.null(password)) {
    password <- read_password("password")
    if (is.null(password)) {
      message("Operation cancelled")
      return(invisible(FALSE))
    }
  }

  # add habitility to check for username. All pass for now
  check_username(username)

  # build proxy url for environment variable
  http_proxy <- build_http_env(proxy, username, password)

  Sys.setenv(HTTP_PROXY = http_proxy)
  Sys.setenv(http_proxy = http_proxy)
  if (isTRUE(https)) {
    https_proxy <- http_proxy
    Sys.setenv(HTTPS_PROXY = https_proxy)
    Sys.setenv(https_proxy = https_proxy)
  }
  if (!is.null(noproxy)) {
    Sys.setenv(NO_PROXY = paste0(noproxy, collapse = ", "))
    Sys.setenv(no_proxy = paste0(noproxy, collapse = ", "))
  }
  message("Proxy configured")
  invisible(TRUE)
}


#' Build proxy url with authentification
#'
#' Build proxy url as `http://username:password@proxy-url.com:port`
#'
#' @param proxy character. Proxy url
#' @param username character
#' @param password character
#'
#' @return proxy url with username and password
#' @examples
#'   build_http_env("http://proxy-url.com:3232", "its", "me")
build_http_env <- function(proxy, username, password) {
  parsed_proxy <- httr::parse_url(proxy)
  if (username != "") {
    parsed_proxy$username <- username
    parsed_proxy$password <- password
  }
  if (username == "" && password != "") {
    warning("As username is empty, password is ignored\n")
  }
  httr::build_url(parsed_proxy)
}


#' Unset proxy configuration for the session
#'
#' This fonction is a helper to unset all configuration of proxy for the current
#' session.
#'
#' @param verbose default is `FALSE`.
#'
#' @return `FALSE` is no proxy configuration was set before. `TRUE` if
#'   configuration is unset with success.
#' @export
#'
#' @examples
#' \dontrun{
#'  set_proxy(proxy = "http://10.132.23.444:3232",
#'            username = "",
#'            password = "",
#'            noproxy = ".mycompany.com",
#'            https = TRUE)
#'  is_proxy_activated(verbose = TRUE)
#'  unset_proxy(verbose = TRUE)
#'  is_proxy_activated(verbose = TRUE)
#'  }
unset_proxy <- function(verbose = FALSE) {
  if (!is_proxy_activated(FALSE)) {
    if (verbose) message("Proxy is not activated. Nothing to unset.")
    return(FALSE)
  }
  Sys.unsetenv("HTTP_PROXY")
  Sys.unsetenv("HTTPS_PROXY")
  Sys.unsetenv("NO_PROXY")
  Sys.unsetenv("http_proxy")
  Sys.unsetenv("https_proxy")
  Sys.unsetenv("no_proxy")
  if (verbose) message("Proxy unset")
  TRUE
}

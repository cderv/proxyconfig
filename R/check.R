#' Verify if a proxy is configured
#'
#' This checks for any set environment variable relevant to proxy
#'
#' @param verbose if `TRUE` will print a summary of configuration. Authentification
#'   is redacted for printing
#'
#' @return `TRUE` is a proxy is configured. `FALSE` otherwise.
#'
#' @examples
#'   is_proxy_activated(verbose = TRUE)
#'
#' @export
is_proxy_activated <- function(verbose = FALSE) {
  proxy_env <- c("HTTP_PROXY", "HTTPS_PROXY", "NO_PROXY")
  # use also http_proxy, https_proxy and no_proxy
  proxy_env <- c(proxy_env, tolower(proxy_env))
  set_proxy_env <- purrr::set_names(purrr::map_chr(proxy_env, Sys.getenv, unset = NA_character_), proxy_env)
  all_empty <- purrr::map_lgl(set_proxy_env, ~ identical(.x, NA_character_))
  if (all(all_empty)) return(FALSE)
  if (verbose) {
    # redact auth if print is asked
    redacted_proxy_url <- function(proxy_url) {
      parsed_url <- httr::parse_url(proxy_url)
      redacted_proxy <- modifyList(
        parsed_url,
        list(
          username = redact_string(parsed_url$username),
          password = redact_string(parsed_url$password)
        )
      )
      httr::build_url(redacted_proxy)
    }
    http_env <- stringr::str_detect(names(set_proxy_env), stringr::regex("^HTTP", ignore_case = TRUE))
    http_env_redacted <- purrr::modify_if(set_proxy_env, http_env, redacted_proxy_url)

    msg <- glue::glue("
                      **** Proxy info
                           HTTP_PROXY: {http_env_redacted$HTTP_PROXY}
                          HTTPS_PROXY: {http_env_redacted$HTTPS_PROXY}
                             NO_PROXY: {http_env_redacted$NO_PROXY}
                           http_proxy: {http_env_redacted$http_proxy}
                          https_proxy: {http_env_redacted$https_proxy}
                             no_proxy: {http_env_redacted$no_proxy}
                      ****
                      ",
                      .na = "<unset>", .sep = "\n")
    message("***** Proxy Info\n", msg, "*****")
  }
  TRUE
}

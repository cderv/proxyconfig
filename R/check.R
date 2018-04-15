#' @export
is_proxy_activated <- function(verbose = F) {
  http_proxy <- Sys.getenv("http_proxy", unset = "")
  https_proxy <- Sys.getenv("https_proxy", unset = "")
  no_proxy <- Sys.getenv("no_proxy", unset = "")
  all_empty <- vapply(list(http_proxy, https_proxy, no_proxy),
                      function(x) x == "",
                      TRUE)
  if (all(all_empty)) return(FALSE)
  if (verbose) {
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
    msg <- glue::glue(
      "***** Proxy Info",
      "  http_proxy: { redacted_http }",
      "  https_proxy: { redacted_https }",
      "  no_proxy: { no_proxy }",
      "*****",
      .sep = "\n",
      no_proxy = no_proxy,
      redacted_http = redacted_proxy_url(http_proxy),
      redacted_https = redacted_proxy_url(https_proxy)
    )
    message(msg)
  }
  TRUE
}

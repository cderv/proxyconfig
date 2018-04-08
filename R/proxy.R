
get_proxy <- function(proxy_name) {
  # get configuration from local yaml file
  if (file.exists("proxyconfig.yml")) {
    if (!requireNamespace("config", quietly = TRUE)) {
      stop("you must installed the config package to use proxyconfig.yml configuration", call. = FALSE)
    }
    proxy <- config::get(proxy_name, file = "proxyconfig.yml")
    return(proxy)
  }
  stop("proxy must be define through use_proxy argument or with a proxyconfig.yml file", call. = FALSE)
}

check_proxy <- function(proxy) {
  if (length(proxy) == 0) return(FALSE)
  # check for <url(:port)>
  grepl("^[a-zA-Z0-9\\.-]+(:[0-9]+)?$", proxy, perl = TRUE)
}


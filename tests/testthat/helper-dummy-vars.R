dummy_proxy_url <- "http://user:pwd@proxy.info:5656"

dummy_env_var_lc <- c(http_proxy = dummy_proxy_url,
                      https_proxy = dummy_proxy_url,
                      no_proxy = ".dummy.domain")

dummy_env_var_uc <- purrr::set_names(dummy_env_var_lc, toupper(names(dummy_env_var_lc)))

dummy_env_var <- c(dummy_env_var_uc, dummy_env_var_lc)

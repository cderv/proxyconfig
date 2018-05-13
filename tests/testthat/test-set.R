context("test-set.R")

test_that("set_proxy stop if wrong proxy", {
  unset_proxy()
  expect_error(set_proxy())
  unset_proxy()
  # expect_error(set_proxy(proxy = NULL))
  # unset_proxy()
  expect_error(set_proxy(proxy = "34#YU"))
  unset_proxy()
})

test_that("set_proxy return false with warning if already set", {
  withr::with_envvar(
    dummy_env_var,
    {
      suppressWarnings(expect_false(set_proxy(proxy = dummy_proxy_url)))
      expect_warning(set_proxy(proxy = dummy_proxy_url))
    })
})

test_that("build_http_env correctly", {
  expect_equal(build_http_env("http://proxy-url.com:3232", "its", "me"),
               "http://its:me@proxy-url.com:3232/")
  expect_equal(build_http_env("http://proxy-url.com:3232", "", ""),
               "http://proxy-url.com:3232/")
  expect_equal(suppressWarnings(build_http_env("http://proxy-url.com:3232", "", "me")),
               "http://proxy-url.com:3232/")
  expect_warning(build_http_env("http://proxy-url.com:3232", "", "me"))
})

test_that("env var are set correctly", {
  unset_proxy()
  set_proxy(
    proxy = "http://proxy.mycompany.com:3939",
    username = "its",
    password = "me",
    noproxy = c(".mycompany.com", "163.104.50.180"),
    https = TRUE
  )

  expect_equal(Sys.getenv("HTTP_PROXY"), "http://its:me@proxy.mycompany.com:3939/")
  expect_equal(Sys.getenv("HTTPS_PROXY"), "http://its:me@proxy.mycompany.com:3939/")
  expect_equal(Sys.getenv("http_proxy"), "http://its:me@proxy.mycompany.com:3939/")
  expect_equal(Sys.getenv("https_proxy"), "http://its:me@proxy.mycompany.com:3939/")
  expect_equal(Sys.getenv("NO_PROXY"), ".mycompany.com, 163.104.50.180")
  expect_equal(Sys.getenv("no_proxy"), ".mycompany.com, 163.104.50.180")
  unset_proxy()
})

test_that("env var are set correctly if proxy url provided as options", {
  withr::local_options(list(`proxyconfig.proxy` = "http://proxy.mycompany.com:3939"))
  unset_proxy()
  set_proxy(
    username = "its",
    password = "me"
  )
  expect_equal(Sys.getenv("HTTP_PROXY"), "http://its:me@proxy.mycompany.com:3939/")
  expect_equal(Sys.getenv("http_proxy"), "http://its:me@proxy.mycompany.com:3939/")
  unset_proxy()
})

test_that("proxy is correctly unset", {
  withr::with_envvar(
    dummy_env_var,
    {
      expect_true(unset_proxy(FALSE))
      unset_env <- purrr::map_chr(dummy_env_var, Sys.getenv, unset = "unset")
      purrr::walk(unset_env, expect_identical, "unset")
    })
  withr::with_envvar(
    dummy_env_var,
    {
      expect_message(unset_proxy(TRUE), regexp = "Proxy unset", fixed = TRUE)
    }
  )
})

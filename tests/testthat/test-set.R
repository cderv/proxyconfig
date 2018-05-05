context("test-set.R")

test_that("set_proxy stop if wrong proxy", {
  unset_proxy()
  expect_error(set_proxy())
  unset_proxy()
  expect_error(set_proxy(proxy = NULL))
  unset_proxy()
  expect_error(set_proxy(proxy = "34#YU"))
  unset_proxy()
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

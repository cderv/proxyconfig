context("test-proxy.R")

test_that("check proxy argument for correct format", {
  expect_equal(check_proxy("10.132.23"), TRUE)
  expect_equal(check_proxy("10#132+23"), FALSE)
  expect_equal(check_proxy("10.132.23.444:32"), TRUE)
  expect_equal(check_proxy("10.132.23.444:hu"), FALSE)
  expect_equal(check_proxy("proxy-url.com:64"), TRUE)
  expect_equal(check_proxy("proxy-url.com#64"), FALSE)
})

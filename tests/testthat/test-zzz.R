context("test-zzz.R")

test_that("redact string and keep maximum 3 character", {
  expect_equal(redact_string("test"), "***")
  expect_equal(redact_string("test", redact_char = "#"), "###")
})

test_that("check_username is TRUE is no regex provided", {
  random <- c(letters, LETTERS, 1:9)
  username <- paste0(sample(random, sample.int(10), replace = TRUE), collapse = "")
  expect_true(check_username(username))
})

test_that("check_username handles error when regex provided", {
  # no error if correct format
  expect_true(check_username("A87987", "^[A-Z][0-9]{5}$"))
  # default message
  expect_error(check_username("AB8799", "^[A-Z][0-9]{5}$"), "incorrect username format")
  # error with custom message
  msg <- "username should be one uppercase letter followed by 5 integer"
  expect_error(check_username("AB8799", "^[A-Z][0-9]{5}$", msg), msg)
})

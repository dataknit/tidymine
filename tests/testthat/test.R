library(tidymine)

context("Untidy input")

test_that("Outcome untidied to numeric", {
  test <- tibble::tibble(column_a = seq(0, 1, 0.2)) %>%
    untidy_outcome(column_a)
  expect_is(test, "numeric")
})

test_that("Outcome untidied to vector", {
  test <- tibble::tibble(column_a = seq(0, 1, 0.2)) %>%
    untidy_outcome(column_a)
  expect_vector(test)
})

test_that("Predictors untidied to data.frame", {
  test <- tibble::tibble(column_a = seq(0, 1, 0.2),
                         column_b = seq(2, 4, 0.4))
  hi <- untidy_predictors(test, column_b)
  expect_is(hi, c("data.frame"))
})



context("Tidy mine output")

test_that("minerva::mine outputs a list", {
  x <- 0:10 / 10
  y <- sin(10 * pi * x) + x
  mine_output <- minerva::mine(x = x, y = y)
  expect_is(mine_output, "list")
})

test_that("tidy_mine_output converts mine output into a tibble", {
  x <- mlb_2008[,-c(1:3)]
  excl <- which(diag(var(x)) < 1e-5) # exclude variables with low variance
  x <- x[,-excl]
  y <- mlb_2008$salary
  minerva_result <- minerva::mine(x = x, y = y)
  x_names <- colnames(x)
  test <- tidy_mine_output(minerva_result, x_names)
  expect_is(test, c("tbl_df", "tbl", "data.frame"))
})

test_that("tidy_mine_output correctly reassigns variable names", {
  test <- tibble::tibble(column_a = seq(0, 1, 0.2),
                         column_b = seq(2, 4, 0.4),
                         column_c = sin(seq(0, 2, 0.4) + rnorm(6, mean = 0, sd = 1)))
  x <- test[,-1]
  y <- test$column_a
  minerva_result <- minerva::mine(x = x, y = y)
  x_names <- colnames(x)
  tidied_mine_output <- tidy_mine_output(minerva_result, x_names)
  expect_equal(x_names, tidied_mine_output$variable_name)
})

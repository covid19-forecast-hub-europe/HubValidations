test_that("Output class", {

  res <- expect_silent({
    validate_repository(
      system.file("testdata", package = "ForecastHubValidations")
    )
  })

  expect_s3_class(res, c("fhub_validations", "list"))

  expect_true(all(map_lgl(res, rlang::is_condition)))

  expect_true(all(purrr::map_int(res, length) == 2L))

})

test_that("Successful validation", {

  res <- validate_repository(
    system.file("testdata", package = "ForecastHubValidations")
  )

  expect_true(all(map_lgl(res, rlang::is_message)))

  expect_true(all(map_lgl(res, ~ rlang::inherits_any(.x, "fhub_success"))))

})

test_that("Failed validation", {

  tdir <- fs::path(tempdir(), "failed_fh_validations")

  withr::with_dir(tdir, {
    res <- expect_silent({
      validate_repository(
        fs::path("testdata")
      )
    })
  })

  expect_true(any(map_lgl(res, rlang::is_warning)))

  expect_true(any(map_lgl(res, ~ rlang::inherits_any(.x, "fhub_failure"))))

})

test_that("Number of validations", {

  res <- validate_repository(
    system.file("testdata", package = "ForecastHubValidations")
  )

  expect_length(res, 30L)

})

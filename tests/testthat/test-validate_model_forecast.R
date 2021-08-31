test_that("Output class", {

  res <- expect_silent({
    validate_model_forecast(
      system.file("testdata", "example-model", "2021-07-26-example-model.csv",
                  package = "ForecastHubValidations"),
      system.file("testdata", "forecast-schema.yml",
                  package = "ForecastHubValidations")
    )})

  expect_s3_class(res, c("fhub_validations", "list"))

  expect_true(all(map_lgl(res, rlang::is_condition)))

  expect_true(all(purrr::map_int(res, length) == 2L))

})

test_that("Succesful validation", {

  res <- validate_model_forecast(
    system.file("testdata", "example-model", "2021-07-26-example-model.csv",
                package = "ForecastHubValidations"),
    system.file("testdata", "forecast-schema.yml",
                package = "ForecastHubValidations")
  )

  expect_true(all(map_lgl(res, rlang::is_message)))

  expect_true(all(map_lgl(res, ~ rlang::inherits_any(.x, "fhub_success"))))

})

test_that("Failed validation", {

  tdir <- fs::path(tempdir(), "failed_fh_validations")

  withr::with_dir(tdir, {
    res <- expect_silent({
      validate_model_forecast(
        fs::path("testdata", "example-model", "2021-07-18-example-model.csv"),
        fs::path("testdata", "forecast-schema.yml")
      )
    })
  })

  expect_true(any(map_lgl(res, rlang::is_warning)))

  expect_true(any(map_lgl(res, ~ rlang::inherits_any(.x, "fhub_failure"))))

})

test_that("Number of validations", {

  res <- validate_model_forecast(
    system.file("testdata", "example-model", "2021-07-26-example-model.csv",
                package = "ForecastHubValidations"),
    system.file("testdata", "forecast-schema.yml",
                package = "ForecastHubValidations")
  )

  expect_length(res, 3L)

})

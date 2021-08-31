test_that("Output class", {

  res <- expect_silent({
    validate_model_folder(
     system.file("testdata", "example-model",
                 package = "ForecastHubValidations"),
     system.file("testdata", "forecast-schema.yml",
                 package = "ForecastHubValidations"),
     system.file("testdata", "metadata-schema.yml",
                 package = "ForecastHubValidations")
  )})

  expect_s3_class(res, c("fhub_validations", "list"))

  expect_true(all(map_lgl(res, rlang::is_condition)))

  expect_true(all(purrr::map_int(res, length) == 2L))

})

test_that("Succesful validation", {

  res <- validate_model_folder(
    system.file("testdata", "example-model",
                package = "ForecastHubValidations"),
    system.file("testdata", "forecast-schema.yml",
                package = "ForecastHubValidations"),
    system.file("testdata", "metadata-schema.yml",
                package = "ForecastHubValidations")
  )

  expect_true(all(map_lgl(res, rlang::is_message)))

  expect_true(all(map_lgl(res, ~ rlang::inherits_any(.x, "fhub_success"))))

})

test_that("Failed validation", {

  tdir <- fs::path(tempdir(), "failed_fh_validations")

  withr::with_dir(tdir, {
    res <- expect_silent({
      validate_model_folder(
        fs::path("testdata", "example-model"),
        fs::path("testdata", "forecast-schema.yml"),
        fs::path("testdata", "metadata-schema.yml")
      )
    })
  })

  expect_true(any(map_lgl(res, rlang::is_warning)))

  expect_true(any(map_lgl(res, ~ rlang::inherits_any(.x, "fhub_failure"))))

})

test_that("Number of validations", {

  res <- validate_model_folder(
    system.file("testdata", "example-model",
                package = "ForecastHubValidations"),
    system.file("testdata", "forecast-schema.yml",
                package = "ForecastHubValidations"),
    system.file("testdata", "metadata-schema.yml",
                package = "ForecastHubValidations")
  )

  expect_length(res, 14L)

})

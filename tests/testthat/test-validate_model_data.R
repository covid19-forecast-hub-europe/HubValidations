test_that("Output class", {

  res <- expect_silent({
    validate_model_data(
      system.file("testdata", "data-processed", "example-model", "2021-07-26-example-model.csv",
                  package = "HubValidations"),
      system.file("testdata", "schema-data.yml",
                  package = "HubValidations")
    )})

  expect_s3_class(res, c("fhub_validations", "list"))

  expect_true(all(map_lgl(res, rlang::is_condition)))

  expect_true(all(purrr::map_int(res, length) == 3L))

})

test_that("Successful validation", {

  res <- validate_model_data(
    system.file("testdata", "data-processed", "example-model", "2021-07-26-example-model.csv",
                package = "HubValidations"),
    system.file("testdata", "schema-data.yml",
                package = "HubValidations")
  )

  expect_true(all(map_lgl(res, rlang::is_message)))

  expect_true(all(map_lgl(res, ~ rlang::inherits_any(.x, "fhub_success"))))

})

test_that("Failed validation", {

  tdir <- fs::path(tempdir(), "failed_fh_validations")

  withr::with_dir(tdir, {
    res <- expect_silent({
      validate_model_data(
        fs::path("testdata", "data-processed", "example-model", "2021-07-18-example-model.csv"),
        fs::path("testdata", "schema-data.yml")
      )
    })
  })

  expect_true(any(map_lgl(res, rlang::is_warning)))

  expect_true(any(map_lgl(res, ~ rlang::inherits_any(.x, "fhub_failure"))))

})

test_that("Erroring validation", {

  tdir2 <- fs::path(tempdir(), "error_fh_validations")

  withr::with_dir(tdir2, {
    res <- expect_silent({
      validate_model_data(
        fs::path("testdata", "data-processed", "example-model", "2021-07-19-example-model.csv"),
        fs::path("testdata", "schema-data.yml")
      )
    })
  })

  expect_true(any(map_lgl(res, rlang::is_error)))

  expect_true(any(map_lgl(res, ~ rlang::inherits_any(.x, "unrecoverable_error"))))

})

test_that("Number of validations", {

  res <- validate_model_data(
    system.file("testdata", "data-processed", "example-model", "2021-07-26-example-model.csv",
                package = "HubValidations"),
    system.file("testdata", "schema-data.yml",
                package = "HubValidations")
  )

  expect_length(res, 3L)

})

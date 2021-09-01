test_that("print method", {

  res <- expect_silent({
    validate_model_forecast(
      system.file("testdata", "example-model", "2021-07-26-example-model.csv",
                  package = "ForecastHubValidations"),
      system.file("testdata", "forecast-schema.yml",
                  package = "ForecastHubValidations")
    )})

  expect_output(print(res))

})

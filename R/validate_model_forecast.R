#' Validate model forecast file
#'
#' @param forecast_file Path to the forecast `.csv` file
#' @param forecast_schema Path to the `.yml` schema file
#'
#' @return An object of class `fhub_validations`.
#'
#' @importFrom yaml read_yaml
#' @importFrom jsonlite toJSON
#' @importFrom jsonvalidate json_validate
#' @importFrom rlang error_cnd
#' @export
#'
#' @examples
#' validate_model_forecast(
#'   system.file("
#'     testdata", "example-model", "2021-07-26-example-model.csv",
#'     package = "ForecastHubValidations"
#'   ),
#'   system.file("
#'     testdata", "forecast-schema.yml",
#'     package = "ForecastHubValidations"
#'   )
#' )
validate_model_forecast <- function(forecast_file, forecast_schema) {

  validations <- list()

  tryCatch(
    {
      validations <- c(validations, fhub_check(
        forecast_file,
        "Filename", "formed of a date and a model name",
        grepl(
          "^\\d{4}\\-\\d{2}\\-\\d{2}-[a-zA-Z0-9_+]+-[a-zA-Z0-9_+]+\\.csv$",
          fs::path_file(forecast_file)
        )
      ))

      forecast <- readr::read_csv(
        forecast_file,
        col_types = readr::cols("quantile" = readr::col_double())
      )

      validations <- c(validations, fhub_check(
        forecast_file,
        "`forecast_date` column", "identical to the date in filename",
        identical(
          unique(forecast$forecast_date),
          as.Date(
            gsub(
              "^(\\d{4}-\\d{2}-\\d{2})-[a-zA-Z0-9_+]+-[a-zA-Z0-9_+]+\\.csv$",
              "\\1", fs::path_file(forecast_file)
            )
          )
        )
      ))

      forecast_json <- toJSON(forecast, dataframe = "columns", na = "null")
      # For some reason, jsonvalidate doesn't like it when we don't unbox
      schema_json <- toJSON(read_yaml(forecast_schema), auto_unbox = TRUE)

      validations <- c(validations, fhub_check(
        forecast_file,
        "Forecast data", "formed of the expected columns with correct type",
        # Default engine (imjv) doesn't support schema version above 4 so we
        # switch to ajv that supports all versions
        json_validate(forecast_json, schema_json,
          engine = "ajv",
          verbose = TRUE, greedy = TRUE
        )
      ))
    },
    error = function(e) {
      # This handler is used when an unrecoverable error is thrown. This can
      # happen when, e.g., the csv file cannot be parsed by read_csv(). In this
      # situation, we want to output all the validations until this point plus
      # this "unrecoverable" error.
      e <- error_cnd(
        class = "unrecoverable_error",
        where = forecast_file,
        message = conditionMessage(e)
      )
      validations <<- c(validations, list(e))
    }
  )

  class(validations) <- c("fhub_validations", "list")

  return(validations)
}

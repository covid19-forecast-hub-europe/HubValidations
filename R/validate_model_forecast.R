#' Validate model forecast file
#'
#' @param forecast_file Path to the forecast `.csv` file
#' @param forecast_schema Path to the `.yml` schema file
#'
#' @importFrom yaml read_yaml
#' @importFrom jsonlite toJSON
#' @importFrom jsonvalidate json_validate
#'
#' @export
#'
#' @examples
#' validate_model_forecast(
#'   system.file("testdata", "example-model", "2021-07-26-example-model.csv",
#'               package = "ForecastHubValidations"),
#'   system.file("testdata", "forecast-schema.yml",
#'               package = "ForecastHubValidations")
#' )

validate_model_forecast <- function(forecast_file, forecast_schema, ...) {

  forecast <- readr::read_csv(
    forecast_file,
    col_types = readr::cols("quantile" = readr::col_double())
  )

  forecast_json <- toJSON(forecast, dataframe = "columns", na = "null")
  # For some reason, jsonvalidate doesn't like it when we don't unbox
  schema_json <- toJSON(read_yaml(forecast_schema), auto_unbox = TRUE)

  validations <- list(
    fhub_check(
      forecast_file,
      "Filename", "formed of a date and a model name",
      grepl("^\\d{4}\\-\\d{2}\\-\\d{2}-[a-zA-Z0-9_+]+-[a-zA-Z0-9_+]+\\.csv$",
            fs::path_file(forecast_file))
    ),
    fhub_check(
      forecast_file,
      "`forecast_date` column", "identical to the date in filename",
      identical(
        unique(forecast$forecast_date),
        as.Date(
          gsub(
            "^(\\d{4}\\-\\d{2}\\-\\d{2})-[a-zA-Z0-9_+]+-[a-zA-Z0-9_+]+\\.csv$",
            "\\1", fs::path_file(forecast_file)
          )
        )
      )
    ),
    fhub_check(
      forecast_file,
      "Forecast data", "formed of the expected columns with correct type",
      # Default engine (imjv) doesn't support schema version above 4 so we
      # switch to ajv that supports all versions
      json_validate(forecast_json, schema_json, engine = "ajv",
                    verbose = TRUE, greedy = TRUE)
    )
  )

  class(validations) <- c("fhub_validations", "list")

  return(validations)
}

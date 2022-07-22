#' Validate model data file
#'
#' @param data_file Path to the `.csv` file
#' @param data_schema Path to the `.yml` schema file
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
#' validate_model_data(
#'   system.file(
#'     "testdata", "data-processed", "example-model", "2021-07-26-example-model.csv",
#'     package = "ForecastHubValidations"
#'   ),
#'   system.file(
#'     "testdata", "schema-forecast.yml",
#'     package = "ForecastHubValidations"
#'   )
#' )
validate_model_data <- function(data_file, data_schema) {

  validations <- list()

  tryCatch(
    {
      validations <- c(validations, fhub_check(
        data_file,
        grepl(
          "^\\d{4}\\-\\d{2}\\-\\d{2}-[a-zA-Z0-9_+]+-[a-zA-Z0-9_+]+\\.csv$",
          fs::path_file(data_file)
        ),
        "Filename", "formed of a date and a model name, separated by an hyphen"
      ))

      data <- readr::read_csv(
        data_file,
        col_types = readr::cols("quantile" = readr::col_double())
      )

      validations <- c(validations, fhub_check(
        data_file,
        identical(
          unique(data$forecast_date),
          as.Date(
            gsub(
              "^(\\d{4}-\\d{2}-\\d{2})-[a-zA-Z0-9_+]+-[a-zA-Z0-9_+]+\\.csv$",
              "\\1", fs::path_file(data_file)
            )
          )
        ),
        "`forecast_date` column", "identical to the date in filename"
      ))

      data_json <- toJSON(data, dataframe = "columns", na = "null")

      if (!file.exists(data_schema)) {
        stop("Data schema file (`", data_schema, "`) does not exist",
             call. = FALSE)
      }
      # For some reason, jsonvalidate doesn't like it when we don't unbox
      schema_json <- toJSON(read_yaml(data_schema), auto_unbox = TRUE)

      # Default engine (imjv) doesn't support schema version above 4 so we
      # switch to ajv that supports all versions
      valid <- json_validate(data_json, schema_json, engine = "ajv",
                             verbose = TRUE, greedy = TRUE)

      if (!valid) {
        pb <- attr(valid, "errors") %>%
          transmute(m = paste("-", .data$dataPath, .data$message)) %>%
          pull(.data$m)
      } else {
        pb <- NULL
      }

      validations <- c(validations, fhub_check(
        data_file,
        valid,
        "Data", "formed of the expected columns with correct type",
        paste(pb, collapse = "\n ")
      ))
    },
    error = function(e) {
      # This handler is used when an unrecoverable error is thrown. This can
      # happen when, e.g., the csv file cannot be parsed by read_csv(). In this
      # situation, we want to output all the validations until this point plus
      # this "unrecoverable" error.
      e <- error_cnd(
        class = "unrecoverable_error",
        where = data_file,
        message = conditionMessage(e)
      )
      validations <<- c(validations, list(e))
    }
  )

  class(validations) <- c("fhub_validations", "list")

  return(validations)
}

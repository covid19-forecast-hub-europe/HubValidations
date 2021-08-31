#' Validate forecasts and metadata for a given model/folder
#'
#' @param path Path to the model/folder to validate
#' @inheritParams validate_model_forecast
#' @inheritParams validate_model_metadata
#'
#' @export
#'
#' @examples
#' validate_model_folder(
#'   system.file("testdata", "example-model",
#'               package = "ForecastHubValidations"),
#'   system.file("testdata", "forecast-schema.yml",
#'               package = "ForecastHubValidations"),
#'   system.file("testdata", "metadata-schema.yml",
#'               package = "ForecastHubValidations")
#' )
validate_model_folder <- function(path, forecast_schema, metadata_schema) {

  validations_folder <- list()

  tryCatch(
    {
      all_files <- fs::dir_ls(
        path = path,
        type = "file"
      )

      forecast_files <- all_files[fs::path_ext(all_files) == "csv"]

      metadata_file <- all_files[fs::path_ext(all_files) == "yml"]

      validations_folder <- c(validations_folder,
        fhub_check(
          fs::path_file(path),
          "There", "only one metadata file",
          identical(length(metadata_file), 1L)
        ),
        fhub_check(
          fs::path_file(path),
          "Folder name", "the same as the model name in metadata filename",
          identical(
            fs::path_file(path),
            gsub("^.*-([a-zA-Z0-9_+]+-[a-zA-Z0-9_+]+).*", "\\1",
                 fs::path_file(metadata_file))
          )
        )
      )

      validations_folder <- c(
        validations_folder,
        unlist(
          lapply(forecast_files, function(file) {
           fhub_check(
             fs::path_file(file),
             "Folder name", "identical to model name in forecast file",
             identical(
               fs::path_file(path),
               gsub("^.*-([a-zA-Z0-9_+]+-[a-zA-Z0-9_+]+).*", "\\1",
                    fs::path_file(file))
             )
           )
          }),
          recursive = FALSE
        )
      )
    },
    error = function(e) {
      # This handler is used when an unrecoverable error is thrown. This can
      # happen when, e.g., the csv file cannot be parsed by read_csv(). In this
      # situation, we want to output all the validations until this point plus
      # this "unrecoverable" error.
      e <- error_cnd(
        class = "unrecoverable_error",
        where = fs::path_file(path),
        message = conditionMessage(e)
      )
      validations_folder <<- c(validations_folder, list(e))
    }
  )

  validations_metadata <- validate_model_metadata(
    metadata_file,
    metadata_schema
  )

  validations_forecasts <- lapply(
    forecast_files,
    validate_model_forecast,
    forecast_schema
  )
  validations_forecasts <- unlist(validations_forecasts, recursive = FALSE)

  validations <- c(
    validations_folder,
    validations_metadata,
    validations_forecasts
  )

  class(validations) <- c("fhub_validations", "list")

  return(validations)

}

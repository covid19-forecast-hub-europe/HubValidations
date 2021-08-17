#' @examples
#' validate_model_folder(
#'   system.file("testdata", "example-model",
#'               package = "ForecastHubValidations"),
#'   system.file("extdata", "forecast-schema.yml",
#'               package = "ForecastHubValidations"),
#'   system.file("extdata", "metadata-schema.yml",
#'               package = "ForecastHubValidations")
#' )
validate_model_folder <- function(path, forecast_schema, metadata_schema) {

  all_files <- fs::dir_ls(
    path = path,
    type = "file"
  )

  forecast_files <- all_files[fs::path_ext(all_files) == "csv"]

  metadata_file <- all_files[fs::path_ext(all_files) == "yml"]

  validations_folder <- list(
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
    })
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

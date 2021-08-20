#' Validate a complete repository containing multiple forecast folders
#'
#' @param data_folder The path to the folder containing forecasts
#' @inheritParams validate_model_forecast
#' @inheritParams validate_model_metadata
#'
#' @return An object of class `fhub_validations`.
#'
#' @importFrom dplyr %>% add_count
#' @importFrom rlang .data
#'
#' @export
#'
#' @examples
#' validate_repository(
#'   system.file("testdata", package = "ForecastHubValidations")
#' )
#'
validate_repository <- function(
  data_folder = ".",
  forecast_schema = file.path(data_folder, "forecast-schema.yml"),
  metadata_schema = file.path(data_folder, "metadata-schema.yml")
) {

  forecast_folders <- fs::dir_ls(
    path = data_folder,
    type = "directory"
  )

  validations_folders <- lapply(
    forecast_folders,
    validate_model_folder,
    forecast_schema = forecast_schema,
    metadata_schema = metadata_schema
  )
  validations_folders <- unlist(validations_folders, recursive = FALSE)

  metadata_files <- fs::dir_ls(
    path = data_folder,
    type = "file",
    regexp = "([a-zA-Z0-9_+]+-[a-zA-Z0-9_+]+)/metadata\\-.\\1\\.yml",
    recurse = TRUE
  )

  model_designations <- purrr::map_dfr(
    metadata_files,
    ~ list(
        filename = fs::path_file(.x),
        team = read_yaml(.x)[["team_name"]],
        designation = read_yaml(.x)[["team_model_designation"]]
      )
  ) %>%
    add_count(.data$team, .data$designation)

  validations_repo <- apply(model_designations, 1, function(x) {
    fhub_check(
      x[["filename"]],
      "There", "only one primary model for a given team",
      x[["n"]] == 1
    )
  })

  validations <- c(validations_folders, validations_repo)

  class(validations) <- c("fhub_validations", "list")

  return(validations)
}

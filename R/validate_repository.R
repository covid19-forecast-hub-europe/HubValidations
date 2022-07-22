#' Validate a complete repository containing multiple forecast folders
#'
#' @inheritParams validate_model
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
  data_folder = "data-processed",
  metadata_folder = "model-metadata",
  data_schema = "schema-data.yml",
  metadata_schema = "schema-metadata.yml"
) {

  validations <- list()

  tryCatch(
    {

      models <- fs::dir_ls(
        path = data_folder,
        type = "directory"
      ) |>
        basename()

      validations <- c(validations, unlist(lapply(
        models,
        validate_model,
        data_folder = data_folder,
        metadata_folder = metadata_folder,
        data_schema = data_schema,
        metadata_schema = metadata_schema
      ), recursive = FALSE))

      metadata_files <- fs::dir_ls(
        path = metadata_folder,
        type = "file"
      )

      model_designations <- purrr::map_dfr(
        metadata_files,
        ~ list(
            filename = fs::path_file(.x),
            team = read_yaml(.x)[["team_name"]],
            designation = read_yaml(.x)[["team_model_designation"]]
          )
      ) %>%
        dplyr::filter(.data$designation == "primary") %>%
        add_count(.data$team, .data$designation)

      validations <- c(validations, unlist(
        apply(model_designations, 1, function(x) {
          fhub_check(
            x[["filename"]],
            x[["n"]] == 1,
            "There", "only one primary model for a given team"
          )
        }), recursive = FALSE))
    },
    error = function(e) {
      # This handler is used when an unrecoverable error is thrown. This can
      # happen when, e.g., the csv file cannot be parsed by read_csv(). In this
      # situation, we want to output all the validations until this point plus
      # this "unrecoverable" error.
      e <- error_cnd(
        class = "unrecoverable_error",
        where = data_folder,
        message = conditionMessage(e)
      )
      validations <<- c(validations, list(e))
    }
  )

  class(validations) <- c("fhub_validations", "list")

  return(validations)
}

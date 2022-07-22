#' Validate data and metadata for a given model/folder
#'
#' @param model_name Path to the folder containing the model data
#' @param data_folder The path to the folder containing forecasts
#' @param metadata_folder The path to the folder containing metadata
#' @inheritParams validate_model_data
#' @inheritParams validate_model_metadata
#'
#' @export
#'
#' @examples
#' validate_model(
#'   "example-model",
#'   system.file("testdata", "data-processed",
#'               package = "HubValidations"),
#'   system.file("testdata", "model-metadata",
#'               package = "HubValidations"),
#'   system.file("testdata", "schema-data.yml",
#'               package = "HubValidations"),
#'   system.file("testdata", "schema-metadata.yml",
#'               package = "HubValidations")
#' )
validate_model <- function(
  model_name,
  data_folder = "data-processed",
  metadata_folder = "model-metadata",
  data_schema = "schema-data.yml",
  metadata_schema = "schema-metadata.yml"
) {

  validations_folder <- list()

  tryCatch(
    {
      data_files <- fs::dir_ls(
        path = file.path(data_folder, model_name),
        regexp = "\\.csv$",
        type = "file"
      )

      metadata_file <- fs::dir_ls(
        path = metadata_folder,
        regexp = paste0("/", fs::path_ext_set(model_name, "yml")),
        fixed = TRUE,
        type = "file"
      )

      validations_folder <- c(validations_folder,
        fhub_check(
          model_name,
          identical(length(metadata_file), 1L),
          "There", "exactly one metadata file"
        )
      )

      validations_folder <- c(
        validations_folder,
        unlist(
          lapply(data_files, function(file) {
           fhub_check(
             fs::path_file(file),
             identical(
               model_name,
               gsub("^.*-([a-zA-Z0-9_+]+-[a-zA-Z0-9_+]+).*", "\\1",
                    fs::path_file(file))
             ),
             "Folder name", "identical to model name in data file"
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
        where = fs::path_file(model_name),
        message = conditionMessage(e)
      )
      validations_folder <<- c(validations_folder, list(e))
    }
  )

  validations_metadata <- validate_model_metadata(
    metadata_file,
    metadata_schema
  )

  validations_data <- lapply(
    data_files,
    validate_model_data,
    data_schema
  )
  validations_data <- unlist(validations_data, recursive = FALSE)

  validations <- c(
    validations_folder,
    validations_metadata,
    validations_data
  )

  class(validations) <- c("fhub_validations", "list")

  return(validations)

}

#' Validate model metadata file
#'
#' @param metadata_file Path to the metadata `.yml` file
#' @param schema_file Path to the `.yml` schema file
#'
#' @details
#' Checks:
#'   * `metadata_file` uses `.yml` extension
#'   * `metadata_file` name starts with the content of `model_abbr` field
#'   * `metadata_file` matches specification from `schema_file`
#'
#' @importFrom yaml read_yaml
#' @importFrom jsonlite toJSON
#' @importFrom fs path_ext
#' @importFrom jsonvalidate json_validate
#'
validate_model_metadata <- function(metadata_file, schema_file) {

  # Check that file has the yml extension ----
  if (path_ext(metadata_file) != ".yml") {
    stop(
      "The metadata file should use the `.yml` file extension. The current ",
      "file extension is: ", path_ext(metadata_file), "."
    )
  }

  metadata <-read_yaml(metadata_file)

  # Check that file name starts with `model_abbr` ----

  if (metadata_file != paste("metadata", metadata$model_abbr, sep = "-")) {
    stop(
      "The metadata file should start with 'metadata-' and then include the ",
      "model abbreviated name, as specified in the `model_abbr` field."
    )
  }

  # Validate against schema ----

  # For some reason, jsonvalidate doesn't like it when we don't unbox
  metadata_json <- toJSON(metadata, auto_unbox = TRUE)
  schema_json <- toJSON(read_yaml(schema_file), auto_unbox = TRUE)

  # Default engine (imjv) doesn't support schema version above 4 so we switch
  # to ajv that supports all versions
  valid <- json_validate(metadata_json, schema_json, engine = "ajv",
                         verbose = TRUE, greedy = TRUE)

  # We could use the error = TRUE from json_validate to get directly an error
  # but this way, we can customize the error message more finely
  if (!valid) {
    validation_errors <- attr(valid, "errors")
    validation_msg <- paste("-",
                            validation_errors$instancePath,
                            validation_errors$message)
    validation_msg <- paste(validation_msg, collapse = "\n")
    stop(
      "Error while validating metadata file:\n", validation_msg
    )
  }

}

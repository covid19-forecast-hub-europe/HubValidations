#' Validate model metadata file
#'
#' @param metadata_file Path to the metadata `.yml` file
#' @param metadata_schema Path to the `.yml` schema file
#'
#' @return An object of class `fhub_validations`.
#'
#' @importFrom yaml read_yaml
#' @importFrom jsonlite toJSON
#' @importFrom jsonvalidate json_validate
#' @importFrom dplyr pull transmute
#'
#' @export
#'
#' @examples
#' validate_model_metadata(
#'   system.file("testdata", "example-model", "metadata-example-model.txt",
#'               package = "ForecastHubValidations"),
#'   system.file("testdata", "schema-metadata.yml",
#'               package = "ForecastHubValidations")
#' )
#'
validate_model_metadata <- function(metadata_file, metadata_schema) {

  validations <- list()

  tryCatch(
    {
      validations <- c(
        validations,
        fhub_check(
          metadata_file,
          fs::path_ext(metadata_file) == "txt",
          "Metadata file", "using the `.txt` extension"
        ),
        fhub_check(
          metadata_file,
          grepl("^metadata-", fs::path_file(metadata_file)),
          "Metadata filename", "starting with 'metadata-'"
        )
      )

      metadata <- read_yaml(metadata_file)

      validations <- c(validations, fhub_check(
        metadata_file,
        grepl(metadata$model_abbr, fs::path_file(metadata_file)),
        "Metadata filename", "the same as `model_abbr`"
      ))

      # For some reason, jsonvalidate doesn't like it when we don't unbox
      metadata_json <- toJSON(metadata, auto_unbox = TRUE)

      if (!file.exists(metadata_schema)) {
        stop("Metadata schema file (`", metadata_schema, "`) does not exist",
             call. = FALSE)
      }

      schema_json <- toJSON(read_yaml(metadata_schema), auto_unbox = TRUE)

      # Default engine (imjv) doesn't support schema version above 4 so we
      # switch to ajv that supports all versions
      valid <- json_validate(metadata_json, schema_json, engine = "ajv",
                             verbose = TRUE, greedy = TRUE)

      if (!valid) {
        pb <- attr(valid, "errors") %>%
          transmute(m = paste("-", .data$instancePath, .data$message)) %>%
          pull(.data$m)
      } else {
        pb <- NULL
      }

      validations <- c(validations, fhub_check(
        metadata_file,
        valid,
        "Metadata file", "consistent with schema specifications",
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
        where = metadata_file,
        message = conditionMessage(e)
      )
      validations <<- c(validations, list(e))
    }
  )

  class(validations) <- c("fhub_validations", "list")

  return(validations)
}

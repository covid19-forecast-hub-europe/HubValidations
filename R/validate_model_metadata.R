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
#' @import testthat
#'
#' @examples
#' validate_model_metadata(
#'   system.file("extdata", "metadata-example-model.yml",
#'               package = "ForecastHubValidations"),
#'   system.file("extdata", "metadata-schema.yml",
#'               package = "ForecastHubValidations")
#' )
#'
validate_model_metadata <- function(metadata_file, schema_file) {

  test_file(
    system.file("extdata", "test-metadata.R",
                package = "ForecastHubValidations"),
    env = rlang::current_env()
  )

}

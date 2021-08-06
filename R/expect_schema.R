#' @importFrom jsonvalidate json_validate
#' @importFrom testthat expect quasi_label
expect_schema <- function(object, schema, engine) {

  act <- quasi_label(rlang::enquo(object), arg = "object")

  valid <- json_validate(act$val, schema, engine = engine,
                         verbose = TRUE, greedy = TRUE)

  if (!valid) {
    validation_errors <- attr(valid, "errors")
    validation_msg <- paste("-",
                            validation_errors$instancePath,
                            validation_errors$message)
    validation_msg <- paste(validation_msg, collapse = "\n")
  }

  expect(
    valid,
    sprintf("%s does not follow schema specification:\n%s", act$lab, validation_msg)
  )

  invisible(act$val)

}

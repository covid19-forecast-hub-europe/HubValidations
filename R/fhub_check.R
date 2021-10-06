#' Utility function to perform a given check and raise the relevant condition
#'
#' @param location Path of folder/file to test
#' @param test A test to run. Must evaluate to `TRUE` or `FALSE`
#' @param msg_subject Subject of the condition message
#' @param msg_attribute Attribute of the condition message
#' @param ... Additional text for the condtion message
#'
#' @return An object of class `condition` (either `message` or `error` depending
#'    on the value of `test`)..
#'
#' @importFrom rlang message_cnd warning_cnd
#'
#' @noRd
fhub_check <- function(location, test, msg_subject, msg_attribute, ...) {

  if (test) {
    res <- message_cnd(
      "fhub_success",
      where = location,
      message = paste(msg_subject, "is", msg_attribute, "\n", ...)
    )
  } else {
    res <- warning_cnd(
      "fhub_failure",
      where = location,
      message = paste(msg_subject, "has to be", msg_attribute, "\n", ...)
    )
  }

  return(list(res))
}

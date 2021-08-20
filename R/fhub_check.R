#' Utility function to perform a given check and raise the relevant condition
#'
#' @param location Path of folder/file to test
#' @param msg_subject Subject of the condition message
#' @param msg_attribute Attribute of the condition message
#' @param test A test to run. Must evaluate to `TRUE` or `FALSE`
#'
#' @return An object of class `condition` (either `message` or `error` depending
#'    on the value of `test`)..
#'
#' @importFrom rlang message_cnd error_cnd
#'
#' @noRd
fhub_check <- function(location, msg_subject, msg_attribute, test) {

  if (test) {
    message_cnd("fhub_success",
                where = location,
                message = paste(msg_subject, "is", msg_attribute))
  } else {
    error_cnd("fhub_failure",
              where = location,
              message = paste(msg_subject, "has to be", msg_attribute))
  }

}

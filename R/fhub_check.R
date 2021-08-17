#' @importFrom rlang message_cnd error_cnd
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

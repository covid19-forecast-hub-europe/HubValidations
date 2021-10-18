#' Raise conditions stored in a `fhub_validations` object
#'
#' This is meant to be used in CI workflows to raise conditions from
#' `fhub_validations` objects.
#'
#' @param x A `fhub_validations` object
#'
#' @return An error if one of the elements of `x` is of class `fhub_failure` or
#' `fhub_unrecoverable_error`. `TRUE` invisibly otherwise.
#'
#' @export
check_for_errors <- function(x) {
  failures <- x[map_lgl(x, ~ inherits_any(.x, "fhub_failure"))]
  errors <- x[map_lgl(x, ~ inherits_any(.x, "fhub_unrecoverable_error"))]

  pb <- c(failures, errors)
  class(pb) <- c("fhub_validations", "list")

  if (length(pb) > 0) {
    print(pb)
    stop(
      "\nThe validation checks produced some errors reported above.",
      call. = FALSE
    )
  }

  return(invisible(TRUE))
}

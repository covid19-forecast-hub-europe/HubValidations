#' Print results of `validate_...()` function as a bullet list
#'
#' @param x An object of class `fhub_validations`
#' @param ... Unused argument present for class consistency
#'
#' @importFrom dplyr case_when
#' @importFrom purrr map_lgl map_chr
#' @importFrom rlang format_error_bullets inherits_any inherits_all
#' @importFrom stats setNames
#'
#' @export
print.fhub_validations <- function(x, ...) {

  msg <- setNames(
    paste(
      fs::path_file(map_chr(x, "where")),
      map_chr(x, "message"),
      sep = ": "
    ),
    case_when(
      map_lgl(x, ~ inherits_any(.x, "fhub_success")) ~ "v",
      map_lgl(x, ~ inherits_any(.x, "fhub_failure")) ~ "!",
      map_lgl(x, ~ inherits_any(.x, "unrecoverable_error")) ~ "x",
      TRUE ~ "*"
    )
  )

  cat(format_error_bullets(msg))

}

summary.fhub_validations <- function(x, ...) {

  # TODO
  NULL

}

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
      "The validation checks produced some errors reported above.",
      call. = FALSE
    )
  }

  return(invisible(TRUE))
}


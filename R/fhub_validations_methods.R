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



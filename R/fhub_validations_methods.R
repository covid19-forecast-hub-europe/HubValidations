#' @importFrom dplyr case_when
#' @importFrom purrr map_lgl map_chr
#' @importFrom rlang format_error_bullets inherits_any
#'
#' @export
print.fhub_validations <- function(fhub_validations) {

  msg <- setNames(
    paste(
      fs::path_file(map_chr(fhub_validations, "where")),
      map_chr(fhub_validations, "message"),
      sep = ": "
    ),
    case_when(
      map_lgl(fhub_validations, ~ inherits_any(.x, "fhub_success")) ~ "v",
      map_lgl(fhub_validations, ~ inherits_any(.x, "fhub_failure")) ~ "x",
      TRUE ~ "*"
    )
  )

  cat(format_error_bullets(msg))

}

summary.fhub_validations <- function(fhub_validations) {

  # TODO
  NULL

}

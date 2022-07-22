#' Validate forecast hub from pull request
#'
#' @param gh_repo GitHub repository address in the format `username/repo`
#' @param pr_number Number of the pull request to validate
#' @param local Logical. Is this function called from your local computer or
#' from a continuous integration system. By default, it tries to guess the
#' answer based on the values of some environment variables
#' @param ... Arguments passed to [validate_repository()]
#' @inheritParams validate_repository
#'
#' @return An object of class `fhub_validations`.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' validate_pr(
#'   "epiforecasts/covid19-forecast-hub-europe",
#'   536,
#'   data_folder = "data-processed"
#' )
#' }

validate_pr <- function(
  gh_repo,
  pr_number,
  data_folder,
  metadata_folder,
  local = identical(Sys.getenv("GITHUB_ACTIONS"), "true") &&
          identical(Sys.getenv("GITHUB_REPOSITORY"), gh_repo),
  ...
) {

  validations <- list()

  tryCatch({

    if (local) {
      validations <- c(
        validations,
        validate_repository(data_folder, metadata_folder, ...)
      )
    } else {
      pr <- gh::gh(
        "/repos/{gh_repo}/pulls/{pr_number}",
        gh_repo = gh_repo,
        pr_number = pr_number
      )

      pr_head <- pr$head

      tmp <- paste0(tempdir(), "/", pr_head$user$login, "_", pr_head$repo$name)

      if (!fs::dir_exists(tmp)) {
        fs::dir_create(tmp)
        gert::git_clone(
          url = pr_head$repo$html_url,
          branch = pr_head$ref,
          path = tmp
        )
      }

      validations <- c(
        validations,
        validate_repository(
          fs::path(tmp, data_folder),
          fs::path(tmp, metadata_folder),
          ...
        )
      )
    }
  },
  error = function(e) {
    # This handler is used when an unrecoverable error is thrown. This can
    # happen when, e.g., the csv file cannot be parsed by read_csv(). In this
    # situation, we want to output all the validations until this point plus
    # this "unrecoverable" error.
    e <- error_cnd(
      class = "unrecoverable_error",
      where = gh_repo,
      message = conditionMessage(e)
    )
    validations <<- c(validations, list(e))
  })

  tryCatch({

    pr_files <- purrr::map_chr(
      gh::gh(
        "/repos/{gh_repo}/pulls/{pr_number}/files",
        gh_repo = gh_repo,
        pr_number = pr_number
      ),
      "filename"
    )

    validations <- c(validations, fhub_check(
      gh_repo,
      all(startsWith(pr_files, data_folder)),
      paste("Only content of", data_folder), "changed"
    ))
  },
  error = function(e) {
    # This handler is used when an unrecoverable error is thrown. This can
    # happen when, e.g., the csv file cannot be parsed by read_csv(). In this
    # situation, we want to output all the validations until this point plus
    # this "unrecoverable" error.
    e <- error_cnd(
      class = "unrecoverable_error",
      where = gh_repo,
      message = conditionMessage(e)
    )
    validations <<- c(validations, list(e))
  })

  class(validations) <- c("fhub_validations", "list")

  return(validations)
}


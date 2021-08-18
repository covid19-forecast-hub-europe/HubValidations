#' @export
#'
#' @examples
#' validate_pr(
#'   "epiforecasts/covid19-forecast-hub-europe",
#'   536,
#'   data_folder = "data-processed"
#' )

validate_pr <- function(gh_repo, pr_number, data_folder, ...) {

  pr <- gh::gh(paste("/repos", gh_repo, "pulls", pr_number, sep = "/"))

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

  validate_repository(fs::path(tmp, data_folder), ...)


}


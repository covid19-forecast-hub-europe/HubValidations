#' @examples
#' validate_pr(
#'   "epiforecasts/covid19-forecast-hub-europe",
#'   "536"
#' )

validate_pr <- function(gh_repo, pr_number) {

  pr <- gh::gh(paste("/repos", gh_repo, "pulls", pr_number, sep = "/"))

  pr_head <- pr$head

  tmp <- fs::dir_create(paste0(tempdir(), "/", pr_head$user, "_", pr_head$repo$name))

  gert::git_clone(
    url = pr_head$repo$html_url,
    branch = pr_head$ref,
    path= tmp
  )

}


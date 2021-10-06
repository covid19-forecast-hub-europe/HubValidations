tdir <- fs::path(tempdir(), "failed_fh_validations")
fs::dir_create(tdir)
withr::defer(fs::dir_delete(tdir), teardown_env())

fs::dir_copy(
  fs::path_package("ForecastHubValidations", "testdata"),
  tdir
)
withr::with_dir(tdir, {
  fs::file_move("testdata/example-model/2021-07-19-example-model.csv",
                "testdata/example-model/2021-07-18-example-model.csv")
  fs::file_move("testdata/example-model2/metadata-example-model2.txt",
                "testdata/example-model2/metadata-example-model-fail.txt")
})

tdir2 <- fs::path(tempdir(), "error_fh_validations")
fs::dir_create(tdir2)
withr::defer(fs::dir_delete(tdir2), teardown_env())

fs::dir_copy(
  fs::path_package("ForecastHubValidations", "testdata"),
  tdir2
)

file_to_break <- fs::path(tdir2, "testdata", "schema-forecast.yml")

d <- readLines(file_to_break)
d[1] <- paste0(d[1], ":")
write(d, file_to_break)


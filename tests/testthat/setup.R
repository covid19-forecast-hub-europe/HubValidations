tdir <- fs::path(tempdir(), "failed_fh_validations")
fs::dir_create(tdir)
fs::dir_copy(
  fs::path_package("ForecastHubValidations", "testdata"),
  tdir
)
withr::with_dir(tdir, {
  fs::file_move("testdata/example-model/2021-07-19-example-model.csv",
                "testdata/example-model/2021-07-18-example-model.csv")
  fs::file_move("testdata/example-model2/metadata-example-model2.yml",
                "testdata/example-model2/metadata-example-model-fail.yml")
})
withr::defer(fs::dir_delete(tdir), teardown_env())

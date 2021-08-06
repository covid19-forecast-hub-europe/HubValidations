test_that("Metadata file uses the `.yml` extension", {

  expect_match(metadata_file, "\\.yml$")

})

metadata <-read_yaml(metadata_file)

test_that("Metadata file name starts with `model_abbr`", {

  expect_match(
    metadata_file,
    paste("metadata", metadata$model_abbr, sep = "-")
  )

})

# For some reason, jsonvalidate doesn't like it when we don't unbox
metadata_json <- toJSON(metadata, auto_unbox = TRUE)
schema_json <- toJSON(read_yaml(schema_file), auto_unbox = TRUE)

test_that("Metadata file matches schema specifications", {

  # Default engine (imjv) doesn't support schema version above 4 so we switch
  # to ajv that supports all versions
  expect_schema(metadata_json, schema_json, engine = "ajv")

})

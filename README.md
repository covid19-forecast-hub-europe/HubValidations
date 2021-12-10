
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ForecastHubValidations

<!-- badges: start -->

[![R-CMD-check](https://github.com/epiforecasts/ForecastHubValidations/workflows/R-CMD-check/badge.svg)](https://github.com/epiforecasts/ForecastHubValidations/actions)
[![Coverage
status](https://codecov.io/gh/epiforecasts/ForecastHubValidations/branch/main/graph/badge.svg)](https://codecov.io/github/epiforecasts/ForecastHubValidations?branch=main)
<!-- badges: end -->

This package aims at providing a simple interface to run validations on
data and metadata submitted to a forecast hub. Validation tests can be
run at different levels (single file, single folder, whole repository)
and locally as well as part of a continuous integration workflow. For
more information, please read the [“Package design”
vignette](https://epiforecasts.io/ForecastHubValidations/articles/tests.html).

## Installation

You can the latest version of this package from GitHub with:

``` r
# install.packages("remotes")
remotes::install_github("epiforecasts/ForecastHubValidations")
```

## Usage

``` r
library(ForecastHubValidations)

validate_repository(
 system.file("testdata", package = "ForecastHubValidations")
)
#> ✓ example-model: There is only one metadata file
#> ✓ example-model: Folder name is the same as the model name in metadata filename
#> ✓ 2021-07-19-example-model.csv: Folder name is identical to model name in forecast file
#> ✓ 2021-07-26-example-model.csv: Folder name is identical to model name in forecast file
#> ✓ metadata-example-model.yml: Metadata file is using the `.yml` extension
#> ✓ metadata-example-model.yml: Metadata filename is starting with 'metadata-'
#> ✓ metadata-example-model.yml: Metadata filename is the same as `model_abbr`
#> ✓ metadata-example-model.yml: Metadata file is consistent with schema specifications
#> ✓ 2021-07-19-example-model.csv: Filename is formed of a date and a model name
#> ✓ 2021-07-19-example-model.csv: `forecast_date` column is identical to the date in filename
#> ✓ 2021-07-19-example-model.csv: Forecast data is formed of the expected columns with correct type
#> ✓ 2021-07-26-example-model.csv: Filename is formed of a date and a model name
#> ✓ 2021-07-26-example-model.csv: `forecast_date` column is identical to the date in filename
#> ✓ 2021-07-26-example-model.csv: Forecast data is formed of the expected columns with correct type
#> ✓ example-model2: There is only one metadata file
#> ✓ example-model2: Folder name is the same as the model name in metadata filename
#> ✓ 2021-07-19-example-model2.csv: Folder name is identical to model name in forecast file
#> ✓ 2021-07-26-example-model2.csv: Folder name is identical to model name in forecast file
#> ✓ metadata-example-model2.yml: Metadata file is using the `.yml` extension
#> ✓ metadata-example-model2.yml: Metadata filename is starting with 'metadata-'
#> ✓ metadata-example-model2.yml: Metadata filename is the same as `model_abbr`
#> ✓ metadata-example-model2.yml: Metadata file is consistent with schema specifications
#> ✓ 2021-07-19-example-model2.csv: Filename is formed of a date and a model name
#> ✓ 2021-07-19-example-model2.csv: `forecast_date` column is identical to the date in filename
#> ✓ 2021-07-19-example-model2.csv: Forecast data is formed of the expected columns with correct type
#> ✓ 2021-07-26-example-model2.csv: Filename is formed of a date and a model name
#> x 2021-07-26-example-model2.csv: `forecast_date` column has to be identical to the date in filename
#> ✓ 2021-07-26-example-model2.csv: Forecast data is formed of the expected columns with correct type
#> ✓ metadata-example-model.yml: There is only one primary model for a given team
#> ✓ metadata-example-model2.yml: There is only one primary model for a given team
```

## Context

This project is part of a larger effort to provide tools to create and
run a forecast hub. Please also refer to our other packages:

-   [ForecastHubSubmissionApp](https://github.com/epiforecasts/ForecastHubSubmissionApp)

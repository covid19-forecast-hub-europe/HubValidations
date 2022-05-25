
<!-- README.md is generated from README.Rmd. Please edit that file -->

# HubValidations

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
vignette](https://epiforecasts.github.io/ForecastHubValidations/articles/design.html).

## Installation

You can the latest version of this package from GitHub with:

``` r
# install.packages("remotes")
remotes::install_github("epiforecasts/HubValidations")
```

## Usage

``` r
library(HubValidations)

validate_repository(
 system.file("testdata", package = "HubValidations")
)
#> Rows: 6144 Columns: 7
#> ── Column specification ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
#> Delimiter: ","
#> chr  (3): target, location, type
#> dbl  (2): quantile, value
#> date (2): forecast_date, target_end_date
#> 
#> ℹ Use `spec()` to retrieve the full column specification for this data.
#> ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
#> Warning: Unknown or uninitialised column: `origin_date`.
#> Rows: 7200 Columns: 7
#> ── Column specification ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
#> Delimiter: ","
#> chr  (3): target, location, type
#> dbl  (2): quantile, value
#> date (2): forecast_date, target_end_date
#> 
#> ℹ Use `spec()` to retrieve the full column specification for this data.
#> ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
#> Warning: Unknown or uninitialised column: `origin_date`.
#> Rows: 6144 Columns: 7
#> ── Column specification ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
#> Delimiter: ","
#> chr  (3): target, location, type
#> dbl  (2): quantile, value
#> date (2): forecast_date, target_end_date
#> 
#> ℹ Use `spec()` to retrieve the full column specification for this data.
#> ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
#> Warning: Unknown or uninitialised column: `origin_date`.
#> Rows: 7200 Columns: 7
#> ── Column specification ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
#> Delimiter: ","
#> chr  (3): target, location, type
#> dbl  (2): quantile, value
#> date (2): forecast_date, target_end_date
#> 
#> ℹ Use `spec()` to retrieve the full column specification for this data.
#> ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
#> Warning: Unknown or uninitialised column: `origin_date`.
#> ✔ example-model: There is only one metadata file 
#> 
#> ✔ example-model: Folder name is the same as the model name in metadata filename 
#> 
#> ✔ 2021-07-19-example-model.csv: Folder name is identical to model name in data file 
#> 
#> ✔ 2021-07-26-example-model.csv: Folder name is identical to model name in data file 
#> 
#> ✔ metadata-example-model.txt: Metadata file is using the `.txt` extension 
#> 
#> ✔ metadata-example-model.txt: Metadata filename is starting with 'metadata-' 
#> 
#> ✔ metadata-example-model.txt: Metadata filename is the same as `model_abbr` 
#> 
#> ✔ metadata-example-model.txt: Metadata file is consistent with schema specifications 
#>  
#> ✔ 2021-07-19-example-model.csv: Filename is formed of a date and a model name, separated by an hyphen 
#> 
#> ! 2021-07-19-example-model.csv: `forecast_date` column has to be identical to the date in filename 
#> 
#> ✔ 2021-07-19-example-model.csv: Data is formed of the expected columns with correct type 
#>  
#> ✔ 2021-07-26-example-model.csv: Filename is formed of a date and a model name, separated by an hyphen 
#> 
#> ! 2021-07-26-example-model.csv: `forecast_date` column has to be identical to the date in filename 
#> 
#> ✔ 2021-07-26-example-model.csv: Data is formed of the expected columns with correct type 
#>  
#> ✔ example-model2: There is only one metadata file 
#> 
#> ✔ example-model2: Folder name is the same as the model name in metadata filename 
#> 
#> ✔ 2021-07-19-example-model2.csv: Folder name is identical to model name in data file 
#> 
#> ✔ 2021-07-26-example-model2.csv: Folder name is identical to model name in data file 
#> 
#> ✔ metadata-example-model2.txt: Metadata file is using the `.txt` extension 
#> 
#> ✔ metadata-example-model2.txt: Metadata filename is starting with 'metadata-' 
#> 
#> ✔ metadata-example-model2.txt: Metadata filename is the same as `model_abbr` 
#> 
#> ✔ metadata-example-model2.txt: Metadata file is consistent with schema specifications 
#>  
#> ✔ 2021-07-19-example-model2.csv: Filename is formed of a date and a model name, separated by an hyphen 
#> 
#> ! 2021-07-19-example-model2.csv: `forecast_date` column has to be identical to the date in filename 
#> 
#> ✔ 2021-07-19-example-model2.csv: Data is formed of the expected columns with correct type 
#>  
#> ✔ 2021-07-26-example-model2.csv: Filename is formed of a date and a model name, separated by an hyphen 
#> 
#> ! 2021-07-26-example-model2.csv: `forecast_date` column has to be identical to the date in filename 
#> 
#> ✔ 2021-07-26-example-model2.csv: Data is formed of the expected columns with correct type 
#>  
#> ✔ metadata-example-model.txt: There is only one primary model for a given team
```

## Context

This project is part of a larger effort to provide tools to create and
run a forecast hub. Please also refer to our other packages:

-   [HubSubmissionApp](https://github.com/epiforecasts/ForecastHubSubmissionApp)

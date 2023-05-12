#' Generate a synthetic dataset tailored for REDI computations
#'
#' Simulate a complete training dataset, which may be representative of various
#' applications. Several flexible arguments allow adjustment of the range of
#' observed days, the distribution and the mean of `Output` values, as well as
#' the ratio of missing data.
#'
#' @param start_date A date, indicating the starting time of observations.
#'    Default is '2022-01-01'.
#' @param end_date A date, indicating the ending time of observations. Default
#'    is '2023-01-01'.
#' @param by A number or a character string, indicating the reference time
#'    time period between two observations. Possible values are 'day', 'week',
#'    'month', 'year', or any arbitrary number. See documentation of the 'seq()'
#'    for additional information if necessary. Default is 'day'.
#' @param output_distrib A character string, indicating the distribution of
#'    `Output` values. Possible values: 'Gaussian' (default), 'Uniform'.
#' @param ratio_missing A number, between 0 and 1, indicating the ratio of
#'    missing values in the dataset. Default is 0.5.
#' @param mean A number, indicating the mean value of the Gaussian distribution.
#'    Default is 50.
#' @param var A number, indicating the variance of the Gaussian distribution.
#'    Default is 10.
#' @param range_unif A vector, indicating the range of values for the Uniform
#'    distribution. Default is c(0,100).
#'
#' @return  A full dataset of synthetic data.
#' @export
#'
#' @importFrom rlang .data
#'
#' @examples
#'
#' ## Generate a dataset with Gaussian measurements
#' data = simu_db(output_distrib = 'Gaussian')
#'
#' ## Generate a dataset with Uniform measurements and 30% of missing data.
#' data = simu_db(output_distrib = 'Uniform', ratio_missing = 0.3)
#'
simu_db <- function(
    start_date = '2022-01-01',
    end_date = '2023-01-01',
    by = 'day',
    output_distrib = 'Gaussian',
    ratio_missing = 0.5,
    mean = 50,
    var = 10,
    range_unif = c(0, 100)
){
  ## Define the range of observed inputs
  input <- seq(
      lubridate::as_date(start_date),
      lubridate::as_date(end_date),
      by = 'day')

  size <- length(input)

  ## Simulate observed output values
  if(output_distrib == 'Gaussian'){
    output = stats::rnorm(size, mean, sqrt(var))
  } else if (output_distrib == 'Uniform'){
    output = stats::runif(size, range_unif[[1]], range_unif[[2]])
  } else {
    stop("The 'output_distrib' argument should be 'Gaussian' or 'Uniform'.")
  }

  ## Draw random locations of missing data
  missing_index <- sample(2:size, ratio_missing * size)

  ## Replace values by NA to simulate missing data
  output[missing_index] <- NA

  ## Create and return the dataset
  tibble::tibble(
    'Input' = input,
    'Output' = output) %>%
   return()
}

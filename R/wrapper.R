#' Compute REDI for all observed and missing input values in a dataset
#'
#' Wrapper function that converts the dataset to the adequate format, compute
#' values of REDI for each `Input` values, display a generic plot of the results
#' and return a tibble containing both data and corresponding REDI values.
#'
#' @param data A tibble or a data frame, containing an `Input` column that is
#'    used as reference for the observations (e.g. time for
#'    longitudinal data), and an `Output` column specifying the observed
#'    values of interest (the workload).
#' @param coef A number or vector, containing the values of the lambda
#'    coefficient used in the REDI computations, controlling the decay
#'    of the exponential weights. Default is c(0.05, 0.1, 0.5).
#' @param input A character or a number, indicating the name or the
#'    index of the `Input` column (time).
#' @param output A character or a number, indicating the name or the
#'    index of the `Output` column (workload).
#' @param plot A boolean, indicating whether results should be displayed.
#'    is TRUE.
#' @param by A number or a character string, indicating the reference time
#'    period between two observations. Possible values are 'day', 'week',
#'    'month', 'year', or any arbitrary number. See documentation of the 'seq()'
#'    for additional information if necessary. Default is 'day'.
#' @param format A character string, indicating the date format of the input.
#'    Please read `lubridate::as_date()`. Default is '%Y%m%d'.
#' @param summary_duplicate A function, used to summarise Output values for
#'    duplicated Input values. Default is mean.
#'
#' @return A tibble containing 4 columns : `Input` (without duplicates),
#'        `Output`, `Lambda` and `REDI`, which corresponds to the vector
#'         returned by the `loop_REDI()` function.
#' @export
#'
#' @examples
#' data <- simu_db()
#' redi <- redi(data)
redi <- function(
    data,
    coef = c(0.05, 0.1, 0.5),
    input = 1,
    output = 2,
    plot = TRUE,
    by = 'day',
    format = '%Y%m%d',
    summary_duplicate = mean
    ){

  ## Format the dataset
  data <- format_data(
    data = data,
    input = input,
    output = output,
    by = by,
    format = format,
    summary_duplicate = summary_duplicate)

  ## Compute loop_REDI for all `Lambda` values
  res <- c()
  for (i in coef){
    res <- res %>%
      dplyr::bind_rows(
        loop_redi(data, coef = i) %>% dplyr::mutate('Lambda' = i))
  }

  ## Display a generic plot of the results
  if(plot){
    plot_redi(res) %>% print()
  }

  return(res)
}

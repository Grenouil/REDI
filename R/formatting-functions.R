#' Format the dataset to the syntax of REDI functions
#'
#' @param data A tibble or data frame containing one column indicating time and
#'    another indicating the quantity for which we want to compute REDI.
#' @param input A character or a number, indicating whether the name or the
#'    index of the input column (time).
#' @param output A character or a number, indicating whether the name or the
#'    index of the output column (workload).
#' @param by A number or a character string, indicating the reference time
#'    period between two observations. Possible values are 'day', 'week',
#'    'month', 'year', or any arbitrary number. See documentation of the 'seq()'
#'    for additional information if necessary. Default is 'day'.
#' @param format A character string, indicating the date format of the input.
#'    Please read `lubridate::as_date()`. Default is '%Y%m%d'.
#' @param summary_duplicate A function, used to summarise Output values for
#'    duplicated Input values. Default is mean.
#'
#' @return A tibble with Input and Output columns and explicit missing values
#'    between observations.
#' @export
#'
#' @examples
#' TRUE
format_data <- function(
    data,
    input = 1,
    output = 2,
    by = 'day',
    format = '%Y%m%d',
    summary_duplicate = mean){

  ## Recover the adequate Input and Output column in the dataset
  db <- tibble::tibble(
    'Input' = data[[input]] %>% lubridate::as_date(format = format),
    'Output' = data[[output]]
  )

  ## Test whether there are `Input` values duplicated in the data
  if(any(base::duplicated(db$Input)) == TRUE){
    warning('At least one `Input` value is duplicated. For each duplicated',
            '`Input`, the mean value of the corresponding`Output`is computed',
            ' and only one occurence of `Input` is retained. One can replace',
            ' the mean by another basic function by changing the default value',
            'of `summary_duplicate`.')

    ## Summarise duplicated values and add missing Inputs between observed data
    db <- db %>%
      dplyr::group_by(.data$Input) %>%
      dplyr::summarise('Output' = summary_duplicate(.data$Output)) %>%
      dplyr::distinct(.data$Input, .keep_all = TRUE)
  }

    db %>%
      dplyr::full_join(tibble::tibble(
        'Input' = seq(min(db$Input), max(db$Input), by = by)
      ), by = 'Input') %>%
      dplyr::arrange(.data$Input) %>%
    return()
}

#' Compute REDI for a specific input
#'
#' @param data A tibble or data frame, containing an `Input` column (with the
#'    Date format) and an `Output` column. A simple vector of workload values,
#'    pre-sorted by chronological order, can also be provided.
#' @param coef A number corresponding to the lambda coefficient, controlling the
#'    decay of the exponential weights.
#'
#' @return A number, corresponding to the REDI value at the last `Input` time,
#'    computed over the whole period.
#' @export
#'
#' @examples
#' data <- simu_db()
#' compute_redi(data = data, coef = 0.1)
compute_redi <- function(data, coef = 0.1){
  load <- 0
  norm <- 0

  ## If a vector is provided, create a dummy tibble
  if(data %>% is.vector()){
    data <- tibble::tibble(
      'Input' = 1:length(data),
      'Output' = data)
  }

  ## Sort according to the Input values
  data <- data %>% dplyr::arrange(.data$Input)

  if(any(base::duplicated(data$Input)) == TRUE){
    stop('Some input values are duplicated. Please use format_data().')
  }

  ## Count the number of time points
  nb_inputs <- nrow(data)

  ## Iterate on all inputs starting from 0 to have first coef = 1
  for (i in 0:(nb_inputs - 1))
  {
    ## We compute from present to past, so we are moving backwards
    ## Skip the summation if the value is missing
    if( !is.na(data$Output[nb_inputs - i]) )
    {
      ## Compute the sum of daily loads weighted by the appropriate coefficient
      load <- load + exp(- coef * i) * data$Output[nb_inputs - i]
      ## Update the normalisation constant
      norm <- norm + exp(- coef * i)
    }
  }
  return(load/norm)
}

#' Compute the evolution of REDI over successive inputs
#'
#' @param data A tibble or data frame, containing an `Input` column (with the
#'    Date format) and an `Output` column. A simple vector of workload values,
#'    pre-sorted by chronological order can also be provided.
#' @param coef A number corresponding to the lambda coefficient, controlling the
#'    decay of the exponential weights. Default is 0.1.
#'
#' @return A tibble similar to `data`, containing an additional \code{REDI}
#'     column computed over the successive input values.
#' @export
#'
#' @examples
#' data <- simu_db()
#' loop_redi(data = data, coef = 0.1)
loop_redi <- function(data, coef = 0.1)
{
  ## If a vector is provided, create a dummy tibble
  if(data %>% is.vector()){
    data <- tibble::tibble(
      'Input' = length(data):1,
      'Output' = data)
  }

  ## Sort according to the Input values.
  data <- data %>% dplyr::arrange(dplyr::desc(.data$Input))

  if(any(base::duplicated(data$Input)) == TRUE){
    stop('Some input values are duplicated. Please use format_data().')
  }

  ## Throw an error if the dataset starts with a missing point.
  if(data %>%
     dplyr::filter(.data$Input == min(.data$Input)) %>%
     dplyr::pull(.data$Output) %>%
     is.na()){
    stop("The first Input corresponds to a missing Output value. ",
         "Please provide a first observed value to start computing REDI.")
  }

  ## Compute REDI for all Input values with speed-up vectorised operations
  list_redi <- data %>%
    tidyr::uncount(weights = 1:nrow(data), .id = 'Repet') %>% ## Duplicate DBs
    dplyr::mutate('Coef' = exp(- coef * (.data$Repet - 1))) %>% ## Compute coefs
    dplyr::group_by(.data$Input) %>%
    dplyr::mutate('Sub_db' = dplyr::n() - .data$Repet) %>% ## Identify sub-DBs
    tidyr::drop_na() %>% ## Ignore the missing `Output` values from computations
    dplyr::group_by(.data$Sub_db) %>%
    dplyr::summarise( ## Compute REDI for each sub-DB
      'REDI' = sum( .data$Output * .data$Coef / sum(.data$Coef))) %>%
    dplyr::pull(.data$REDI) ## Extract REDI values

  ## Add REDI values to the dataset and return results
    data %>%
    dplyr::mutate('REDI' = list_redi) %>%
    return()
}

#' REDI: Robust Exponential Decreasing Index
#'
#' Implementation of the Robust Exponential Decreasing Index (REDI).
#' The REDI represents a measure of cumulated workload, robust to missing data,
#' providing control of the decreasing influence of workload over time.
#' Various functions are provided to format data, compute REDI, and
#' visualise results in a simple and convenient way.
#'
#' @section Details:
#' For a quick introduction to \pkg{REDI}, please refer to the README at
#' \url{https://github.com/ArthurLeroy/REDI}
#'
#' @section Author(s):
#' Arthur Leroy, Alexia Grenouillat \cr
#' Maintainer: Arthur Leroy - \email{arthur.leroy.pro@@gmail.com}
#'
#' @section References:
#' Issa Moussa, Arthur Leroy et al., BMJ SEM (2019)
#' \url{https://bmjopensem.bmj.com/content/bmjosem/5/1/e000573.full.pdf}
#'
#' @section Examples:
#'
#' ### Simulate a dataset, compute REDI and display results \cr
#' set.seed(42) \cr
#' data <- simu_db(nb_inputs) \cr
#' redi <- redi(data) \cr
#' plot_redi(redi) \cr
#'
#' @docType package
#' @name REDI
NULL
#> NULL

#' Display the evolution of REDI over time and data points.
#'
#' @param redi A tibble or data frame containing 4 mandatory columns : `Input`,
#'    `Output`, `REDI` and `Lambda`. One can use the `redi()`
#'    function to get this tibble under the right format.
#' @param x_axis A character string, label of the x-axis. Default is 'Input'.
#' @param y_axis A character string, label of the y-axis. Default is 'Output'.
#' @param plot_data A boolean, indicating whether original data should be
#'    displayed. Default is TRUE.
#' @param alpha A number, between 0 and 1, controlling the transparency of
#'                    data points. Default is 0.2.
#' @param size A number, controlling the size of the data points. Default is 1.
#'
#' @return Graph of the evolution of REDI over time, possibly for different
#'    values of Lambda, along with the original data points.
#' @export
#'
#' @examples
#' TRUE
plot_redi <- function(
    redi,
    plot_data = TRUE,
    x_axis = 'Input',
    y_axis = 'Output',
    alpha = 0.2,
    size = 1){

  ## Transform `Lambda` into factor for colouring purposes
  db_plot <- redi %>% dplyr::mutate('Lambda' = as.factor(.data$Lambda))

  ## Plot REDI curves for all values over time of `Lambda`
  gg <- ggplot2::ggplot(db_plot) +
    ggplot2::geom_line(
      ggplot2::aes(
        x = .data$Input,
        y = .data$REDI,
        col = .data$Lambda)
      ) +
    ggplot2::labs(
      x = x_axis,
      y = y_axis,
      title = 'Evolution of REDI over time') +
    ggplot2::theme_classic()

  ## Add raw data points if requested
  if(plot_data){
    gg <- gg +
      ggplot2::geom_point(
        ggplot2::aes(x = .data$Input, y = .data$Output),
        alpha = alpha,
        size = size
      )
  }

  return(gg)
}

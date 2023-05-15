# REDI-package-master
Implementation of the Robust Exponential Decreasing Index (REDI), proposed in the article by Issa Moussa, Arthur Leroy et al. (2019) <https://bmjopensem.bmj.com/content/bmjosem/5/1/e000573.full.pdf>.

The REDI represents a measure of cumulated workload, robust to missing data, providing control of the decreasing influence of workload over time. 
Various functions are provided to format data, compute REDI, and visualise results in a simple and convenient way.
=======

# REDI

<!-- badges: start -->
<!-- badges: end -->

The *REDI* package implements the Robust Exponential Decreasing Index
(REDI). It represents a measure of cumulated workload, is robust to
missing data and provides control of the decreasing influence of the
workload over time.

*REDI* provides various functions to format data, compute REDI and
visualise results in a simple and convenient way.

Issa Moussa, Arthur Leroy et al. (2019): Robust Exponential Decreasing
Index (REDI): adaptive and robust method for computing cumulated
workload. *BMJ Open Sport & Exercise Medicine*,
<https://bmjopensem.bmj.com/content/bmjosem/5/1/e000573.full.pdf>.

## Installation

You can install the development version of REDI from
[GitHub](https://github.com/) with:

``` r
#install.packages("devtools")
devtools::install_github("Grenouil/REDI-package-master")
```

## Example: REDI

Here is a basic example on how to simulate a dataset with the adequate
format, apply REDI on it and visualise results.

### Data simulation

``` r
library(REDI)
## Simulate a synthetic dataset, containing observations (inputs) from '2022-01-01' to '2023-01-01'. Outputs follow a gaussian distribution (mean = 50, var = 10), with a ratio of missing values equals to 0.5.

set.seed(3)
db <- simu_db(start_date = '2022-01-01',
    end_date = '2023-01-01',
    by = 'day',
    output_distrib = 'Gaussian',
    ratio_missing = 0.5,
    mean = 50,
    var = 10)
db
#> # A tibble: 366 × 2
#>    Input      Output
#>    <date>      <dbl>
#>  1 2022-01-01   47.0
#>  2 2022-01-02   49.1
#>  3 2022-01-03   NA  
#>  4 2022-01-04   46.4
#>  5 2022-01-05   NA  
#>  6 2022-01-06   50.1
#>  7 2022-01-07   NA  
#>  8 2022-01-08   53.5
#>  9 2022-01-09   46.1
#> 10 2022-01-10   54.0
#> # … with 356 more rows
```

As displayed above, any dataset processed in REDI should provide 2
columns: one corresponding to `Input` values (*i.e.* time) and another
to `Output` values (*i.e.* workload).

### Computation of REDI

``` r
## Apply redi() on db, with coef equal to 0.1.
db_redi <- redi(data = db, coef = 0.1, plot = FALSE)
db_redi
#> # A tibble: 366 × 4
#>    Input      Output  REDI Lambda
#>    <date>      <dbl> <dbl>  <dbl>
#>  1 2023-01-01   NA    51.1    0.1
#>  2 2022-12-31   53.4  51.1    0.1
#>  3 2022-12-30   NA    50.4    0.1
#>  4 2022-12-29   NA    50.4    0.1
#>  5 2022-12-28   51.3  50.4    0.1
#>  6 2022-12-27   NA    50.1    0.1
#>  7 2022-12-26   NA    50.1    0.1
#>  8 2022-12-25   NA    50.1    0.1
#>  9 2022-12-24   NA    50.1    0.1
#> 10 2022-12-23   43.7  50.1    0.1
#> # … with 356 more rows
```

**db_redi** contains 4 columns: `Input`, `Output`,`REDI` and `Lambda`.

### Display results

``` r
## Display results on a 2D plot, setting 'plot_data' to TRUE to visualise original data.
plot_redi(redi = db_redi,
          x_axis = 'Input',
          y_axis = 'Output',
          plot_data = TRUE)
#> Warning: Removed 183 rows containing missing values (`geom_point()`).
```

<img src="man/figures/README-plot REDI-1.png" width="100%" />



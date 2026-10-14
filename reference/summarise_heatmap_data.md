# 按热图格子聚合数据

按 `x_var` ×
`y_var`（以及可选的分面变量）分组，计算每个格子的统计值和样本数。 这是
[`plot_performance_heatmap()`](https://tony2015116.github.io/pigheatmap/reference/plot_performance_heatmap.md)
的数据准备步骤，单独导出是为了方便：

- 拿到汇总表另作他用（导出 Excel、写报告等）；

- 在绘图前先检查聚合结果是否符合预期。

## Usage

``` r
summarise_heatmap_data(
  data,
  x_var,
  y_var,
  fill_var,
  facet_vars = NULL,
  summary_stat = c("mean", "median", "sum", "sd", "min", "max"),
  min_count = 1
)
```

## Arguments

- data:

  原始数据框。

- x_var, y_var:

  X 轴、Y 轴映射的列名（字符串）。

- fill_var:

  需要聚合的数值列名（字符串）。因子或字符型的数字会被自动转换。

- facet_vars:

  （可选）分面变量名，长度为 1 或 2。

- summary_stat:

  聚合统计量：`"mean"`（默认）、`"median"`、`"sum"`、`"sd"`、
  `"min"`、`"max"`，或自定义函数，例如
  `function(x) quantile(x, 0.9, na.rm = TRUE)`。

- min_count:

  单元格最少样本数，低于该值的格子会被剔除，默认为 1（不剔除）。

## Value

一个 tibble，包含分组列以及：

- `stat_value`：该格子的统计值；

- `count`：该格子的有效样本数（`fill_var` 非缺失的行数）。

## Examples

``` r
# 各场、各胎次的平均断奶数
summarise_heatmap_data(sow_demo, x_var = "farm", y_var = "parity", fill_var = "weaned")
#> # A tibble: 30 × 4
#>    farm   parity stat_value count
#>    <chr>   <int>      <dbl> <int>
#>  1 Farm A      1      10.6    173
#>  2 Farm A      2      11.4    147
#>  3 Farm A      3      11.8    131
#>  4 Farm A      4      12.4    144
#>  5 Farm A      5      12.3    108
#>  6 Farm A      6      11.2     69
#>  7 Farm A      7      10.8     66
#>  8 Farm A      8      10.4     43
#>  9 Farm A      9      10.1     16
#> 10 Farm A     10       9.14     7
#> # ℹ 20 more rows

# 用中位数，并剔除样本数少于 10 窝的格子
summarise_heatmap_data(
  sow_demo, "farm", "parity", "weaned",
  summary_stat = "median", min_count = 10
)
#> # A tibble: 25 × 4
#>    farm   parity stat_value count
#>    <chr>   <int>      <dbl> <int>
#>  1 Farm A      1         11   173
#>  2 Farm A      2         12   147
#>  3 Farm A      3         12   131
#>  4 Farm A      4         12   144
#>  5 Farm A      5         12   108
#>  6 Farm A      6         11    69
#>  7 Farm A      7         11    66
#>  8 Farm A      8         10    43
#>  9 Farm A      9         10    16
#> 10 Farm B      1         10   181
#> # ℹ 15 more rows
```

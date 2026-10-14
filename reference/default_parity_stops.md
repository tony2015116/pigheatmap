# "胎次"默认分段色阶

内置的胎次配色方案，作为 `plot_type = "parity"` 时的默认值：

|        |                    |                      |
|--------|--------------------|----------------------|
| 胎次   | 颜色               | 含义                 |
| 0~1    | 灰色               | 数据代表性不足       |
| 2~3    | 浅黄 -\> 黄绿      | 逐渐接近峰值         |
| 3~5    | 黄绿 -\> 深绿      | 生产高峰期，颜色最优 |
| 5~8    | 黄绿 -\> 橙 -\> 红 | 下降趋势由轻到重     |
| 8 以上 | 灰色               | 数据代表性不足       |

可通过
[`plot_performance_heatmap()`](https://tony2015116.github.io/pigheatmap/reference/plot_performance_heatmap.md)
的 `color_stops` 参数完全自定义。

## Usage

``` r
default_parity_stops()
```

## Value

含 `value`、`color` 两列的数据框。

## Details

配色以 3~5
胎（生产高峰期）的深绿色为峰值，峰值之后依次经过黄绿、橙、红，
颜色越醒目表示下降越明显；两端代表性不足的胎次统一收尾为灰色。所有彩色断点
都取自 ColorBrewer 的 RdYlGn 配色，保证饱和度和明度风格一致。

断点表最后多了一个 value = 9
的灰色锚点。这是为了让灰色在定义域内部有实际 宽度：这样 8
胎恰好取红色，8 胎以上（包括被 `squish` 裁剪到上边界的 9 胎、 10
胎……）取灰色。详见
[`build_segment_scale()`](https://tony2015116.github.io/pigheatmap/reference/build_segment_scale.md)
中关于硬分界的说明。

## Examples

``` r
default_parity_stops()
#>    value   color
#> 1      0  grey70
#> 2      1  grey70
#> 3      2 #FFFFBF
#> 4      3 #D9EF8B
#> 5      3 #A6D96A
#> 6      5 #1A9850
#> 7      6 #D9EF8B
#> 8      7 #FDAE61
#> 9      8 #D73027
#> 10     8  grey70
#> 11     9  grey70
```

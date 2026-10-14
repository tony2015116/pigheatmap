# 构造分段/自定义色阶

根据一组 (value, color) 断点构造
[`ggplot2::scale_fill_gradientn()`](https://ggplot2.tidyverse.org/reference/scale_gradient.html)，用于表现
"特定区间对应特定颜色"的场景。不仅限于胎次，背膘厚、首配日龄等任何有经验
区间划分的性状都可以使用。

## Usage

``` r
build_segment_scale(
  stops,
  limits = range(stops$value),
  oob = scales::squish,
  name = ggplot2::waiver(),
  ...
)
```

## Arguments

- stops:

  数据框，包含 `value` 和 `color` 两列，按 `value` 升序排列。

- limits:

  长度为 2 的升序数值向量，色阶的取值范围，超出部分按 `oob` 处理。
  默认取 `range(stops$value)`。

- oob:

  越界值处理函数，默认为
  [`scales::squish()`](https://scales.r-lib.org/reference/oob.html)（裁剪到边界颜色）。

- name:

  图例标题。

- ...:

  其他传给
  [`ggplot2::scale_fill_gradientn()`](https://ggplot2.tidyverse.org/reference/scale_gradient.html)
  的参数，例如 `breaks`。

## Value

一个可以用 `+` 叠加到 ggplot 对象上的连续填充色阶。

## Details

**硬分界**：允许 `value`
出现重复（同一断点前后颜色不同），以制造颜色骤变。
函数内部会对重复断点做极小偏移（取值范围的百万分之一），避免插值出错：

- 一般位置：后一个重复点向上偏移，因此**恰好等于断点的值取前一个颜色**
  （例如断点 8 前红后灰，则 8 显示为红色，8 以上显示为灰色）。

- 位于 `limits` 上边界的重复点：无法再向上偏移，改为前一个向下偏移，此时
  恰好等于上边界的值（以及被 `squish`
  裁剪到上边界的值）取**后一个**颜色。

如果希望上边界处也保持"取前一个颜色"，可以像
[`default_parity_stops()`](https://tony2015116.github.io/pigheatmap/reference/default_parity_stops.md)
那样，
在硬分界之后再加一个同色锚点，让最后一段颜色在定义域内部有实际宽度。

## Examples

``` r
library(ggplot2)

mating_age_stops <- data.frame(
  value = c(200, 240, 260, 300),
  color = c("#D73027", "#1A9850", "#1A9850", "#D73027")
)

df <- data.frame(x = 1:11, y = 1, age = seq(200, 300, by = 10))
ggplot(df, aes(x, y, fill = age)) +
  geom_tile() +
  geom_text(aes(label = age)) +
  build_segment_scale(mating_age_stops, name = "Age (d)")
```

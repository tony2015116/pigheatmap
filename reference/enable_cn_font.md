# 启用中文字体渲染

调用
[`showtext::showtext_auto()`](https://rdrr.io/pkg/showtext/man/showtext_auto.html)，让中文在各类图形设备（尤其是
[`ggsave()`](https://ggplot2.tidyverse.org/reference/ggsave.html)
导出的位图）上正确显示，并同步设置 showtext 的 dpi。

**dpi 必须和导出时一致**：showtext 默认按 96 dpi 渲染文字，如果用
`ggsave(dpi = 300)` 导出而这里没有设成 300，图片中的文字会明显偏小。

该函数会修改整个 R 会话的图形状态，因此只需要在脚本开头调用一次。
需要先安装 showtext：`install.packages("showtext")`。

## Usage

``` r
enable_cn_font(dpi = 300, family = NULL, family_name = "cn")
```

## Arguments

- dpi:

  与 [`ggsave()`](https://ggplot2.tidyverse.org/reference/ggsave.html)
  导出时一致的 dpi，默认为 300。

- family:

  （可选）要注册的字体文件路径，例如 `"C:/Windows/Fonts/msyh.ttc"`。
  提供后会以 `family_name` 注册为字体族；不提供则使用 showtext
  内置的中文字体。

- family_name:

  注册字体时使用的字体族名称，默认为 `"cn"`。

## Value

不可见地返回 `TRUE`。

## Examples

``` r
if (FALSE) { # \dontrun{
# 脚本开头调用一次
enable_cn_font(dpi = 300)

p <- plot_performance_heatmap(sow_demo, "month", "parity", "weaned")
ggplot2::ggsave("heatmap.png", p, width = 12, height = 7, dpi = 300)

# 使用指定的字体文件（例如 Windows 上的微软雅黑）
enable_cn_font(dpi = 300, family = "C:/Windows/Fonts/msyh.ttc")
p + ggplot2::theme(text = ggplot2::element_text(family = "cn"))
} # }
```

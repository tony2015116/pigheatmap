# pigheatmap 0.2.0

* 改用 [fusen](https://thinkr-open.github.io/fusen/) 开发：所有代码、文档、测试和文章都写在
  `dev/flat_*.Rmd` 中，由 `source("dev/inflate_all.R")` 统一生成。
* 新增 pkgdown 网站，由 GitHub Actions 自动构建并发布到 GitHub Pages。
* 新增示例数据集 `sow_demo`（模拟的母猪分娩记录）。
* 新增三篇文章：快速上手、分段色阶、主题与中文字体。
* `showtext` 和 `sysfonts` 移到 Suggests，只在调用 `enable_cn_font()` 时需要。
* 修复：在 Windows 上运行 `devtools::check()` 时，示例因中文无法在 pdf 设备上绘制而报错
  （`conversion failure ... in 'mbcsToSbcs'`）。现在仅在 R CMD check / pkgdown 构建时
  自动改用 png 设备，日常使用不受影响。

# pigheatmap 0.1.0

* 首个版本，由原有绘图脚本整理而来。
* 修复：分段色阶的硬分界落在定义域上边界时取色错误的问题（`build_segment_scale()` 内部处理，无需再依赖额外锚点）。
* 修复：格子标签小数位不一致（`2` 现在显示为 `2.0`）。
* 修复：胎次整数刻度会在坐标轴末端多出一个空刻度。
* 修复：分面列名含空格或以数字开头时报错。
* 修复：字符型数值转换时出现两条重复的警告。
* 新增 `summarise_heatmap_data()`，可单独获取聚合结果。
* 新增 `enable_cn_font()`，主题函数不再修改全局 showtext 状态。
* 新增 `theme_args`，`get_common_theme()` 的所有参数都可以从主函数调整。
* 新增 `label_color = "auto"`，按格子亮度自动选择黑/白文字。
* 新增 `count_label`、`show_caption`、`subtitle` 参数。
* 新增参数校验：`alpha_range`、`min_count`、`theme_args`、`facet_space` 与 `facet_scales` 的组合。

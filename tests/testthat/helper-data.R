# 测试辅助函数（手动维护，不由 fusen 生成；已在 dev/config_fusen.yaml 的 keep 中登记）

# 测试用的小数据集
make_sow_data <- function() {
  data.frame(
    farm   = rep(c("A", "B"), each = 6),
    parity = rep(1:3, 4),
    weaned = c(10, 11, 12, 9, 11, 13, 10, 12, 11, 10, 12, 12)
  )
}

# 把色阶映射后的颜色统一成大写 #RRGGBB，便于比较
map_colors <- function(scale, values) {
  sc <- scale$clone()
  sc$train(values)
  toupper(substr(sc$map(values), 1, 7))
}

hex <- function(col) {
  rgb <- grDevices::col2rgb(col)
  toupper(grDevices::rgb(rgb[1, ], rgb[2, ], rgb[3, ], maxColorValue = 255))
}

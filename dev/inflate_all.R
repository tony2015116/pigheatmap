# 一键重新生成整个包：转义中文字符串 -> inflate 所有 flat 文件 -> 更新文档与依赖
#
# 用法（在包根目录下）：
#   source("dev/inflate_all.R")
#
# 为什么不直接用 fusen::inflate_all()？
#   fusen 0.7.x 在 dev/config_fusen.yaml 中只保存文章的英文文件名，不保存中文标题，
#   用 inflate_all() 重新生成后，文章标题会变成英文文件名（如 "pigheatmap"）。
#   这里显式地为每个 flat 文件指定"中文标题 = 英文文件名"，保证标题不丢。
#
# 新增 flat 文件时，在下面的 flats 列表中加一行即可：
#   - 生成文章："dev/flat_xxx.Rmd" = c("中文标题" = "english-file-name")
#   - 不生成文章："dev/flat_xxx.Rmd" = NA

flats <- list(
  "dev/flat_utils.Rmd"   = NA,
  "dev/flat_scales.Rmd"  = c("分段色阶" = "segmented-scales"),
  "dev/flat_theme.Rmd"   = c("主题与中文字体" = "theme-and-fonts"),
  "dev/flat_heatmap.Rmd" = c("快速上手" = "pigheatmap")
)

local({
  if (!file.exists("DESCRIPTION") || !dir.exists("dev")) {
    stop("请在包根目录下运行：source(\"dev/inflate_all.R\")")
  }

  # 1. 函数代码中的中文字符串 -> \uXXXX 转义
  source("tools/escape_strings.R", local = TRUE)

  # 2. 逐个 inflate；check = FALSE，最后统一检查
  old <- options(usethis.quiet = TRUE)
  on.exit(options(old), add = TRUE)
  for (f in names(flats)) {
    message("\n==== inflate ", f)
    fusen::inflate(
      flat_file = f,
      vignette_name = flats[[f]],
      check = FALSE,
      open_vignette = FALSE,
      overwrite = "yes",
      clean = "yes"
    )
  }

  # 3. 让 vignette 索引名（vignette() / browseVignettes() 中显示的名称）也使用中文标题
  for (f in names(flats)) {
    v <- flats[[f]]
    if (length(v) != 1 || is.na(v) || is.null(names(v))) next
    path <- file.path("vignettes", paste0(v, ".Rmd"))
    lines <- readLines(path, encoding = "UTF-8")
    lines <- sub(
      paste0("%\\VignetteIndexEntry{", v, "}"),
      paste0("%\\VignetteIndexEntry{", names(v), "}"),
      lines,
      fixed = TRUE
    )
    con <- file(path, open = "wb")
    writeLines(enc2utf8(lines), con, useBytes = TRUE)
    close(con)
  }

  # 4. 检查是否有未登记到 dev/config_fusen.yaml 的文件
  fusen::check_not_registered_files(open = FALSE)

  message(
    "\n完成。接下来可以运行：\n",
    "  devtools::test()\n",
    "  devtools::check()\n",
    "  pkgdown::build_site()"
  )
})

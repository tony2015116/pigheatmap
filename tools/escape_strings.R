# 把 dev/flat_*.Rmd 中 function-* 代码块里的中文字符串字面量转换为 \uXXXX 转义，
# 并把原文保留在行尾注释中。CRAN / R CMD check 要求 R 代码中的字符串只含 ASCII。
#
# 通常不需要单独运行：source("dev/inflate_all.R") 会先自动调用本脚本。
# 单独运行（在包根目录下）：source("tools/escape_strings.R")
#
# 规则（每行只处理一个字符串字面量）：
#   - 字符串含中文：转义；若行尾还没有注释，把原文追加为行尾注释。
#   - 字符串已转义、且行尾注释里有中文：以注释里的原文为准重新生成转义。
#     因此修改文案时，只需要改行尾注释里的中文，再运行本脚本。
#   - 以 # 开头的行（注释、roxygen 文档）不处理，roxygen 里的中文是允许的。

local({
  escape_utf8 <- function(s) {
    cps <- utf8ToInt(s)
    paste0(vapply(cps, function(cp) {
      if (cp < 128) intToUtf8(cp) else sprintf("\\u%04x", cp)
    }, character(1)), collapse = "")
  }
  has_non_ascii <- function(s) grepl("[^\\x01-\\x7f]", s, perl = TRUE)

  # 前缀（不含引号和 #）+ 字符串字面量 + 其余部分
  line_re <- "^([^\"#]*?)\"((?:[^\"\\\\]|\\\\.)*)\"(.*)$"
  comment_re <- "^(.*?)\\s*# (.+)$"

  process_line <- function(ln) {
    if (grepl("^\\s*#", ln)) return(ln)
    m <- regmatches(ln, regexec(line_re, ln, perl = TRUE))[[1]]
    if (length(m) == 0) return(ln)
    prefix <- m[2]
    content <- m[3]
    rest <- m[4]

    cm <- regmatches(rest, regexec(comment_re, rest, perl = TRUE))[[1]]
    comment <- if (length(cm)) cm[3] else NA_character_
    rest_code <- if (length(cm)) cm[2] else rest

    if (has_non_ascii(content)) {
      original <- content
    } else if (!is.na(comment) && has_non_ascii(comment) &&
               grepl("\\\\u[0-9a-fA-F]{4}", content)) {
      original <- comment
    } else {
      return(ln)
    }
    new_comment <- if (!is.na(comment)) comment else original
    paste0(prefix, "\"", escape_utf8(original), "\"", rest_code, " # ", new_comment)
  }

  flats <- list.files("dev", pattern = "^flat_.*\\.Rmd$", full.names = TRUE)
  for (path in flats) {
    lines <- readLines(path, encoding = "UTF-8", warn = FALSE)
    out <- lines
    in_fun_chunk <- FALSE
    for (i in seq_along(lines)) {
      ln <- lines[i]
      if (grepl("^```\\{r[ ,]+function-", ln)) {
        in_fun_chunk <- TRUE
        next
      }
      if (in_fun_chunk && grepl("^```\\s*$", ln)) {
        in_fun_chunk <- FALSE
        next
      }
      if (in_fun_chunk) out[i] <- process_line(ln)
    }
    n_changed <- sum(out != lines)
    if (n_changed > 0) {
      con <- file(path, open = "wb")
      writeLines(enc2utf8(out), con, useBytes = TRUE)
      close(con)
    }
    message(sprintf("%s: %d line(s) escaped", path, n_changed))
  }
})

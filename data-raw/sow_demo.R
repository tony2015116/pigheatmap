# 生成示例数据集 sow_demo（模拟数据，仅用于文档和示例）
# 运行方式：在包根目录执行 source("data-raw/sow_demo.R")

set.seed(2026)

n_litters <- 1800
farms <- c("Farm A", "Farm B", "Farm C")
months <- sprintf("2026-%02d", 1:6)

sow_demo <- data.frame(
  month = sample(months, n_litters, replace = TRUE),
  farm = sample(farms, n_litters, replace = TRUE, prob = c(0.5, 0.3, 0.2)),
  stringsAsFactors = FALSE
)

# 胎次分布：三个场的胎龄结构不同
#   Farm A：结构合理，平均胎次约 3.8
#   Farm B：后备母猪补充多，以低胎次为主，平均胎次约 2.7
#   Farm C：淘汰不及时，高胎次母猪偏多，平均胎次约 6.5
parity_prob <- list(
  "Farm A" = c(0.18, 0.17, 0.16, 0.14, 0.12, 0.09, 0.07, 0.04, 0.02, 0.01),
  "Farm B" = c(0.34, 0.25, 0.16, 0.10, 0.06, 0.04, 0.02, 0.01, 0.01, 0.01),
  "Farm C" = c(0.03, 0.04, 0.06, 0.08, 0.10, 0.13, 0.16, 0.17, 0.12, 0.11)
)
sow_demo$parity <- vapply(
  sow_demo$farm,
  function(f) sample(1:10, 1, prob = parity_prob[[f]]),
  integer(1),
  USE.NAMES = FALSE
)

# 产活仔数：3~5 胎达到高峰，之后逐渐下降；不同场之间有固定差异
farm_effect <- c("Farm A" = 0.6, "Farm B" = 0, "Farm C" = -0.8)
peak <- 2.4 * exp(-((sow_demo$parity - 4)^2) / 6)
sow_demo$born_alive <- pmax(
  0,
  round(10.5 + peak + farm_effect[sow_demo$farm] + stats::rnorm(n_litters, 0, 2.2))
)

# 断奶仔猪数：产活仔数扣除哺乳期死亡
sow_demo$weaned <- pmax(
  0,
  sow_demo$born_alive - stats::rbinom(n_litters, sow_demo$born_alive, 0.09)
)

# 背膘厚（mm）：一部分记录缺失，模拟实际生产中的漏测
sow_demo$backfat <- round(stats::rnorm(n_litters, 17 - 0.3 * sow_demo$parity, 2.5), 1)
sow_demo$backfat[sample(n_litters, 120)] <- NA

sow_demo <- sow_demo[order(sow_demo$month, sow_demo$farm, sow_demo$parity), ]
rownames(sow_demo) <- NULL

usethis::use_data(sow_demo, overwrite = TRUE)

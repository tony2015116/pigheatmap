# 示例数据：母猪分娩记录（模拟）

模拟的 3 个猪场、2026 年 1~6 月共 1800 窝分娩记录，用于文档和示例。
三个场的胎龄结构不同：Farm A 结构合理（平均胎次约 3.8），Farm B
以低胎次为主 （约 2.7），Farm C 高胎次母猪偏多（约 6.5）。产活仔数在 3~5
胎达到高峰，之后逐渐 下降；背膘厚有约 7% 的缺失值。

## Usage

``` r
sow_demo
```

## Format

一个包含 1800 行、6 列的数据框：

- month:

  分娩年月，字符型，如 "2026-01"

- farm:

  猪场，"Farm A" / "Farm B" / "Farm C"

- parity:

  胎次，整数 1~10

- born_alive:

  产活仔数（头）

- weaned:

  断奶仔猪数（头）

- backfat:

  分娩时背膘厚（mm），含缺失值

## Source

模拟数据，生成脚本见 GitHub 仓库中的 `data-raw/sow_demo.R`。

## Examples

``` r
head(sow_demo)
#>     month   farm parity born_alive weaned backfat
#> 1 2026-01 Farm A      1         13     13      NA
#> 2 2026-01 Farm A      1         15     14    17.2
#> 3 2026-01 Farm A      1         12     10    16.0
#> 4 2026-01 Farm A      1         11     11    19.4
#> 5 2026-01 Farm A      1         11     10    15.1
#> 6 2026-01 Farm A      1          9      9    15.8
```

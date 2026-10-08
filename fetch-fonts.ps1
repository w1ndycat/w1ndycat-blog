# 下载 Noto Serif SC (400/700) 的 woff2 子集到 static/fonts/noto-serif-sc/
# 并生成引用本地路径的 @font-face CSS，输出到 assets/css/fonts-generated.css
$ErrorActionPreference = "Stop"

# Noto Serif SC 是可变字体（wght 200-900），用区间语法可让 101 个子集各只对应一条规则
$cssUrl = "https://fonts.googleapis.com/css2?family=Noto+Serif+SC:wght@200..900&display=swap"
$outDir = "static\fonts\noto-serif-sc"
New-Item -ItemType Directory -Force -Path $outDir | Out-Null

$ua = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
$css = (Invoke-WebRequest -Uri $cssUrl -UserAgent $ua).Content

# 找出所有 woff2 地址并下载
$urls = [regex]::Matches($css, "https://[^)]+\.woff2") | ForEach-Object { $_.Value } | Select-Object -Unique
Write-Output "共 $($urls.Count) 个 woff2 文件"

$i = 0
foreach ($u in $urls) {
    $i++
    $name = "subset-$i.woff2"
    Invoke-WebRequest -Uri $u -UserAgent $ua -OutFile (Join-Path $outDir $name)
    $css = $css.Replace($u, "/fonts/noto-serif-sc/$name")
    if ($i % 20 -eq 0) { Write-Output "已下载 $i / $($urls.Count)" }
}

$css | Out-File -Encoding utf8 "assets\css\fonts-generated.css"
Write-Output "完成，CSS 已写入 assets\css\fonts-generated.css"

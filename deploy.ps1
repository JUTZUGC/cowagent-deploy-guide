# CowAgent 一键部署脚本（第三方指南）——按官方文档封装
# 官方文档：https://docs.cowagent.ai
# 更新日期：2026-10-25
# 类型：docker
$ErrorActionPreference = 'Stop'
Set-Location -Path $PSScriptRoot

foreach ($cmd in @('git', 'docker')) {
  if (-not (Get-Command $cmd -ErrorAction SilentlyContinue)) { throw "需要先安装 $cmd" }
}
docker compose version | Out-Null
if ($LASTEXITCODE -ne 0) { throw '需要 Docker Compose v2（docker compose 子命令）' }

New-Item -ItemType Directory -Force -Path .download | Out-Null
Set-Location -Path .download

New-Item -ItemType Directory -Force -Path cowagent | Out-Null
Set-Location cowagent
curl.exe -fLO https://cdn.link-ai.tech/code/cow/docker-compose.yml
$f = 'docker-compose.yml'; $t = (Get-Content $f -Raw) -replace "WEB_HOST: '127.0.0.1'", "WEB_HOST: '0.0.0.0'" -replace '"9899:9899"', '"127.0.0.1:9899:9899"'; [IO.File]::WriteAllText((Resolve-Path $f).Path, $t, [Text.UTF8Encoding]::new($false))
docker compose up -d

Write-Host ''
$url = 'http://127.0.0.1:9899'
Write-Host "等待服务启动：$url"
$ready = $false
for ($i = 0; $i -lt 30; $i++) {
  try {
    Invoke-WebRequest -UseBasicParsing -Uri $url -TimeoutSec 3 | Out-Null
    $ready = $true
    break
  } catch {
    Start-Sleep -Seconds 2
  }
}
if (-not $ready) { throw "60 秒内未探测到 $url，请手动打开确认或查看日志" }
Write-Host '服务已就绪'
Write-Host '部署完成：浏览器打开 http://127.0.0.1:9899 ，先在控制台里填模型 API Key，再按需接消息渠道'
Write-Host '若结果异常或需要改配置，请参考官方文档：https://docs.cowagent.ai'

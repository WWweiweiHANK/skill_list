$ErrorActionPreference = "Stop"

$技能根目录 = Split-Path -Parent $PSScriptRoot
$说明路径 = Join-Path $技能根目录 "SKILL.md"
$UTF8无标记 = [System.Text.UTF8Encoding]::new($false)
$说明文本 = [System.IO.File]::ReadAllText($说明路径, $UTF8无标记)

foreach ($片段 in @(
	"faithful defaults plus optional parameterization",
	"Ask only when",
	"unresolved dependency",
	"multiple credible boundaries",
	"changes the host-system integration contract",
	"Do not ask the user to choose between faithful reconstruction and parameter exposure",
	"particle emission coverage",
	"viewport-adaptation contract"
)) {
	if (-not $说明文本.Contains($片段)) {
		throw "拆解决策门槛未覆盖关键依赖判断：$片段"
	}
}

Write-Output "Godot source decomposition dependency gate verified."

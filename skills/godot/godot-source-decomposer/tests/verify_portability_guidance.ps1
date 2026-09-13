$ErrorActionPreference = "Stop"

$技能根目录 = Split-Path -Parent $PSScriptRoot
$说明路径 = Join-Path $技能根目录 "SKILL.md"
$说明文本 = Get-Content -Raw -LiteralPath $说明路径

foreach ($片段 in @(
	"relative to the scene file",
	"minimal fixture"
)) {
	if (-not $说明文本.Contains($片段)) {
		throw "拆解 Skill 缺少组件路径可移植性要求：$片段"
	}
}

Write-Output "Godot source decomposition portability guidance verified."

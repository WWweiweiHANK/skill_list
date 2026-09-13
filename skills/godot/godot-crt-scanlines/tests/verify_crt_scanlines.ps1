$ErrorActionPreference = "Stop"

$技能根目录 = Split-Path -Parent $PSScriptRoot
$着色器路径 = Join-Path $技能根目录 "assets\crt_scanlines\crt_scanlines.gdshader"
$覆盖层路径 = Join-Path $技能根目录 "assets\crt_scanlines\CRT全屏覆盖.tscn"

foreach ($路径 in @($着色器路径, $覆盖层路径)) {
	if (-not (Test-Path -LiteralPath $路径)) {
		throw "缺少 CRT 可复用资产：$路径"
	}
}

$着色器文本 = Get-Content -Raw -LiteralPath $着色器路径
$覆盖层文本 = Get-Content -Raw -LiteralPath $覆盖层路径

foreach ($片段 in @(
	"shader_type canvas_item;",
	"hint_screen_texture",
	"uniform vec2 resolution",
	"uniform float warp_amount",
	"uniform float scan_line_amount",
	"COLOR.a = 1.0;"
)) {
	if (-not $着色器文本.Contains($片段)) {
		throw "着色器缺少 CRT 契约：$片段"
	}
}

foreach ($片段 in @(
	'[node name="CRT全屏覆盖" type="CanvasLayer"]',
	'[node name="扫描线" type="ColorRect" parent="."]',
	'anchors_preset = 15',
	'mouse_filter = 2',
	'shader_parameter/resolution = Vector2(640, 360)',
	'shader_parameter/warp_amount = 0.05',
	'shader_parameter/scan_line_amount = 0.3'
)) {
	if (-not $覆盖层文本.Contains($片段)) {
		throw "覆盖层缺少 CRT 契约：$片段"
	}
}

Write-Output "CRT scanlines asset contract verified."

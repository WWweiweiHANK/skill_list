$ErrorActionPreference = "Stop"

$技能根目录 = Split-Path -Parent $PSScriptRoot
$组件根目录 = Join-Path $技能根目录 "Godot_UI_GameMaker_skill\screen-transition\variants\circle-iris"
$场景路径 = Join-Path $组件根目录 "圆形转场.tscn"
$控制器路径 = Join-Path $组件根目录 "圆形转场控制器.gd"
$着色器路径 = Join-Path $组件根目录 "圆形转场.gdshader"
$音效路径 = Join-Path $组件根目录 "Transition.wav"

foreach ($路径 in @($场景路径, $控制器路径, $着色器路径, $音效路径)) {
	if (-not (Test-Path -LiteralPath $路径)) {
		throw "圆形转场缺少保真组件资源：$路径"
	}
}

$UTF8无标记 = [System.Text.UTF8Encoding]::new($false)
$场景文本 = [System.IO.File]::ReadAllText($场景路径, $UTF8无标记)
$控制器文本 = [System.IO.File]::ReadAllText($控制器路径, $UTF8无标记)
$着色器文本 = [System.IO.File]::ReadAllText($着色器路径, $UTF8无标记)

foreach ($片段 in @(
	"layer = 16",
	"shader_parameter/tint_color = Color(0, 0, 0, 1)",
	"shader_parameter/center = Vector2(0.5, 0.5)",
	"shader_parameter/radius = 1.0",
	"volume_db = 6.0",
	'bus = &"Sound"'
)) {
	if (-not $场景文本.Contains($片段)) {
		throw "场景缺少源圆形转场保真数值：$片段"
	}
}

foreach ($片段 in @(
	"@export var 遮罩颜色: Color = Color.BLACK",
	"@export var 圆心: Vector2 = Vector2(0.5, 0.5)",
	"@export var 收拢时长: float = 0.5",
	"@export var 展开时长: float = 0.5",
	"@export var 遮罩阈值倍率: float = 1.25",
	"func 播放收拢() -> void:",
	"func 播放展开() -> void:"
)) {
	if (-not $控制器文本.Contains($片段)) {
		throw "控制器缺少开放参数或转场接口：$片段"
	}
}

foreach ($片段 in @(
	"uniform vec4 tint_color",
	"uniform vec2 center",
	"uniform float radius",
	"uniform float threshold_multiplier",
	"aspect_ratio"
)) {
	if (-not $着色器文本.Contains($片段)) {
		throw "着色器缺少圆形遮罩保真逻辑：$片段"
	}
}

Write-Output "Circle transition asset contract verified."

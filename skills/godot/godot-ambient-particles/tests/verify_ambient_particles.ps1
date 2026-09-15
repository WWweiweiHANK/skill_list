$ErrorActionPreference = "Stop"

$技能根目录 = Split-Path -Parent $PSScriptRoot
$场景路径 = Join-Path $技能根目录 "assets\ambient_particles\保真环境粒子.tscn"
$控制器路径 = Join-Path $技能根目录 "assets\ambient_particles\环境粒子控制器.gd"
$贴图路径 = Join-Path $技能根目录 "assets\ambient_particles\square.png"

foreach ($路径 in @($场景路径, $控制器路径, $贴图路径)) {
	if (-not (Test-Path -LiteralPath $路径)) {
		throw "缺少保真环境粒子资产：$路径"
	}
}

$UTF8无标记 = [System.Text.UTF8Encoding]::new($false)
$场景文本 = [System.IO.File]::ReadAllText($场景路径, $UTF8无标记)
$控制器文本 = [System.IO.File]::ReadAllText($控制器路径, $UTF8无标记)

foreach ($片段 in @(
	'[node name="保真环境粒子" type="Node2D"',
	'[node name="粒子" type="GPUParticles2D" parent="."',
	'amount = 50',
	'lifetime = 3.0',
	'emission_box_extents = Vector3(300, 100, 1)',
	'initial_velocity_min = 10.0',
	'initial_velocity_max = 20.0',
	'gravity = Vector3(0, 20, 0)',
	'scale_min = 0.5',
	'scale_max = 0.75',
	'blend_mode = 1'
)) {
	if (-not $场景文本.Contains($片段)) {
		throw "场景缺少保真粒子契约：$片段"
	}
}

foreach ($片段 in @(
	'@export var 粒子密度: int',
	'@export var 风向: Vector2',
	'@export var 速度倍率: float',
	'@export var 大小倍率: float',
	'@export var 粒子颜色: Color',
	'@export var 是否适配屏幕: bool',
	'@export var 屏幕密度倍率: float',
	'@export var 粒子可见度倍率: float',
	'func 设置预设',
	'func 设置屏幕雪花',
	'func 应用参数'
)) {
	if (-not $控制器文本.Contains($片段)) {
		throw "控制器缺少公开参数或接口：$片段"
	}
}

Write-Output "Ambient particle asset contract verified."

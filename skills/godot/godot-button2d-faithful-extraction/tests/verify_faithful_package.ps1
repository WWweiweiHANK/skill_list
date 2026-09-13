$技能根目录 = Split-Path -Parent $PSScriptRoot
$按钮目录 = Join-Path $技能根目录 "assets\Godot_UI_GameMaker_skill\button\base\faithful_button2d"
$必需文件 = @(
	"button_2d.tscn",
	"button_2d.gd",
	"juice_2d.gd",
	"damped_spring_data.gd",
	"runtime\damped_spring_1d.gd",
	"runtime\damped_springs.gd",
	"fonts\main.tres",
	"fonts\Match 7.ttf",
	"fonts\chinese.tres",
	"fonts\chinese_font.tres",
	"fonts\NotoSansSC.ttf",
	"sounds\hover.wav",
	"sounds\click.wav"
)

$缺失文件 = @()
foreach ($相对路径 in $必需文件) {
	$完整路径 = Join-Path $按钮目录 $相对路径
	if (-not (Test-Path -LiteralPath $完整路径 -PathType Leaf)) {
		$缺失文件 += $相对路径
	}
}

if ($缺失文件.Count -gt 0) {
	throw "保真按钮包缺少必需文件：$($缺失文件 -join '、')"
}

$场景文本 = Get-Content -Raw -LiteralPath (Join-Path $按钮目录 "button_2d.tscn")
$必须保留 = @(
	'path="button_2d.gd"',
	'path="fonts/main.tres"',
	'path="juice_2d.gd"',
	'path="damped_spring_data.gd"',
	'path="sounds/hover.wav"',
	'path="sounds/click.wav"',
	"shadow_offset = Vector2(6, 6)",
	"font_size = 48",
	'text = "Button"'
)
foreach ($片段 in $必须保留) {
	if (-not $场景文本.Contains($片段)) {
		throw "按钮场景未保留源参数：$片段"
	}
}

if ($场景文本 -match 'path="res://') {
	throw "场景含有未声明的绝对资源路径。"
}

Write-Output "faithful Button2D package manifest verified"

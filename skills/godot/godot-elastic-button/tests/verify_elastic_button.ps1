$ErrorActionPreference = "Stop"

$技能根目录 = Split-Path -Parent $PSScriptRoot
$场景路径 = Join-Path $技能根目录 "assets\elastic_button\弹性按钮.tscn"
$按钮脚本路径 = Join-Path $技能根目录 "assets\elastic_button\弹性按钮.gd"
$反馈脚本路径 = Join-Path $技能根目录 "assets\elastic_button\弹性反馈.gd"
$说明路径 = Join-Path $技能根目录 "SKILL.md"

foreach ($路径 in @($场景路径, $按钮脚本路径, $反馈脚本路径)) {
	if (-not (Test-Path -LiteralPath $路径)) {
		throw "缺少可复用按钮资产：$路径"
	}
}

$场景文本 = Get-Content -Raw -LiteralPath $场景路径
$按钮脚本文本 = Get-Content -Raw -LiteralPath $按钮脚本路径
$反馈脚本文本 = Get-Content -Raw -LiteralPath $反馈脚本路径
$说明文本 = Get-Content -Raw -LiteralPath $说明路径

$场景契约 = [string[]]@(
	'\[node name="弹性按钮" type="Control"',
	'\[node name="按钮" type="Button" parent="\."',
	'\[node name="标签" type="Label" parent="按钮"',
	'pressed" from="按钮" to="\." method="_当按钮按下"',
	'mouse_entered" from="按钮" to="\." method="_当鼠标进入"',
	'mouse_exited" from="按钮" to="\." method="_当鼠标离开"'
)

foreach ($正则表达式 in $场景契约) {
	if ($场景文本 -notmatch $正则表达式) {
		throw "场景缺少契约：$正则表达式"
	}
}

$相对脚本引用 = [string[]]@(
	'path="弹性按钮.gd"',
	'path="弹性反馈.gd"'
)

foreach ($片段 in $相对脚本引用) {
	if (-not $场景文本.Contains($片段)) {
		throw "场景脚本必须使用相对路径：$片段"
	}
}

if ($场景文本.Contains('res://ui/弹性按钮/')) {
	throw "场景不得依赖固定的 ui/弹性按钮 安装目录。"
}

if (-not $说明文本.Contains('same directory')) {
	throw "Skill 说明必须明确三个组件文件可复制到任意目标目录的同级位置。"
}

foreach ($片段 in @(
	'signal 按钮已按下',
	'signal 鼠标已进入',
	'signal 鼠标已离开',
	'func 设置禁用状态',
	'func 设置文本',
	'func _当按钮按下',
	'func _当鼠标进入',
	'func _当鼠标离开'
)) {
	if (-not $按钮脚本文本.Contains($片段)) {
		throw "按钮脚本缺少公共接口：$片段"
	}
}

foreach ($片段 in @('func 播放悬停反馈', 'func 播放按压反馈', 'Tween.TRANS_ELASTIC')) {
	if (-not $反馈脚本文本.Contains($片段)) {
		throw "反馈脚本缺少弹性反馈：$片段"
	}
}

Write-Output "Elastic button asset contract verified."

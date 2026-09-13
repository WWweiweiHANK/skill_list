$ErrorActionPreference = "Stop"
$技能根目录 = Split-Path -Parent $PSScriptRoot
$临时根目录 = Join-Path ([System.IO.Path]::GetTempPath()) "faithful-button2d-fixture"
if (Test-Path -LiteralPath $临时根目录) {
	Remove-Item -LiteralPath $临时根目录 -Recurse -Force
}
New-Item -ItemType Directory -Path $临时根目录 | Out-Null
Copy-Item -Path (Join-Path $技能根目录 "tests\fixture\*") -Destination $临时根目录 -Recurse
New-Item -ItemType Directory -Path (Join-Path $临时根目录 "button") | Out-Null
Copy-Item -Path (Join-Path $技能根目录 "assets\Godot_UI_GameMaker_skill\button\base\faithful_button2d\*") -Destination (Join-Path $临时根目录 "button") -Recurse
$Godot控制台 = $env:GODOT_CONSOLE
if ([string]::IsNullOrWhiteSpace($Godot控制台)) {
	$Godot控制台 = "C:\Users\ww\Downloads\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe"
}
& $Godot控制台 --headless --path $临时根目录 --editor --quit
if ($LASTEXITCODE -ne 0) {
	throw "Godot 导入组件失败，退出码：$LASTEXITCODE"
}
$运行输出 = & $Godot控制台 --headless --path $临时根目录 --quit 2>&1
$运行输出
$运行文本 = $运行输出 -join "`n"
if ($LASTEXITCODE -ne 0) {
	throw "Godot 运行组件夹具失败，退出码：$LASTEXITCODE"
}
if ($运行文本 -notmatch "faithful Button2D fixture verified") {
	throw "组件夹具未输出成功标识。"
}
foreach ($失败标识 in @("SCRIPT ERROR", "Parse Error", "Failed loading resource")) {
	if ($运行文本 -match $失败标识) {
		throw "组件夹具出现加载或脚本错误：$失败标识"
	}
}

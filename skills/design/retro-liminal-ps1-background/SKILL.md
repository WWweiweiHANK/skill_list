---
name: retro-liminal-ps1-background
description: 生成90年代末至2000年代初老式3D游戏风格的空场景背景图，强调PS1低多边形、低清贴图、CRT/VHS显示质感、日常空间的轻微诡异与怀旧感。适用于书房、办公室、地铁站、寿司店、卧室、商场、走廊、月面等游戏背景环境。
---

# Retro Liminal PS1 Background

用于生成“后室 / liminal space”气质的复古游戏背景，但默认不做纯恐怖，不依赖经典黄色后室走廊；核心是“普通、熟悉、空旷、略微不对劲”。

## 核心视觉目标

最终画面应像一张来自 **1997–2003 年间老式3D主机游戏** 的实机截图，而不是现代3D渲染后叠滤镜。

画面优先满足：

- retro PS1-style low-poly 3D environment
- early 3D console game aesthetic
- simple blocky geometry
- low polygon count
- chunky architectural shapes
- large flat polygon surfaces
- primitive environmental modeling
- mundane liminal space
- ordinary yet subtly strange
- nostalgic, low-resolution, rough but intentional

## 默认构图

除非用户另行指定：

- 宽高比：**4:3**
- 镜头：第一人称游戏视角
- 焦段：轻微广角
- 畸变：弱鱼眼
- 构图：居中、空间纵深清楚
- 视点高度：接近普通成年人站立视线
- 保留较大的可用空区，方便后续放角色、文本或交互主体
- 不使用过强电影化景深，不做现代摄影感

若提供参考照片：

1. 保留参考图最重要的空间结构、家具布局和识别性元素。
2. 简化复杂物体为PS1时期可实现的粗糙模型。
3. 不机械复刻照片中的品牌、文字、屏幕内容或个人信息。
4. 参考照片中的人物、动物、UI、日期、水印默认移除。

## 建筑与家具建模规则

场景模型应明显低模：

- 桌、柜、书架、椅子、隔断使用简单盒体和少量切面。
- 圆形物体减少段数，避免现代高精度圆润建模。
- 小物件数量适中，只用于体现生活痕迹，不堆成资产展示。
- 电线、书本、瓶子、文件夹等可做成简化块状轮廓。
- 不使用复杂倒角、细密雕刻、真实布料模拟或高精度五金件。

空间应该“有人生活过，但此刻没人”。

## 材质与贴图规则

必须优先呈现旧游戏贴图感：

- low-resolution textures
- blurry pixelated textures
- slightly stretched UV mapping
- repeating tiled textures
- PS1-era texture warping
- primitive non-PBR materials
- weak or fake specular highlights
- slightly dirty and aged surfaces
- visible texture repetition acceptable

避免：

- 现代PBR材质
- 高分辨率木纹和金属细节
- 光线追踪反射
- 超清玻璃、布料、皮革表现
- 写实法线贴图和微表面细节

## 光照与氛围

默认氛围：

- dim indoor lighting
- moody ambient light
- soft fluorescent or tungsten lighting
- slightly gloomy
- uncanny nostalgic atmosphere
- liminal mundane interior
- not horror, but subtly eerie

空间应让人感觉熟悉、安静、无人、时间停滞，但不要主动加入血迹、怪物、尸体、惊吓点或明显恐怖符号。

如果是室外场景，使用同样原则：光照简单、低动态范围、阴影硬度适中、天空与远景保持低清旧游戏感。

## 色彩

默认使用：

- muted retro palette
- slightly desaturated
- aged beige
- dull yellow
- brown
- gray-green
- dusty gray
- faded blue

颜色服务于空间，不抢未来主体。避免高饱和霓虹和现代赛博朋克配色，除非用户明确要求。

## CRT / VHS 显示质感

显示层是该风格的重要组成，但不可盖过场景本身：

- horizontal scanlines
- subtle VHS noise
- analog distortion
- chromatic aberration
- RGB fringing
- soft blur
- dark vignette
- slightly curved screen edges
- mild signal instability

原则：**像从旧电视或老式游戏采集卡里看到，而不是在高清图片上套一个明显滤镜。**

## 背景图生成约束

当用户说“只要背景”或用途为游戏背景时，默认排除：

- 人物
- 动物
- 怪物
- 武器
- 手持物
- 可作为主体展示的道具
- 文字
- 标牌上的可读文本
- UI
- HUD
- 数值框
- 标题
- 奖励提示
- 雷达
- 字幕
- 水印

允许存在必要的环境家具与弱化的小型生活物件，但不得让单个物件成为视觉主角。

## 场景描述补全规则

当用户只给地点类型、没有填写地点描述时，不要要求用户补完；直接根据地点类型补出合理场景。

补全内容按以下顺序思考：

1. 空间结构：房间尺寸、走廊、墙体、柜体、门窗、平台等。
2. 主要家具：只保留能定义地点的2–6类物件。
3. 墙面与地面：低清、重复、轻微老化。
4. 灯光：单一或少量灯源，形成安静阴暗层次。
5. 空间感觉：普通、熟悉、无人、稍显诡异。
6. 主体预留：尽量在中央、下中部或用户指定区域留出干净空间。

## 默认提示词骨架

生成时可以按地点替换 `[LOCATION]`、`[STRUCTURE]` 和 `[PROPS]`：

```text
A [LOCATION] environment for a game background.
[STRUCTURE]. [PROPS].
No people, no animals, no characters, no monsters, no weapons, no readable text, no UI, no HUD.

retro PS1-style low-poly 3D environment,
early 3D console game aesthetic,
simple blocky geometry,
low polygon count,
chunky architectural shapes,
large flat polygon surfaces,
primitive environmental modeling,
low-resolution blurry pixelated textures,
slightly stretched UV mapping,
repeating tiled textures,
PS1-era texture warping,
primitive non-PBR materials,
slightly dirty aged surfaces,
muted retro palette,
slightly desaturated beige, yellow, brown, gray-green,
dim moody ambient lighting,
soft fluorescent or tungsten lighting,
liminal mundane space,
ordinary yet subtly eerie,
nostalgic but not horror,
first-person retro game camera,
slightly wide-angle,
subtle fisheye distortion,
centered composition,
clear depth,
4:3 aspect ratio,
CRT television effect,
horizontal scanlines,
subtle VHS noise,
analog distortion,
chromatic aberration,
RGB fringing,
soft blur,
dark vignette,
slightly curved screen edges.
```

## 质量检查

生成前后检查：

- 是否第一眼像旧游戏，而不是现代写实场景？
- 低模是否来自模型本身，而不是只靠像素滤镜？
- 是否有清晰的空间结构与纵深？
- 是否太干净、太现代、太高精？
- CRT效果是否克制，不至于看不清空间？
- 是否出现了不需要的人物、动物、文字、UI或主体道具？
- 是否保留了未来角色/交互物的放置空间？
- 默认是否保持4:3？

若画面过于现代：降低材质细节、减少多边形、减弱现代光照与反射，并强化低清贴图和UV拉伸，而不是单纯增加噪点。

若画面过于恐怖：减少纯黑区域、异常符号和戏剧化光源，回到“普通日常空间 + 无人 + 轻微不协调”的基调。

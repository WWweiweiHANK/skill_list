---
name: godot-ambient-particles
description: Use when a Godot 4 scene needs source-faithful drifting dust or falling snow particles with Inspector control of density, wind, speed, size, and color.
---

# Godot Ambient Particles

The default `保真尘埃` preset reproduces the extracted source: 50 additive square particles, a 3-second lifetime, a 300×100 emission region, 10–20 initial speed, downward gravity 20, size range 0.5–0.75, alpha fade, scale fade, and turbulence. `雪花` is an intentional variant with its own values; it is not a claim of source parity.

## Install

Copy [assets/ambient_particles](assets/ambient_particles/) together into the target project, keeping the three files in one folder. Instance `保真环境粒子.tscn`; its resource paths are relative to the scene file.

## Inspector interface

Use the root node's exports:

| Parameter | Effect |
| --- | --- |
| `粒子密度` | Active particle amount; source default 50 |
| `风向` / `风力` | Gravity direction and magnitude; source default `Vector2(0, 1)` / 20 |
| `速度倍率` | Multiplies source initial-speed range 10–20 |
| `大小倍率` | Multiplies source size range 0.5–0.75 |
| `粒子颜色` | Tints the source alpha ramp without changing its fade timing |
| `效果类型` | `保真尘埃` or the explicit `雪花` variant |

Call `设置预设` only when changing the variant at runtime; call `应用参数` after changing exported values by code. The component uses an additive CanvasItem material and is decorative: it does not process input or require an autoload.

## Fidelity and placement

Keep `保真尘埃` settings unchanged when source parity matters. The source coordinate origin is `(160, 90)` in a 640×1280 title viewport; move the root according to the host scene rather than treating that coordinate as responsive layout. Do not copy the source title-screen background, UI, audio, themes, or gameplay scripts.

See [extraction-record.json](assets/ambient_particles/extraction-record.json) for the exact retained and excluded dependencies.

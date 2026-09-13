---
name: godot-crt-scanlines
description: Use when a Godot 4 game needs a pixel-art CRT scanline overlay or slight screen curvature without adopting a full post-processing stack.
---

# Godot CRT Scanlines

Use the included overlay for the source pattern: nearest-filtered scanlines plus a restrained barrel warp. It deliberately does not add bloom, noise, chromatic aberration, vignette, or color grading.

## Install

Copy [assets/crt_scanlines](assets/crt_scanlines/) to `res://effects/crt_scanlines/` in the target project, then instance `CRT全屏覆盖.tscn` as a presentation-layer child. The scene is a full-viewport `CanvasLayer + ColorRect` and consumes no input.

## Parameters

| Shader parameter | Use | Starting value |
| --- | --- | --- |
| `resolution` | Logical pixel resolution that determines scanline spacing | `Vector2(640, 360)` |
| `warp_amount` | Curvature strength | `0.05` |
| `scan_line_amount` | Scanline darkness | `0.3` |

Use the game's logical render resolution for `resolution`, not the desktop window size. Keep `warp_amount` at or below `0.1` for readable UI. Place the overlay above world rendering but below any UI that must remain perfectly sharp; move it above the UI only when the whole presentation should receive CRT treatment.

## Boundaries

- The shader needs a Godot 4 CanvasItem that supports `hint_screen_texture`.
- Do not copy a source project's post-processing controller, autoloads, render settings, Theme, or unrelated shaders.
- For runtime parameter animation, let the host project's presentation controller set this material's uniforms; do not add a global singleton merely for this overlay.

See [extraction-record.json](assets/crt_scanlines/extraction-record.json) for the portable dependency record.

---
name: godot-elastic-button
description: Add or adapt a reusable Godot 4 elastic button with themed states, hover/press motion, unified signals, and optional sounds. Use for interactive UI buttons; do not use for non-interactive decorative labels.
---

# Godot Elastic Button

Use this skill when a Godot UI needs a reusable button with a compact, arcade-like elastic response. The implementation is in [assets/elastic_button](assets/elastic_button/).

## Component contract

`弹性按钮.tscn` is a `Control` scene designed to be placed inside a Container or anchored by its parent. Its base behavior is always enabled:

- native Button activation and disabled state;
- normal, hover, pressed, and disabled StyleBox states;
- light hover-scale and press-bounce feedback;
- signals `按钮已按下`, `鼠标已进入`, and `鼠标已离开`;
- keyboard and gamepad focus through the child Button.

The optional capabilities are `悬停音效` and `点击音效`. Keep them unset unless the target project supplies its own audio resources and routing.

## Use

1. Copy `弹性按钮.tscn`, `弹性按钮.gd`, and `弹性反馈.gd` together into the target Godot project. Preserve their relative paths.
2. Instance the scene. Change appearance through exported colors, border, shadow, and feedback parameters rather than editing the scene internals.
3. Connect `按钮已按下` to the owning feature. Use `设置文本` and `设置禁用状态` as the public interface.
4. For a project-wide visual change, make a scene variant or inject Theme values. Do not add gameplay, save, progression, or scene-navigation decisions into the button script.

## Responsive and compatibility constraints

- The root is a `Control`, not a fixed-position `Node2D`; let its parent Container or anchors determine layout.
- The asset targets Godot 4.x and uses `Tween.TRANS_ELASTIC` for motion.
- The scene intentionally contains no source-project font, theme, sound, or global singleton dependency.
- If the host project already defines a global class named `弹性按钮`, omit or rename the `class_name` line before copying.

## Source lineage

This component was extracted from a `Node2D + Button + Juice2D` pattern. The original project-specific sound bus, `InputManager`, fixed offsets, and damped-spring singleton were intentionally replaced with local exports and local Tween behavior. See [extraction-record.json](assets/elastic_button/extraction-record.json) for the dependency and risk record.

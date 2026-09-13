---
name: godot-button2d-faithful-extraction
description: Install or adapt the source-faithful Godot 4 Button2D preset, preserving its Theme/fonts, state StyleBoxes, Juice2D spring feedback, audio, signals, and host-service contracts. Use only when source parity is required; do not use for a redesigned generic button.
---

# Faithful Button2D Extraction

Use this skill only after the user has selected **faithful reconstruction** for the source `button_2d` family. It installs the preserved source scene from `assets/Godot_UI_GameMaker_skill/button/base/faithful_button2d/`; it is not a generic replacement for the elastic-button skill.

## Non-negotiable fidelity rules

- Copy the entire `faithful_button2d` directory as one unit. Do not copy only `button_2d.tscn`, its script, or a subset of visual assets.
- Keep the source node hierarchy: `Button2D` -> `Button` -> `Label`, plus `Juice`, `Hover`, and `Click`. Do not add a second feedback node, wrapper, decorative border, or substitute animation implementation.
- Keep the original exported interface, signals, StyleBox state values, Label shadow/font overrides, audio streams, and `Juice2D` parameters. Change only an explicitly requested gameplay binding or button text.
- Resource paths inside the bundled scene are relative to that scene. Do not replace them with a hard-coded `res://ui/...` path.
- The original binary `.theme` files encode project-absolute resource paths. This package uses portable text Theme resources (`fonts/main.tres` and `fonts/chinese.tres`) containing the source values relevant to this button and the original font files. This is a serialization change, not a visual redesign.

## Installation

1. Copy `assets/Godot_UI_GameMaker_skill/button/base/faithful_button2d/` to a single target directory, for example `res://ui/faithful_button2d/`. Keep its internal layout unchanged.
2. Add `res://ui/faithful_button2d/runtime/damped_springs.gd` as the **single** project autoload named `DampedSprings`. If the project already has an equivalent autoload, reuse it; never create a competing singleton.
3. Ensure the host project has an autoload named `InputManager` exposing `using_gamepad() -> bool`. This is a source contract required for the root button script to compile. Do not silently replace it with a local node.
4. Ensure the `Sound` audio bus exists. The source scene routes `Hover` and `Click` to that bus.
5. For Chinese locale parity, add a translation remap from the installed `fonts/main.tres` path to `fonts/chinese.tres` for `zh_CN`. Read [the install reference](references/installation.md) before editing `project.godot`.
6. Instance `button_2d.tscn`, set its existing `button_text` export to the intended label, and connect the root `pressed` signal. Do not rename the child nodes referenced by the source script.

## Verification

Run both packaged checks after installation or before distributing an update:

```powershell
& "$env:USERPROFILE\.codex\skills\godot-button2d-faithful-extraction\tests\verify_faithful_package.ps1"
& "$env:USERPROFILE\.codex\skills\godot-button2d-faithful-extraction\tests\verify_fixture.ps1"
```

The fixture copies the component into a new directory, registers the required singleton and audio bus, then loads and presses it. If a target project lacks a declared host contract, stop and request the integration decision instead of adding substitute nodes.

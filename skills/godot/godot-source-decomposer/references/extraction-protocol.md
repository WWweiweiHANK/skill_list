# Extraction protocol

Read this reference for Analyze, Extract, or Build work.

## Evidence record

Capture paths and roles, not just filenames:

```text
scene -> instantiated nodes -> scripts/resources -> visual behavior
script class -> base class -> signals/public API
theme -> StyleBox/font/color/icon overrides
shader material -> shader -> uniforms/render assumptions
animation/tween -> trigger -> affected properties
```

For every dependency mark `required`, `optional`, `project-specific`, or `excluded-business-logic`. A NodePath is portable only when its owner and node identity remain stable. When a scene and its required files are distributed together, use paths relative to the scene file; a `res://` path is reserved for an explicitly declared host-project dependency.

For Analyze, first give the user a scope statement: target effect, included root nodes, supporting resources, and excluded neighboring effects. Ask a focused confirmation only when more than one scope is credible. Record the result using `../Godot_UI_GameMaker_skill/schemas/extraction.schema.json`.

## Layout reconstruction

Describe the intended rule in words (for example, “centered with max width and edge margins”), then map it to anchors/offsets/Containers and stretch settings. Do not preserve coordinates merely because they match one screenshot. Identify portrait failure, clipping, minimum-size conflicts, and input/focus implications.

## Risk gate

Use `safe`, `conditional`, or `blocked`. `conditional` requires a mitigation and a verification step. `blocked` means do not extract until the missing dependency, API mismatch, ownership ambiguity, or layout/render assumption is resolved.

## Architecture choice

Use shallow layers such as `BaseButton -> ThemedButton`; compose animation, audio, tooltip, cooldown, and particle capabilities. A Variant is appropriate when the family contract stays the same but Theme/layout/config changes. A new family requires a distinct interaction contract or visual root, not merely a new effect.

## Registry and selection order

Validate `registry/component-registry.json` with `schemas/registry.schema.json` before changing it. For a requested effect, decide in this fixed order:

1. Parameterize an existing capability when its contract and lifecycle already fit.
2. Add a Variant when only Theme, layout, visual resource, or configuration differs.
3. Reuse an existing Capability when its behavior and attachment contract fit.
4. Add a Capability to the existing family when the concern is independently optional and composable.
5. Add a Component Family only when interaction contract or visual root is genuinely distinct.

When creating a registry entry, add names only after the implementation and verification evidence exist. Keep `base_capabilities` always enabled, `optional_capabilities` opt-in, and record a combination as a `preset` rather than duplicating it.

## Build conversation contract

For a Button Build, state that the base includes click activation, Hover/Pressed/Disabled states, Theme, light click feedback, and unified signals. Then list the registry's current optional capabilities, asking which should be included. Do not assume that a visually present source effect is desired in the new build. For other families, present their base and optional capabilities from the registry in the same way.

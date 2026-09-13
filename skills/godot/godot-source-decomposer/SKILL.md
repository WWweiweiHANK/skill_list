---
name: godot-source-decomposer
description: Use when analyzing or extracting Godot 4.x visual, UI, Shader, Theme, Control, layout, scene-inheritance, or component-composition behavior into reusable component-family assets.
---

# Godot Source Decomposer

Treat the requested effect as a dependency-backed visual component, not as an isolated file. The durable unit is one Component Family (Button, Panel, Popup, ProgressBar, ScreenEffect, etc.); effects are capabilities, variants, or presets inside that family.

## Modes

- **Analyze**: locate and confirm the effect boundary; report evidence, dependency graph, layout intent, inheritance/composition, business-logic seams, and risks. Do not mutate files. Produce an extraction record conforming to `schemas/extraction.schema.json`.
- **Extract**: only after the user explicitly confirms an Analyze report with a `safe` or mitigated `conditional` verdict, isolate the reusable visual/UI portion, preserve interfaces, and place it under `Godot_UI_GameMaker_skill/<family>/`. Update the registry.
- **Build**: configure or generate a family component in a target project by selecting a family, base capability, and optional capabilities. Do not enable advanced effects by default. Report the selected preset/variant, public interface, and responsive assumptions before editing.

Use the user's explicitly named mode. If omitted, begin in Analyze. Analyze never silently becomes Extract or Build.

## Required workflow

1. Resolve the target project and ask for confirmation when the named effect has multiple plausible boundaries. Record the selected nodes/scenes/resources and exclusions.
2. Scan the dependency graph: `.tscn`, `.gd`, `.gdshader`, `.tres/.res`, Theme and StyleBox resources, materials, AnimationPlayer/Tween, NodePath references, signals, `class_name`, script inheritance, and scene inheritance. Follow indirect references until the visual behavior is explained.
3. Reconstruct layout intent from anchors, offsets, size flags, Containers, minimum sizes, viewport/stretch settings, and aspect assumptions. Test or reason about landscape, portrait, and at least one alternate resolution; flag absolute coordinates that encode a fragile assumption.
4. Separate business logic. Keep signals, callbacks, public methods/properties, and resource/config interfaces; exclude economy, progression, dialogue, save, networking, and other domain decisions unless explicitly requested as an interface contract.
5. Perform a compatibility/risk gate before extraction: Godot version/API, theme/resource paths, shader uniforms and render assumptions, input routing, focus/accessibility, scene ownership, NodePath fragility, lifecycle, and likely failure modes. Stop and report if risk is unresolved.
6. Choose architecture using shallow inheritance for identity/base contract and composition for capabilities. Prefer parameterization, then a Variant, then an existing Capability, then a new Capability, and only lastly a new Component Family. Consult and validate against `Godot_UI_GameMaker_skill/registry/component-registry.json` and `schemas/registry.schema.json` before adding anything.
7. After confirmation, extract, normalize paths, and preserve a small public interface. For files copied with a scene, make external-resource paths relative to the scene file; reserve `res://` paths for deliberate host-project dependencies and declare them. Add/update registry metadata, then verify the result in a minimal fixture after copying the complete component family into a different target directory, or verify it in the target project. Report what was changed and remaining caveats. Do not call a result reusable merely because its source scene opens.

## Component library placement

Use this layout and create only the branch required by the approved extraction:

```text
Godot_UI_GameMaker_skill/
├── registry/component-registry.json
├── schemas/
├── button/
│   ├── base/                 # family contract and minimal working scene/script
│   ├── capabilities/<name>/  # composable opt-in behavior
│   ├── variants/<name>/      # same contract, different presentation/config
│   └── presets/<name>/       # named combination of base + capabilities + variant
└── <other-family>/...
```

A capability owns only its visual/interaction concern and must declare attachment point, configuration, lifecycle, and signals it adds. A variant changes presentation or configuration while retaining the family contract. A preset records a useful combination and does not duplicate implementation. Never copy project assets, domain scripts, or unrelated parents into the library without an explicit portability decision.

## Button standard family

Every Button build starts with these enabled base capabilities: click activation, Hover/Pressed/Disabled states, Theme, a lightweight click feedback, and unified signals. The base must remain usable without optional effects.

Offer the current optional capabilities at build time, but leave them disabled unless selected: `HoverScale`, `HoverFloat`, `PressBounce`, `Shake`, `Pulse`, `Glow`, `Shine`, `Outline`, hover/click sound, particles, `Tooltip`, `Hold`, `Cooldown`, and `Loading`. Add new effects to the Button family registry as capabilities or variants; do not create `button-*-skill` folders.

## Deliverable contract

An Analyze report must include: confirmed scope, evidence/dependency graph, layout intent, inheritance/composition map, business-logic interface, compatibility/risk verdict, and proposed family/capability placement.

An Extract or Build result must include: family, base capabilities, selected optional capabilities, public interface, files/resources, responsive assumptions, verification evidence, and registry update. Use the schemas in `Godot_UI_GameMaker_skill/schemas/` and the routing rules in `references/extraction-protocol.md`.

Do not claim extraction or verification without explicit confirmation and observable evidence.

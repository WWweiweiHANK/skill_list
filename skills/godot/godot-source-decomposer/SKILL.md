---
name: godot-source-decomposer
description: Use when analyzing or extracting Godot 4.x visual, UI, Shader, Theme, Control, layout, scene-inheritance, or component-composition behavior into reusable component-family assets.
---

# Godot Source Decomposer

Treat the requested effect as a dependency-backed visual component, not as an isolated file. The durable unit is one Component Family (Button, Panel, Popup, ProgressBar, ScreenEffect, etc.); effects are capabilities, variants, or presets inside that family.

## Modes

- **Analyze**: locate and confirm the effect boundary; report evidence, the full visual-fidelity manifest, dependency graph, layout intent, inheritance/composition, business-logic seams, and risks. Do not mutate files. Produce an extraction record conforming to `schemas/extraction.schema.json`.
- **Extract**: isolate the reusable visual/UI portion with faithful defaults plus optional parameterization. Place it under `Godot_UI_GameMaker_skill/<family>/` and update the registry. Use generalized redesign only for user-requested source deviations.
- **Build**: configure or generate a family component in a target project by selecting a family, base capability, and optional capabilities. Do not enable advanced effects by default. Report the selected preset/variant, public interface, and responsive assumptions before editing.

Use the user's explicitly named mode. If omitted, begin in Analyze. Analyze never silently becomes Extract or Build.

## Required workflow

1. Resolve the target project. Ask only when there are multiple credible boundaries, an unresolved dependency, or a choice that changes the host-system integration contract. Record the selected nodes/scenes/resources and exclusions.
2. Scan the dependency graph: `.tscn`, `.gd`, `.gdshader`, `.tres/.res`, Theme, fonts, StyleBox resources, textures/icons, materials, audio streams/buses, AnimationPlayer/Tween, global singletons, NodePath references, signals, `class_name`, script inheritance, and scene inheritance. Follow indirect references until the visual behavior is explained.
3. Produce a visual-fidelity manifest before proposing code: Theme, fonts, typography, StyleBox state values, texture/icon/shader resources, colors, borders, shadows, outlines, audio feedback, animation parameters, coordinates, offsets, anchors, transforms, size flags, Containers, minimum sizes, viewport/stretch settings, particle emission coverage, density, size, opacity, z-order, and aspect assumptions. Preserve numerical source values as the component defaults. Exposing those values as optional parameters is compatible with faithful reconstruction, not a redesign choice. Test or reason about landscape, portrait, and at least one alternate resolution; flag absolute coordinates that encode a fragile assumption.
4. Separate business logic. Keep signals, callbacks, public methods/properties, and resource/config interfaces; exclude economy, progression, dialogue, save, networking, and other domain decisions unless explicitly requested as an interface contract.
5. Perform a compatibility/risk gate before extraction: Godot version/API, theme/resource paths, shader uniforms and render assumptions, input routing, focus/accessibility, scene ownership, NodePath fragility, lifecycle, and likely failure modes. Mark the work `blocked` only for an unresolved dependency, an ambiguous boundary, or a host-system integration contract that cannot be inferred safely. Do not silently replace or omit any manifest item.
6. Choose architecture using shallow inheritance for identity/base contract and composition for capabilities. Prefer parameterization, then a Variant, then an existing Capability, then a new Capability, and only lastly a new Component Family. Consult and validate against `Godot_UI_GameMaker_skill/registry/component-registry.json` and `schemas/registry.schema.json` before adding anything.
7. After confirmation, extract, normalize paths, and preserve a small public interface. For files copied with a scene, make external-resource paths relative to the scene file; reserve `res://` paths for deliberate host-project dependencies and declare them. In faithful reconstruction, retain every required manifest item and compare the result against the source. In generalized redesign, name every intentional deviation and never call the result a reconstruction. Add/update registry metadata, then verify the result in a minimal fixture after copying the complete component family into a different target directory, or verify it in the target project. Report what was changed and remaining caveats. Do not call a result reusable merely because its source scene opens.

## Dependency and deviation gate

Use source values as faithful defaults and expose safe, effect-local controls when they map directly to those values. Do not ask the user to choose between faithful reconstruction and parameter exposure: both are normally delivered together.

Ask only when one of these observable conditions holds:

- there are multiple credible effect roots or call chains;
- a required asset, shader, audio bus, singleton, NodePath, or service is unresolved or unavailable;
- the result must either own a host service (scene change, input blocking, focus, audio routing, save state) or adapt to one, and the source does not establish which contract applies;
- the user asks for a deliberate visual or behavioral departure from the source.

Otherwise, proceed with the faithful baseline and report each exposed parameter plus its source default. For particles and screen effects, include a viewport-adaptation contract when host coverage is claimed: specify emission coverage, density scaling, visible bounds, particle-size/opacity scaling, z-order, and one landscape plus portrait verification. A generalized redesign is an explicit source deviation: list every intentional visual and behavioral difference. If a required asset cannot be copied or referenced, stop and state that visual parity cannot be claimed.

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

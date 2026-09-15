# Archify Integration Skill

## Identity
- Upstream: https://github.com/tt-a1i/archify
- Purpose: convert a codebase or system description into a polished, interactive architecture/system map.
- Core approach: agent produces typed JSON IR; Archify validates and deterministically renders it to interactive HTML/SVG and export formats.
- Upstream license: MIT.

## When to use
Invoke Archify when the user wants to:
- understand a repository at a high level;
- visualize runtime architecture, module relationships, data flow, lifecycle, or sequence flow;
- compare architecture before/after a change;
- inspect trust boundaries, external dependencies, or major execution paths;
- create a presentation-ready architecture map from code or a system description;
- explain a complex project structure to collaborators.

Do not use Archify as a substitute for code-level debugging or source decomposition. It summarizes validated structure; another skill should inspect implementation details when needed.

## Supported diagram intents
Prefer one of these intents:
- high-level runtime architecture;
- workflow/process map;
- sequence/interaction flow;
- data-flow map;
- lifecycle/state progression;
- before / delta / after architecture comparison.

## Default workflow
1. Identify the repository or system scope.
2. Read enough source/configuration to establish real components and relationships.
3. Select 8–12 core components for a high-level map unless the user requests another scale.
4. Identify one primary path through the system.
5. Mark external dependencies and trust boundaries when relevant.
6. Put secondary detail in cards/metadata instead of creating excessive edges.
7. Generate the Archify representation.
8. Validate that every important edge is supported by source evidence or explicit user-provided system description.
9. Export or present HTML/SVG/PNG only after validation.

## Grounding rules
- Never invent topology to make the diagram prettier.
- Distinguish authored/static relationships from inferred runtime impact.
- If a route or dependency is uncertain, mark it as uncertain or inspect more source before rendering.
- Prefer fewer meaningful nodes over exhaustive file-by-file maps.
- Use source locations in supporting cards when that improves traceability.

## Codex installation reference
Official upstream global install:
```bash
npx skills add tt-a1i/archify -g
```
Codex-compatible global skill location is typically under `~/.agents/skills/`.

To try without installing:
```bash
npx skills use tt-a1i/archify@archify --agent codex
```

This Git skill is a durable wrapper/reference for the user workflow. Installing the upstream renderer/runtime is a separate machine-level step.

## GameStudio integration
Archify should complement the existing Godot source-decomposition and GameStudio skills.

Recommended order:
1. Source-decomposition skill inspects Godot scenes, scripts, inheritance, shaders, signals, resources, and layout behavior.
2. Archify converts the discovered structure into a project/module map.
3. Ponytail can review a proposed architecture change for unnecessary complexity.
4. Change-log skill records accepted changes.

For Godot projects, useful map layers include:
- scene hierarchy and scene ownership;
- autoloads/global state;
- major managers/controllers;
- UI layer vs gameplay layer;
- resources/data tables/save system;
- signal/event relationships;
- external SDK/platform boundaries;
- asset-generation or content pipelines.

Avoid mapping every Node unless the task is specifically about scene composition. Prefer semantic subsystems.

## Suggested prompts
- "Analyze this repository and use Archify to create a high-level runtime architecture map."
- "Show 8–12 core components, one primary path, external dependencies, and trust boundaries."
- "Create a Before / Delta / After architecture comparison for this refactor."
- "Map how this Godot scene flows from input to gameplay logic to UI and save state."

## Upstream update policy
When refreshing this skill:
1. Check `tt-a1i/archify` README, changelog, and skill schema.
2. Review supported diagram types, export formats, and installation paths.
3. Update commands/version-sensitive guidance only when upstream materially changes.
4. Do not vendor the full upstream renderer into `skill_list` unless explicitly requested.

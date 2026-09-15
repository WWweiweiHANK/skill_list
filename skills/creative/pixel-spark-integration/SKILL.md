# Pixel Spark Integration Skill

## Identity

- **Skill name:** `pixel-spark-integration`
- **Upstream project:** `ArimaKana/pixel-spark`
- **Original URL supplied by user:** `https://github.com/ArimaKana/pixelfy`
- **Current repository name:** `pixel-spark` (the supplied repository URL now resolves to this renamed repository)
- **License:** Apache-2.0
- **Category:** creative / pixel art / game asset production / editor integration

## Purpose

Use this skill when a task involves producing, editing, animating, organizing, or exporting pixel-art assets and Pixel Spark could serve as the execution tool.

This skill is a **tool integration layer**, not a replacement for `game-art-agent`.

`game-art-agent` owns:
- art direction and style consistency;
- production stage judgment;
- naming and archive rules;
- Master asset confirmation;
- deciding what should be produced next.

`pixel-spark-integration` owns:
- deciding whether Pixel Spark is suitable for the requested asset operation;
- translating an art task into Pixel Spark operations;
- sprite / animation / tile / tilemap editing workflows;
- MCP-oriented execution planning;
- Godot-oriented export preparation.

## What Pixel Spark Is

Pixel Spark is an AI-native desktop pixel-art editor built with Vue 3, Vite, Tailwind CSS v4, and Electron.

Its notable capabilities include:

- sprite editing with pixel-perfect drawing tools;
- layers, blend modes, clipping masks, transform/filter tools;
- frame-by-frame animation, tags, onion skinning, GIF / spritesheet / PNG-sequence export;
- palette presets, extraction, quantization, and palette ramps;
- tile editing and tile-map authoring;
- Godot Terrain rule tiles and Godot 4 scene export;
- AI-assisted sprite, reference-image, animation, and tile generation;
- MCP access for external AI clients;
- project-local file storage rather than a purely browser-based SaaS workflow.

## When to Invoke

Invoke this skill when the user asks for one or more of the following:

1. Turn a concept / reference image into a pixel-art production workflow.
2. Edit an existing sprite or pixel-art asset.
3. Create or refine frame animation.
4. Build directional animation sets.
5. Create tile sets or tile maps.
6. Prepare Godot-compatible Terrain tiles or TileMap assets.
7. Quantize or normalize palette usage across an asset set.
8. Use an external AI agent through MCP to manipulate a pixel editor.
9. Turn a confirmed GameArtAgent Master design into production-ready pixel assets.
10. Export sprite sheets, PNG sequences, GIFs, tile sets, or Godot-ready resources.

Do **not** invoke it merely because a project uses pixel art. If the task is still in art-direction / style-definition / concept selection, stay in `game-art-agent` first.

## Preflight Checks

Before executing a Pixel Spark workflow, establish:

- target project/game;
- asset type: sprite / animation / tileset / tilemap / reference;
- target canvas size or tile size;
- palette constraints, if any;
- animation direction count and frame budget;
- intended engine/export target, especially Godot;
- whether a Master reference has already been confirmed;
- whether the task is destructive to an existing asset;
- whether MCP or direct manual/editor execution is expected.

If any of these are unknown but not blocking, choose conservative defaults and record them.

## Recommended GameArtAgent Handoff

Use this sequence:

1. `game-art-agent` determines production stage.
2. Confirm or identify the Master reference.
3. Freeze key style constraints:
   - silhouette;
   - pixel density;
   - palette;
   - outline policy;
   - light direction;
   - animation exaggeration level.
4. Hand production execution to this skill.
5. Generate/edit the asset in Pixel Spark.
6. Compare output against the Master.
7. Reject drift or revise.
8. Export production asset.
9. Return to `game-art-agent` for naming, archive state, and Master/Derived classification.

## Pixel-Art Production Rules

When using Pixel Spark for a derived asset:

- preserve the established pixel density;
- avoid introducing semi-random anti-aliasing unless the style explicitly uses it;
- prefer palette reuse before adding new colors;
- keep silhouette readability above internal detail;
- preserve anchor points between animation frames;
- do not upscale a small asset with smooth interpolation;
- use nearest-neighbor logic when resizing pixel assets;
- keep animation frame changes intentional rather than AI-noisy;
- compare all generated animation frames against frame 1 / Master pose for identity drift.

## Core Workflows

### A. Reference -> Sprite

1. Start from the confirmed reference.
2. Choose target sprite dimensions.
3. Generate or import a reference image if necessary.
4. Pixelize to target resolution.
5. Quantize to the project palette where appropriate.
6. Remove noisy single-pixel artifacts.
7. Check silhouette and facial/identity landmarks.
8. Save as a derived asset.

### B. Sprite -> Animation

1. Treat the approved sprite or frame 1 as the identity anchor.
2. Define the action and expected loop length.
3. Generate/author candidate frames.
4. Remove visually redundant or unstable frames.
5. Normalize body proportions and contact points.
6. Preview as a loop.
7. Tag animation ranges.
8. Export only after loop stability is confirmed.

### C. Four-direction Character Animation

For down / left / right / up workflows:

- keep sprite scale and body proportions identical across directions;
- treat left/right mirroring as a style choice, not an automatic assumption;
- preserve equipment handedness where gameplay matters;
- validate idle and walk loops separately;
- use stable animation tags for downstream export.

### D. Tile Set / Tile Map

1. Lock tile size first.
2. Define terrain categories and adjacency needs.
3. Build or import a tile atlas.
4. Remove fully transparent / invalid cells.
5. Configure terrain rule variants if required.
6. Verify seams in repeated placement.
7. Verify collisions separately from visuals.
8. Export to the target engine format.

### E. Godot Terrain Export

Pixel Spark can prepare Godot-oriented terrain resources and export Godot 4 scene data.

Before export verify:

- tile dimensions;
- atlas layout;
- terrain peering / rule variants;
- map-layer ordering;
- collision coverage;
- resource paths after extraction/import;
- whether the target project uses TileMap or TileMapLayer conventions.

After export, test the generated resources inside the actual Godot project before marking them production-ready.

## MCP Integration

Pixel Spark exposes an MCP interface intended for external AI clients. The upstream project documents roughly ninety native editor tools spanning pixel operations, animation, tilemaps, project files, and export.

Important boundary:

- MCP tools can manipulate editor/project content;
- upstream documentation explicitly keeps some AI-generation and internal Agent controls outside the MCP tool surface.

When using MCP:

1. Launch Pixel Spark.
2. Use the application's MCP UI to copy the current stdio configuration.
3. Add that configuration to the compatible AI client.
4. Confirm the MCP server is visible before issuing asset-editing commands.
5. Prefer small atomic operations when editing valuable assets.
6. Save/checkpoint before large structural changes.

## Installation / Development

From the upstream repository:

```bash
npm install
npm run dev
```

Other useful upstream commands:

```bash
npm run build
npm start
npm run dist
```

The project is an Electron desktop app. `npm run dist` is used for Windows packaging in the upstream workflow.

## Important Project Areas

When inspecting upstream source, prioritize:

- project persistence / project-file modules;
- sprite editor state and history;
- animation timeline/tag logic;
- palette and quantization logic;
- tile/tilemap editors;
- Godot export code;
- MCP server and tool definitions;
- AI provider configuration;
- export code paths.

Do not assume file paths remain stable across upstream updates. Search the current repository before modifying integrations.

## Asset State Convention

Every output should be classified as one of:

- `REFERENCE` — inspiration/reference only;
- `WIP` — actively being edited;
- `CANDIDATE` — acceptable candidate awaiting review;
- `MASTER` — approved source of truth;
- `DERIVED` — produced from a Master;
- `EXPORT` — engine-ready/generated output.

Pixel Spark should normally produce `WIP`, `CANDIDATE`, `DERIVED`, or `EXPORT` assets. `MASTER` status should be granted by the GameArtAgent workflow, not automatically by this skill.

## Naming Recommendation

Use English filenames and stable asset identity:

```text
<project>_<asset>_<variant>_<state>.<ext>
```

Examples:

```text
snow_girl_idle_down_master.png
snow_girl_walk_down_derived.png
meow_coin_pickup_fx_export.png
snow_terrain_ice_tileset_export.png
```

## Known Limits / Risks

- AI-generated frames may introduce identity or silhouette drift.
- Automatic pixelization can create noisy clusters that need manual cleanup.
- Palette quantization can destroy focal details if target color count is too low.
- Terrain rule sets can appear valid individually but still seam badly when painted repeatedly.
- Export correctness must be verified in the actual engine.
- MCP capabilities and tool names may change as the upstream project evolves.
- External AI services used by Pixel Spark may require provider credentials and can have their own pricing/availability constraints.

## Upstream Update Procedure

When refreshing this skill:

1. Open `ArimaKana/pixel-spark`.
2. Read the current README and MCP documentation.
3. Check recent release/commit notes for changes to:
   - MCP tools;
   - project format;
   - animation system;
   - Godot exporter;
   - AI providers;
   - installation commands.
4. Update this Skill only for behavior that still exists upstream.
5. Record the update in the skill repository changelog.

## Source Binding

This skill is specifically bound to:

`https://github.com/ArimaKana/pixel-spark`

The user originally supplied:

`https://github.com/ArimaKana/pixelfy`

That repository now resolves to `ArimaKana/pixel-spark`. Treat `pixel-spark` as the canonical upstream identity unless the owner renames it again.

## Relationship to Existing Skills

- `game-art-agent` -> production-stage owner and art-direction authority.
- `pixel-spark-integration` -> pixel editor / animation / tile / export execution specialist.
- Godot skills -> downstream engine implementation and validation.

Typical chain:

```text
GameArtAgent
    -> confirm style / Master
Pixel Spark Integration
    -> produce / edit / animate / tile / export
Godot workflow
    -> import / wire / validate in game
GameArtAgent
    -> archive / status / Master tracking
```

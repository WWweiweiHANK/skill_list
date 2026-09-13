---
name: game-art-agent
description: Use when defining, producing, reviewing, or organizing AI-generated game-art assets across ChatGPT discussions and a Codex game project, especially when a visual direction, Master asset, derivatives, or asset records must remain consistent.
---

# GameArtAgent

Run AI game-art work as a controlled production system, not an endless stream of image generations. The goal is a coherent, traceable asset family that can be safely used in a game project.

## Collaboration boundary

Treat the work as a three-party collaboration:

| Party | Owns | Does not own |
|---|---|---|
| User | Creative intent, final taste, approval of a visual direction, and every promotion to `MASTER` | Routine bookkeeping and implementation details once they are authorized |
| ChatGPT | Art-direction discussion, option framing, style diagnosis, production briefs, and recommendation of a candidate Master | Silent final selection or changing project files without the user's authorization |
| Codex | Project execution: file organization, renames, registry and documentation updates, reference repair, technical checks, and status reporting | Choosing which aesthetic is better or promoting any candidate to `MASTER` without the user's explicit confirmation |

Codex must never infer an approval from words such as “looks good,” “use this,” or from a file being latest. A Master change requires an unambiguous user instruction such as: “Set `lucky_cat_v03.png` as the Lucky Cat Master.” If it is absent, preserve the current Master and label the candidate `SELECTED` or `EXPLORE` as appropriate.

## Lifecycle

Use the current asset status to decide the next action.

| Status | Meaning | Allowed next action |
|---|---|---|
| `EXPLORE` | Candidate used to discover a direction | Compare, annotate, iterate, or archive |
| `SELECTED` | Preferred candidate awaiting explicit Master confirmation | Prepare review notes; do not replace a Master |
| `MASTER` | Approved canonical source for an asset family | Create controlled derivatives and protect the source |
| `PRODUCTION` | A derivative being made from a named Master | Review, revise, accept, or archive |
| `IN_GAME_REVIEW` | Asset is being assessed in its actual scene/UI | Record findings, then accept, revise, or archive |
| `ARCHIVE` | Superseded, rejected, or historical asset | Retain metadata; do not use as a new source without a deliberate revival |

### 1. Explore

Clarify the asset's gameplay role, mood, audience, camera/view context, constraints (including transparent background, resolution, and animation needs), and 2–3 distinct visual directions. Keep candidates separate from production assets. Discuss tradeoffs; do not call an exploration output final by default.

### 2. Set the direction

Turn the chosen direction into concrete, observable rules: silhouette, proportions, shape language, palette, material/rendering treatment, line/detail density, lighting, readability, and prohibited drift. Record these rules in the Art Bible before large-scale production.

### 3. Establish a Master

Only after explicit user confirmation, promote the candidate to `MASTER`. Give it a stable canonical name and location, preserve its source/version provenance, update both records, and move replaced candidates to `ARCHIVE` rather than deleting them. A Master is the family’s reference, not merely its current favorite image.

### 4. Produce derivatives

Every derivative must name its parent Master and inherit its locked visual rules. Change only the requested variables—such as pose, expression, rarity, damage state, colorway, size tier, or UI state. If a requested derivative needs a style or proportion break, return to exploration rather than silently drifting the family.

### 5. Review

Review assets against the Art Bible and their Master, not only by whether they look attractive in isolation. Check visual consistency, silhouette/readability, gameplay clarity, technical suitability, and any requested format constraints. Give a clear recommendation: revise, accept into production, nominate for Master confirmation, or archive.

### 6. In-game review

Place or inspect the asset in the intended game context whenever possible: actual UI scale, camera distance, background contrast, lighting, states/animation, and performance/import behavior. Log defects and decisions. An image can pass standalone review yet fail in-game review; return it to `PRODUCTION` when changes are needed.

### 7. Archive

Archive rejected, superseded, and retired assets with their identity and reason retained. Do not delete assets, overwrite a Master, or mass-move game assets without explicit authorization and a check of affected references.

## Project records

Use these project files when the project has an `art/` area; otherwise create them only when the user authorizes establishing the workflow.

- `art/art_bible.md` is the source of visual rules. For every family with a Master, include the canonical filename/path, locked traits, palette/material notes, permitted variation axes, and relevant in-game constraints.
- `art/asset_registry.md` is the source of asset state and lineage. Maintain one row or entry per asset with: `asset_id`, status, type/family, canonical path, parent Master/source, version or date, intended game use, and a short decision note.
- `CHANGELOG.md` (or the project’s existing change record) records completed material changes: promotions, archive/move/rename operations, record updates, broken-reference repairs, and review outcomes. Follow the project’s established changelog format if one exists.

If records disagree, do not guess. Report the conflict, preserve files, and ask the user which record is authoritative.

## Naming and layout

Use stable, lowercase `snake_case` asset IDs. Prefer names that express family, role/variant, and version only where versions are still useful, e.g. `lucky_cat_master.png`, `lucky_cat_idle_v01.png`, `upgrade_button_orange_master.png`.

Keep Master files, derivatives, and archives separate. A typical layout is:

```text
art/
  characters/lucky_cat/master/lucky_cat_master.png
  characters/lucky_cat/variants/lucky_cat_idle_v01.png
  ui/buttons/master/upgrade_button_orange_master.png
  archive/characters/lucky_cat/lucky_cat_explore_v02.png
  art_bible.md
  asset_registry.md
```

Adapt to an existing project layout rather than forcing this example. Before any rename or move, locate scene, UI, script, import, and manifest references; repair only those broken by the authorized change and record the result.

## Operating modes

In a normal ChatGPT conversation, provide art-direction help, statuses, concise decision options, and a ready-to-paste Codex execution brief after the user makes a decision. Do not pretend to have organized files unless connected to the project and authorized to do so.

In a Codex project, inspect existing conventions first; then execute only approved, scoped operations. Report changed paths, record updates, reference checks, and any decisions that still need user confirmation. For projects such as `Incremental_meowmeowmeow`, preserve the existing game architecture and imports while applying this workflow.

## Completion check

Before calling an asset operation complete, confirm: the asset status is accurate; the Master relation is explicit; Art Bible and Asset Registry agree; references remain valid after any file operation; and the Changelog captures material changes. Flag pending user decisions rather than making them on the user’s behalf.

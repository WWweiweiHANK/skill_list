---
name: crazygames-godot-web-compression
description: Compress a Godot HTML5 export for CrazyGames with verified Brotli assets and minimal loader rewrites. Use only when the user asks to optimize, compress, or prepare a Godot web export/package for CrazyGames.
---

# CrazyGames Godot Web Compression

Use this Skill to reduce the delivery size of a Godot HTML5 export intended for CrazyGames. Preserve Godot's generated startup/configuration logic; make only the required asset URL changes.

## Preflight

- Work in the directory containing the export. Require `index.html`, `index.js`, `index.pck`, and `index.wasm`.
- If the uncompressed files are absent but their `.br` variants exist and `index.html` already points to the Brotli variants, report that the package appears processed. Do not recreate or delete files.
- Use a Brotli encoder that supports quality level 11. Keep originals until both compression and loader validation succeed.

## Compress and verify

- Create `index.js.br`, `index.pck.br`, and `index.wasm.br` with Brotli quality `11`; do not recompress an existing corresponding `.br` file.
- Impose a three-minute limit for each compression operation. Stop and report a timeout rather than deleting or substituting files.
- For every `.br` asset, perform a Brotli decompression test and compare the decompressed bytes exactly with its source file.
- If verification fails, remove only that invalid `.br` output and retry compression at most twice. Stop and report the failed asset after the second retry.

## Update the loader

- Change the script reference from `index.js` to `index.js.br`.
- Before Godot creates or consumes its configuration, add one fetch redirection layer that maps exact requests for `index.pck` and `index.wasm` to `index.pck.br` and `index.wasm.br`.
- Keep Godot's generated configuration and startup code otherwise unchanged. Do not duplicate the redirection on repeated runs.
- Validate that the HTML has one `index.js.br` reference, one redirection layer, and mappings for both `index.pck` and `index.wasm`.

## Delivery checks and cleanup

- Identify the upload/deployment server behavior: assets served as Brotli content normally require the appropriate `Content-Encoding: br` and correct JavaScript/WASM MIME types. Direct `.br` URLs can have host-specific behavior, so confirm that the target CrazyGames upload/runtime path accepts the approach before shipping.
- Verify the game loads in a production-like browser or CrazyGames test flow and that no original asset URL is requested.
- Only after all asset checks and loader checks pass may `index.js`, `index.pck`, and `index.wasm` be removed. State explicitly which originals were removed.

## Boundaries

- This is a CrazyGames Godot package-compression Skill, not a general website minification or Godot export-configuration Skill.
- Do not alter game content, Godot project settings, or unrelated HTML/CSS/JavaScript while applying it.

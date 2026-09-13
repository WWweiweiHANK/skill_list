---
name: godot-game-analytics
description: Use when adding, revising, or reviewing analytics and telemetry in a Godot 4 game, especially for event-bus projects with high-frequency gameplay, HTTP delivery, offline retries, or privacy-sensitive player data.
---

# Godot Game Analytics

Instrument confirmed domain outcomes, not UI intent. Keep analytics as an Autoload subscriber; gameplay and UI must not issue HTTP requests.

## Architecture

1. Inspect existing Autoloads, event bus, save lifecycle, and source-of-truth services.
2. Add narrow domain signals only where a transaction/state change has succeeded. Include IDs, cost, and result state needed for analysis.
3. Let one analytics manager attach common context (`schema_version`, event/session/install IDs, build/platform, timestamps), persist a bounded offline queue, and POST batches.
4. Aggregate high-frequency actions locally into periodic summaries. Flush on a timer, application close, and a safe lifecycle boundary.
5. Test event normalization, reserved-field protection, aggregation, queue recovery, and failure retention before enabling production networking.

## Event contract

Use stable snake_case names and JSON-safe primitive values. Every event needs `event_id`, `session_id`, `event_name`, `schema_version`, UTC client time, platform, and a privacy-safe install identifier. Never let custom fields overwrite those keys.

| Situation | Event | Required business fields |
|---|---|---|
| State transition | `level_up`, `cat_unlock`, `background_unlock` | relevant ID and resulting level/state |
| Economy success | `upgrade_purchase`, `merge_success` | item/type, cost, result level |
| Ad lifecycle | `ad_start`, `ad_finish`, `ad_fail` | stable ad type; omit raw provider errors |
| Repeated gameplay | `gameplay_summary` | interval counters, not one request per hit |

## Transport and safety

Batch with a size cap, retain failed events locally, and only remove entries after the server has handled them. Use HTTPS in production. Server validation, rate limiting, and anti-abuse checks belong server-side: date-derived client strings are not authentication. Do not place private keys, SSH credentials, tokens, or raw IP addresses in client code, telemetry payloads, commits, or Skills.

## Completion checklist

- Verify each producer fires after—not before—the underlying mutation.
- Confirm debug/editor mode is log-only or uses an explicit test endpoint.
- Verify a real success, an offline failure/restart recovery path, and a high-frequency aggregation interval.
- Record schema changes and known retention/privacy decisions in the project change log.

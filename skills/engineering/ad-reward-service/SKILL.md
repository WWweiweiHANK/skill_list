---
name: ad-reward-service
description: Use when integrating rewarded or interstitial ads into a game or app, especially when rewards can be granted twice, granted after cancellation, blocked by a missing SDK, or coupled directly to a provider-specific API.
---

# Rewarded Ad Service

## Core pattern

Treat ads as a platform service, not gameplay logic. UI and gameplay emit a reward intent; one service chooses an adapter, owns ad lifecycle state, and reports a normalized result. Grant a reward only from the confirmed-complete branch.

## Separate the contracts

- Business layer: asks for a named reward opportunity with context. It must not import or call an ad SDK.
- Ad service: prevents duplicate requests, records pause/audio state, selects an adapter, restores state, and invokes exactly one result branch.
- Platform adapter: translates provider callbacks into `completed`, `cancelled`, `failed`, or `unavailable`. Keep provider IDs, JavaScript bridges, native SDK calls, and test ads here.
- Reward handler: validates that its pending context still matches, then applies the reward and persists it if needed.

Use a request shape equivalent to `request_rewarded_ad(context, on_completed, on_not_completed)`. Context identifies the reward opportunity; it is not an instruction to grant the reward.

## Lifecycle rules

1. Reject or report failure when an ad is already active; never overwrite pending callbacks.
2. On actual ad start, snapshot pause and audio state, then suppress game input/audio as appropriate.
3. On every terminal result, restore the snapshot, clear pending state, and invoke one callback only.
4. `completed` grants the reward. `cancelled` and `failed` do not.
5. Define unavailable behavior explicitly per build: development may use a marked mock completion; production must not silently grant a real reward because an SDK is missing or blocked.

## Integration checks

- Subscribe the service to the existing intent/event bus; an emitted request with no listener is a broken integration.
- Keep the reward context until the terminal callback, then discard it. Ignore stale callbacks for another screen, player, or reward.
- Do not let provider callbacks directly mutate game currency, unlocks, or multipliers.
- For interstitial ads, use the same lifecycle service but no reward callback.

## Verification

Test the real service with a local adapter and assert observable outcomes:

- completed: one matching reward result, state restored;
- cancelled/failed: no reward, state restored;
- duplicate request: second request does not replace the first;
- unavailable: follows the explicitly selected development or production policy.

Before release, run a provider preview/device test and verify that a full video triggers the completed branch while an early close does not.

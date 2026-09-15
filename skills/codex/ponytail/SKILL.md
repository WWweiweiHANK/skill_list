# Ponytail Integration Skill

## Identity
- Upstream: https://github.com/DietrichGebert/ponytail
- Purpose: minimal senior-developer reasoning mode for Codex and other coding agents.
- Core principle: prefer the smallest correct implementation; YAGNI; standard library and native platform features first; avoid unrequested abstractions.
- Upstream license: MIT.

## When to use
Invoke this skill when the task involves:
- implementing a feature where over-engineering is a risk;
- reviewing code for unnecessary abstractions, layers, frameworks, or premature extensibility;
- simplifying an existing implementation;
- evaluating technical debt, unnecessary code, duplicated architecture, or avoidable dependencies;
- finding the shortest maintainable solution that satisfies the actual requirement.

Do not use Ponytail to suppress necessary architecture. If the task has hard constraints around scale, security, maintainability, compatibility, or extensibility, preserve those constraints and minimize only within them.

## Operating mode
Before changing code:
1. Restate the actual required outcome in one sentence.
2. Identify the smallest implementation surface that can satisfy it.
3. Check whether an existing project utility, engine feature, standard-library API, or native platform feature already solves the need.
4. Avoid introducing a new abstraction unless there are at least two concrete current uses or the abstraction is required by the framework/engine.
5. Prefer deleting or reusing code over adding parallel systems.

During implementation:
- minimize file count, new types, dependencies, configuration, and indirection;
- prefer existing conventions in the repository;
- do not add speculative extension points;
- do not generalize one-off behavior prematurely;
- keep code readable rather than merely short.

During review, explicitly look for:
- wrappers that add no semantic value;
- duplicate managers/services/helpers;
- new dependencies that replace simple built-ins;
- configuration added for hypothetical future cases;
- factories/interfaces with only one implementation;
- unnecessary event layers or state containers;
- duplicated validation or serialization paths;
- compatibility layers with no current requirement.

## Commands / conceptual submodes
The upstream Ponytail project exposes modes such as:
- ponytail: smallest correct implementation
- ponytail-review: review for over-engineering
- ponytail-audit: architecture/code audit
- ponytail-debt: identify simplifiable technical debt
- ponytail-gain: estimate simplification gains
- ponytail-help: mode guidance

When this repository skill is used without the upstream plugin installed, reproduce the same reasoning principles manually.

## Codex installation reference
Official upstream Codex flow:
```bash
codex plugin marketplace add DietrichGebert/ponytail
codex plugin add ponytail@ponytail
```
Then start Codex, open `/hooks`, review and trust the lifecycle hooks, and start a new thread.

The upstream plugin currently declares instructions/skills plus lifecycle hooks. Installing the upstream plugin is separate from storing this Git skill.

## Integration with GameStudio
Use Ponytail as an engineering constraint layer, not as the product-design authority.

Recommended order:
1. Game-design or product skill defines what should exist.
2. Godot/source-decomposition skill determines engine-level implementation constraints.
3. Ponytail asks: what is the smallest correct implementation under those constraints?
4. Change-log skill records the final accepted changes.

For Godot specifically:
- prefer built-in nodes, signals, resources, themes, AnimationPlayer/Tween, and engine-native serialization before inventing custom frameworks;
- avoid singleton/autoload growth unless cross-scene state genuinely requires it;
- avoid creating multiple managers for concerns already handled by one clear owner;
- reuse existing base components when semantics truly match.

## Upstream update policy
When refreshing this skill:
1. Check `DietrichGebert/ponytail` README and plugin metadata.
2. Review new/renamed commands, skills, hooks, and principles.
3. Update this wrapper only when upstream behavior materially changes.
4. Do not vendor the full upstream source into this repository unless explicitly requested.

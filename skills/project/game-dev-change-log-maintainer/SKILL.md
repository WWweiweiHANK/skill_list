---
name: game-dev-change-log-maintainer
description: Use when completing code, game-design, gameplay, balance, content, or configuration changes in a game project and a durable project change record must be maintained.
---

# Game Development Change Log Maintainer

Every completed game-development change has a durable, specific record in the project before the final response. Treat the change log as an operations artifact: a reader must be able to identify what changed, why, impact, and how it was checked without reconstructing the session from source control.

## Required finish step

Before giving the final response for a task that changed code, game design, gameplay, balance, content, configuration, or game assets:

1. Locate the project-root log in this order: an existing explicit game/project change log (including `CHANGELOG.md`, `DEVLOG.md`, `修改记录.md`, or a clearly equivalent root-level file); otherwise use `CHANGELOG_GAME_DEV.md` at the project root.
2. If no selected log exists, create `CHANGELOG_GAME_DEV.md` with a short title and a newest-first or oldest-first convention; preserve the convention thereafter.
3. Inspect the changes made in this task and append one factual entry. Do not claim pre-existing dirty-worktree changes as this task's work.
4. Re-open the written entry and check that every required field below is present and specific. Only then finish the task.

Do not create a second log when an explicit project log already exists. Do not log a task whose only change is the log itself.

## Entry contract

Each entry includes all fields below. Use `无` or `不适用（原因）` where appropriate; never silently omit a field.

```markdown
## YYYY-MM-DD HH:MM ±HH:MM — <concise modification target>

- 修改目标：<feature, system, scene, or design objective>
- 具体改动：<observable behavior/content changes; include key values or rules>
- 涉及文件：<each changed path and its role>
- 新增 / 删除 / 调整：<separate concrete items>
- 规则 / 策划变化：<gameplay, balance, economy, UX, or content-rule impact>
- 技术实现变化：<architecture, data, scripts, scenes, resources, APIs, or tooling>
- 兼容性或风险：<saves, configs, migrations, performance, platform, regressions; or no known risk>
- 验证结果：<tests, build, manual checks and results; state not run and why>
- 待办事项：<remaining work, follow-up, or 无>
```

## Specificity rules

- Name the actual files and distinguish added, removed, and modified artifacts.
- Record changed gameplay rules and balance values, not a generic phrase such as “adjusted balance.”
- Separate player-visible/design impact from implementation detail.
- Record verification honestly; passing tests, unrun tests, and manual observations are different results.
- If an old log is vague, reuse it and add a complete new entry; do not skip logging or replace its history.

## Red flags

Stop before finalizing if any of these are true:

- “The final response summary is enough.”
- “The task is urgent or small.”
- “The existing log is vague or I cannot confirm its intended format.”
- “I will add the entry later.”

These are not exceptions. Write the entry now, retaining the existing log and its format where possible.

---
name: hermes-update-assessment
description: "When Hermes updates, translate changelogs into user-relevant insights. Focus on what matters to THIS user's stack, not everything Nous ships."
category: gentech-ops
version: 2.0.0
tags: [hermes, updates, agent-kit, user-centric, maintenance]
---

# Hermes Update Assessment — User-First

## Core Principle
Nous Research has unlimited tokens and 10+ agents building Hermes. There will be MANY updates. Most won't matter to the user. Our job is to filter the noise and surface only what's relevant to THEIR stack.

**Don't report what changed. Report what it means for them.**

## Workflow

### Step 1: Get the Changelog
```bash
hermes --version
curl -s https://api.github.com/repos/NousResearch/hermes-agent/releases/latest | python3 -c "import sys,json; r=json.load(sys.stdin); print(r['body'])"
```

### Step 2: Filter by User's Stack
Read the user's profile to know what they use:
- What providers? What channels? What tools?
- What cron jobs? What MCP servers? What skills?

**Filter the changelog:** Does this affect THEIR stack? → Report. Otherwise → Skip.

### Step 3: Translate to User Language
- "I can now run tasks in background" (not "delegate_task background=true")
- "Memory updates never fail now" (not "atomic batch operations")
- "This saves you money" (not "curator consolidation disabled")

### Step 4: Update Agent Kit If Needed
Only when distribution format, skill format, or security changes.

### Step 5: Report
```
🔄 Hermes v[NEW] — What It Means for You

## TL;DR
[1-2 sentences]

## What Changed (That Matters)
1. [Feature] — [what it means for YOUR stack]

## What You Can Do Now
- [New capability]

## Agent Kit Updated?
- Yes → [what changed]
- No → [why not needed]
```

---
name: wake-template
description: "Morning wake-up template for Hermes agents — reads vault ideas and prompts the user. Drop into any Hermes profile for instant morning intelligence."
category: agent-kit
version: 1.0.0
author: GenTech Labs
tags: [startup, morning, ideas, prompt, agent-kit]
---

# Wake Template — Morning Intelligence Prompt

## What This Does
Every morning (or on session start), this template:
1. Reads the vault's ideas/brainstorming file
2. Presents top ideas to the user
3. Asks what to work on today
4. Flags urgent items

## Installation

Copy this skill to your Hermes profile:
```bash
cp -r wake-template ~/.hermes/profiles/your-profile/skills/
```

Add to your cron jobs:
```json
{
  "name": "Morning Wake Prompt",
  "schedule": "0 8 * * *",
  "prompt": "You are [Agent Name]. Run the wake template:\n\n1. Read [VAULT]/ideas.md\n2. Present top 3-5 ideas with status\n3. Ask: 'What should we work on today?'\n4. Flag anything with deadline < 7 days\n\nFormat: Clean, scannable, under 200 words.",
  "deliver": "origin"
}
```

## Customization

### Change the ideas file path
Replace `[VAULT]/ideas.md` with your vault's actual ideas file.

### Change the prompt style
Edit the prompt to match your agent's personality.

### Add market context
If your agent tracks markets, add a price snapshot section.

### Add activity logging
If your agent has collaborators, add a "who said what overnight" section.

## Template Prompt

```
You are [Agent Name], the solo agent for [Org Name].

**Morning Wake Prompt:**

1. Read [VAULT]/ideas.md (or equivalent brainstorming file)
2. Present the top 3-5 ideas:
   - Name
   - Status (concept/building/live)
   - 1-line summary
   - Deadline if applicable

3. Ask: "What should we work on today?"

4. If any idea has a deadline < 7 days, flag with 🔴

5. Quick market snapshot (if applicable):
   - Key prices
   - Events today

**Format:** Clean, scannable, under 200 words. No walls of text.
```

## Why This Matters

Most agents start sessions blank. They don't know what was being worked on, what ideas are pending, or what's urgent. This template gives every agent:
- **Context** — what's in the pipeline
- **Direction** — what to focus on today
- **Urgency** — what's deadline-sensitive

It's the difference between an agent that waits for instructions and one that proactively suggests work.

## Integration with Agent Kit

This template works with:
- **Obsidian vaults** — read ideas.md, considerations.md
- **GitHub repos** — read TODO.md, ISSUES.md
- **Any markdown-based knowledge base**

Pair with `proactive-context` skill for full session lifecycle:
- **Morning:** Wake template (this) → prompt user
- **During session:** Proactive context → save insights
- **End of session:** Handoff notes → preserve context

## Credits

Built by GenTech Labs for the Hermes agent ecosystem.
Part of the [GenTech Agent Kit](https://github.com/ProtoJay4789/genTech-agent-kit).

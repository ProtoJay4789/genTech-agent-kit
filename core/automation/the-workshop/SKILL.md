---
name: the-workshop
description: "Daily autonomous work prompt — agent reviews vault, identifies actionable tasks, and delivers a build list. Part of the GenTech vault workflow: Green Room (ideas) → Mess Hall (decisions) → Workshop (action)."
category: automation
version: 1.0.0
author: GenTech Agent Kit
tags: [workflow, daily-standup, autonomous, cron, vault]
---

# The Workshop — Daily Autonomous Work Prompt

Part of the vault workflow:
- **Green Room** — ideas waiting to be explored
- **Mess Hall** — decisions waiting to be made
- **The Workshop** — where the agent identifies what it can build today, no human input needed

## Purpose

Every morning, the agent reviews the vault backlog and delivers a scannable build list. The list separates:

1. **Autonomous tasks** — research, prototyping, API testing, spec writing, skill creation, vault organization. Things the agent can start and complete without waiting on anyone.
2. **Blocked tasks** — things requiring human decisions, account signups, approvals, or personal information.
3. **Recent progress** — what got done in recent sessions.

## Cron Job Setup

```python
cronjob(
    action="create",
    name="Daily Build List — The Workshop",
    schedule="0 7 * * *",  # Adjust for timezone
    deliver="telegram:<chat_id>",
    enabled_toolsets=["file", "terminal", "session_search"],
    prompt="""You are the agent. This is the daily Workshop standup.

YOUR TASK:
1. Read the vault backlog:
   - {vault}/09-Green Room/ideas.md
   - {vault}/11-Mess Hall/considerations.md

2. Identify AUTONOMOUS tasks (no human input needed):
   - Research and analysis
   - Code exploration and prototyping
   - Spec writing and architecture docs
   - Skill creation and vault organization
   - Market research and trend monitoring

   EXCLUDE anything requiring the human to:
   - Sign up for accounts
   - Make business decisions
   - Interact with platforms manually
   - Provide personal information

3. Check recent sessions (session_search) to avoid
   suggesting tasks already in progress.

4. Deliver:

🌅 **Workshop Build List — [date]**

**Ready to go (no input needed):**
• [task] — [what, estimated effort]

**Waiting on you:**
• [task] — [what human needs to do]

**Recent progress:**
• [what got done]

Keep it concise. 2-3 sentences per item."""
)
```

## Vault Folder Convention

```
09-Green Room/     → Ideas (unvalidated, exploratory)
11-Mess Hall/      → Considerations (validated, pending decision)
[Work Channel]     → Workshop (agent delivers daily action items)
```

## Customization

| Field | What to change |
|-------|---------------|
| `schedule` | Timezone-adjusted time |
| `deliver` | Your work channel |
| `vault paths` | Your ideas.md and considerations.md locations |
| `EXCLUDE` | Team-specific exclusions |

## Pitfalls

- **Stale vault** — Workshop produces the same list if backlog isn't updated
- **Suggesting blocked tasks** — classify as "waiting on you" when in doubt
- **Session context drift** — always cross-check recent sessions first
- **Over-promising** — pick top 3-5 items, not 10

---
name: wake-up-protocol
description: "Wake-up protocol — restore identity, behavior, and context after restart. Run this FIRST on every session start. Part of the AAE Behavior Layer."
category: behavior
version: 1.0.0
author: GenTech Agent Kit
tags: [startup, identity, behavior, context, wake-up, brain-refresh, behavior-layer]
---

# Wake-Up Protocol — Behavior Layer

## Purpose
When an agent restarts, it loses all behavioral context. This protocol restores identity, rules, and current state from the vault — so the agent wakes up knowing who it is, who it works with, and how to act.

**This is the fix for "restart amnesia."**

## When to Run
- Every session start (new conversation, after restart, after context compaction)
- When the user says "wake up" or "refresh yourself"
- When the agent feels like it's lost behavioral context

## Protocol — Read IN ORDER

### Step 1: Identity Reset (MANDATORY)
```
read_file("{vault}/00-BRIEFING.md")
```
This file contains:
- Agent identity (name, role, personality)
- User info (who they are, preferences, schedule)
- Collaborators (who else the agent interacts with)
- Routing rules (which channel handles what)
- Behavioral rules (do's and don'ts)

**If this file doesn't exist, create it from the template:**
```
read_file("{kit}/core/behavior/briefing/TEMPLATE.md")
```
Then customize it for your agent and save as `{vault}/00-BRIEFING.md`.

### Step 2: Current State
```
read_file("{vault}/00-Working-Memory.md")
```
Active projects, deadlines, system status. This is what's happening RIGHT NOW.

### Step 3: Recent Context
```
search_files("*.md", path="{vault}/11-Mess Hall/", target="files", limit=3)
```
Check for today's or yesterday's handoff notes. These tell you what was happening before the restart.

### Step 4: Active Ideas (Optional)
```
read_file("{vault}/09-Green Room/ideas.md")
```
Only if you need context on what's being planned.

## After Reading
- Don't dump everything to the user — just confirm you're back online
- If there's something urgent from the handoff, mention it
- If nothing urgent, just say you're ready
- Keep it to 2-3 sentences max

## How This Integrates

### With the AAE Stack
This protocol is the **Behavior Layer** — it sits between Identity (who am I?) and Memory (what do I know?):

```
┌─────────────────────────────────────────┐
│  Layer 1: Identity (ERC-8004)           │  ← On-chain identity
├─────────────────────────────────────────┤
│  Layer 2: Safety (OWASP ASI)           │  ← What I can't do
├─────────────────────────────────────────┤
│  ★ Layer 3: Behavior (Wake-Up) ★       │  ← How I act (THIS)
├─────────────────────────────────────────┤
│  Layer 4: Memory (Echo Brain)           │  ← What I know
├─────────────────────────────────────────┤
│  Layer 5: Commerce (x402)              │  ← How I pay
├─────────────────────────────────────────┤
│  Layer 6: Credit (Scoring)             │  ← How I'm rated
├─────────────────────────────────────────┤
│  Layer 7: Voice (Personas)             │  ← How I sound
└─────────────────────────────────────────┘
```

### With Proactive Context
- **Save** during work → `proactive-context` (writes handoff notes)
- **Restore** on restart → `wake-up-protocol` (reads briefing + handoff)
- Together they form a complete context lifecycle

### With Session Resume
- **wake-up-protocol** = identity + behavior (runs FIRST)
- **session-resume** = task context (runs after)
- They're complementary, not competing

### With Memory Rules
- Wake-up protocol reads the briefing file (behavioral rules)
- Memory rules govern what gets saved to persistent memory
- Briefing = who I am. Memory = what I've learned.

## Customization

### For Your Agent
1. Copy `core/behavior/briefing/TEMPLATE.md` to your vault as `00-BRIEFING.md`
2. Fill in the fields — agent name, user info, collaborators, rules
3. The wake-up protocol reads it automatically

### For Different Deployments
The `{vault}` placeholder adapts to any vault structure:
- Gentech: `/root/vaults/gentech/`
- Custom: Set `VAULT_DIR` environment variable
- The protocol finds the briefing file relative to the vault root

## Pitfalls
- **Don't skip Step 1** — without the briefing, the agent acts generic
- **Don't skip Step 3** — handoff notes catch you up on pre-restart work
- **Don't dump vault contents** — the user doesn't need to see what you're reading
- **Don't re-read files already in system prompt** — if briefing is injected, skip Step 1
- **Briefing must be human-editable** — the user should be able to update it without asking the agent

## Verification
After running the protocol, the agent should be able to answer:
1. Who am I? (from briefing)
2. Who is my user? (from briefing)
3. Who are the collaborators? (from briefing)
4. What are we building? (from working memory)
5. What was I doing before restart? (from handoff notes)

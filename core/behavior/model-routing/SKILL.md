---
name: model-routing
description: "Cost-optimized model routing — which model for which task. Part of the AAE Behavior Layer. The model is the junior; skills are the senior review."
category: behavior
version: 1.0.0
author: GenTech Agent Kit
tags: [behavior, models, routing, cost-optimization, token-management]
---

# Model Routing — Behavior Layer

## Purpose

Not every task needs the most expensive model. This skill defines a routing strategy that sends each task to the cheapest model that can handle it — saving tokens for when they matter.

**Core philosophy:** The model is the junior developer. Skills (deploy-and-verify, pre-work-audit, the-workshop) are the senior review. A cheaper model with good process beats an expensive model with no oversight.

## Model Tiers (as of June 2026)

| Tier | Models | Cost | Use For |
|------|--------|------|---------|
| **Free** | NVIDIA: Mistral Large 3 675B, Llama 4 Maverick, Qwen3-Next 80B, Nemotron 3 Nano Omni (vision) | $0 | Research, content, documentation, light analysis, vision tasks |
| **Budget** | DeepSeek V4 ($0.20/M), MiniMax M2.7/M3 ($0.30/M), GLM-5 ($0.60/M) | $0.20–0.60/M | Spec writing, brainstorming, light coding, task decomposition |
| **Mid** | MiMo-V2.5 (OpenCode Go), Kimi K2.7 (OpenCode Go), Gemini 2.5 Flash ($0.30/M) | Included in sub | Main conversation, coordination, moderate code |
| **Code** | Kimi K2.7 Code (OpenCode Go), GLM-5.1 ($1.40/M) | $0.95–1.40/M | Deep code audits, smart contract review, architecture |
| **Premium** | Claude Sonnet/Opus, GPT-5.x, o3 | $2–30/M | Complex reasoning, multi-step planning, critical decisions |

## Routing Rules

### By Task Type

| Task | Route To | Why |
|------|----------|-----|
| Web search / research | Free (NVIDIA) or `web_search` tool | No LLM needed for search itself |
| Content writing / docs | Budget (DeepSeek, MiniMax) | Good enough for prose, save tokens |
| Spec writing / architecture | Budget or Mid | Needs reasoning but not code execution |
| Light coding / scripts | Mid (MiMo via OpenCode Go) | Included in subscription |
| Deep code audit | Code (Kimi K2.7) | Best code model in our stack |
| Smart contract review | Code (Kimi K2.7) | Security-critical, needs strong reasoning |
| Complex multi-step planning | Premium (Claude, GPT-5) | Worth the cost for critical decisions |
| Vision / image analysis | Free (Nemotron 3 Nano Omni) | Only free vision model available |
| DeFi data / on-chain queries | Free (BlockRun tools) | `blockrun_defi`, `blockrun_dex`, `blockrun_price` are free |
| Daily standup / briefings | Budget or Mid | Simple synthesis, no code needed |

### By Channel (GenTech Setup)

| Channel | Default Model | Override For |
|---------|--------------|-------------|
| HQ (coordination) | MiMo-V2.5 | Use Budget for non-urgent analysis |
| Labs (code) | MiMo-V2.5 → `/model` to Kimi K2.7 for code tasks | Always upgrade for smart contracts |
| Strategies (finance) | MiMo-V2.5 + BlockRun DeFi tools | Data tools are free; model just synthesizes |
| Entertainment (content) | MiMo-V2.5 → Budget for content drafts | Free models write decent content |

### By Agent Role

| Role | Model Strategy |
|------|---------------|
| **Orchestrator** (main agent) | Mid tier — coordinates, doesn't deep-code |
| **Research subagent** | Free tier — `delegate_task` with free model |
| **Code subagent** | Code tier — Kimi K2.7 or GLM-5.1 |
| **Content subagent** | Budget tier — DeepSeek or MiniMax |
| **Cron jobs** | Cheapest that works — research = Free, synthesis = Budget |

## How to Route in Practice

### Using BlockRun Free Models (in-session)
```
mcp_blockrun_blockrun_chat(
    message="Research X and summarize findings",
    mode="free"  # Routes to NVIDIA free models
)
```

### Using delegate_task with Free Models
```
delegate_task(
    goal="Research competitive landscape for agent security platforms",
    toolsets=["web"],
    # Subagent uses current model — for truly free routing,
    # use blockrun_chat with mode="free" inside the task
)
```

### Using /model in OpenCode Go
```
/model kimi-k2.7    # Switch to Kimi for code tasks
/model mimo-v2.5    # Switch back to MiMo for conversation
```

### Using BlockRun DeFi Tools (Always Free)
```
mcp_blockrun_blockrun_defi(path="protocols")           # $0.005
mcp_blockrun_blockrun_dex(query="SOL")                 # Free
mcp_blockrun_blockrun_price(action="price", symbol="BTC-USD")  # Free
```

## Token Budget Awareness

### OpenCode Go Limits ($10/mo subscription)
- Monitor: `opencode.ai/workspace/` → Usage tab
- Rolling: resets daily
- Weekly: resets weekly
- Monthly: resets monthly — **this is the hard cap**
- Strategy: use OpenCode Go for conversation + light code; route heavy research to free models

### BlockRun Pay-per-use (USDC wallet)
- Free tools: `blockrun_dex`, `blockrun_price`, `blockrun_search` (limited)
- Cheap tools: `blockrun_defi` ($0.001–0.005), `blockrun_chat` with free models ($0)
- Expensive tools: `blockrun_chat` with premium models ($0.001–0.18/M tokens)
- Strategy: exhaust free tools first, then use cheapest paid option

## The Junior + Senior Pattern

```
┌──────────────────────────────────────────┐
│  TASK ARRIVES                            │
├──────────────────────────────────────────┤
│  1. Classify (what tier does this need?) │
│  2. Route (send to cheapest viable)      │
│  3. Verify (skills catch mistakes)       │
│  4. Retry if needed (still cheaper       │
│     than starting with premium)          │
└──────────────────────────────────────────┘
```

**Example:** A spec writing task on a free model might take 3 retries to get right. Each retry costs $0. Total: $0 + time. Same task on Claude Sonnet: $0.15 first try. The free model + retries is cheaper, and the skills ensure quality.

**Exception:** Safety-critical tasks (smart contract audit, production deploy) should START on a strong model. Don't cheap out on code that handles money.

## Pitfalls

- **Free models have rate limits** — don't hammer NVIDIA endpoints in tight loops
- **Free models have smaller context windows** (131K vs 1M) — chunk large inputs
- **OpenCode Go monthly cap is hard** — once hit, you're on your own API keys
- **BlockRun USDC balance depletes** — set `blockrun_wallet action="budget"` to cap spending
- **Don't route everything to premium** — it's tempting but burns budget fast
- **Skills still need tokens** — every retry on a free model still uses inference, even if $0
- **Vision tasks need specific models** — only Nemotron 3 Nano Omni is free + vision-capable

## Verification

After implementing this routing:
1. Check OpenCode Go usage stays under 3% daily burn rate
2. Verify free model tasks complete successfully (check BlockRun wallet balance)
3. Confirm code tasks still use Kimi K2.7 (not degraded to cheaper models)
4. Monitor quality — if free models produce too many retries, upgrade that task tier

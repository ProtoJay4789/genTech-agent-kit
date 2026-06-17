# Single-Agent Multi-Channel Pattern

> One agent, multiple specialized channels — the cost-saving alternative to multi-agent setups.

## The Problem

Running multiple agents is expensive:
- Each agent consumes its own token budget
- Each requires separate context window and conversation history
- Orchestration overhead adds complexity
- Most solo operators or small teams can't justify the cost

## The Solution

Run ONE agent across multiple Telegram groups or Discord channels, each specialized by topic. The agent behaves differently in each channel, giving users the *experience* of multiple agents while only paying for one.

## Why This Works

### Telegram
- Groups feel like **separate rooms** — each has its own identity
- Topic-based routing is native
- You're literally "in a different place" mentally
- Bot can have different system prompts per group

### Discord
- Channels are visually separated
- Threads allow deep dives without polluting main channel
- Role-based context switching
- Server-wide bot with per-channel behavior

## Architecture

```
                    ┌─────────────────┐
                    │   ONE AGENT     │
                    │   (same brain)  │
                    └────────┬────────┘
                             │
              ┌──────────────┼──────────────┐
              │              │              │
        ┌─────┴─────┐ ┌─────┴─────┐ ┌─────┴─────┐
        │  Finance  │ │   Code    │ │  Content  │
        │  Channel  │ │  Channel  │ │  Channel  │
        └───────────┘ └───────────┘ └───────────┘
```

## Token Savings

| Setup | Tokens/Day (est.) | Cost/Month |
|-------|-------------------|------------|
| 3 separate agents | ~30K | ~$30-50 |
| 1 agent, 3 channels | ~12K | ~$12-20 |
| **Savings** | **~60%** | **~$18-30** |

**Why cheaper:** One context window, one system prompt load, one conversation history. The agent only loads topic-specific context when needed.

## Configuration Templates

### Telegram

```yaml
agent:
  name: "MyAgent"
  
groups:
  - id: "-100XXXXXXXXXX"
    name: "Finance"
    topic: "finance, defi, portfolio, yield"
    behavior: |
      You are a finance specialist. 
      Focus on market analysis, portfolio optimization, DeFi strategies.
      Be precise, data-driven, concise.
    
  - id: "-100YYYYYYYYYY"
    name: "Code"
    topic: "code, dev, technical, contracts"
    behavior: |
      You are a senior developer.
      Focus on clean code, architecture, debugging, smart contracts.
      Be technical, methodical, thorough.
    
  - id: "-100ZZZZZZZZZZ"
    name: "Content"
    topic: "content, social, marketing, writing"
    behavior: |
      You are a content strategist.
      Focus on social media, copywriting, brand voice, engagement.
      Be creative, engaging, warm.
```

### Discord

```yaml
agent:
  name: "MyAgent"
  
channels:
  - id: "finance-channel-id"
    topic: "finance, defi, portfolio"
    behavior: "Finance specialist. Market analysis, portfolio, DeFi. Precise, data-driven."
    
  - id: "dev-channel-id"
    topic: "code, dev, technical"
    behavior: "Senior developer. Clean code, architecture, debugging. Technical, methodical."
    
  - id: "content-channel-id"
    topic: "content, social, marketing"
    behavior: "Content strategist. Social, copywriting, brand. Creative, engaging."
```

## Behavior Matrix

| Channel | Focus | Response Style | Example Topics |
|---------|-------|----------------|----------------|
| Finance | Market analysis, portfolio, DeFi | Precise, data-driven, concise | "What's the ETH price?" "Check my LP position" |
| Code | Architecture, debugging, deployment | Technical, methodical, thorough | "Fix this bug" "Deploy this contract" |
| Content | Social, copywriting, brand voice | Creative, engaging, warm | "Draft a tweet" "Review this post" |
| Coordination | Status, blockers, decisions | Direct, action-oriented | "What's blocking us?" "Update the status" |

## Anti-Patterns

1. **Don't** let the agent carry context between channels — each channel is isolated
2. **Don't** use the same behavior in every channel — defeats the purpose
3. **Don't** create too many channels — 3-5 is optimal, more gets confusing
4. **Do** let the user decide which channel to use — don't auto-route unless configured

## Benefits

- **Cost savings**: 60%+ vs multi-agent setup
- **Simplicity**: One deployment, one config, one brain
- **User experience**: Feels like multiple specialists, only one to manage
- **Scalability**: Add new channels without new agent instances
- **Maintenance**: Update one agent, all channels benefit

## Use Cases

- Solo developers wanting specialized help without the cost
- Small teams where one agent handles all departments
- Hackathon teams where one agent switches roles by channel
- Personal productivity (finance, code, content in separate rooms)
- Client-facing bots where each client gets their own channel

## Implementation Notes

- Use channel metadata or topic to determine behavior
- Load topic-specific context only when needed
- Keep channel histories isolated (don't bleed context)
- Let users explicitly choose which channel to use

## Source

GenTech Labs pattern — implemented in production across Telegram groups (HQ, Labs, Strategies, Entertainment).

---

*Part of the GenTech Agent Kit — making agent architecture accessible to everyone.*

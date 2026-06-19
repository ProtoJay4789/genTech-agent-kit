# ⚡ GenTech Agent Kit

**The AAE-compatible agent standard. Identity. Execution. Audit. Baked in.**

![GenTech Agent Kit](https://protojay4789.github.io/assets/dashboard-thumbnail.png)

---

## Quick Install (Hermes Distribution)

```bash
hermes install --from github.com/ProtoJay4789/genTech-agent-kit
```

This installs **alongside your existing setup** — it does NOT overwrite your model config:

- ✅ Core skills (wake-up, context, DeFi ops, research)
- ✅ MCP connections (BlockRun, WURK, Pay)
- ✅ 3 starter cron jobs (morning digest, brain backup, skill audit)
- ✅ Vault structure template
- ✅ Config template (optional — your model setup stays as-is)

**What you keep:** Your model, provider, API keys, existing config
**What we add:** Agent skills, automation, integrations, vault structure

**Optional: Adopt our model defaults**
```bash
# Only if you want to use Xiaomi MiMo like we do
cp config.yaml ~/.hermes/config.yaml
# Then set: export XIAOMI_API_KEY="your..."
```

**Optional: Enable MCP connections**
```bash
# Only if you want BlockRun/WURK/Pay integrations
export BLOCKRUN_API_KEY="your..."
export WURK_API_KEY="your..."
```

---

## Why This Exists

Building an AI agent that works in the agent economy requires:

1. **Identity** — Who is this agent paying on behalf of?
2. **Enforcement** — Make the transaction happen
3. **Audit** — Prove it went through

Integrating these separately takes **weeks**. GenTech Agent Kit bakes them together. One import. All three pieces. Ready to ship.

> "We're the wrapper after all."

---

## Architecture

```
genTech-agent-kit/
├── distribution.yaml    # Hermes distribution manifest
├── SOUL.md              # Agent personality (customize this)
├── config.yaml          # Model/provider defaults
├── mcp.json             # MCP server connections
├── cron/                # Starter cron jobs
│   └── defaults.json
├── core/                        # Always installed
│   ├── brain/                   # Context management
│   │   └── proactive-context/   # Handoff notes, Mess Hall, memory
│   ├── behavior/                # Identity + behavioral rules
│   │   ├── wake-up-protocol/    # Brain refresh on restart
│   │   ├── briefing/            # Agent identity template
│   │   └── model-routing/       # Cost-optimized model selection
│   ├── vault/                   # Structure
│   │   └── vault-structure/     # Standard vault layout
│   └── automation/              # Cron jobs
│       ├── the-workshop/        # Daily autonomous work
│       └── context-snapshot.json
├── modules/                     # Pick and choose
│   ├── dashboard/               # Presentation layer
│   │   ├── dashboard-engine.js  # 38KB, zero deps
│   │   └── examples/
│   └── protocols/               # Integrations
├── skills/                      # Bundled skills
├── docs/                        # Documentation
└── install.sh                   # Legacy installer (still works)
```

---

## What Makes This Different

### vs. Building from Scratch
- **2-minute setup** vs. days of configuration
- **Battle-tested skills** — wake-up protocol, context management, DeFi ops
- **Pre-wired MCP** — BlockRun, WURK, Pay ready to go
- **Starter cron jobs** — morning digest, backups, audits

### vs. Other Agent Frameworks
- **AAE-compatible** — ERC-8004 identity, x402 payments, audit trails
- **Vault-first memory** — Obsidian-compatible knowledge base
- **Topic routing** — organize conversations by subject
- **Agent economy ready** — not just chat, but commerce

---

## Customization

### Your Model Setup Stays As-Is
The distribution does NOT touch your model config. Use whatever you want:
- Local models (Ollama, LM Studio, llama.cpp)
- Cloud providers (Anthropic, OpenAI, OpenRouter)
- Custom endpoints (Xiaomi, Kimi, DeepSeek)

We just add the agent layer on top.

### Change the Personality
Edit `SOUL.md` — this is your agent's identity. Fill in:
- Your name and context
- Collaborator names
- Communication preferences
- Behavioral rules

### Adopt Our Defaults (Optional)
If you want to use our model setup:
```bash
cp config.yaml ~/.hermes/config.yaml
# Set your API key: export XIAOMI_API_KEY="your..."


### Add More Skills
```bash
# From the hub
hermes skills install <skill-id>

# From a URL
hermes skills install https://example.com/SKILL.md --name my-skill
```

### Add More Cron Jobs
```bash
hermes cron create "every 6h" --prompt "Check portfolio positions" --name "Portfolio Check"
```

---

## Modules

### Core (Always Installed)
- **Wake-Up Protocol** — restores identity after restart
- **Proactive Context** — handoff notes, memory management
- **Model Routing** — cost-optimized model selection
- **The Workshop** — daily autonomous work prompt

### Dashboard Module
- **Dashboard Engine** — 38KB, zero dependencies
- **Hub Template** — project showcase
- **DeFi Dashboard** — portfolio tracking

### Protocol Module
- **x402** — micropayments
- **Circle** — USDC payments
- **WURK.fun** — microtasks
- **DexScreener** — live prices
- **DeFiLlama** — protocol data

---

## For Collaborators

### What You Get
- A working AI agent with DeFi capabilities
- Pre-configured tools and integrations
- Starter automation (cron jobs)
- Clear structure for customization

### What You Need
- A Hermes installation (`curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash`)
- API keys for your chosen model provider
- Optional: BlockRun account for x402 payments

### Getting Started
1. Install the distribution
2. Set your API keys in `.env`
3. Edit `SOUL.md` with your identity
4. Run `hermes` and start building

---

## Development

### Local Development
```bash
git clone https://github.com/ProtoJay4789/genTech-agent-kit
cd genTech-agent-kit
./install.sh --all
```

### Adding Skills
1. Create `skills/my-skill/SKILL.md` with YAML frontmatter
2. Test locally with `hermes -s my-skill`
3. Push to repo — auto-included in distribution

### Adding Cron Jobs
1. Add job definition to `cron/defaults.json`
2. Test with `hermes cron create` using the same prompt
3. Push to repo — auto-included in distribution

---

## License

MIT — use it, fork it, sell it.

---

## Credits

Built by [GenTech Labs](https://github.com/ProtoJay4789) on top of [Hermes Agent](https://github.com/NousResearch/hermes-agent) by [Nous Research](https://nousresearch.com).

> "Tough love for the agent economy."

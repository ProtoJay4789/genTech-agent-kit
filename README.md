# ⚡ GenTech Agent Kit

**The AAE-compatible agent standard. Identity. Execution. Audit. Baked in.**

![GenTech Agent Kit](https://protojay4789.github.io/assets/dashboard-thumbnail.png)

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
│
├── core/                        # Always installed
│   ├── brain/                   # Context management
│   │   └── proactive-context/   # Handoff notes, Mess Hall, memory
│   ├── behavior/                # Identity + behavioral rules
│   │   ├── wake-up-protocol/    # Brain refresh on restart
│   │   └── briefing/            # Agent identity template
│   ├── vault/                   # Structure
│   │   ├── Green Room/          # Ideas
│   │   ├── Mess Hall/           # Thinking space
│   │   └── Archive/             # History
│   └── automation/              # Cron jobs
│       └── context-snapshot.json
│
├── modules/                     # Pick and choose
│   ├── dashboard/               # Presentation layer
│   │   ├── dashboard-engine.js  # 38KB, zero deps
│   │   └── examples/
│   ├── defi/                    # LP tracking, yield scouting
│   ├── payments/                # x402, Circle
│   ├── identity/                # ERC-8004, wallet binding
│   ├── audit/                   # Transaction logging
│   └── protocols/               # Travala, WURK, COTI
│
├── chains/                      # Chain-specific
│   ├── avalanche/
│   ├── ethereum/
│   ├── base/
│   └── solana/
│
└── docs/
    ├── memory-rules.md
    ├── KNOWN_ISSUES.md      # 🔧 Troubleshooting — check here first when stuck
    ├── DASHBOARD_TEMPLATES.md # 📊 Built-in patterns for common dashboard types
    ├── DEFI_LP_MONITORING_PATTERN.md # 💰 Two-tier alerts + fee efficiency tracking
    └── integrations.md
```

---

## Quick Start

### Option 1: Full Stack (Recommended)
```bash
git clone https://github.com/ProtoJay4789/genTech-agent-kit.git
cd genTech-agent-kit
./install.sh --all
```

### Option 2: Pick and Choose
```bash
# Core only (brain + vault + automation)
./install.sh --core

# Add DeFi module
./install.sh --module defi

# Add Avalanche chain
./install.sh --chain avalanche
```

### Option 3: Manual
```bash
# Copy core to your Hermes profile
cp -r core/brain/* ~/.hermes/profiles/your-profile/skills/
cp -r core/vault/* ~/your-vault/

# Copy modules you want
cp -r modules/dashboard/* ~/your-dashboard/
cp -r modules/defi/* ~/your-defi/
```

---

## Modules

### 🧠 Brain + Behavior Layer (Core)
**Always installed.** The foundation of context management and agent identity.

**⚠️ IMPORTANT: The brain and behavior layer are the most critical components.** Without them, your agent forgets everything between sessions AND forgets how to behave. The vault is your agent's second brain — ideas, decisions, handoffs, context snapshots.

**The Behavior Layer solves "restart amnesia":**
- **Wake-Up Protocol** — restores identity, rules, and context on every restart
- **Briefing File** — human-editable identity card (`00-BRIEFING.md`)
- Pairs with proactive-context for a complete save/restore lifecycle

**We recommend [Obsidian](https://obsidian.md/) for the vault.** It's free, local-first, and works perfectly with Hermes.

**Install Obsidian CLI (ob) for constant sync:**
```bash
npm install -g obsidian-cli
ob sync  # Syncs vault to Obsidian desktop/mobile
```

**Set up automatic sync:**
```bash
# Add to your cron jobs
0 */6 * * * cd ~/vaults/your-vault && ob sync
```

This keeps your agent's brain synced across devices — desktop, mobile, anywhere you need it.

**What's in the brain:**
- **Green Room** (`09-Green Room/`) — Ideas and brainstorming
- **Mess Hall** (`11-Mess Hall/`) — Thinking space, scratchpad, handoff notes
- **Archive** (`Archive/`) — Historical content
- **Daily** (`08-Daily/`) — Daily summaries

**What's in the behavior layer:**
- **Wake-Up Protocol** — Run on every restart. Reads briefing, working memory, handoff notes.
- **Briefing File** (`00-BRIEFING.md`) — Who the agent is, who the user is, how to act.

**Why it matters:**
- Handoff notes preserve context across sessions
- Mess Hall captures ideas mid-conversation
- Context snapshots auto-save every 6 hours
- Your agent never loses important information

**First time setup:**
```bash
# Create your vault
mkdir -p ~/vaults/your-vault/{09-Green\ Room,11-Mess\ Hall,Archive,08-Daily}

# Install Obsidian CLI
npm install -g obsidian-cli

# Initialize sync
cd ~/vaults/your-vault && ob init
```

### 📊 Dashboard Module
**Presentation layer.** 38KB, zero dependencies.

- 8 section types (stats, table, progress, checklist, grid, cards, timeline, custom)
- 7 field formats (money, percent, badge, date, number, tags, text)
- 5 themes (Default, Avalanche, Ethereum, Solana, Fire)
- Auto-refresh with live data
- Mobile-first responsive

### 💰 DeFi Module
**Portfolio intelligence.** Track positions, scout yields, climb milestones.

- LP position tracking
- Yield scout fleet
- Fee milestone progression
- Live price feeds (DexScreener)
- Range status monitoring

### 🔐 Identity Module
**Who is this agent?** Wallet binding, user verification.

- ERC-8004 trustless agents
- Wallet binding (EVM, Solana, Base)
- Persona isolation
- Multi-chain identity resolution

### ⚡ Enforcement Module
**Make it happen.** Payments, execution, automation.

- x402 micropayments (Circle)
- Auto-execution engine
- Multi-sig support
- Protocol integration

### 📋 Audit Module
**Prove it.** Transaction logging, compliance.

- Transaction logging with receipts
- Proof of execution on-chain
- Dashboard visualization
- Automated compliance reporting

### 🔗 Protocols Module
**Connect to everything.** Pre-built integrations.

- Travala (travel booking)
- WURK.fun (microtasks)
- COTI (privacy transactions)
- More added regularly

---

## Chains

| Chain | Status | Protocols |
|-------|--------|-----------|
| **Avalanche** | ✅ Live | LFJ, Pangolin, Benqi |
| **Ethereum** | ✅ Live | Uniswap, Aave, Lido |
| **Base** | ✅ Live | Uniswap, Aerodrome |
| **Solana** | 🔄 Coming | Raydium, Orca, Jito |

**Each chain gets the GenTech spin:**
- Native protocol integrations
- Optimized gas strategies
- Chain-specific yield opportunities
- Local compliance handling

---

## The Three Pillars

### 🔐 Identity
> "Agents need to know who they're paying on behalf of."

- Wallet binding (EVM, Solana, Base)
- User verification (ERC-8004 trustless agents)
- Persona isolation (per-user dashboards and data)
- Multi-chain identity resolution

### ⚡ Enforcement
> "Agents need to be enforced to make the transaction."

- x402 payment rails (Circle, USDC)
- Auto-execution with configurable thresholds
- Multi-sig for high-value transactions
- Protocol-native integration (Travala, WURK, LFJ)

### 📋 Audit
> "Agents need to be audited to make sure the transaction went through."

- Transaction logging with receipts
- Proof of execution on-chain
- Dashboard visualization of all activity
- Automated compliance reporting

---

## Contributing

### 🐛 Found a Bug?
Check **[KNOWN_ISSUES.md](docs/KNOWN_ISSUES.md)** first — we track every bug, gotcha, and workaround we find.

If it's not listed:
1. Open an issue with symptoms + steps to reproduce
2. We'll add it to KNOWN_ISSUES.md with a fix
3. Your report helps everyone who hits the same wall

### For Developers
1. Fork the repo
2. Add your module or chain integration
3. Submit a PR with tests
4. Get merged, ship it

### For Protocol Teams
1. Open an issue with your protocol details
2. We'll add native integration
3. Your protocol gets GenTech Agent support

### For Community
1. Share your use cases
2. Request new chains/protocols
3. Report bugs, suggest features

---

## Roadmap

### Q3 2026
- [ ] Solana full integration
- [ ] BNB Chain support
- [ ] Multi-agent coordination
- [ ] Advanced audit dashboard

### Q4 2026
- [ ] Mobile agent app
- [ ] Voice command interface
- [ ] Cross-chain atomic swaps
- [ ] Institutional compliance module

### 2027
- [ ] AI agent marketplace
- [ ] Agent-to-agent payments
- [ ] Regulatory framework integration
- [ ] Enterprise deployment tools

---

## License

MIT — use it for anything. Built by GenTech Labs for the agent economy.

---

**Built with ❤️ by [GenTech Labs](https://github.com/ProtoJay4789)** — Tough love for the agent economy.

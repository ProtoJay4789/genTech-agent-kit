# GenTech Hub — Sync Protocol

**The three-layer sync workflow. Vault ↔ Hub ↔ Agent Kit.**

## Overview

GenTech operates on three layers that must stay in sync:

| Layer | Location | Purpose |
|-------|----------|---------|
| **Vault** | `/root/vaults/gentech/` | Source of truth for thinking, decisions, builds |
| **Hub** | `github.com/ProtoJay4789/gentech-hub` | Product artifacts (HTML, JSON, engine) |
| **Agent Kit** | `github.com/ProtoJay4789/genTech-agent-kit` | Distributable framework |

## Sync Rule

**Bidirectional — freshest source wins.**

Before ANY data update:

1. **Check all three** — vault, Hub repo, Agent Kit
2. **Find the freshest version** — compare timestamps, lastUpdated fields, git commits
3. **Propagate to the other two** — whichever has the latest becomes truth
4. **Verify all three match** — spot-check key fields

### Quick Check Commands
```bash
# Vault last modified
find /root/vaults/gentech -name "*.md" -mtime -7 | head -10

# Hub last commit
cd /root/projects/gentech-hub && git log -1 --format="%ai %s"

# Agent Kit last commit
cd /root/projects/genTech-agent-kit && git log -1 --format="%ai %s"
```

## Hub Structure

```
gentech-hub/
├── Gaming/                 # Gaming dashboards
│   ├── poe2-dashboard.html
│   └── poe2-monk.json
├── Travels/                # Travel dashboards
├── Cookbook/                # Cookbook dashboards
├── Profiles/               # Profile hub pages
├── Collaborators/          # Collaborator spaces
│   ├── vanito/
│   │   ├── index.html
│   │   └── data/
│   └── christel/
│       ├── index.html
│       └── data/
├── Dashboards/             # Dashboard registry
├── assets/                 # Shared CSS/JS
└── docs/                   # Documentation
```

## Collaborator Spaces

Each collaborator gets their own folder under `Collaborators/`:

```
Collaborators/
├── vanito/
│   ├── index.html          ← Vanito's hub
│   ├── poe2-dashboard.html ← His gaming dashboard
│   └── data/
│       └── poe2-warrior.json
├── christel/
│   ├── index.html          ← Christel's hub
│   └── cookbook.html        ← Her cookbook dashboard
└── [future collaborators]
```

**The vision:** Collaborators get their own profile, their own dashboards, agent access — the AAE experience. This is how we demo the product. They see their data animated, talk to their agent, manage their layers.

## Hub Trigger Phrase

When the user says **"add this to the Hub"** or **"put this in the Hub"**:
1. Detect which Hub layer (Gaming, Travel, Journal, Finance, Cookbook, etc.)
2. Update the corresponding JSON + dashboard
3. Verify the Hub repo has the latest version
4. Sync to Agent Kit if needed

## Nightly Audit (Cron Job)

A nightly cron job at 8 PM checks:
- Every HTML dashboard page for freshness
- Every JSON data file for lastUpdated
- Profile and collaborator folder status
- Naming consistency (no stale "gentech-dashboard" or "gentech-pals" references)
- Cross-layer sync (vault vs Hub vs Agent Kit)

**Report format:**
- ✅ Healthy — things that are current and in sync
- ⚠️ Stale — files older than 14 days that should be current
- 🔴 Drift — naming mismatches, missing files, data mismatches

## Naming History

| Name | Status | Notes |
|------|--------|-------|
| GenTech Pals | ❌ Retired | Gaming companion product |
| GenTech Dashboard | ❌ Retired | Data visualization platform |
| **GenTech Hub** | ✅ Current | The product — AAE storefront |

Always check for stale references: `grep -r "gentech-dashboard\|gentech-pals" --include="*.md"`

## Anti-Patterns

- ❌ Updating one layer without checking the other two
- ❌ Saying "received" on API keys without saving + verifying
- ❌ Trusting the env var `GITHUB_TOKEN` without checking gh config
- ❌ Letting vault and Hub drift without nightly audit catching it

## The Flow

```
User says something → Agent checks Vault → Agent checks Hub
    → Agent finds freshest version → Updates all three
    → Verifies they match → Reports if drift detected
```

**Rule:** Vault ↔ Hub ↔ Agent Kit. Always sync. Never drift.

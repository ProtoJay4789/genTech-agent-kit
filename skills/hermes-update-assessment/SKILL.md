---
name: hermes-update-assessment
description: "When Hermes updates, assess impact on GenTech and update Agent Kit if needed. Run after every Hermes update."
category: gentech-ops
version: 1.0.0
tags: [hermes, updates, agent-kit, assessment, maintenance]
---

# Hermes Update Assessment — GenTech Impact

## Trigger
- After every Hermes update (`hermes update`)
- When Nous Research announces a new release on X
- Weekly cron check for new versions

## Workflow

### Step 1: Check Current vs New Version
```bash
hermes --version
cd /usr/local/lib/hermes-agent && git fetch origin && git log HEAD..origin/main --oneline | head -20
```

### Step 2: Identify Relevant Changes
Scan the changelog/release notes for:
- **Distribution format changes** — affects `distribution.yaml`, `SOUL.md`, install flow
- **Skill system changes** — affects our skill format, SKILL.md frontmatter
- **Cron/scheduler changes** — affects our 27+ cron jobs
- **MCP changes** — affects `mcp.json` connections
- **Memory tool changes** — affects our vault-first approach
- **Provider/model changes** — affects `config.yaml`
- **Security changes** — affects API key handling

### Step 3: GenTech Impact Matrix
For each relevant change, classify:

| Impact | Action |
|--------|--------|
| **None** | No changes needed — log and move on |
| **Minor** | Update Agent Kit docs/skills to match new patterns |
| **Major** | Update Agent Kit + test + push new version |
| **Breaking** | Stop — assess full impact before proceeding |

### Step 4: Update Agent Kit If Needed
If changes affect the distribution:
1. Update `distribution.yaml` — bump version
2. Update `config.yaml` — new options/defaults
3. Update `mcp.json` — new server patterns
4. Update skills in `skills/` — new SKILL.md format
5. Update `README.md` — document changes
6. Commit + push
7. Tag release if breaking changes

### Step 5: Report
Produce a concise impact report:

```
🔄 Hermes Update Assessment — v[NEW]

## Version Change
- Was: v[OLD]
- Now: v[NEW]
- Commits: [N]

## GenTech Impact
- [ ] No changes needed — [why]
- [ ] Agent Kit updated — [what changed]
- [ ] Breaking changes — [what broke and how we fixed it]

## Action Items
- [List any follow-ups needed]
```

## Pitfalls
- Don't update Hermes in production without testing first
- Some changes are cosmetic (UI/themes) — skip those
- Provider changes may affect cron job model pinning
- Distribution format changes need careful testing before pushing

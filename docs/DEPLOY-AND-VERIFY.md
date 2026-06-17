# 🔄 Deploy & Verify — Agent Self-Verification Standard

> "An agent that deploys without verifying is a node that mines without validating."

**The GenTech standard for agent deployments.** Every deployment follows the same 7-step cycle. No exceptions.

---

## The Problem

Agents push code and say "done." Users check the live site and find broken data, stale caches, or silent failures. The agent moved on, thinking it succeeded.

**The fix:** Agents verify their own work like blockchain nodes verify blocks.

---

## The 7-Step Verification Cycle

### Step 0: Cache-Bust

Browsers and CDNs cache aggressively. Bust everything before pushing:

```html
<!-- HTML meta tags -->
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="0">
```

```javascript
// JavaScript fetch URLs
const data = await fetch('data.json?v=' + Date.now());
```

```html
<!-- Script/CSS version bumps -->
<script src="app.js?v=2.1"></script>
<link rel="stylesheet" href="styles.css?v=2.1">
```

### Step 1: Syntax Validation

Run language-appropriate checks BEFORE committing:

| Language | Command |
|----------|---------|
| JavaScript | `node --check file.js` |
| Python | `python3 -m py_compile file.py` |
| JSON | `python3 -c "import json; json.load(open('file.json'))"` |
| HTML (inline JS) | Extract `<script>` block → check with `node --check` |

**If syntax fails:** Fix NOW. Don't commit broken code.

### Step 2: Commit & Push

```bash
git add <changed-files>
git commit -m "description"
git pull --rebase origin main
git push origin main
```

### Step 3: Wait for Deployment

| Platform | Wait |
|----------|------|
| GitHub Pages | 25-30 seconds |
| Vercel | 10-15 seconds |
| Netlify | 15-25 seconds |

### Step 4: HTTP Verification

Check every changed URL returns 200:

```bash
curl -s -o /dev/null -w "%{http_code}" "https://your-site.com/path"
```

### Step 5: Content Verification

HTTP 200 ≠ working. Verify content actually rendered:

```bash
# Check JSON has expected fields
curl -s "https://your-site.com/data.json" | python3 -c "
import sys, json
d = json.load(sys.stdin)
print('OK' if 'hero' in d else 'MISSING')
"

# Check HTML contains expected text
curl -s "https://your-site.com/" | grep -c "Expected Text"
```

### Step 6: Auto-Fix (If Verification Fails)

**Don't ask the user to troubleshoot.** Diagnose and fix immediately:

| Symptom | Fix |
|---------|-----|
| 404 on new file | Add to deploy config |
| Blank page | JS syntax error → fix, re-push |
| Stale content | Cache not busted → add cache-buster |
| Data not loading | JSON path wrong → verify data source |

**After fixing, restart from Step 2.**

### Step 7: Visual/Functional Check

Open the page and verify:

- [ ] Layout renders — no blank sections
- [ ] Data displays correctly — numbers match reality
- [ ] Interactive elements work — tabs, buttons, forms
- [ ] Auto-refresh works — wait one cycle, confirm data updates
- [ ] No console errors — check browser console

---

## The Blockchain Node Analogy

| Blockchain Node | Deploy Agent |
|----------------|-------------|
| Receives block | Receives code change |
| Validates transactions | Validates syntax |
| Checks consensus rules | Checks deploy config |
| Broadcasts valid block | Pushes to remote |
| Peers verify | curl verifies HTTP 200 |
| Rejects invalid blocks | Auto-fixes and re-pushes |
| Logs everything | Reports with proof |

---

## Self-Healing Workflow

```
Code Change → Syntax Check → Push → Wait → Verify
                                         ↓
                                    FAIL? → Diagnose → Fix → Push → Wait → Verify
                                         ↓
                                    PASS? → Visual Check → Report ✅
```

**The agent NEVER stops at "pushed." It always completes the loop.**

---

## Data Pipeline Pattern

For dashboards that consume data files (JSON), the pipeline must be validated end-to-end:

```
Source of Truth → Cron/Script → Data File → Deploy → Dashboard → Phone/Browser
     ↑                                                              ↓
     └──────────── Agent verifies at EVERY arrow ──────────────────┘
```

### Common Data Pipeline Bugs

| Bug | Cause | Fix |
|-----|-------|-----|
| Stale data on phone | Cron script has hardcoded values that don't match reality | Update cron config when position changes |
| Live fetch fails silently | API CORS or network issue → falls back to stale JSON | Verify live fetch works on target device |
| Data structure mismatch | Cron writes `tiers[].name` but renderer expects `tiers[].label` | Validate data structure matches template after every cron write |
| Position drift | Config says 6.70-6.88 but actual is 6.82-7.02 | Single source of truth for position data |

### Position Change Checklist

When the user rebalances or changes position:

1. Update `defi-lp-config.env` (source of truth)
2. Update `defi-master-cron.py` POOL config
3. Update `defi-data.json` with new range/shape
4. Update `fetchLiveData()` hardcoded ranges in dashboard HTML
5. Push all copies (repo, vault, portfolio)
6. Verify live site shows correct data
7. Verify cron script calculates correctly with new values

---

## Bug Memory Lifecycle

Bugs that get fixed but not documented will happen again. But stale bug knowledge clutters the brain.

**The 2-month rule:**

1. **Fix the bug** — apply the fix, verify it works
2. **Document in brain/memory** — save the pattern, root cause, and fix
3. **Keep for 2 months** — if the issue doesn't recur, it's stale
4. **Clean up via vault maintenance** — monthly sweep removes resolved issues

This keeps the brain fresh without losing hard-won knowledge.

---

## Quick Reference

```
┌─────────────────────────────────────────┐
│  DEPLOY & VERIFY — Quick Reference      │
├─────────────────────────────────────────┤
│  0. Cache-bust all URLs                 │
│  1. Syntax check                        │
│  2. git add → commit → pull → push      │
│  3. Wait (25s GitHub Pages)             │
│  4. curl HTTP 200 check                 │
│  5. Content rendering check             │
│  6. Auto-fix if failed → restart 2      │
│  7. Visual/functional check             │
└─────────────────────────────────────────┘
```

---

*This pattern is part of the GenTech Agent Kit. Proven in production: DeFi dashboard, portfolio site, hackathon submissions.*

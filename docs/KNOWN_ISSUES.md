# 🔧 Known Issues & Troubleshooting

> When you hit a wall, check here first. We track every bug, gotcha, and workaround we find — so you don't have to rediscover them.

**Last updated:** 2026-06-14  
**Maintained by:** Gentech (GenTech Labs)

---

## 🚨 Critical Issues

### 1. GitHub Pages 404 After File Move
**Symptom:** Dashboard loads locally but returns 404 on GitHub Pages.  
**Cause:** Files moved to `Archive/` during cleanup but hub links still point to old path.  
**Fix:** Ensure `/DeFi/`, `/Gaming/`, etc. folders exist with the HTML files. GitHub Pages only serves from the repo root structure.  
**Status:** ✅ Fixed (2026-06-14)  
**Watch for:** Any time you reorganize folders, check that all hub links still resolve.

### 2. GitHub Pages Jekyll Build Conflicts
**Symptom:** Push succeeds but Pages deployment fails or serves wrong content.  
**Cause:** GitHub auto-detects Jekyll repos (presence of `_config.yml` or `Gemfile`). Jekyll ignores `node_modules/` and `_site/` but can interfere with custom workflows.  
**Fix:** Add `.nojekyll` file to repo root. Use workflow-based deployment, not legacy Jekyll.  
**Status:** ✅ Fixed (2026-06-13)  
**Watch for:** New repos — always add `.nojekyll` if using GitHub Pages with custom HTML.

### 3. Gateway Service PID Loop
**Symptom:** `hermes-gateway.service` keeps restarting, eating 195MB+ logs.  
**Cause:** Orphaned systemd service from previous install.  
**Fix:** `sudo systemctl stop hermes-gateway.service && sudo systemctl disable hermes-gateway.service && sudo rm /etc/systemd/system/hermes-gateway.service`  
**Status:** ✅ Fixed (2026-06-14)  
**Watch for:** After Hermes updates — check for stale services.

---

## 🖥️ Dashboard Issues

### 4. Dashboard Engine Not Rendering
**Symptom:** Page loads but shows blank or raw JSON.  
**Cause:** `dashboard-engine.js` not loaded, or JSON data file path wrong.  
**Fix:** 
- Ensure `<script src="dashboard-engine.js"></script>` is in `<head>`
- Check browser console for 404 on data file
- Data files must be in same directory or correct relative path  
**Status:** ✅ Known  
**Watch for:** When copying dashboards to new locations — update all script/src paths.

### 5. DexScreener Feed Not Loading
**Symptom:** Scout feed shows "Loading..." forever or empty.  
**Cause:** DexScreener API rate limiting, or CORS blocking.  
**Fix:** 
- DexScreener public API has rate limits (~30 req/min)
- If blocked, add `?interval=1h` to reduce frequency
- Cache responses locally with 60s TTL  
**Status:** ✅ Known  
**Watch for:** Multiple dashboard tabs open simultaneously — each polls independently.

### 6. Mobile Layout Breaking
**Symptom:** Dashboard looks fine on desktop but elements overlap or overflow on mobile.  
**Cause:** Fixed pixel widths, missing responsive breakpoints.  
**Fix:** 
- Use `max-width: 100%` on all containers
- Add `@media (max-width: 768px)` breakpoints
- Test with Chrome DevTools device mode  
**Status:** ✅ Known  
**Watch for:** Any new dashboard section — always add responsive CSS.

### 7. Dark Mode Colors Not Applying
**Symptom:** Dashboard shows light theme even when dark mode is set.  
**Cause:** CSS variables not defined in `:root`, or hardcoded colors overriding vars.  
**Fix:** 
- Ensure all colors use `var(--color-name)` syntax
- Define both light and dark theme variables
- Use `@media (prefers-color-scheme: dark)` for auto-switching  
**Status:** ✅ Known  
**Watch for:** New components — always use CSS variables, never hardcoded hex.

---

## ⛓️ Blockchain & DeFi Issues

### 8. AVAX Price Not Updating
**Symptom:** LP position shows stale USD value.  
**Cause:** DexScreener API returning cached data, or wrong trading pair address.  
**Fix:** 
- Verify pair address on DexScreener: `https://dexscreener.com/avalanche/{pair_address}`
- Check if pool is still active (TVL > 0)
- Force refresh with `?interval=5m` parameter  
**Status:** ✅ Known  
**Watch for:** After pool migrations — pair addresses change.

### 9. Base Sepolia Faucet Empty
**Symptom:** Can't get testnet ETH for deployment.  
**Cause:** Faucets run dry during hackathons.  
**Fix:** 
- Try multiple faucets: Chainlink, Alchemy, QuickNode
- Join Discord channels for faucet requests
- Use `--network base-sepolia` with Hardhat for local testing first  
**Status:** 🟡 Active  
**Watch for:** Hackathon deadlines — faucets get drained fast.

### 10. x402 Payment Failing
**Symptom:** 402 response but payment not processing.  
**Cause:** Wallet not configured, or wrong network.  
**Fix:** 
- Ensure `PAY_PRIVATE_KEY` is set in env
- Check you're on correct network (mainnet vs testnet)
- Verify USDC balance > payment amount + gas  
**Status:** 🟡 Active  
**Watch for:** Network switches — always verify chain ID matches.

---

## 🔐 Identity & Security Issues

### 11. ERC-8004 Binding Failing
**Symptom:** Wallet binding transaction reverts.  
**Cause:** Wrong contract address, or chain not supported.  
**Fix:** 
- Verify contract address on Etherscan/Arbiscan
- Ensure you're on a supported chain (Ethereum, Arbitrum, Base)
- Check gas limit — binding may need 100k+ gas  
**Status:** 🟡 Active  
**Watch for:** New chain deployments — addresses differ per network.

### 12. Persona Isolation Leaking
**Symptom:** Data from one persona appearing in another.  
**Cause:** localStorage not properly namespaced.  
**Fix:** 
- Use `localStorage.setItem('gentech-{persona}-{key}', value)` pattern
- Clear stale data with `localStorage.removeItem()` on persona switch  
**Status:** ✅ Known  
**Watch for:** Dashboard tabs sharing same origin — isolate by persona prefix.

---

## 🛠️ Development & Build Issues

### 13. Foundry Build Failing
**Symptom:** `forge build` throws compilation errors.  
**Cause:** Solidity version mismatch, or missing imports.  
**Fix:** 
- Check `foundry.toml` for correct `solc_version`
- Run `forge install` to fetch dependencies
- Verify import paths match `lib/` structure  
**Status:** ✅ Known  
**Watch for:** After `forge update` — dependencies may break.

### 14. Test Coverage Gaps
**Symptom:** Tests pass but contract behaves unexpectedly in production.  
**Cause:** Missing edge case tests (zero amounts, overflow, reentrancy).  
**Fix:** 
- Add tests for: zero values, max uint, reentrancy, access control
- Use `forge test -vvv` for detailed output
- Run `forge coverage` to see gaps  
**Status:** ✅ Known  
**Watch for:** New features — always add tests before submit.

### 15. Import Path Resolution
**Symptom:** `import` statements fail in Solidity.  
**Cause:** Remappings not configured, or `lib/` structure changed.  
**Fix:** 
- Add to `foundry.toml`: `remappings = ['@openzeppelin/=lib/openzeppelin-contracts/']`
- Run `forge remappings` to verify  
**Status:** ✅ Known  
**Watch for:** After cloning new repos — always run `forge install` first.

---

## 📱 Mobile & Browser Issues

### 16. iOS Safari WebGL Issues
**Symptom:** Canvas-based dashboards render blank on iOS Safari.  
**Cause:** WebGL context loss, or memory limits on older devices.  
**Fix:** 
- Add `preserveDrawingBuffer: true` to WebGL context
- Reduce canvas resolution on mobile (detect via `navigator.userAgent`)
- Fallback to CSS animations if WebGL fails  
**Status:** 🟡 Active  
**Watch for:** Any canvas-heavy dashboard — test on iOS Safari.

### 17. Telegram Web App Scroll Issues
**Symptom:** Scroll inside Telegram Web App gets stuck or bounces.  
**Cause:** Telegram's WebView capturing touch events.  
**Fix:** 
- Add `overscroll-behavior: none` to body
- Use `-webkit-overflow-scrolling: touch` for smooth scroll
- Test in Telegram's built-in browser, not external  
**Status:** ✅ Known  
**Watch for:** Any page served through Telegram bot links.

---

## 🔄 Workflow Gotchas

### 18. Vault Sync Conflicts
**Symptom:** `ob sync` shows conflicts or duplicate entries.  
**Cause:** Multiple devices editing same file, or Obsidian desktop not closed before sync.  
**Fix:** 
- Always close Obsidian desktop before running `ob sync`
- Check `git status` for conflicts before syncing
- Resolve conflicts manually, then re-run sync  
**Status:** ✅ Known  
**Watch for:** Mobile + desktop editing simultaneously.

### 19. Memory Bar Not Showing
**Symptom:** Context memory indicator doesn't appear.  
**Cause:** Memory usage below 80% threshold (by design).  
**Fix:** This is expected behavior. Memory bar only shows at 80–100% capacity to avoid UI noise.  
**Status:** ✅ By Design  
**Watch for:** Users asking "where's the memory bar?" — explain the threshold.

### 20. Cron Job Not Delivering
**Symptom:** Scheduled task runs but message doesn't appear in Telegram.  
**Cause:** Chat ID wrong, or delivery target misconfigured.  
**Fix:**
- Verify chat ID: `send_message(action='list')` to see targets
- Check cron job config: `cronjob(action='list')`
- Ensure `deliver` field matches target format: `"telegram:{chat_id}"`  
**Status:** ✅ Known  
**Watch for:** After adding new Telegram groups — IDs change.

### 21. Dashboard Shows Stale Data After Position Change
**Symptom:** Phone dashboard shows old price/range/efficiency even though position changed.  
**Cause:** Multiple files have hardcoded position values that don't get updated together. The cron script, config file, data JSON, and dashboard HTML all need synchronized updates.  
**Fix:** Follow the Position Change Checklist in `docs/DEPLOY-AND-VERIFY.md`. All 7 files must be updated:
1. `defi-lp-config.env` (source of truth)
2. `defi-master-cron.py` POOL config
3. `defi-data.json` with new range/shape
4. Dashboard HTML `fetchLiveData()` hardcoded ranges
5. Push all copies (repo, vault, portfolio)
6. Verify live site shows correct data
7. Verify cron script calculates correctly  
**Status:** ✅ Fixed (2026-06-16)  
**Watch for:** Every time Jordan rebalances or changes LP position.

---

## 🐛 Report New Issues

Found something not listed here? **Report it immediately:**

1. Describe the symptom (what you see)
2. Describe the cause (if you know it)
3. Describe the fix (if you found one)
4. Add it to this doc with status: 🟡 Active

**We ship fixes, not just reports.** Every issue gets tracked until resolved.

---

*This document is part of the GenTech Agent Kit. Keep it updated as you build.*

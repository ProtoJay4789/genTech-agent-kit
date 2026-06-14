# 💰 DeFi LP Monitoring Pattern

> Cron job + dashboard combo for monitoring LP positions, fee efficiency, and rebalance triggers.

**Last updated:** 2026-06-14

---

## 🎯 The Pattern

```
Cron Job (every 10 min) → Check Position → Alert if needed
        ↓
Dashboard (live view) → Verify → Rebalance on Trader Joe
```

**Why both?**
- **Cron job** = Mobile notifications (alerts you)
- **Dashboard** = Visual verification (shows you the data)
- **Together** = Full loop: Alert → Verify → Act

---

## 📊 Fee Efficiency Formula

Fee efficiency measures how much of your theoretical max fees you're actually earning.

```
Fee Efficiency = (Actual Fees / Max Possible Fees) × 100%
```

### For Curve-Shaped Liquidity (Concentrated LP):

```
Fee Efficiency = (Volume in Range / Total Volume) × 100%
```

### When to Rebalance:

| Efficiency | Status | Action |
|-----------|--------|--------|
| **> 80%** | 🟢 Excellent | Hold — earning max fees |
| **60-80%** | 🟡 Good | Monitor — approaching threshold |
| **50-60%** | 🟠 Warning | Rebalance soon — losing potential |
| **< 50%** | 🔴 Critical | Rebalance now — earning half of max |

### The Math:

```
Position: $1000 in AVAX/USDC on Trader Joe
Range: $5.50 - $6.50
Current Price: $6.20

Volume in Range: $50,000
Total Volume: $80,000

Fee Efficiency = ($50,000 / $80,000) × 100% = 62.5%

Status: 🟡 Good — monitor, rebalance if drops below 50%
```

---

## 🔔 Cron Job Pattern

### Tier 1: Initial Alert (every 10 min)

```python
# Check if price is near range boundary
if price < range_low * 1.05 or price > range_high * 0.95:
    send_alert("⚠️ Price near range boundary. Current: ${price}")
```

### Tier 2: Confirm Breakout (wait 5 min)

```python
# After initial alert, wait 5 min and check again
time.sleep(300)  # 5 minutes

if price < range_low or price > range_high:
    send_alert("🔴 Breakout confirmed! Price outside range. Rebalance now.")
else:
    send_alert("🟢 False alarm — price back in range.")
```

### Tier 3: Fee Efficiency Check

```python
# Calculate fee efficiency
fee_efficiency = (volume_in_range / total_volume) * 100

if fee_efficiency < 50:
    send_alert(f"📉 Fee efficiency at {fee_efficiency}%. Rebalance recommended.")
```

---

## 📱 Smart Routing

| Event | Channel | Message |
|-------|---------|---------|
| Price near boundary | Strategies | ⚠️ "Price near range boundary" |
| Breakout confirmed | Strategies | 🔴 "Breakout confirmed — rebalance now" |
| Fee efficiency < 50% | Strategies | 📉 "Fee efficiency low — rebalance recommended" |
| Position healthy | Local only | ✅ Log only, no alert |

---

## 🖥️ Dashboard Integration

The DeFi dashboard shows:
- **LP Curve** — Visual range with current price
- **Fee Efficiency** — Real-time percentage
- **Scout Feed** — Alert history
- **Rebalance Button** — Direct link to Trader Joe

### Dashboard Auto-Refresh Pattern:

```javascript
// Refresh every 60 seconds
setInterval(async () => {
    const data = await fetch('defi-data.json?' + Date.now());
    dashboard.update(await data.json());
}, 60000);

// Refresh on tab focus
document.addEventListener('visibilitychange', () => {
    if (document.visibilityState === 'visible') refreshData();
});
```

---

## 🔧 Implementation Checklist

- [ ] Cron job: Check every 10 min
- [ ] Cron job: Tier 1 alert (price near boundary)
- [ ] Cron job: Tier 2 confirm (wait 5 min, check again)
- [ ] Cron job: Tier 3 fee efficiency (< 50%)
- [ ] Dashboard: LP curve visualization
- [ ] Dashboard: Fee efficiency display
- [ ] Dashboard: Auto-refresh (60s)
- [ ] Dashboard: Direct link to Trader Joe
- [ ] Smart routing: Alerts → Strategies group

---

*This pattern is part of the GenTech Agent Kit. Use it for any LP monitoring setup.*

# 📊 DeFi LP Monitoring Pattern

> The standard pattern for monitoring concentrated liquidity positions with tiered alerts and fee efficiency tracking.

**Last updated:** 2026-06-14

---

## 🎯 The Formula

### Two-Tier Alert System

**Tier 1 — Early Warning (every 10 minutes)**
```
IF price moves outside optimal range:
  → Send alert: "Price approaching range boundary"
  → Wait 5 minutes to confirm
```

**Tier 2 — Confirmation (after 5 min wait)**
```
IF price still outside range after 5 min:
  → Send alert: "Breakout confirmed — rebalance recommended"
  → Include current position stats
```

### Fee Efficiency Tracking

**The Key Insight:**
With curve-shaped liquidity, fee efficiency is highest when price stays near the center of your range. When efficiency drops below 50%, you're leaving money on the table.

```
Fee Efficiency = (actual fees earned / max possible fees) × 100

IF efficiency < 50%:
  → Alert: "Fee efficiency dropping — consider rebalance"
  → Include: current efficiency %, estimated daily fees at 100%
```

### The Full Monitoring Loop

```
Every 10 minutes:
  1. Fetch current price (CoinMarketCast or on-chain)
  2. Check if price is in range
  3. Calculate fee efficiency
  
  IF out of range:
    → Tier 1 alert
    → Wait 5 min
    → Re-check
    → IF still out: Tier 2 alert
  
  IF efficiency < 50%:
    → Efficiency alert
  
  IF both conditions met:
    → Combined alert: "Rebalance recommended — out of range + low efficiency"
```

---

## 🔧 Implementation

### Cron Job Setup

```yaml
name: "DeFi LP Monitor — Two-Tier Alert + Fee Efficiency"
schedule: "*/10 6-23 * * *"  # Every 10 min, 6am-11pm
deliver: "strategies"        # Smart routing to Strategies group
```

### Script Pattern

```python
import json
import urllib.request
from datetime import datetime, timedelta

# State tracking
state = {
    "last_alert_condition": None,
    "last_alert_time": None,
    "oor_alerted": False,      # Out-of-range alerted
    "eff_alerted": False,       # Efficiency alerted
    "price_history": []         # Last 12 prices for trend
}

def monitor_lp_position():
    # 1. Fetch current price
    price = fetch_price()  # CoinMarketCap or on-chain
    
    # 2. Check range
    in_range = RANGE_LOW <= price <= RANGE_HIGH
    
    # 3. Calculate efficiency
    efficiency = calculate_efficiency()  # From on-chain data
    
    # 4. Tier 1 — Early warning
    if not in_range and not state["oor_alerted"]:
        send_alert(f"⚠️ Price ${price} approaching range boundary")
        state["oor_alerted"] = True
        state["last_alert_time"] = datetime.now()
    
    # 5. Tier 2 — Confirmation (5 min later)
    elif not in_range and state["oor_alerted"]:
        elapsed = (datetime.now() - state["last_alert_time"]).seconds
        if elapsed >= 300:  # 5 minutes
            send_alert(f"🚨 Breakout confirmed — rebalance recommended")
            state["oor_alerted"] = False  # Reset after confirmed
    
    # 6. Efficiency check
    if efficiency < 50 and not state["eff_alerted"]:
        send_alert(f"📉 Fee efficiency at {efficiency}% — consider rebalance")
        state["eff_alerted"] = True
    
    # 7. Reset when conditions resolve
    if in_range:
        state["oor_alerted"] = False
    if efficiency >= 50:
        state["eff_alerted"] = False
    
    # 8. Save state
    save_state(state)
```

### Alert-Once Pattern

**Key rule:** Don't spam the user. Alert once per condition, then stay silent until:
- Condition resolves (price returns to range)
- New condition appears (efficiency drops)

```python
# Track what we've alerted on
if condition_met and not state[f"{condition}_alerted"]:
    send_alert(message)
    state[f"{condition}_alerted"] = True

# Reset when condition resolves
if condition_resolved:
    state[f"{condition}_alerted"] = False
```

---

## 📱 Dashboard Integration

### Auto-Refresh Pattern

```javascript
// Refresh every 60 seconds
setInterval(async () => {
    const data = await fetch('defi-data.json?' + Date.now());
    dashboard.update(await data.json());
}, 60000);

// Refresh on tab focus
document.addEventListener('visibilitychange', () => {
    if (document.visibilityState === 'visible') {
        refreshData();
    }
});
```

### Dashboard Sections

| Section | Data | Refresh |
|---------|------|---------|
| **Price** | Current AVAX/USDC | 60s |
| **Position** | LP value, ranges | 60s |
| **Efficiency** | Fee efficiency % | 60s |
| **Alerts** | Out-of-range, low efficiency | Real-time |
| **Scout Progress** | Daily fees vs target | 60s |

### Scout Progress Bar

```
🎯 Scout ($5.00/day): [==○○○○○○○○] 20% — $1.00/day
```

- 20-char bar width
- `=` for completed, `○` for remaining
- Show percentage and dollar amount

---

## 🔄 The Flow: Cron → Dashboard → Action

```
┌─────────────────────────────────────────────────────────────────┐
│                    DEFI LP MONITORING FLOW                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────────┐     ┌──────────────┐     ┌──────────────┐   │
│  │  CRON JOB    │────▶│  DASHBOARD   │────▶│    USER      │   │
│  │  (every 10m) │     │  (auto-refresh│     │   (action)   │   │
│  └──────┬───────┘     └──────────────┘     └──────────────┘   │
│         │                                                      │
│         ▼                                                      │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │              TWO-TIER ALERT SYSTEM                       │   │
│  │                                                          │   │
│  │  Tier 1: "Price approaching boundary" → Wait 5 min     │   │
│  │  Tier 2: "Breakout confirmed" → Rebalance recommended  │   │
│  │                                                          │   │
│  │  Fee Efficiency: <50% → "Consider rebalance"           │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
│         │                                                      │
│         ▼                                                      │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │                    USER ACTIONS                          │   │
│  │                                                          │   │
│  │  1. Check dashboard to verify                           │   │
│  │  2. Go to Trader Joe / LFJ                              │   │
│  │  3. Rebalance position                                  │   │
│  │  4. Dashboard updates automatically                     │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 💡 Why This Matters

**Without monitoring:**
- You forget to check your position
- Price drifts out of range
- You earn 0% fees for days
- You notice too late

**With monitoring:**
- Agent checks every 10 minutes
- Early warning before breakout
- Fee efficiency tracked continuously
- You rebalance at the right time
- You earn maximum fees all day

**The difference:** Earning a little vs earning your full potential.

---

## 📚 Related

- `defi-lp-monitoring` skill — Full monitoring workflow
- `DASHBOARD_TEMPLATES.md` — Dashboard patterns
- `KNOWN_ISSUES.md` — Troubleshooting

---

*This pattern is part of the GenTech Agent Kit. Use it as a starting point for any DeFi monitoring dashboard.*

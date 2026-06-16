# 📊 Dashboard Templates

> Built-in patterns for common dashboard types. Use these as starting points when building new dashboards.

**Last updated:** 2026-06-14

---

## 🎯 Template Patterns

### 1. Profile Dashboard
**Use when:** User wants to see their own data, stats, and activity.

```json
{
  "type": "profile",
  "sections": [
    { "type": "header", "title": "My Dashboard" },
    { "type": "stats-grid", "columns": 4 },
    { "type": "activity-feed", "maxItems": 20 },
    { "type": "settings-panel" }
  ],
  "autoRefresh": 60,
  "refreshOnFocus": true
}
```

**Rules:**
- Auto-refresh every 60 seconds
- Refresh when user switches back to tab
- Show last updated timestamp
- Cache data locally for offline view

### 2. Monitoring Dashboard
**Use when:** Tracking live data (prices, positions, alerts).

```json
{
  "type": "monitoring",
  "sections": [
    { "type": "header", "title": "Live Monitor" },
    { "type": "alert-banner", "priority": "high" },
    { "type": "data-grid", "realTime": true },
    { "type": "chart", "timeRange": "24h" },
    { "type": "activity-log", "autoScroll": true }
  ],
  "autoRefresh": 30,
  "refreshOnFocus": true,
  "pushAlerts": true
}
```

**Rules:**
- Auto-refresh every 30 seconds
- Push alerts for critical changes
- Highlight new data with animations
- Sound alerts for important events

### 3. Portfolio Dashboard
**Use when:** Showing financial positions, yields, P&L.

```json
{
  "type": "portfolio",
  "sections": [
    { "type": "header", "title": "Portfolio" },
    { "type": "total-value", "currency": "USD" },
    { "type": "position-grid", "sortable": true },
    { "type": "performance-chart", "periods": ["1d", "7d", "30d"] },
    { "type": "yield-sources" },
    { "type": "recent-transactions" }
  ],
  "autoRefresh": 60,
  "refreshOnFocus": true,
  "showPnL": true
}
```

**Rules:**
- Auto-refresh every 60 seconds
- Show P&L in green/red
- Sort positions by value or yield
- Click position for details

### 4. Intel Feed Dashboard
**Use when:** Community-sourced intelligence (travel, food, safety).

```json
{
  "type": "intel-feed",
  "sections": [
    { "type": "header", "title": "Intel Feed" },
    { "type": "filter-bar", "categories": ["safety", "food", "price", "logistics"] },
    { "type": "feed", "sortBy": "recent", "upvoteable": true },
    { "type": "submit-intel-form" },
    { "type": "reputation-panel" }
  ],
  "autoRefresh": 120,
  "refreshOnFocus": true,
  "allowSubmissions": true
}
```

**Rules:**
- Auto-refresh every 2 minutes
- Allow upvotes/downvotes
- Show author reputation
- Filter by category

### 5. Build/Project Dashboard
**Use when:** Tracking hackathon projects, builds, milestones.

```json
{
  "type": "project",
  "sections": [
    { "type": "header", "title": "Project Name" },
    { "type": "status-banner", "status": "building" },
    { "type": "milestone-tracker", "totalPhases": 5 },
    { "type": "task-list", "groupBy": "status" },
    { "type": "code-stats", "showTests": true },
    { "type": "submission-checklist" }
  ],
  "autoRefresh": 300,
  "refreshOnFocus": true
}
```

**Rules:**
- Auto-refresh every 5 minutes
- Show test status (pass/fail)
- Track milestones with progress bar
- Submission checklist with deadlines

### 6. Hub Dashboard
**Use when:** A personal landing page for a user/family member with tabs.

**Template:** See `modules/dashboard/hub-template.html`

```json
{
  "type": "hub",
  "sections": [
    { "type": "header", "title": "Jordan's Hub" },
    { "type": "tab-nav", "tabs": ["home", "profile", "travel", "chat"] },
    { "type": "tab-content", "id": "home" },
    { "type": "tab-content", "id": "profile" },
    { "type": "tab-content", "id": "travel" },
    { "type": "tab-content", "id": "chat" }
  ]
}
```

**Rules:**
- Bottom nav buttons and tab sections must have matching IDs/classes
- Use a **unique `localStorage` key per hub** (e.g. `jordan-hub-default-tab`, `vanito-hub-default-tab`)
- Never hardcode live data; fetch from `data.json` or redirect to the live dashboard
- Verify all internal links after renaming files
- Use `data-tab` attributes or `id="nav-{{tab}}"` for robust tab selection

**Common bugs to avoid:**
- JavaScript uses `.tab-section` but HTML uses `.tab-content`
- JavaScript uses `.nav-btn` but HTML uses `.nav-item`
- `localStorage` key is shared across hubs, so one user's default breaks another's tabs
- Links point to renamed/deleted files (e.g. `poe2-warrior-dashboard.html` → `poe2-dashboard.html`)
- Hub embeds stale hardcoded numbers instead of fetching live data

---

## 🚨 Hub Audit Checklist

Before deploying any hub:

- [ ] Tab switching works on mobile and desktop
- [ ] Each hub uses a unique `localStorage` default-tab key
- [ ] All links resolve (no 404s)
- [ ] Live data is fetched, not hardcoded
- [ ] "Back to Hub" links work from sub-pages
- [ ] Settings modal saves and restores the correct tab

---

## 🔧 Auto-Refresh Patterns

### Standard Pattern (60s)
```javascript
// Auto-refresh every 60 seconds
setInterval(async () => {
    try {
        const res = await fetch('data.json?' + Date.now());
        const data = await res.json();
        dashboard.update(data);
        console.log('[Dashboard] Refreshed at', new Date().toLocaleTimeString());
    } catch (e) {
        console.warn('[Dashboard] Refresh failed:', e.message);
    }
}, 60000);
```

### Focus-Based Refresh
```javascript
// Refresh when user returns to tab
document.addEventListener('visibilitychange', () => {
    if (document.visibilityState === 'visible') {
        refreshData();
    }
});
```

### Smart Refresh (Reduce API Calls)
```javascript
// Only refresh if data has changed
let lastHash = '';
setInterval(async () => {
    const res = await fetch('data.json?' + Date.now());
    const data = await res.json();
    const hash = JSON.stringify(data).hash;
    if (hash !== lastHash) {
        dashboard.update(data);
        lastHash = hash;
    }
}, 60000);
```

---

## 📱 Mobile Considerations

- Reduce refresh frequency on mobile (120s instead of 60s)
- Pause refresh when tab is backgrounded
- Show "Last updated: X minutes ago" indicator
- Allow manual refresh with pull-to-refresh gesture

---

## 🎨 Visual Patterns

### Live Indicator
```html
<div class="live-indicator">
    <span class="pulse"></span> Live — Auto-refreshing
</div>
```

### Last Updated
```html
<div class="last-updated">
    Last updated: <span id="last-update">--</span>
</div>
```

### Refresh Button
```html
<button onclick="refreshData()" class="refresh-btn">
    🔄 Refresh Now
</button>
```

---

*These templates are part of the GenTech Agent Kit. Use them as starting points and customize for your specific use case.*

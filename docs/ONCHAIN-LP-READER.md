# On-Chain LP Position Reader — Agent Kit Template

> **Status:** Production-ready (LFJ V2.1 on Avalanche)  
> **Date:** 2026-06-16  
> **Part of:** GenTech Agent Kit

## What It Does

Reads live LP position data directly from blockchain RPC — no MetaMask, no browser, no API keys. Computes the **actual** position range from on-chain bin prices, estimates real daily fees from pool volume, and emits a dashboard-ready `defi-data.json`.

## Architecture

```
┌─────────────────────────────────────────┐
│  Layer 1: Chain-Agnostic (Free)         │
│  ├── Native balance (eth_getBalance)    │
│  ├── ERC-20 balance (balanceOf)         │
│  └── Price feeds (DexScreener/Pyth)     │
├─────────────────────────────────────────┤
│  Layer 2: DEX-Specific Adapters         │
│  ├── LFJ V2.1: balanceOf per bin       │
│  ├── Uniswap V3: NFT Position Manager  │
│  └── Pangolin: similar to LFJ           │
├─────────────────────────────────────────┤
│  Layer 3: Dashboard Output              │
│  └── defi-data.json (unified format)    │
└─────────────────────────────────────────┘
```

## Supported DEXes

| DEX | Chain | Method | Status |
|-----|-------|--------|--------|
| LFJ V2.1 | Avalanche | `balanceOf(wallet, binId)` per bin | ✅ Production |
| LFJ V2.2 | Multi-chain | Same pattern | 🔧 Needs ABI update |
| Uniswap V3 | Ethereum/Base/Arbitrum | `NonfungiblePositionManager.positions(tokenId)` | 📋 Template |
| Pangolin V2 | Avalanche | Similar to LFJ | 📋 Template |

## Quick Start

```bash
# Install dependencies
cd /root/projects/lp-reader
npm install @traderjoe-xyz/sdk @traderjoe-xyz/sdk-v2 @traderjoe-xyz/sdk-core viem

# Run (wallet required)
node reader.mjs --wallet 0xYourAddress

# Run with a specific shape
node reader.mjs --wallet 0xYourAddress --shape curve

# Override output path
node reader.mjs --wallet 0xYourAddress --output /path/to/defi-data.json

# Cron wrapper
bash /root/vaults/gentech/scripts/run-reader.sh
```

## Output Format (defi-data.json)

```json
{
  "lastUpdated": "2026-06-16T16:24:49.105Z",
  "pool": "AVAX/USDC",
  "chain": "Avalanche",
  "dex": "LFJ",
  "currentPrice": 6.78,
  "priceChange24h": -3.34,
  "volume24h": 1572197,
  "liquidity": 374435,
  "lpPosition": {
    "pair": "AVAX/USDC",
    "feeTier": "10bps",
    "shape": "bid-ask",
    "displayShape": "Bid-Ask",
    "currentPrice": 6.78,
    "rangeMin": 6.8269,
    "rangeMax": 7.0277,
    "avaxAmount": 6.7071,
    "usdcAmount": 0.0,
    "totalValue": 45.47,
    "activeBin": 8362879,
    "binStep": 10,
    "totalBins": 30
  },
  "fees": {
    "dailyFees": 0.19,
    "cumulativeFees": 0.1798,
    "feeCurrency": "USD"
  },
  "hero": {
    "rangeStatus": "Out of Range",
    "efficiency": 0,
    "efficiencyZone": "Edge"
  },
  "rebalanceSuggestions": {
    "suggestions": [
      {
        "icon": "🚨",
        "title": "Price Out of Range",
        "priority": "high",
        "action": "Rebalance on LFJ"
      }
    ]
  },
  "transactions": [
    {
      "date": "2026-06-16",
      "type": "Snapshot",
      "token": "AVAX/USDC",
      "amount": "6.7071 WAVAX + 0.00 USDC",
      "usd": "45.47",
      "status": "Out of Range"
    }
  ],
  "curveData": {
    "currentPrice": 6.78,
    "rangeMin": 6.8269,
    "rangeMax": 7.0277,
    "bins": [
      { "price": 6.8269, "depth": 0.12, "id": 8362860 },
      "..."
    ]
  }
}
```

## How LFJ Position Reading Works

1. **Pool is ERC-1155-like**: Each bin is a tokenId.
2. **`balanceOf(wallet, binId)`** returns liquidity shares per bin.
3. **`totalSupply(binId)`** + **`getBin(binId)`** gives pool reserves per bin.
4. **Share calculation**: `userAmount = (userLiquidity / totalSupply) * binReserves`.
5. **Real bin price**: `Bin.getPriceFromId(id, binStep) * 10^(tokenXDecimals - tokenYDecimals)`.
6. **Actual range**: min/max price of bins that hold liquidity.
7. **Scan range**: ±200 bins around active bin covers most positions.

## Real Range vs. Fake Range

**Old mistake:** `rangeMin = dexPrice - 0.12`, `rangeMax = dexPrice + 0.12`.
- The range moved with price.
- "In Range" was basically always true.
- Rebalance triggers were meaningless.

**Correct approach:** compute each bin's real USD price from `Bin.getPriceFromId()`.
- The range stays fixed until the user rebalances.
- "Out of Range" is detected correctly.
- Efficiency is calculated against the real position.

## Shape Support

The reader accepts a `--shape` parameter. This is metadata for the dashboard; on-chain data does not encode the shape used at deposit time.

```bash
node reader.mjs --wallet 0x... --shape bid-ask
node reader.mjs --wallet 0x... --shape curve
node reader.mjs --wallet 0x... --shape spot
node reader.mjs --wallet 0x... --shape uniform
```

## Fee Estimation

No free RPC endpoint gives historical fee accrual. The reader estimates:

```
dailyFees = volume24h × (binStep / 10000) × (lpValue / poolTVL)
```

This is directionally accurate and updates with real market volume. Replace with subgraph or event scanning for exact figures.

## Cron Integration

The reader runs every 3 hours via Hermes cron:

```
Schedule: 0 */3 * * *
Script: /root/vaults/gentech/scripts/run-reader.sh
Output: /root/ProtoJay4789.github.io/DeFi/defi-data.json
```

The wrapper also commits and pushes to GitHub Pages.

## Dashboard Cache Busting

GitHub Pages caches aggressively. The dashboard fetches data with `cache: 'no-store'`:

```js
fetch('defi-data.json?' + Date.now(), { cache: 'no-store' })
```

This prevents stale "In Range" status after a rebalance or price move.

## Extending to Other DEXes

### Uniswap V3
```javascript
// NonfungiblePositionManager at 0xC36442b4a4522E871399CD717aBDD847Ab11FE88
const balance = await readContract({
  address: NFT_MANAGER,
  abi: UNI_V3_NFT_ABI,
  functionName: 'balanceOf',
  args: [wallet],
});
// Then loop: tokenOfOwnerByIndex → positions(tokenId)
```

### Pangolin V2
Similar to LFJ — fork of Joe V1/V2. Same `balanceOf` pattern.

## Known Limitations

1. **Bin scanning range**: ±200 bins from active. If position is wider, increase scan range (costs more RPC calls).
2. **RPC rate limits**: Free endpoints may rate-limit on heavy multicall. Consider Alchemy/Infura for production.
3. **V2.2 ABI**: Pool may use different ABI version — check `getReserves()` vs `getReservesAndId()`.
4. **Fee estimation**: Based on 24h volume, not exact historical fees.
5. **Shape metadata**: Supplied by user; not detectable on-chain without heuristic analysis.

## Dependencies

- `viem` — Ethereum client library (lightweight, fast)
- `@traderjoe-xyz/sdk-v2` — LFJ contract ABIs + `Bin.getPriceFromId()`
- `@traderjoe-xyz/sdk-core` — Shared types
- No API keys needed for reading

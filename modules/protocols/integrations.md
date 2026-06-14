# GenTech Agent Kit — Integrations

## Active Integrations

| Protocol | Status | Chain | Use Case |
|----------|--------|-------|----------|
| **x402** | ✅ Live | Multi-chain | Micropayments |
| **Circle** | ✅ Live | Multi-chain | USDC payments |
| **LFJ (Trader Joe)** | ✅ Live | Avalanche | LP positions |
| **DexScreener** | ✅ Live | Multi-chain | Live prices |
| **WURK.fun** | ✅ Live | Solana | Microtasks |
| **Travala** | ✅ Live | Multi-chain | Travel booking |
| **COTI** | ✅ Live | Ethereum | Privacy transactions |
| **ERC-8004** | ✅ Live | EVM | Agent identity |

## Coming Soon

| Protocol | Target | Chain | Use Case |
|----------|--------|-------|----------|
| **Solana** | Q3 2026 | Solana | Full ecosystem |
| **BNB Chain** | Q3 2026 | BSC | DEX integration |
| **Arbitrum** | Q3 2026 | ARB | L2 scaling |
| **Jito** | Q4 2026 | Solana | MEV protection |
| **GMX** | Q4 2026 | Arbitrum | Perpetuals |

## Integration Ideas

When discovering new tools, add them here:

### DeFi
- [ ] Uniswap V4 hooks
- [ ] Aerodrome veNFT
- [ ] Benqi staking
- [ ] Pangolin vePNG

### Identity
- [ ] ERC-725 identity
- [ ] Soulbound tokens
- [ ] DID integration

### Payments
- [ ] Stripe onramp
- [ ] MoonPay integration
- [ ] Transak

### Automation
- [ ] Gelato Network
- [ ] Chainlink Automation
- [ ] OpenZeppelin Defender

## How to Add an Integration

1. **Evaluate** — Does it fit the three pillars (Identity, Enforcement, Audit)?
2. **Prototype** — Build a proof of concept
3. **Test** — Verify on testnet
4. **Document** — Add to this file
5. **Release** — Update the kit

## Chain-Specific Integrations

### Avalanche
- LFJ (Trader Joe) — Concentrated liquidity
- Pangolin — DEX + vePNG
- Benqi — Lending + staking
- Platypus — Single-sided LP

### Ethereum
- Uniswap — DEX
- Aave — Lending
- Lido — Staking
- MakerDAO — CDP

### Base
- Uniswap — DEX
- Aerodrome — ve(3,3) DEX
- Compound — Lending

### Solana
- Raydium — AMM
- Orca — CLMM
- Jito — MEV + staking
- Marinade — Liquid staking

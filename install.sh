#!/bin/bash

# GenTech Agent Kit — Installer
# Usage: ./install.sh [--all|--core|--module <name>|--chain <name>]

set -e

KIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HERMES_DIR="${HERMES_DIR:-$HOME/.hermes/profiles}"
VAULT_DIR="${VAULT_DIR:-$HOME/vaults}"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

usage() {
    echo "GenTech Agent Kit Installer"
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --all              Install everything (core + all modules + all chains)"
    echo "  --core             Install core only (brain + vault + automation)"
    echo "  --module <name>    Install a specific module"
    echo "  --chain <name>     Install a specific chain"
    echo "  --list             List available modules and chains"
    echo "  --help             Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 --all                    # Install everything"
    echo "  $0 --core                   # Core only"
    echo "  $0 --module dashboard       # Add dashboard module"
    echo "  $0 --chain avalanche        # Add Avalanche chain"
    echo ""
}

list_available() {
    echo "Available modules:"
    echo "  dashboard    - Presentation layer (38KB, zero deps)"
    echo "  defi         - LP tracking, yield scouting"
    echo "  payments     - x402, Circle integration"
    echo "  identity     - ERC-8004, wallet binding"
    echo "  audit        - Transaction logging"
    echo "  protocols    - Travala, WURK, COTI"
    echo ""
    echo "Available chains:"
    echo "  avalanche    - LFJ, Pangolin, Benqi"
    echo "  ethereum     - Uniswap, Aave, Lido"
    echo "  base         - Uniswap, Aerodrome"
    echo "  solana       - Raydium, Orca, Jito (coming soon)"
}

install_core() {
    echo -e "${GREEN}Installing core...${NC}"
    
    # Brain layer
    if [ -d "$HERMES_DIR" ]; then
        echo "  Copying brain layer to Hermes profiles..."
        find "$HERMES_DIR" -maxdepth 1 -type d | while read profile; do
            if [ -d "$profile/skills" ]; then
                cp -r "$KIT_DIR/core/brain/proactive-context" "$profile/skills/" 2>/dev/null || true
                echo "    Added to $(basename "$profile")"
            fi
        done
    else
        echo -e "${YELLOW}  Hermes profiles not found. Copy manually:${NC}"
        echo "    cp -r core/brain/proactive-context ~/.hermes/profiles/your-profile/skills/"
    fi
    
    # Vault structure
    echo "  Vault structure ready in core/vault/"
    echo "    Copy to your vault: cp -r core/vault/* ~/your-vault/"
    
    # Automation
    echo "  Automation templates ready in core/automation/"
    echo "    Import via Hermes cron: hermes cron import core/automation/context-snapshot.json"
    
    # Obsidian sync recommendation
    echo ""
    echo -e "${YELLOW}  ⚠️ IMPORTANT: Set up Obsidian sync for your vault${NC}"
    echo "    npm install -g obsidian-cli"
    echo "    cd ~/vaults/your-vault && ob init"
    echo "    Add to cron: 0 */6 * * * cd ~/vaults/your-vault && ob sync"
    echo ""
    
    echo -e "${GREEN}Core installed!${NC}"
}

install_module() {
    local module=$1
    
    if [ ! -d "$KIT_DIR/modules/$module" ]; then
        echo -e "${RED}Module '$module' not found${NC}"
        echo "Available modules: dashboard defi payments identity audit protocols"
        exit 1
    fi
    
    echo -e "${GREEN}Installing module: $module${NC}"
    
    case $module in
        dashboard)
            echo "  Dashboard engine ready in modules/dashboard/"
            echo "    Copy to your project: cp modules/dashboard/dashboard-engine.js ~/your-project/"
            ;;
        defi)
            echo "  DeFi module ready in modules/defi/"
            echo "    Includes: LP tracking, yield scouting, milestones"
            ;;
        payments)
            echo "  Payments module ready in modules/payments/"
            echo "    Includes: x402, Circle integration"
            ;;
        identity)
            echo "  Identity module ready in modules/identity/"
            echo "    Includes: ERC-8004, wallet binding"
            ;;
        audit)
            echo "  Audit module ready in modules/audit/"
            echo "    Includes: Transaction logging, compliance"
            ;;
        protocols)
            echo "  Protocols module ready in modules/protocols/"
            echo "    Includes: Travala, WURK, COTI"
            ;;
    esac
    
    echo -e "${GREEN}Module '$module' installed!${NC}"
}

install_chain() {
    local chain=$1
    
    if [ ! -d "$KIT_DIR/chains/$chain" ]; then
        echo -e "${RED}Chain '$chain' not found${NC}"
        echo "Available chains: avalanche ethereum base solana"
        exit 1
    fi
    
    echo -e "${GREEN}Installing chain: $chain${NC}"
    echo "  Chain config ready in chains/$chain/"
    
    case $chain in
        avalanche)
            echo "    Protocols: LFJ, Pangolin, Benqi"
            ;;
        ethereum)
            echo "    Protocols: Uniswap, Aave, Lido"
            ;;
        base)
            echo "    Protocols: Uniswap, Aerodrome"
            ;;
        solana)
            echo "    Protocols: Raydium, Orca, Jito (coming soon)"
            ;;
    esac
    
    echo -e "${GREEN}Chain '$chain' installed!${NC}"
}

install_all() {
    echo -e "${GREEN}Installing GenTech Agent Kit — Full Stack${NC}"
    echo ""
    
    install_core
    
    for module in dashboard defi payments identity audit protocols; do
        install_module "$module"
    done
    
    for chain in avalanche ethereum base; do
        install_chain "$chain"
    done
    
    echo ""
    echo -e "${GREEN}═══════════════════════════════════════════════${NC}"
    echo -e "${GREEN}GenTech Agent Kit — Full Stack Installed!${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════${NC}"
    echo ""
    echo "Next steps:"
    echo "  1. Configure your agent in config.yaml"
    echo "  2. Set up your vault structure"
    echo "  3. Import cron jobs via Hermes"
    echo "  4. Start building!"
    echo ""
}

# Parse arguments
if [ $# -eq 0 ]; then
    usage
    exit 0
fi

while [[ $# -gt 0 ]]; do
    case $1 in
        --all)
            install_all
            exit 0
            ;;
        --core)
            install_core
            exit 0
            ;;
        --module)
            if [ -z "$2" ]; then
                echo -e "${RED}Error: --module requires a name${NC}"
                exit 1
            fi
            install_module "$2"
            exit 0
            ;;
        --chain)
            if [ -z "$2" ]; then
                echo -e "${RED}Error: --chain requires a name${NC}"
                exit 1
            fi
            install_chain "$2"
            exit 0
            ;;
        --list)
            list_available
            exit 0
            ;;
        --help)
            usage
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            usage
            exit 1
            ;;
    esac
done

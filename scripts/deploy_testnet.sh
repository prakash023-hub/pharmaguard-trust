#!/usr/bin/env bash
# Deploy ComplianceAttestation to Casper testnet.
# Prereqs: secret key PEM, testnet CSPR, built wasm (see pharmaguard_attestation/DEPLOY.md)

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CONTRACT_DIR="$ROOT/pharmaguard_attestation"
WASM="$CONTRACT_DIR/wasm/ComplianceAttestation.wasm"

NODE="${CASPER_NODE:-https://node.testnet.cspr.cloud/rpc}"
CHAIN="${CASPER_CHAIN:-casper-test}"
SECRET_KEY="${CASPER_SECRET_KEY:?Set CASPER_SECRET_KEY to your secret_key.pem path}"
PAYMENT="${CASPER_PAYMENT:-5000000000000}"

export PATH="/opt/homebrew/bin:${HOME}/.cargo/bin:${PATH}"
export CARGO_TARGET_DIR="$CONTRACT_DIR/target"

if [[ ! -f "$WASM" ]]; then
  echo "Building contract..."
  (cd "$CONTRACT_DIR" && cargo odra build -c ComplianceAttestation)
fi

echo "Deploying to $NODE (chain: $CHAIN)..."
casper-client put-transaction session \
  --node-address "$NODE" \
  --chain-name "$CHAIN" \
  --secret-key "$SECRET_KEY" \
  --wasm-path "$WASM" \
  --payment-amount "$PAYMENT" \
  --gas-price-tolerance 1 \
  --standard-payment true \
  --install-upgrade \
  --session-arg "odra_cfg_package_hash_key_name:string:'pharmaguard_compliance_package_hash'" \
  --session-arg "odra_cfg_allow_key_override:bool:'true'" \
  --session-arg "odra_cfg_is_upgradable:bool:'true'" \
  --session-arg "odra_cfg_is_upgrade:bool:'false'"

echo ""
echo "Save the deploy hash from the output above."
echo "Then fetch package hash:"
echo "  casper-client get-state-root-hash --node-address $NODE"
echo "  casper-client query-global-state --node-address $NODE --state-root-hash <HASH> --key pharmaguard_compliance_package_hash"

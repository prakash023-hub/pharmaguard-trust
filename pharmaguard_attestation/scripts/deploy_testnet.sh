#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
WASM="${ROOT}/wasm/ComplianceAttestation.wasm"

: "${CASPER_SECRET_KEY:?Set CASPER_SECRET_KEY to your testnet secret_key.pem path}"
: "${CASPER_NODE:=http://52.35.59.254:7777}"
: "${CASPER_CHAIN:=casper-test}"
# 800 CSPR in motes — under block limit, much higher than 10/200 that failed
: "${CASPER_PAYMENT:=800000000000}"
: "${PACKAGE_KEY_NAME:=pharmaguard_package_hash}"
: "${CASPER_PRICING_MODE:=fixed}"
: "${CASPER_COMPUTATION_FACTOR:=64}"
: "${CASPER_RUNTIME:=vm-casper-v2}"

if [[ ! -f "${WASM}" ]]; then
  "${ROOT}/scripts/build.sh"
fi

casper-client put-transaction session \
  --node-address "${CASPER_NODE}" \
  --chain-name "${CASPER_CHAIN}" \
  --secret-key "${CASPER_SECRET_KEY}" \
  --payment-amount "${CASPER_PAYMENT}" \
  --transferred-value 0 \
  --gas-price-tolerance 10 \
  --standard-payment true \
  --pricing-mode "${CASPER_PRICING_MODE}" \
  --additional-computation-factor "${CASPER_COMPUTATION_FACTOR}" \
  --transaction-runtime "${CASPER_RUNTIME}" \
  --install-upgrade \
  --wasm-path "${WASM}" \
  --session-arg "odra_cfg_package_hash_key_name:string:'${PACKAGE_KEY_NAME}'" \
  --session-arg "odra_cfg_allow_key_override:bool:'true'" \
  --session-arg "odra_cfg_is_upgradable:bool:'true'" \
  --session-arg "odra_cfg_is_upgrade:bool:'false'"

echo "Deployed. Check SUCCESS on testnet.cspr.live (not Out of gas)."
echo "  casper-client get-account --node-address ${CASPER_NODE} --account-identifier YOUR_PUBLIC_KEY"

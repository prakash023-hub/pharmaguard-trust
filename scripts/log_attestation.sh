#!/usr/bin/env bash
# Call log_attestation on deployed ComplianceAttestation package.

set -euo pipefail

NODE="${CASPER_NODE:-https://node.testnet.cspr.cloud/rpc}"
CHAIN="${CASPER_CHAIN:-casper-test}"
SECRET_KEY="${CASPER_SECRET_KEY:?Set CASPER_SECRET_KEY}"
PACKAGE_HASH="${CASPER_PACKAGE_HASH:?Set CASPER_PACKAGE_HASH (hash-...)}"
SESSION_ID="${1:?session_id}"
QUERY_HASH="${2:?query_hash}"
AWARE="${3:-ACCESS}"
PAYMENT="${CASPER_CALL_PAYMENT:-3000000000}"

casper-client put-transaction package \
  --node-address "$NODE" \
  --chain-name "$CHAIN" \
  --secret-key "$SECRET_KEY" \
  --contract-package-hash "$PACKAGE_HASH" \
  --session-entry-point log_attestation \
  --payment-amount "$PAYMENT" \
  --gas-price-tolerance 1 \
  --standard-payment true \
  --session-arg "session_id:string:'$SESSION_ID'" \
  --session-arg "query_hash:string:'$QUERY_HASH'" \
  --session-arg "aware_category:string:'$AWARE'"

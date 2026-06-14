#!/usr/bin/env bash
set -euo pipefail

: "${CASPER_SECRET_KEY:?Set CASPER_SECRET_KEY}"
: "${CASPER_PACKAGE_HASH:?Set CASPER_PACKAGE_HASH (hash-... from deploy)}"
: "${CASPER_NODE:=http://52.35.59.254:7777}"
: "${CASPER_CHAIN:=casper-test}"
: "${CASPER_PAYMENT:=3000000000}"

casper-client put-transaction package \
  --node-address "${CASPER_NODE}" \
  --chain-name "${CASPER_CHAIN}" \
  --secret-key "${CASPER_SECRET_KEY}" \
  --payment-amount "${CASPER_PAYMENT}" \
  --gas-price-tolerance 1 \
  --standard-payment true \
  --contract-package-hash "${CASPER_PACKAGE_HASH}" \
  --session-entry-point log_attestation

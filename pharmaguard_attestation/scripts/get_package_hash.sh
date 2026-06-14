#!/usr/bin/env bash
# Fetch pharmaguard_package_hash after deploy. Requires proxy on 127.0.0.1:7778.
set -euo pipefail

: "${CASPER_NODE:=http://127.0.0.1:7778}"
: "${CASPER_PUBLIC_KEY:?Paste full public key from Casper Wallet (copy button)}"

echo "Querying account on ${CASPER_NODE} ..."
casper-client get-account \
  --node-address "${CASPER_NODE}" \
  --account-identifier "${CASPER_PUBLIC_KEY}" \
  -vv 2>&1 | grep -E "pharmaguard_package_hash|package" || true

echo ""
echo "If empty: (1) start cspr_proxy.js in another terminal (2) use full public key from wallet"

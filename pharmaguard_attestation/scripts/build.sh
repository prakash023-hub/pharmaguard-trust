#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
export PATH="/opt/homebrew/bin:${HOME}/.cargo/bin:${PATH}"
export CARGO_TARGET_DIR="${ROOT}/target"

cd "${ROOT}"
cargo odra build -c ComplianceAttestation

echo "WASM ready: ${ROOT}/wasm/ComplianceAttestation.wasm"

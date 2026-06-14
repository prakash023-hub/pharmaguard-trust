# Deploy ComplianceAttestation (Casper testnet)

## One-time setup

```bash
brew install binaryen wabt   # wasm-opt + wasm-strip (required)
export PATH="/opt/homebrew/bin:$HOME/.cargo/bin:$PATH"
rustup target add wasm32-unknown-unknown --toolchain nightly-2026-01-01
```

## Build

```bash
cd ~/Projects/pharmaguard-trust/pharmaguard_attestation
export CARGO_TARGET_DIR="$PWD/target"
cargo odra build -c ComplianceAttestation
cargo odra test -b casper -s compliance_attestation
```

Output: `wasm/ComplianceAttestation.wasm`

## Deploy

1. Export secret key from [Casper Wallet](https://testnet.cspr.live/) (testnet).
2. Fund account via faucet on the same site.

```bash
export CASPER_SECRET_KEY=~/path/to/secret_key.pem
export CASPER_NODE=https://node.testnet.cspr.cloud/rpc
export CASPER_CHAIN=casper-test

~/Projects/pharmaguard-trust/scripts/deploy_testnet.sh
```

3. Copy deploy hash from CLI output → open on https://testnet.cspr.live/
4. Query package hash and save for agent:

```bash
export CASPER_PACKAGE_HASH=hash-xxxxxxxx   # from explorer or named key query
```

## Agent + on-chain audit

```bash
export CASPER_SECRET_KEY=~/path/to/secret_key.pem
export CASPER_PACKAGE_HASH=hash-xxxxxxxx

python3 ~/Projects/pharmaguard-trust/src/agent.py "eGFR 35 UTI antibiotic?"
```

When env vars are set, each lookup also calls `log_attestation` on testnet.

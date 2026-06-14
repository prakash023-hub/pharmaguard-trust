#!/usr/bin/env python3
"""Write clinical attestation hashes to Casper Testnet via Odra contract."""

from __future__ import annotations

import os
import subprocess
from pathlib import Path

SCRIPT = Path(__file__).resolve().parent.parent / "pharmaguard_attestation/scripts/log_attestation.sh"


def log_attestation(session_id: str, query_hash: str, aware_category: str) -> dict:
    package_hash = os.environ.get("CASPER_PACKAGE_HASH", "").strip()
    secret_key = os.environ.get("CASPER_SECRET_KEY", "").strip()
    if not package_hash or not secret_key:
        return {
            "skipped": True,
            "reason": "Set CASPER_PACKAGE_HASH and CASPER_SECRET_KEY to write on-chain",
        }

    env = {
        **os.environ,
        "CASPER_PACKAGE_HASH": package_hash,
        "CASPER_SECRET_KEY": secret_key,
        "SESSION_ID": session_id,
        "QUERY_HASH": query_hash,
        "AWARE_CATEGORY": aware_category,
    }
    result = subprocess.run(
        ["bash", str(SCRIPT)],
        env=env,
        capture_output=True,
        text=True,
        check=False,
    )
    if result.returncode != 0:
        return {
            "error": True,
            "stderr": result.stderr.strip() or result.stdout.strip(),
        }
    return {"tx": result.stdout.strip(), "platform": "casper_testnet"}

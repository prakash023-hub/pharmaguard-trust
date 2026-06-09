#!/usr/bin/env python3
"""PharmaGuard Trust — agentic clinical compliance for Casper Buildathon."""

from __future__ import annotations

import argparse
import hashlib
import json
import sys
from pathlib import Path

# Reuse clinical logic pattern from PharmaGuard
DRUG_DB = {
    "nitrofurantoin": {"aware": "ACCESS", "renal": "eGFR < 30 contraindicated"},
    "amoxicillin": {"aware": "ACCESS", "renal": "dose adjust eGFR < 30"},
}


def pii_check(text: str) -> str | None:
    import re
    if re.search(r"\b\d{3}-\d{2}-\d{4}\b", text):
        return "SSN pattern blocked"
    return None


def clinical_lookup(query: str) -> dict:
    lower = query.lower()
    drug = "nitrofurantoin" if "uti" in lower else "amoxicillin"
    info = DRUG_DB[drug]
    return {
        "drug": drug,
        "aware": info["aware"],
        "renal": info["renal"],
        "recommendation": f"Consider {drug} ({info['aware']}) — {info['renal']}",
    }


def session_id(query: str) -> str:
    return hashlib.sha256(query.encode()).hexdigest()[:16]


def run_trust_agent(query: str) -> dict:
    block = pii_check(query)
    if block:
        return {"blocked": True, "reason": block}

    result = clinical_lookup(query)
    sid = session_id(query)
    audit = {
        "session_id": sid,
        "query_hash": hashlib.sha256(query.encode()).hexdigest(),
        "platform": "casper_testnet",
        "open_did": "VC/VP flow via OmniOne CX — integrate in production",
        "omnione_chain": "ComplianceAudit.recordLookup on deploy",
        "x402": "Agent micropayment per lookup — see contracts/ComplianceAudit.sol",
        "result": result,
    }

    log_path = Path(__file__).resolve().parent.parent / "audit_trail.jsonl"
    with log_path.open("a", encoding="utf-8") as f:
        f.write(json.dumps(audit) + "\n")

    return {"session_id": sid, "audit": audit, "answer": result["recommendation"]}


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("query", nargs="?", default="eGFR 35 UTI antibiotic?")
    args = parser.parse_args()
    out = run_trust_agent(args.query)
    print(json.dumps(out, indent=2))
    if out.get("blocked"):
        sys.exit(2)


if __name__ == "__main__":
    main()

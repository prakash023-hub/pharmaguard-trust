# PharmaGuard Trust

**x402 Clinical Compliance Oracle — [Casper Agentic Buildathon 2026](https://dorahacks.io/hackathon/casper-agentic-buildathon/detail)**

> *"Agents that pay, prove, and prescribe — zero-trust clinical lookups on Casper."*

**Full win guide:** [CASPER_WIN_PLAYBOOK.md](./CASPER_WIN_PLAYBOOK.md)

## Why this wins Casper (not generic hackathon fluff)

| Casper wants | We deliver |
|---|---|
| **Example #4: AI Compliance + ZK** | Clinical compliance attestations — no PHI on-chain |
| **x402 micropayments** | Agent pays per `/api/clinical-lookup` ([casper-x402](https://github.com/make-software/casper-x402)) |
| **MCP + Agent Skills** | [Casper MCP Server](https://www.casper.network/ai) + CSPR.click |
| **Odra upgradable contracts** | `ComplianceAttestation` on testnet |
| **RWA** | Pharma compliance proofs = real-world attestations |
| **0 BUIDLs on leaderboard** | First mover — submit early + CSPR.fans votes |

**Target:** Qualification → Finals → **$30K cash**

## One-line pitch

Multi-agent clinical network where each drug lookup costs micropayment (x402), identity is verified (OpenDID), and audit trail is immutable (Casper Testnet).

## Quick start

```bash
cd pharmaguard-trust
python3 src/agent.py "Patient eGFR 35 UTI — antibiotic?"
# → appends audit_trail.jsonl
```

### Casper Testnet deploy (required for qualification)

1. Use [Casper AI Toolkit](https://www.casper.network/ai) + Odra to deploy `ComplianceAudit.sol`
2. Wire `recordLookup` from agent after each clinical query
3. Record demo video showing: agent query → x402 payment → on-chain tx

## Architecture

```
Clinician / Agent query
    → PII guardrail
    → Clinical brain (AWaRe)
    → x402 micropayment (Casper)
    → ComplianceAudit.sol (on-chain hash)
    → OpenDID VC (clinician identity) [production extension]
```

## Community vote strategy

Casper has **zero BUIDLs** — submit early, share on Twitter/Discord, vote on CSPR.fans.

## Submit

- **Deadline:** July 1, 2026 (qualification)
- **URL:** https://dorahacks.io/hackathon/casper-agentic-buildathon

## Team

Prakash Raj — PharmaGuard ecosystem

# Casper Win Playbook — PharmaGuard Trust

**Hackathon:** [Casper Agentic Buildathon 2026](https://dorahacks.io/hackathon/casper-agentic-buildathon/detail)  
**Deadline:** June 30, 2026 (submit BUIDL by **July 1**)  
**Cash prize:** $30,000  
**Secret weapon:** [0 BUIDLs submitted](https://dorahacks.io/hackathon/casper-agentic-buildathon/buidl) — you can be first.

---

## The winning idea (use this exact pitch)

### **PharmaGuard Trust — AI Compliance Oracle for Clinical Agents**

> Autonomous clinical agents pay **x402 micropayments** per drug lookup, receive AWaRe stewardship answers, and mint **on-chain compliance attestations** on Casper — without putting patient PHI on-chain.

This is Casper's own **Example #4** from the hackathon page:
*"AI-Driven Compliance & KYC via Zero-Knowledge — agent issues compliance token, upgradable contracts revoke status without exposing user data."*

| Judge criterion | How you score |
|---|---|
| Agentic AI | Multi-step agent: guardrail → pay → query → attest |
| x402 | Agent pays CSPR per `/api/clinical-lookup` call |
| MCP | Casper MCP Server checks balance + deploy hash |
| Odra contract | `ComplianceAttestation` on testnet (upgradable) |
| RWA | Pharma compliance records = real-world asset proofs |
| Real-world use | Hospitals, pharmacies, telehealth agents |
| Testnet tx | **Required** — one deploy per lookup minimum |

**One-line pitch for DoraHacks:**
`Pay-per-lookup clinical AI with x402 micropayments and immutable compliance attestations on Casper Testnet.`

---

## Architecture (build exactly this)

```
┌─────────────────────────────────────────────────────────────┐
│  CLINICAL AGENT (Python + LLM)                              │
│  1. PII guardrail block                                     │
│  2. x402 payment to API server (make-software/casper-x402)  │
│  3. GET /api/clinical-lookup?query=...                      │
└──────────────────────────┬──────────────────────────────────┘
                           │ paid request
┌──────────────────────────▼──────────────────────────────────┐
│  x402 RESOURCE SERVER (Go or Python wrapper)                │
│  Returns: AWaRe recommendation + triggers attestation       │
└──────────────────────────┬──────────────────────────────────┘
                           │
┌──────────────────────────▼──────────────────────────────────┐
│  ODRA SMART CONTRACT (Casper Testnet)                       │
│  recordAttestation(queryHash, awareCategory, agentAddress)  │
│  → real transaction on https://testnet.cspr.live              │
└──────────────────────────┬──────────────────────────────────┘
                           │
┌──────────────────────────▼──────────────────────────────────┐
│  CASPER MCP (optional demo)                                 │
│  Agent asks: "GetAccountBalance" / verify deploy hash         │
└─────────────────────────────────────────────────────────────┘
```

**On-chain stores ONLY hashes** — never patient names, SSN, or raw queries with PHI.

---

## Two ways to reach finals (do BOTH)

### Path A — Community vote (easiest with 0 competitors)
1. Submit BUIDL **early** (this week)
2. Share on Twitter/X + Casper Discord + Telegram
3. Get votes on **CSPR.fans** app
4. **Top 3 votes = auto-advance to finals** (no extra judging)

### Path B — Technical merit
1. Deploy Odra contract to **Casper Testnet**
2. Show **live transaction** in demo video
3. Open GitHub + demo video on YouTube

---

## Your build checklist (in order)

### Phase 1 — Today (2 hours)

- [ ] Register: https://dorahacks.io/hackathon/casper-agentic-buildathon → **Register as Hacker**
- [ ] Create BUIDL project: **PharmaGuard Trust**
- [ ] Join Casper Discord + Telegram (links on hackathon page)
- [ ] Create GitHub repo `pharmaguard-trust` (public, MIT)
- [ ] Push code from `~/Projects/pharmaguard-trust/`

### Phase 2 — Days 1–3 (smart contract)

- [ ] Install Rust + `cargo install cargo-odra cargo-odra-cli`
- [ ] `cargo install casper-client`
- [ ] Generate keys: https://testnet.cspr.live/tools/faucet
- [ ] Get free testnet CSPR from faucet
- [ ] Clone Odra template OR use `contracts/` as spec for Odra port
- [ ] Build: `cargo odra build -b casper`
- [ ] Deploy to testnet — save **contract package hash** + **tx URL**

**Odra docs:** https://odra.dev/docs/backends/casper/  
**CSPR.cloud API key (optional):** https://console.cspr.build/

### Phase 3 — Days 4–7 (x402 + agent)

- [ ] Clone https://github.com/make-software/casper-x402
- [ ] Run facilitator + demo server locally
- [ ] Wrap clinical lookup as paid endpoint (replace `/weather` with `/clinical-lookup`)
- [ ] Wire `src/agent.py` to pay x402 then call API
- [ ] After each paid lookup → call contract `recordAttestation`

### Phase 4 — Days 8–10 (demo + MCP)

- [ ] Install Casper MCP Server — query deploy hash in demo
- [ ] Optional: `claude skill install cspr-click` for agent wallet demo
- [ ] Record **3–5 min YouTube demo** (public, unlisted OK)

### Phase 5 — Days 11–14 (submit + vote)

- [ ] Submit BUIDL on DoraHacks with: GitHub, video, testnet explorer links
- [ ] Post on X tagging @Casper_Network
- [ ] Push CSPR.fans votes from friends + Discord

---

## Demo video script (copy this)

| Time | Show |
|---|---|
| 0:00 | Problem: clinical AI has no payment model or audit trail |
| 0:30 | Architecture diagram (from README) |
| 1:00 | Run agent: `python3 src/agent.py "eGFR 35 UTI antibiotic?"` |
| 1:30 | Terminal: x402 payment accepted |
| 2:00 | Open **testnet.cspr.live** — show attestation transaction |
| 2:30 | Show MCP balance check or contract state |
| 3:00 | "Upgradable Odra contract — compliance rules evolve without redeploying agents" |
| 3:30 | Call to action: PharmaGuard Trust on Casper |

---

## DoraHacks BUIDL description (paste this)

**Title:** PharmaGuard Trust — x402 Clinical Compliance Oracle

**Tagline:** Pay-per-lookup antibiotic stewardship with on-chain attestations.

**Description:**
PharmaGuard Trust is an agentic clinical compliance system for the Casper agent economy. Autonomous health agents pay per drug lookup using the x402 micropayment protocol, receive AWaRe-category stewardship guidance, and write immutable compliance attestations to an upgradable Odra smart contract on Casper Testnet. Patient data never goes on-chain — only cryptographic hashes of queries and recommendations.

**Tech stack:** Odra, x402 (make-software/casper-x402), Casper MCP Server, CSPR.click agent skill, Python agent.

**Track:** Casper Innovation — Agentic AI + RWA (pharmaceutical compliance attestations).

**Live demo:** [YouTube link]  
**Testnet tx:** [testnet.cspr.live link]  
**GitHub:** [your repo]

---

## What judges MUST see (non-negotiable)

| Item | Status |
|---|---|
| Public GitHub + MIT license | You do today |
| README with run instructions | ✅ in repo |
| Demo video on YouTube | You record |
| **Casper Testnet transaction** | You deploy Odra contract |
| x402 OR MCP OR Agent Skill used | Wire casper-x402 |
| Original code for this hackathon | PharmaGuard fork OK |

---

## Realistic prize paths

| Outcome | Prize |
|---|---|
| Top 3 community vote | Finals → up to $30K |
| Finals + strong RWA/compliance story | $5K–$15K cash likely |
| x402 ecosystem credits | Up to $100K credits (bonus) |

---

## When you're ready — say this

Reply in Cursor: **"Casper Phase 2"** and paste:
1. Your GitHub repo URL (after push)
2. Whether you have Rust installed
3. Your testnet account public key (if you have one)

I'll help wire Odra deploy + x402 integration in **one** Agent session.

# Casper agent — verified working

Your run produced:

- **Drug:** nitrofurantoin
- **AWaRe:** ACCESS
- **Session:** `7725b27673933e38`
- **Audit log:** `audit_trail.jsonl` (appended in repo root)

## Run again

```bash
cd ~/Projects/pharmaguard-trust
python3 src/agent.py "Patient eGFR 35 UTI antibiotic?"
```

## Next (Casper win path only)

See **CASPER_WIN_PLAYBOOK.md** — Steps 1–4 done for agent. Now:

1. Push to GitHub
2. Casper testnet faucet + Odra deploy
3. x402 integration
4. Demo video + DoraHacks BUIDL

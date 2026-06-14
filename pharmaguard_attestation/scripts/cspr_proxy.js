#!/usr/bin/env node
/**
 * Local proxy: casper-client -> CSPR.cloud (adds Authorization header).
 * Odra/casper-client cannot set custom headers on their own.
 */
const http = require("http");
const https = require("https");

const PORT = Number(process.env.CSPR_PROXY_PORT || 7778);
const TARGET = process.env.CSPR_CLOUD_NODE || "https://node.testnet.cspr.cloud";

function cleanToken(raw) {
  return String(raw || "")
    .trim()
    .replace(/^Bearer\s+/i, "")
    .replace(/^["']|["']$/g, "")
    .replace(/[\r\n\t]/g, "")
    .replace(/[^a-zA-Z0-9-]/g, "");
}

const TOKEN = cleanToken(process.env.CSPR_CLOUD_AUTH_TOKEN);

if (!TOKEN) {
  console.error("Set CSPR_CLOUD_AUTH_TOKEN (from https://console.cspr.build/)");
  process.exit(1);
}

if (/[^\x20-\x7E]/.test(TOKEN)) {
  console.error(
    "CSPR_CLOUD_AUTH_TOKEN has invalid characters. Re-copy from console.cspr.build (no quotes/newlines)."
  );
  process.exit(1);
}

const targetUrl = new URL(TARGET);

function forward(req, res) {
  const chunks = [];
  req.on("data", (c) => chunks.push(c));
  req.on("end", () => {
    const body = Buffer.concat(chunks);
    const path = req.url || "/rpc";
    const options = {
      hostname: targetUrl.hostname,
      port: targetUrl.port || (targetUrl.protocol === "https:" ? 443 : 80),
      path,
      method: req.method,
      headers: {
        "Content-Type": "application/json",
        Authorization: TOKEN,
        "Content-Length": String(body.length),
      },
    };
    const lib = targetUrl.protocol === "https:" ? https : http;
    const upstream = lib.request(options, (up) => {
      res.writeHead(up.statusCode || 502, up.headers);
      up.pipe(res);
    });
    upstream.on("error", (err) => {
      res.writeHead(502);
      res.end(String(err));
    });
    if (body.length) upstream.write(body);
    upstream.end();
  });
}

http.createServer(forward).listen(PORT, () => {
  console.log(`CSPR.cloud proxy: http://127.0.0.1:${PORT} -> ${TARGET}`);
  console.log("In another terminal: export CASPER_NODE=http://127.0.0.1:7778");
});

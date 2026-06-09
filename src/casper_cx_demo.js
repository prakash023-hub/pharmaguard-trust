/**
 * OmniOne CX Mobile ID + JWT flow stub for Casper hackathon demo.
 * Full integration: https://www.casper.network/ai
 * OmniOne CX sample from OpenDID hackathon guidebook.
 */
export function buildMobileIdAuthConfig() {
  return {
    contentInfo: { signType: "ENT_MID" },
    compareCI: false,
  };
}

export function parseJwtFromCxResponse(res) {
  if (!res?.token) {
    throw new Error("No token in OmniOne CX response");
  }
  return {
    token: res.token,
    verifyUrl: `https://cx.raonsecure.co.kr:18543/oacx/api/v1.0/trans?token=${encodeURIComponent(res.token)}`,
  };
}

/**
 * Demo handler — wire OACX.LOAD_MODULE in your web UI for live Mobile ID auth.
 */
export function onMobileIdSuccess(res, onVerified) {
  const { token, verifyUrl } = parseJwtFromCxResponse(res);
  return fetch(verifyUrl)
    .then((r) => r.json())
    .then((profile) => onVerified({ token, profile }));
}

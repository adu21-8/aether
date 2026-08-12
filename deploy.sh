#!/usr/bin/env bash
# Deploy Aether to Netlify.
#
# Uses a per-command auth token so it never touches (or is affected by) whatever
# account the Netlify CLI is globally logged into. Put the token for the account
# that owns this site in ~/.netlify-aether-token — never in this file, and never
# in the repo.
#
#   chmod 600 ~/.netlify-aether-token
#   ./deploy.sh            # deploy to production
#
set -euo pipefail

TOKEN_FILE="${NETLIFY_TOKEN_FILE:-$HOME/.netlify-aether-token}"
SITE_NAME="${SITE_NAME:-aether-trade}"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STAGE="$(mktemp -d)"
trap 'rm -rf "$STAGE"' EXIT

if [[ ! -f "$TOKEN_FILE" ]]; then
  echo "No token at $TOKEN_FILE" >&2
  echo "Create one: Netlify → User settings → Applications → Personal access tokens" >&2
  exit 1
fi
TOKEN="$(tr -d '[:space:]' < "$TOKEN_FILE")"

# Only the app ships. No source notes, no editor config, no deploy tooling.
for f in index.html manifest.webmanifest sw.js icon.svg icon-192.png icon-512.png apple-touch-icon.png; do
  cp "$ROOT/$f" "$STAGE/"
done

echo "Deploying $(ls -1 "$STAGE" | wc -l | tr -d ' ') files to '$SITE_NAME'…"

if netlify api getSite --auth "$TOKEN" --data "{\"site_id\":\"$SITE_NAME.netlify.app\"}" >/dev/null 2>&1; then
  netlify deploy --prod --dir "$STAGE" --site "$SITE_NAME" --auth "$TOKEN"
else
  echo "Site not found — creating it."
  netlify sites:create --name "$SITE_NAME" --auth "$TOKEN" || true
  netlify deploy --prod --dir "$STAGE" --site "$SITE_NAME" --auth "$TOKEN"
fi

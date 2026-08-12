#!/usr/bin/env bash
# Deploy Aether to Netlify.
#
#   ./deploy.sh              deploy to production
#   ./deploy.sh --draft      deploy a preview URL without touching production
#
# The site lives on a different Netlify account from the default one this
# machine is logged into, so the script switches accounts for the deploy and
# switches back afterwards — including on failure or Ctrl-C. Both accounts come
# from `netlify login`; no token file is involved.
#
# One-time setup, if `netlify switch` doesn't list the owning account:
#   netlify login       # authorise the account that owns the site
set -euo pipefail

SITE_ID="${SITE_ID:-851a48f3-af7f-41e1-a613-56d6c6ab9edc}"   # aether-trade
DEPLOY_ACCOUNT="${DEPLOY_ACCOUNT:-morayyan.abbasx@outlook.com}"
DEFAULT_ACCOUNT="${DEFAULT_ACCOUNT:-morayyan.abbasx@gmail.com}"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Exactly what becomes public. Anything not listed here — README.md, this
# script, .claude/ — stays off the site.
FILES=(index.html manifest.webmanifest sw.js icon.svg icon-192.png icon-512.png apple-touch-icon.png)

PROD=1
[[ "${1:-}" == "--draft" ]] && PROD=0

command -v netlify >/dev/null || { echo "netlify CLI not found: npm i -g netlify-cli" >&2; exit 1; }

STAGE="$(mktemp -d)"
SWITCHED=0
cleanup(){
  rm -rf "$STAGE"
  # always hand the CLI back, even if the deploy died halfway
  if (( SWITCHED )); then netlify switch --email "$DEFAULT_ACCOUNT" >/dev/null 2>&1 || true; fi
}
trap cleanup EXIT

for f in "${FILES[@]}"; do
  [[ -f "$ROOT/$f" ]] || { echo "Missing $f — refusing to deploy a partial site." >&2; exit 1; }
  cp "$ROOT/$f" "$STAGE/"
done

# Refuse to publish a build carrying a secret.
if grep -rqE 'gsk_[A-Za-z0-9]{20}|sk-ant-[A-Za-z0-9]{20}|nfp_[A-Za-z0-9]{20}' "$STAGE"; then
  echo "Aborting: an API key or token is present in the files to be deployed." >&2
  exit 1
fi

if netlify switch --email "$DEPLOY_ACCOUNT" >/dev/null 2>&1; then
  SWITCHED=1
else
  echo "Could not switch to $DEPLOY_ACCOUNT. Run 'netlify login' to authorise it." >&2
  exit 1
fi

echo "Deploying ${#FILES[@]} files as $DEPLOY_ACCOUNT$( ((PROD)) || echo ' (draft)' )…"

if ((PROD)); then
  netlify deploy --prod --dir "$STAGE" --site "$SITE_ID" --message "${*:-manual deploy}"
else
  netlify deploy --dir "$STAGE" --site "$SITE_ID" --message "draft"
fi

---
name: chrome-webstore-release-blueprint
description: Guide a user end-to-end through setting up Chrome Web Store API release automation in any repository. Use when asked to walk someone through OAuth/CWS credential setup, refresh token creation, local/CI secret setup, version-based publish automation, and submission status checks.
---

# Chrome Web Store Release Blueprint

Use this skill as a hands-on setup guide. Lead the user step-by-step, treating all Google/OAuth dashboard tasks as user-driven, giving one clear step at a time and waiting for confirmation before moving on. Ask for exact values only when needed and tell the user where each value comes from. Mask secrets in logs, never commit secret values to git, and prefer repeatable helper scripts over ad-hoc commands. If `gh` is available, offer secret upload automation; if not, provide a manual fallback.

## Step 1: Project Discovery (Before Any Credential Work)

Collect these inputs:

- manifest path containing extension version
- build command
- zip/package command and output file name/path
- CI platform (GitHub Actions by default)
- release branch policy (`main`, tags, or manual dispatch)
- local secret file convention (`.env`, `.env.local`, etc.)

Ask explicitly:
- "Do you want CI to publish only when version changes?"
- "Do you want me to wire GitHub secret upload via `gh`?"

## Step 2: Detailed Credential Walkthrough (User + Agent)

### 2.1 Enable API in Google Cloud

Open: `https://console.cloud.google.com/apis/library/chromewebstore.googleapis.com`

- [ ] Select the intended Google Cloud project
- [ ] Click `Enable` for Chrome Web Store API
- [ ] Confirm "Enabled" status before continuing

### 2.2 Configure OAuth Consent Screen

Open: `https://console.cloud.google.com/apis/credentials/consent`
(If UI redirects, continue in Google Auth Platform consent screen pages.)

- [ ] Choose `External` user type
- [ ] Fill app name, support email, developer contact email; save and continue through scopes
- [ ] Add your own Google account as a test user if app is in Testing mode

> For stable long-lived refresh token behavior, recommend moving consent screen to Production when ready.

### 2.3 Create OAuth Client

Open: `https://console.cloud.google.com/apis/credentials`

- [ ] Click `Create Credentials` → `OAuth client ID` → application type `Web application`
- [ ] Add authorized redirect URI exactly: `https://developers.google.com/oauthplayground`
- [ ] Save both values as `CWS_CLIENT_ID` and `CWS_CLIENT_SECRET`

Prompt: "Paste `CWS_CLIENT_ID` and `CWS_CLIENT_SECRET` when ready (I will treat them as secrets)."

### 2.4 Generate Refresh Token (OAuth Playground)

Open: `https://developers.google.com/oauthplayground/`

- [ ] Click the settings gear icon → enable `Use your own OAuth credentials` → paste `CWS_CLIENT_ID` and `CWS_CLIENT_SECRET`
- [ ] In Step 1, enter scope: `https://www.googleapis.com/auth/chromewebstore` → click `Authorize APIs`
- [ ] Sign in with the account that owns/publishes the extension
- [ ] Click `Exchange authorization code for tokens` → copy the refresh token as `CWS_REFRESH_TOKEN`

Prompt: "Paste `CWS_REFRESH_TOKEN` now. I will only place it in local secret storage/CI secrets."

### 2.5 Capture Store IDs

- `CWS_EXTENSION_ID` — item ID from the store/developer listing URL
- `CWS_PUBLISHER_ID` — developer/publisher ID from Chrome Web Store Developer Dashboard

If user is unsure, ask them to open the Developer Dashboard and copy IDs from item/account URLs or account details.

### 2.6 Credential Checklist

Do not proceed until all five exist:
- `CWS_CLIENT_ID`
- `CWS_CLIENT_SECRET`
- `CWS_REFRESH_TOKEN`
- `CWS_PUBLISHER_ID`
- `CWS_EXTENSION_ID`

## Step 3: Local Secret File and CI Secret Setup

Create a local template file (no real values committed):

```env
CWS_CLIENT_ID=
CWS_CLIENT_SECRET=
CWS_REFRESH_TOKEN=
CWS_PUBLISHER_ID=
CWS_EXTENSION_ID=
```

Ensure the real secret file path is gitignored.

If using GitHub Actions, ask user if `gh` automation is desired.

If yes, verify:

```bash
gh --version
gh auth status
```

If `gh` auth is missing, tell user to run `gh auth login`.

Implement the secret upload helper as `scripts/upload-secrets.sh` (full source below). Usage:

```bash
# Dry run (masks values)
DRY_RUN=true bash scripts/upload-secrets.sh .env.local

# Live upload to default repo
bash scripts/upload-secrets.sh .env.local

# Live upload to specific repo
REPO=owner/repo bash scripts/upload-secrets.sh .env.local
```

### `scripts/upload-secrets.sh`

```bash
#!/usr/bin/env bash
set -euo pipefail

ENV_FILE="${1:-.env.local}"
DRY_RUN="${DRY_RUN:-false}"
REPO="${REPO:-}"   # e.g. owner/repo; falls back to gh default

REQUIRED_KEYS=(CWS_CLIENT_ID CWS_CLIENT_SECRET CWS_REFRESH_TOKEN CWS_PUBLISHER_ID CWS_EXTENSION_ID)

# Load env file
if [[ ! -f "$ENV_FILE" ]]; then
  echo "ERROR: env file not found: $ENV_FILE" >&2; exit 1
fi
# shellcheck disable=SC1090
source "$ENV_FILE"

# Validate all keys are present and non-empty
for key in "${REQUIRED_KEYS[@]}"; do
  val="${!key:-}"
  if [[ -z "$val" ]]; then
    echo "ERROR: missing required secret: $key" >&2; exit 1
  fi
done

REPO_FLAG="${REPO:+--repo $REPO}"

for key in "${REQUIRED_KEYS[@]}"; do
  val="${!key}"
  if [[ "$DRY_RUN" == "true" ]]; then
    echo "[dry-run] would set $key=***"
  else
    # shellcheck disable=SC2086
    echo "$val" | gh secret set "$key" $REPO_FLAG
    echo "Uploaded: $key"
  fi
done
echo "Done."
```

If user declines `gh`, provide manual secret entry checklist for repository settings.

## Step 4: Release Workflow Blueprint (Version-Triggered)

### 4.1 Token Exchange

```bash
ACCESS_TOKEN=$(curl -s -X POST https://oauth2.googleapis.com/token \
  -d "client_id=${CWS_CLIENT_ID}" \
  -d "client_secret=${CWS_CLIENT_SECRET}" \
  -d "refresh_token=${CWS_REFRESH_TOKEN}" \
  -d "grant_type=refresh_token" \
  | jq -r '.access_token')
```

### 4.2 Fetch Published Version

```bash
STATUS=$(curl -s \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  "https://chromewebstore.googleapis.com/v2/publishers/${CWS_PUBLISHER_ID}/items/${CWS_EXTENSION_ID}:fetchStatus")

PUBLISHED_VERSION=$(echo "$STATUS" \
  | jq -r '.publishedItemRevisionStatus.distributionChannels[0].crxVersion // empty')
```

### 4.3 Version Comparison and Publish

```bash
LOCAL_VERSION=$(jq -r '.version' "$MANIFEST_PATH")

if [[ "$LOCAL_VERSION" == "$PUBLISHED_VERSION" ]]; then
  echo "Version unchanged ($LOCAL_VERSION). Skipping publish."
  exit 0
fi

echo "Version changed: $PUBLISHED_VERSION → $LOCAL_VERSION. Building and publishing..."

# Build and package
eval "$BUILD_CMD"
eval "$ZIP_CMD"   # produces $ZIP_PATH

# Upload
curl -s -X POST \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Content-Type: application/zip" \
  --data-binary "@${ZIP_PATH}" \
  "https://chromewebstore.googleapis.com/upload/v2/publishers/${CWS_PUBLISHER_ID}/items/${CWS_EXTENSION_ID}:upload"

# Publish
curl -s -X POST \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  "https://chromewebstore.googleapis.com/v2/publishers/${CWS_PUBLISHER_ID}/items/${CWS_EXTENSION_ID}:publish"
```

Treat these states as successful submission: `PENDING_REVIEW`, `PUBLISHED`, `PUBLISHED_TO_TESTERS`, `STAGED`.

## Step 5: Submission Status Checker Blueprint

Implement the status checker as `scripts/cws-status.sh` (full source below). Usage:

```bash
# Human-readable summary
bash scripts/cws-status.sh --env-file .env.local --manifest src/manifest.json

# JSON output (for CI or jq piping)
bash scripts/cws-status.sh --env-file .env.local --manifest src/manifest.json --json
```

### `scripts/cws-status.sh`

```bash
#!/usr/bin/env bash
set -euo pipefail

ENV_FILE="${ENV_FILE:-.env.local}"
MANIFEST="${MANIFEST:-}"
JSON_OUTPUT="${JSON:-false}"

# Parse flags
while [[ $# -gt 0 ]]; do
  case "$1" in
    --env-file) ENV_FILE="$2"; shift 2 ;;
    --manifest) MANIFEST="$2"; shift 2 ;;
    --json)     JSON_OUTPUT=true; shift ;;
    *) echo "Unknown flag: $1" >&2; exit 1 ;;
  esac
done

# shellcheck disable=SC1090
source "$ENV_FILE"

# Token exchange
ACCESS_TOKEN=$(curl -s -X POST https://oauth2.googleapis.com/token \
  -d "client_id=${CWS_CLIENT_ID}" \
  -d "client_secret=${CWS_CLIENT_SECRET}" \
  -d "refresh_token=${CWS_REFRESH_TOKEN}" \
  -d "grant_type=refresh_token" \
  | jq -r '.access_token')

[[ -z "$ACCESS_TOKEN" || "$ACCESS_TOKEN" == "null" ]] && { echo "ERROR: token exchange failed" >&2; exit 1; }

# Fetch status
STATUS=$(curl -s \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  "https://chromewebstore.googleapis.com/v2/publishers/${CWS_PUBLISHER_ID}/items/${CWS_EXTENSION_ID}:fetchStatus")

PUBLISHED_VERSION=$(echo "$STATUS" | jq -r '.publishedItemRevisionStatus.distributionChannels[0].crxVersion // empty')
PUBLISHED_STATE=$(echo  "$STATUS" | jq -r '.publishedItemRevisionStatus.status // empty')
SUBMITTED_VERSION=$(echo "$STATUS" | jq -r '.pendingItemRevisionStatus.crxVersion // empty')
SUBMITTED_STATE=$(echo  "$STATUS" | jq -r '.pendingItemRevisionStatus.status // empty')
LOCAL_VERSION=""
if [[ -n "$MANIFEST" ]]; then
  LOCAL_VERSION=$(jq -r '.version' "$MANIFEST")
fi

UP_TO_DATE="false"
[[ -n "$LOCAL_VERSION" && "$LOCAL_VERSION" == "$PUBLISHED_VERSION" ]] && UP_TO_DATE="true"
PENDING_REVIEW="false"
[[ "$SUBMITTED_STATE" == "PENDING_REVIEW" ]] && PENDING_REVIEW="true"

if [[ "$JSON_OUTPUT" == "true" ]]; then
  jq -n \
    --arg itemId        "$CWS_EXTENSION_ID" \
    --arg localVersion  "$LOCAL_VERSION" \
    --arg publishedVersion "$PUBLISHED_VERSION" \
    --arg publishedState   "$PUBLISHED_STATE" \
    --arg submittedVersion "$SUBMITTED_VERSION" \
    --arg submittedState   "$SUBMITTED_STATE" \
    --argjson upToDate     "$UP_TO_DATE" \
    --argjson pendingReview "$PENDING_REVIEW" \
    '{itemId:$itemId,localVersion:$localVersion,publishedVersion:$publishedVersion,
      publishedState:$publishedState,submittedVersion:$submittedVersion,
      submittedState:$submittedState,upToDate:$upToDate,pendingReview:$pendingReview}'
else
  echo "Extension : $CWS_EXTENSION_ID"
  [[ -n "$LOCAL_VERSION" ]] && echo "Local ver  : $LOCAL_VERSION"
  echo "Published  : ${PUBLISHED_VERSION} (${PUBLISHED_STATE})"
  [[ -n "$SUBMITTED_VERSION" ]] && echo "Submitted  : ${SUBMITTED_VERSION} (${SUBMITTED_STATE})"
  echo "Up-to-date : $UP_TO_DATE  |  Pending review: $PENDING_REVIEW"
fi
```

## Step 6: Guided Verification Flow

Run this with the user:

1. Confirm status checker runs successfully before release.
2. Bump extension version (patch) in all version sources.
3. Push branch and trigger workflow.
4. Confirm workflow either skips (no version change) or uploads and submits.
5. Re-run status checker — expect `PENDING_REVIEW` first, then published channel matching local version.

## Troubleshooting

| Symptom | Likely cause |
|---|---|
| `invalid_grant` | Wrong/expired refresh token, wrong OAuth client, or wrong account |
| `403` from CWS endpoint | Account lacks publisher permissions for that extension |
| Workflow no-op | Local version equals published version by design |
| Upload failure | Inspect API response and packaged zip structure/manifest validity |
| Version mismatch guard failure | Align all declared version files before publishing |

## Practical Links (Share During Guidance)

- Chrome Web Store API overview: `https://developer.chrome.com/docs/webstore/using-api`
- Publish endpoint: `https://developer.chrome.com/docs/webstore/publish`
- OAuth Playground: `https://developers.google.com/oauthplayground/`
- API enablement page: `https://console.cloud.google.com/apis/library/chromewebstore.googleapis.com`
- Credentials page: `https://console.cloud.google.com/apis/credentials`

## Guardrails

- Never commit credentials.
- Never hardcode secrets in workflow YAML.
- Never auto-publish every push without version comparison.
- Keep setup instructions explicit and user-confirmed at each manual step.
- Prefer repeatable helper scripts over ad-hoc one-off commands.

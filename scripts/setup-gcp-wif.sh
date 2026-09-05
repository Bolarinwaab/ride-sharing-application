#!/usr/bin/env bash
set -euo pipefail

PROJECT_ID="${PROJECT_ID:-ancient-alloy-316217}"
PROJECT_NUMBER="${PROJECT_NUMBER:-962773652580}"
POOL_ID="${POOL_ID:-abiodun-bolarinwa}"
PROVIDER_ID="${PROVIDER_ID:-github-actions}"
DEPLOYER_SA="${DEPLOYER_SA:-github-actions-deployer@${PROJECT_ID}.iam.gserviceaccount.com}"
OWNER="${OWNER:-Bolarinwaab}"

command -v gcloud >/dev/null 2>&1 || { echo "gcloud CLI is required" >&2; exit 1; }

echo "== Checking project =="
gcloud projects describe "${PROJECT_ID}" --format='value(projectId)' >/dev/null

echo "== Checking workload identity pool =="
gcloud iam workload-identity-pools describe "${POOL_ID}" \
  --location=global \
  --project="${PROJECT_ID}" \
  --format='value(name)' || {
    echo "ERROR: pool '${POOL_ID}' was not found in project '${PROJECT_ID}'." >&2
    echo "Run: gcloud iam workload-identity-pools list --location=global --project='${PROJECT_ID}'" >&2
    exit 2
  }

echo "== Checking provider =="
gcloud iam workload-identity-pools providers describe "${PROVIDER_ID}" \
  --workload-identity-pool="${POOL_ID}" \
  --location=global \
  --project="${PROJECT_ID}" \
  --format='value(name)' >/dev/null

echo "== Granting repository-scoped impersonation =="
for REPO in ride-sharing-application online-shopping-platform; do
  gcloud iam service-accounts add-iam-policy-binding "${DEPLOYER_SA}" \
    --project="${PROJECT_ID}" \
    --role=roles/iam.workloadIdentityUser \
    --member="principalSet://iam.googleapis.com/projects/${PROJECT_NUMBER}/locations/global/workloadIdentityPools/${POOL_ID}/attribute.repository/${OWNER}/${REPO}"
done

echo "== Granting deployment permissions =="
gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
  --member="serviceAccount:${DEPLOYER_SA}" \
  --role=roles/artifactregistry.writer

gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
  --member="serviceAccount:${DEPLOYER_SA}" \
  --role=roles/run.admin

echo "WIF bootstrap complete. Configure the GitHub Actions variables/secrets documented in docs/gcp-github-actions.md."

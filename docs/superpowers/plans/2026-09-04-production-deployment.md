# Production Deployment Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Provide a repeatable GitHub Actions deployment path from the main branch to Google Cloud Run without placing cloud credentials or application secrets in the repository.

**Architecture:** GitHub Actions authenticates to Google Cloud with Workload Identity Federation, builds the production container, pushes it to Artifact Registry, and deploys it to Cloud Run. Runtime secrets remain in Google Secret Manager and GitHub only stores non-secret configuration plus the WIF references required for deployment.

**Tech Stack:** GitHub Actions, Google Cloud Workload Identity Federation, Artifact Registry, Cloud Run, Docker, Terraform, Secret Manager.

**Spec:** `docs/integrations.md`, `docs/operations-runbook.md`, `docs/disaster-recovery.md`

## Global Constraints

- Never commit live API keys, passwords, private keys, or service-account JSON files.
- Production deployment requires an authorized Google Cloud project and configured GitHub WIF secrets/variables.
- Cloud Run must use the production container and `/healthz` and `/readyz` probes already defined by the service.
- Production configuration must be supplied through GitHub Actions variables and Google Secret Manager.

---

### Task 1: Add production deployment workflow

**Files:**
- Create: `.github/workflows/deploy-production.yml`

**Interfaces:**
- Consumes: GitHub `WIF_PROVIDER`, `WIF_SERVICE_ACCOUNT`, `GCP_PROJECT_ID`, and `GCP_REGION` configuration plus the existing production Dockerfile.
- Produces: a versioned Artifact Registry image and Cloud Run deployment for `ridenow-api`.

- [x] Add workflow triggered by pushes to `main` and manual dispatch.
- [x] Authenticate with `google-github-actions/auth@v2` using WIF.
- [x] Configure Docker for Artifact Registry.
- [x] Build and push `Dockerfile.production`.
- [x] Deploy the image to Cloud Run.
- [x] Leave live secrets outside source control.

### Task 2: Operational verification

**Files:**
- Existing: `docs/operations-runbook.md`

- [ ] Configure the Google Cloud project and WIF trust.
- [ ] Configure required Secret Manager versions.
- [ ] Trigger the deployment from GitHub.
- [ ] Verify Cloud Run revision health and `/healthz`/`/readyz`.
- [ ] Verify application integrations in staging/production before accepting live traffic.

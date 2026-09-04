# RideNow Operations Runbook

## Health
- `/healthz` verifies process health.
- `/readyz` is used by Cloud Run readiness checks.

## Deploy
Build the container, push it to Artifact Registry, apply the reviewed Terraform plan, then verify readiness and smoke-test authentication, ride creation and payment webhook handling.

## Rollback
Deploy the previous immutable container image and preserve the database migration version. Never roll back a schema destructively; use forward-compatible migrations.

## Incidents
Check Cloud Logging using `X-Correlation-ID`, then inspect provider errors, database saturation, Cloud Run instance health and payment webhook delivery. Disable affected integration traffic before changing persistent state.

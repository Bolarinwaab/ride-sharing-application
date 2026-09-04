# RideNow Production Readiness Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a secure, tested and deployment-ready RideNow API with real provider integrations and GCP operations.

**Architecture:** Keep the current Node.js/domain structure, add focused infrastructure adapters, PostgreSQL/PostGIS persistence, secure middleware and production configuration. Use provider interfaces so tests remain deterministic and production credentials are runtime-only.

**Tech Stack:** Node.js, PostgreSQL/PostGIS, Firebase Admin, Stripe, Google Maps Platform, Firestore/Pub/Sub adapters, Docker, Terraform, GitHub Actions.

**Spec:** `docs/superpowers/specs/2026-09-04-ridenow-production-readiness-design.md`

## Global Constraints
- No secrets or production credentials in Git.
- Payment card data never enters the application database.
- Every external integration has a testable adapter boundary.
- State-changing APIs must support idempotency where duplicate requests are harmful.
- Production deployment requires health/readiness checks and automated tests.

---

### Task 1: Production configuration and HTTP foundation
**Files:** Create `src/config.js`, `src/http.js`, `src/middleware/security.js`, `test/config.test.js`, `test/http.test.js`; modify `package.json`.
- [ ] Write failing configuration and health/readiness tests.
- [ ] Run tests and confirm RED.
- [ ] Implement validated environment configuration, correlation IDs, security headers, CORS and rate limiting.
- [ ] Run tests and confirm GREEN.
- [ ] Commit configuration foundation.

### Task 2: PostgreSQL/PostGIS persistence
**Files:** Create `database/migrations/001_production.sql`, `database/seed.sql`, `src/db.js`, `src/repositories/rideRepository.js`, `test/rideRepository.test.js`.
- [ ] Write failing repository tests for ride creation, driver availability and nearby-driver lookup.
- [ ] Confirm RED.
- [ ] Implement parameterized SQL, transactions, PostGIS geography indexes and constraints.
- [ ] Confirm GREEN with isolated DB tests/fakes where a live DB is unavailable.
- [ ] Commit persistence layer.

### Task 3: Ride lifecycle and matching
**Files:** Create `src/services/rideService.js`, `src/services/matchingService.js`, `test/rideService.test.js`, `test/matchingService.test.js`.
- [ ] Write tests for idempotent ride creation, legal state transitions and nearest available driver selection.
- [ ] Confirm RED.
- [ ] Implement transaction-aware services and repository interfaces.
- [ ] Confirm GREEN.
- [ ] Commit domain workflow.

### Task 4: Identity integration
**Files:** Create `src/integrations/identity/firebaseVerifier.js`, `src/middleware/auth.js`, `test/auth.test.js`, `.env.example` update.
- [ ] Write failing tests for valid token, expired token and missing token.
- [ ] Confirm RED.
- [ ] Implement Firebase Admin verification with dependency injection for tests.
- [ ] Confirm GREEN.
- [ ] Commit identity integration.

### Task 5: Maps/routing integration
**Files:** Create `src/integrations/maps/googleMapsProvider.js`, `src/services/routeService.js`, `test/mapsProvider.test.js`.
- [ ] Write failing adapter tests for geocoding and route/fare inputs.
- [ ] Confirm RED.
- [ ] Implement authenticated Google Maps HTTP adapter with timeouts and bounded retries.
- [ ] Confirm GREEN using mocked HTTP transport.
- [ ] Commit Maps integration.

### Task 6: Stripe payments and webhooks
**Files:** Create `src/integrations/payments/stripeProvider.js`, `src/routes/paymentWebhook.js`, `src/services/paymentService.js`, `test/paymentService.test.js`, `test/paymentWebhook.test.js`.
- [ ] Write tests for idempotency, successful payment and invalid webhook signature.
- [ ] Confirm RED.
- [ ] Implement Stripe PaymentIntent creation and signature-verified webhook handling.
- [ ] Confirm GREEN.
- [ ] Commit payment integration.

### Task 7: Notifications and realtime trip state
**Files:** Create `src/integrations/notifications/index.js`, `src/integrations/notifications/fcmProvider.js`, `src/integrations/notifications/emailProvider.js`, `src/integrations/notifications/smsProvider.js`, `src/integrations/realtime/firestoreTripPublisher.js`, tests.
- [ ] Write provider-contract tests.
- [ ] Confirm RED.
- [ ] Implement replaceable providers with no-op/fake defaults for tests.
- [ ] Confirm GREEN.
- [ ] Commit notifications/realtime.

### Task 8: API assembly and OpenAPI
**Files:** Create/modify `src/app.js`, route modules and `docs/openapi.yaml`, `test/api.test.js`.
- [ ] Write API tests for authenticated ride request, driver acceptance, location update and payment creation.
- [ ] Confirm RED.
- [ ] Wire middleware/services/routes and OpenAPI contracts.
- [ ] Confirm GREEN.
- [ ] Commit API assembly.

### Task 9: Docker, CI and security scanning
**Files:** Modify `Dockerfile`, `.dockerignore`, `.github/workflows/ci.yml`; create `scripts/healthcheck.js`.
- [ ] Add failing CI gates for test/lint/type/security checks as appropriate.
- [ ] Implement multi-stage non-root image and deterministic CI.
- [ ] Run local test suite and Docker build if available.
- [ ] Commit delivery pipeline.

### Task 10: Terraform/GCP deployment baseline
**Files:** Create `infra/terraform/main.tf`, `infra/terraform/variables.tf`, `infra/terraform/outputs.tf`, `infra/terraform/modules/*`, `infra/cloudrun/*`, `docs/deployment.md`.
- [ ] Add validation checks for required project/region variables.
- [ ] Implement VPC, Artifact Registry, Cloud Run, Cloud SQL, Secret Manager bindings, logging/monitoring baseline and least-privilege service accounts.
- [ ] Validate Terraform formatting/plan syntax without applying resources.
- [ ] Commit infrastructure.

### Task 11: Operations, DR and final verification
**Files:** Create `docs/runbook.md`, `docs/integration-setup.md`, `docs/dr-plan.md`, `docs/security.md`.
- [ ] Document provider setup, secret names, migrations, rollback, backups/PITR, alerts and incident response.
- [ ] Run complete test suite and inspect GitHub Actions status.
- [ ] Verify no secret-like values are committed.
- [ ] Commit operational readiness and verify remote repository state.

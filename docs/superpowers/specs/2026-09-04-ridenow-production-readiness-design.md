# RideNow Production Readiness Design

## Goal
Turn the existing RideNow portfolio application into a deployment-ready cloud-native service with real integration boundaries for identity, maps/routing, payments, notifications, persistence, observability, and secure operations.

## Architecture
The application will use a Node.js API with a PostgreSQL/PostGIS transactional store for the first production deployment, while preserving the documented GCP scale-out path for Firestore/Bigtable, Pub/Sub and Spanner where workload growth requires them. External providers are isolated behind adapters so local tests use deterministic fakes and production uses environment/Secret Manager configuration.

Authentication uses Firebase/Google Identity Platform token verification rather than storing passwords. Stripe handles payment intents and signed webhooks. Google Maps Platform provides geocoding and routes. Firebase/Firestore can provide realtime trip state updates, while email/SMS/push notification providers remain replaceable adapters.

## Required capabilities
- Configuration validation with fail-fast startup and no committed secrets.
- Health/readiness endpoints and structured logging.
- Request validation, security headers, CORS allowlist and rate limiting.
- Idempotency for ride creation and payment operations.
- Transaction-safe driver availability and ride state transitions.
- PostGIS-backed nearby-driver matching.
- Google Maps Routes/Geocoding adapter.
- Stripe payment adapter and webhook verification.
- Notification provider interfaces.
- PostgreSQL migrations, indexes and seed data.
- Docker hardening and CI checks.
- Terraform/GCP deployment baseline with Secret Manager references.
- Unit, integration and API contract tests.
- Operational runbook, SLOs, DR and integration setup documentation.

## Security constraints
No API keys, payment secrets, service-account private keys, passwords or production tokens may be committed. Secrets are injected at runtime through environment variables or GCP Secret Manager. Payment card data never enters the application database.

## Production activation boundary
The repository will be production-ready and deployment-ready. Actual live activation still requires the operator's GCP project/billing account, domain, provider accounts and credentials, which must be supplied through secure secret configuration outside Git.

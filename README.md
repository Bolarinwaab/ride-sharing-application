# Ride Sharing Application

Cloud-native ride-sharing portfolio project (RideNow) with a React/TypeScript frontend, Node.js/Express API, PostgreSQL-compatible data model, security, reliability, CI/CD, and a Google Cloud Architect design workbook.

## Architecture

The solution is designed for multi-region deployment with global HTTPS load balancing, Cloud Armor, private services, transactional data stores, high-volume location data, analytics, backups, and disaster recovery.

## Documentation

- `docs/google-cloud-architect-workbook.md` — complete architecture/design workbook
- `docs/architecture.md` — system and reliability architecture
- `docs/api.md` — REST API contract

## Portfolio note

External maps, payments, messaging, and navigation integrations are represented by secure adapters/mock boundaries. No production credentials or third-party secrets are included.

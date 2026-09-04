# RideNow Architecture

## Runtime
Global HTTPS Load Balancer -> Cloud Armor -> API Gateway -> private services in two regions. Stateless APIs autoscale across zones. Pub/Sub decouples notifications and analytics.

## Data
Cloud SQL stores identity/profile data; Spanner stores critical ride transactions; Bigtable/Firestore supports high-volume location and matching data; BigQuery provides analytics; Cloud Storage stores backups/assets.

## Reliability
Multi-zone deployment, health checks, autoscaling, global traffic management, multi-region transactional data, replicated telemetry and tested recovery procedures.

## Security
TLS, least-privilege IAM/service accounts, private databases, Secret Manager, firewall segmentation, controlled egress, audit logging and Cloud Armor. Secrets are never committed.

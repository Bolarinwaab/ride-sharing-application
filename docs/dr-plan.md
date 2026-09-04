# RideNow Disaster Recovery Plan

Primary workload: GCP region configured by Terraform. Critical transactional data is PostgreSQL/PostGIS with automated backups and point-in-time recovery. Externalized location/realtime workloads may be restored from Firestore/Bigtable replication as the architecture scales.

Targets from the architecture workbook: critical ride/auth services target RPO near-zero to 5 minutes and RTO 5–10 minutes; analytics and non-critical data may use longer recovery windows.

Recovery sequence: establish healthy GCP runtime -> restore/validate database -> rotate/verify secrets -> validate identity/maps/payment providers -> enable traffic -> run smoke tests -> monitor error rate and latency.

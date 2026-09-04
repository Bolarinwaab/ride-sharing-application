# RideNow REST API

Base path: `/api/v1`. JSON over HTTPS. Bearer authentication is required except login/refresh.

| Resource | Methods |
|---|---|
| `/auth/login` | POST |
| `/auth/refresh` | POST |
| `/riders`, `/riders/{id}` | GET, POST, PATCH |
| `/drivers`, `/drivers/{id}` | GET, POST, PATCH |
| `/drivers/{id}/availability` | GET, POST, PATCH |
| `/rides`, `/rides/{id}` | GET, POST, PATCH |
| `/matches` | GET, POST |
| `/fares/estimate` | POST |
| `/drivers/{id}/location` | GET, POST |
| `/payments` | GET, POST |
| `/rides/{id}/rating` | GET, POST |
| `/notifications` | GET, POST |
| `/tickets`, `/tickets/{id}` | GET, POST, PATCH |
| `/events` | POST |

Design rules: idempotency keys for ride creation/payment operations, pagination on collections, structured errors, correlation IDs, rate limiting and audit events.

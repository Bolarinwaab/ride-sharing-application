# RideNow Integration Setup

## Required production services
1. Google Cloud project with Cloud Run, Artifact Registry, Cloud SQL/PostGIS and Secret Manager enabled.
2. Firebase/Google Identity Platform project for user authentication.
3. Google Maps Platform project with Routes API and Geocoding API enabled.
4. Stripe account with PaymentIntents and webhook endpoint configured.
5. Optional FCM/Firestore and email/SMS providers for realtime and notifications.

## Secret names
Inject `DATABASE_URL`, `FIREBASE_PROJECT_ID`, `STRIPE_SECRET_KEY`, `STRIPE_WEBHOOK_SECRET`, `GOOGLE_MAPS_API_KEY`, `FCM_PROJECT_ID` and `FIRESTORE_PROJECT_ID` at runtime. Do not place real values in `.env.example`, source code or GitHub.

## Payment flow
Client creates a payment request -> server creates Stripe PaymentIntent with an idempotency key -> Stripe sends a signed webhook -> server verifies signature -> order/ride state is updated exactly once.

## Maps flow
Client supplies pickup/destination -> server calls Routes API -> route distance/duration are used for ETA/fare estimation. Geocoding is performed server-side when addresses need coordinates.

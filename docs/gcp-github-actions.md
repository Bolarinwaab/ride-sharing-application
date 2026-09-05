# GCP + GitHub Actions Deployment

This project uses GitHub Actions OIDC with Google Cloud Workload Identity Federation. No service-account JSON key is required.

## Expected GCP resources

- Project ID: `ancient-alloy-316217`
- Project number: `962773652580`
- Workload Identity Pool: `abiodun-bolarinwa`
- OIDC provider: `github-actions`
- Deployment service account: `github-actions-deployer@ancient-alloy-316217.iam.gserviceaccount.com`
- Region: `us-central1`
- Cloud Run service: `ridenow-api`
- Artifact Registry repository: `ridenow`

## Bootstrap

Run from Google Cloud Shell while authenticated as a project administrator:

```bash
bash scripts/setup-gcp-wif.sh
```

The script deliberately verifies that the pool exists before changing IAM. This prevents the common `Identity Pool does not exist` error caused by using the wrong project or pool resource.

## GitHub Actions configuration

Repository: `Bolarinwaab/ride-sharing-application`

Actions variables:

- `GCP_PROJECT_ID=ancient-alloy-316217`
- `GCP_REGION=us-central1`

Actions secrets:

- `WIF_PROVIDER=projects/962773652580/locations/global/workloadIdentityPools/abiodun-bolarinwa/providers/github-actions`
- `WIF_SERVICE_ACCOUNT=github-actions-deployer@ancient-alloy-316217.iam.gserviceaccount.com`

The workflow requires `id-token: write` and exchanges the GitHub OIDC token through `google-github-actions/auth@v2`.

## ShopCloud

Apply the same WIF bootstrap to `Bolarinwaab/online-shopping-platform`. The script grants repository-scoped access for both repositories. ShopCloud uses Cloud Run service `shopcloud-api` and Artifact Registry repository `shopcloud`.

## Deployment flow

1. GitHub Actions requests a short-lived OIDC token.
2. Google Cloud validates the GitHub identity against the workload identity provider and repository attribute.
3. The deployment service account is impersonated.
4. Docker image is built and pushed to Artifact Registry.
5. Cloud Run is deployed.
6. The service URL is printed by the workflow.

Never commit a GCP service-account private key or other long-lived credential.

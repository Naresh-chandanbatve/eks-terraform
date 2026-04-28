# 🚀 CI/CD Pipeline

The pipeline is built with **GitHub Actions** and handles the full lifecycle from code push to production deployment.

---

## Pipeline Overview

```
  Developer pushes to main
          │
          ▼
  ┌───────────────────┐
  │   Build Stage     │  → Docker build (frontend + backend)
  └────────┬──────────┘
           │
           ▼
  ┌───────────────────┐
  │   Tag & Push      │  → Tag with commit SHA → Push to ECR
  └────────┬──────────┘
           │
           ▼
  ┌───────────────────┐
  │   Deploy Stage    │  → helm upgrade --install → EKS
  └───────────────────┘
```

---

## Workflow File

```yaml
# .github/workflows/deploy.yaml

name: Build & Deploy to EKS

on:
  push:
    branches: [main]

env:
  AWS_REGION: us-east-1
  ECR_REGISTRY: ${{ secrets.ECR_REGISTRY }}
  CLUSTER_NAME: eks-dev-cluster

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: ${{ env.AWS_REGION }}

      - name: Login to Amazon ECR
        uses: aws-actions/amazon-ecr-login@v2

      - name: Set image tag
        run: echo "IMAGE_TAG=sha-$(echo $GITHUB_SHA | cut -c1-7)" >> $GITHUB_ENV

      - name: Build & push frontend
        run: |
          docker build -t $ECR_REGISTRY/frontend:$IMAGE_TAG ./frontend
          docker push $ECR_REGISTRY/frontend:$IMAGE_TAG

      - name: Build & push backend
        run: |
          docker build -t $ECR_REGISTRY/backend:$IMAGE_TAG ./backend
          docker push $ECR_REGISTRY/backend:$IMAGE_TAG

      - name: Update kubeconfig
        run: |
          aws eks update-kubeconfig \
            --name $CLUSTER_NAME \
            --region $AWS_REGION

      - name: Deploy via Helm
        run: |
          helm upgrade --install app ./helm/app \
            --namespace default \
            -f helm/app/values.dev.yaml \
            --set frontend.image.tag=$IMAGE_TAG \
            --set backend.image.tag=$IMAGE_TAG \
            --atomic \
            --timeout 120s
```

---

## Design Decisions

### Commit SHA Tagging

Every image is tagged with the short commit SHA (e.g., `sha-a3f9c12`).

- Full traceability: any running pod can be traced back to the exact commit
- Prevents accidental `latest` tag collisions across environments
- Easy to identify which code is deployed: `kubectl get pods -o yaml | grep image`

### `--atomic` Flag in Helm

If the deployment fails health checks, Helm **automatically rolls back** to the previous revision.

- No manual intervention needed on failed deploys
- Previous release is always in a known-good state
- `--timeout 120s` ensures CI fails fast rather than hanging

### No Environment Promotion (Dev Only)

This pipeline deploys directly to dev. In a production setup, the flow would be:

```
main → dev (auto) → staging (auto, after tests) → prod (manual approval)
```

---

## Required GitHub Secrets

| Secret                  | Description                                                          |
| ----------------------- | -------------------------------------------------------------------- |
| `AWS_ACCESS_KEY_ID`     | IAM user with ECR push + EKS deploy permissions                      |
| `AWS_SECRET_ACCESS_KEY` | Corresponding secret key                                             |
| `ECR_REGISTRY`          | ECR registry URL (e.g., `123456789.dkr.ecr.us-east-1.amazonaws.com`) |

---

## Rollback

To manually roll back to a previous Helm release:

```bash
# List revision history
helm history app -n default

# Roll back to specific revision
helm rollback app 3 -n default
```

To roll back to a specific image:

```bash
kubectl set image deployment/frontend \
  frontend=<ECR_URL>/frontend:sha-<previous-sha> \
  -n default
```

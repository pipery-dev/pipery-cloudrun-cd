# <img src="https://raw.githubusercontent.com/pipery-dev/pipery-cloudrun-cd/main/assets/icon.png" alt="Pipery Cloud Run CD" width="28" align="center" /> Pipery Cloud Run CD

Reusable GitHub Action for Google Cloud Run deployment with structured logging via [Pipery](https://pipery.dev).

[![GitHub Marketplace](https://img.shields.io/badge/Marketplace-Pipery%20Cloud%20Run%20CD-blue?logo=github)](https://github.com/marketplace/actions/pipery-cloudrun-cd)
[![Version](https://img.shields.io/badge/version-1.0.0-blue)](CHANGELOG.md)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## Table of Contents

- [Quick Start](#quick-start)
- [Pipeline Overview](#pipeline-overview)
- [Configuration Options](#configuration-options)
- [Usage Examples](#usage-examples)
- [GitLab CI](#gitlab-ci)
- [Bitbucket Pipelines](#bitbucket-pipelines)
- [About Pipery](#about-pipery)
- [Development](#development)

## Quick Start

```yaml
name: Deploy
on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pipery-dev/pipery-cloudrun-cd@v1
        with:
          image_name: gcr.io/my-project/my-service
          image_tag: ${{ github.sha }}
          service_name: my-service
          region: us-central1
          project_id: my-project
```

## Pipeline Overview

| Step | Description | Skip Input |
| --- | --- | --- |
| Push | Push Docker image to Artifact Registry | `skip_push` |
| Deploy | Deploy to Cloud Run service | `skip_deploy` |
| Status check | Verify service health | `skip_status_check` |

## Configuration Options

| Name | Default | Description |
| --- | --- | --- |
| `project_path` | `.` | Path to the project source tree. |
| `config_file` | `.pipery/config.yaml` | Path to Pipery config file. |
| `image_name` | `` | Container image name to deploy (e.g., `ghcr.io/org/app`). |
| `image_tag` | `${{ github.sha }}` | Container image tag to deploy. |
| `service_name` | `` | Cloud Run service name. |
| `region` | `us-central1` | Google Cloud Run region. |
| `project_id` | `` | Google Cloud project ID. |
| `platform` | `managed` | Target platform: `managed` or `gke`. |
| `traffic` | `100` | Percentage of traffic to route to new revision (0-100). |
| `min_instances` | `0` | Minimum number of Cloud Run instances. |
| `max_instances` | `100` | Maximum number of Cloud Run instances. |
| `concurrency` | `80` | Maximum concurrent requests per instance. |
| `log_file` | `pipery.jsonl` | Path to write the JSONL log file. |
| `skip_push` | `false` | Skip image push step. |
| `skip_deploy` | `false` | Skip deploy step. |
| `skip_status_check` | `false` | Skip health check step. |

## Usage Examples

### Example 1: Basic Cloud Run deployment

```yaml
name: Deploy
on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pipery-dev/pipery-cloudrun-cd@v1
        with:
          image_name: gcr.io/my-project/my-service
          image_tag: ${{ github.sha }}
          service_name: my-service
          region: us-central1
          project_id: my-project
```

### Example 2: With custom scaling and concurrency

```yaml
- uses: pipery-dev/pipery-cloudrun-cd@v1
  with:
    image_name: gcr.io/my-project/my-service
    image_tag: ${{ github.sha }}
    service_name: my-service
    region: us-central1
    project_id: my-project
    min_instances: "2"
    max_instances: "50"
    concurrency: "100"
```

### Example 3: Blue-green deployment with gradual traffic shift

```yaml
- uses: pipery-dev/pipery-cloudrun-cd@v1
  with:
    image_name: gcr.io/my-project/my-service
    image_tag: ${{ github.sha }}
    service_name: my-service
    region: us-west1
    project_id: my-project
    traffic: "50"
```

### Example 4: Multiple regions deployment

```yaml
- uses: pipery-dev/pipery-cloudrun-cd@v1
  with:
    image_name: gcr.io/my-project/my-service
    image_tag: ${{ github.sha }}
    service_name: my-service-us
    region: us-central1
    project_id: my-project

- uses: pipery-dev/pipery-cloudrun-cd@v1
  with:
    image_name: gcr.io/my-project/my-service
    image_tag: ${{ github.sha }}
    service_name: my-service-eu
    region: europe-west1
    project_id: my-project
```

### Example 5: GKE-hosted Cloud Run

```yaml
- uses: pipery-dev/pipery-cloudrun-cd@v1
  with:
    image_name: gcr.io/my-project/my-service
    image_tag: ${{ github.sha }}
    service_name: my-service
    region: us-central1
    project_id: my-project
    platform: gke
```

### Example 6: Skip health checks for faster deployment

```yaml
- uses: pipery-dev/pipery-cloudrun-cd@v1
  with:
    image_name: gcr.io/my-project/my-service
    image_tag: ${{ github.sha }}
    service_name: my-service
    region: us-central1
    project_id: my-project
    skip_status_check: true
```

## GitLab CI

This repository includes a GitLab CI equivalent at `.gitlab-ci.yml`. Copy it into a GitLab project or use it as a reference implementation for running the same Pipery pipeline outside GitHub Actions.

The GitLab pipeline maps action inputs to CI/CD variables, publishes `pipery.jsonl` as an artifact, and maintains the same skip controls. Store credentials as protected GitLab CI/CD variables.

```yaml
include:
  - remote: https://raw.githubusercontent.com/pipery-dev/pipery-cloudrun-cd/v1/.gitlab-ci.yml
```

### GitLab CI Variables

Configure these protected variables in **Settings > CI/CD > Variables**:

- `GCLOUD_SERVICE_KEY_BASE64` - GCP service account key (base64-encoded)
- `GCP_PROJECT_ID` - Google Cloud project ID
- `CLOUDRUN_SERVICE` - Cloud Run service name
- `CLOUDRUN_REGION` - Deployment region (default: us-central1)

## Bitbucket Pipelines

Bitbucket Cloud pipelines provide an alternative to GitHub Actions. The equivalent pipeline configuration is in `bitbucket-pipelines.yml`.

### Getting Started

1. Copy `bitbucket-pipelines.yml` to your Bitbucket repository root
2. Configure Protected Variables in **Repository Settings > Pipelines > Repository Variables**:
   - `GCLOUD_SERVICE_KEY_BASE64` - GCP service account key
   - `GCP_PROJECT_ID` - Google Cloud project ID
   - `CLOUDRUN_SERVICE` - Cloud Run service name
   - `CLOUDRUN_REGION` - Deployment region
3. Commit to trigger deployment

### Pipeline Stages

The Bitbucket equivalent follows the same structure:

checkout → setup → push → deploy → status_check → logs

### Features

- Artifact Registry image push
- Managed and GKE Cloud Run support
- Automatic traffic shifting
- Instance and concurrency scaling
- Health checks and monitoring
- Multi-region deployments
- JSONL-based pipeline logging
- 90-day log retention

## About Pipery

<img src="https://avatars.githubusercontent.com/u/270923927?s=32" alt="Pipery" width="22" align="center" /> [**Pipery**](https://pipery.dev) is an open-source CI/CD observability platform. Every step script runs under **psh** (Pipery Shell), which intercepts all commands and emits structured JSONL events — giving you full visibility into your pipeline without any manual instrumentation.

- Browse logs in the [Pipery Dashboard](https://github.com/pipery-dev/pipery-dashboard)
- Find all Pipery actions on [GitHub Marketplace](https://github.com/marketplace?q=pipery&type=actions)
- Source code: [pipery-dev](https://github.com/pipery-dev)

## Development

```bash
# Run the action locally against test-project/
pipery-actions test --repo .

# Regenerate docs
pipery-actions docs --repo .

# Dry-run release
pipery-actions release --repo . --dry-run
```

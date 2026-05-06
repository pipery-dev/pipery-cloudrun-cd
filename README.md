# Pipery Cloud Run CD

CD pipeline for Google Cloud Run: push image → gcloud run deploy → traffic migration and health check

## Status

- Owner: `pipery-dev`
- Repository: `pipery-cloudrun-cd`
- Marketplace category: `continuous-integration`
- Current version: `3.0.0`

## Usage

```yaml
name: Example
on: [push]

jobs:
  run-action:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pipery-dev/pipery-cloudrun-cd@v3
        with:
          project_path: .
          config_file: .pipery/config.yaml
          image_name: 
          image_tag: ${{ github.sha }}
          service_name: 
          region: us-central1
          project_id: 
          platform: managed
          traffic: 100
          min_instances: 0
          max_instances: 100
          concurrency: 80
          skip_push: false
          skip_deploy: false
          skip_status_check: false
          log_file: pipery.jsonl
```

## GitLab CI

This repository also includes a GitLab CI equivalent at `.gitlab-ci.yml`. Copy it into a GitLab project or use it as the reference implementation when you want to run the same Pipery pipeline outside GitHub Actions.

The GitLab pipeline maps the action inputs to CI/CD variables, publishes `pipery.jsonl` as an artifact, and keeps the same skip controls where the GitHub Action exposes them. Store credentials such as deploy tokens, registry passwords, and cloud provider keys as protected GitLab CI/CD variables.

```yaml
include:
  - remote: https://raw.githubusercontent.com/pipery-dev/pipery-cloudrun-cd/v3/.gitlab-ci.yml
```

## Inputs

| Name | Required | Default | Description |
| --- | --- | --- | --- |
| `project_path` | no | `.` | Path to the project source tree. |
| `config_file` | no | `.pipery/config.yaml` | Path to the pipery config file. |
| `image_name` | no | `` | Container image name to deploy (e.g. ghcr.io/org/app). |
| `image_tag` | no | `${{ github.sha }}` | Container image tag to deploy. |
| `service_name` | no | `` | Cloud Run service name. |
| `region` | no | `us-central1` | Google Cloud Run region. |
| `project_id` | no | `` | Google Cloud project ID. |
| `platform` | no | `managed` | Target platform: managed or gke. |
| `traffic` | no | `100` | Percentage of traffic to route to new revision (0-100). |
| `min_instances` | no | `0` | Minimum number of Cloud Run instances. |
| `max_instances` | no | `100` | Maximum number of Cloud Run instances. |
| `concurrency` | no | `80` | Maximum concurrent requests per instance. |
| `skip_push` | no | `false` | Skip image push step. |
| `skip_deploy` | no | `false` | Skip deploy step. |
| `skip_status_check` | no | `false` | Skip health check step. |
| `log_file` | no | `pipery.jsonl` | Path to write the JSONL log file. |

## Outputs

No outputs.

## Bitbucket Pipelines

Bitbucket Cloud pipelines support this deployment workflow. The equivalent configuration is in `bitbucket-pipelines.yml`.

### Quick Start

1. Copy `bitbucket-pipelines.yml` to your Bitbucket repository root
2. Configure GCP credentials in Repository Variables:
   - `GCLOUD_SERVICE_KEY_BASE64` - Base64-encoded GCP service account key
   - `GCLOUD_PROJECT_ID` - GCP project ID
3. Configure Cloud Run service name and region
4. Commit to trigger deployment

### Pipeline Stages

- checkout → setup → deploy → status_check → logs

### Features

- Google Cloud Run serverless deployment
- Service authentication and configuration
- Memory, CPU, and timeout settings
- Max/min instance configuration
- Health verification
- 90-day log retention

### Documentation

- See `bitbucket-pipelines.yml` for complete customization options
- Refer to [Bitbucket Pipelines Documentation](https://support.atlassian.com/bitbucket-cloud/docs/get-started-with-bitbucket-pipelines/) for detailed reference

## Development

This repository is managed with `pipery-tooling`.

```bash
pipery-actions test --repo .
pipery-actions docs --repo .
pipery-actions release --repo . --dry-run
```

By default, `pipery-actions test --repo .` executes the action against `test-project` and validates `pipery.jsonl`.

## Marketplace Release Flow

1. Update the implementation and changelog.
2. Run `pipery-actions release --repo .`.
3. Push the created git tag and major tag alias.
4. Publish the GitHub release.

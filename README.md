# Pipery Cloud Run CD

Reusable GitHub Action for Cloud Run CD with structured logging via [Pipery](https://pipery.dev).

[![GitHub Marketplace](https://img.shields.io/badge/Marketplace-Pipery%20Cloud%20Run%20CD-blue?logo=github)](https://github.com/marketplace/actions/pipery-cloudrun-cd)
[![Version](https://img.shields.io/badge/version-1.0.0-blue)](CHANGELOG.md)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## Usage

```yaml
name: CD
on:
  push:
    branches: [main]

jobs:
  cd:
    uses: pipery-dev/pipery-cloudrun-cd@v1
    with:
      project_path: .
    secrets: inherit
```

## Pipeline steps

push image → gcloud run deploy → traffic migration → health check

Every step is logged to `pipery.jsonl` via psh and uploaded as a GitHub Actions artifact.

## Inputs

| Input | Description | Default |
|---|---|---|
| `project_path` | Path to the project source tree. | `.` |
| `config_file` | Path to the pipery config file. | `.github/pipery/config.yaml` |
| `image_name` | Container image name to deploy (e.g. ghcr.io/org/app). | `` |
| `image_tag` | Container image tag to deploy. | `${{ github.sha }}` |
| `service_name` | Cloud Run service name. | `` |
| `region` | Google Cloud Run region. | `us-central1` |
| `project_id` | Google Cloud project ID. | `` |
| `platform` | Target platform: managed or gke. | `managed` |
| `traffic` | Percentage of traffic to route to new revision (0-100). | `100` |
| `min_instances` | Minimum number of Cloud Run instances. | `0` |
| `max_instances` | Maximum number of Cloud Run instances. | `100` |
| `concurrency` | Maximum concurrent requests per instance. | `80` |
| `skip_push` | Skip image push step. | `false` |
| `skip_deploy` | Skip deploy step. | `false` |
| `skip_status_check` | Skip health check step. | `false` |
| `log_file` | Path to write the JSONL log file. | `pipery.jsonl` |

## Observability

Each run produces a `pipery.jsonl` file. Upload it as an artifact and inspect it with the [Pipery Dashboard](https://dash.pipery.dev).

## License

MIT — see [LICENSE](LICENSE).

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
          config_file: .github/pipery/config.yaml
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

## Inputs

| Name | Required | Default | Description |
| --- | --- | --- | --- |
| `project_path` | no | `.` | Path to the project source tree. |
| `config_file` | no | `.github/pipery/config.yaml` | Path to the pipery config file. |
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

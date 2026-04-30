# Using Pipery Cloud Run CD

CD pipeline for Google Cloud Run: push image → gcloud run deploy → traffic migration and health check

## Recommended workflow

1. Pin the action to a major tag in production workflows.
2. Keep a representative test project in the repository and point `test_project_path` at it.
3. Emit a `pipery.jsonl` build log during the action run and keep `test_log_path` pointed at it.
4. Make the action consume that path via the configured test input.
5. Keep changelog entries under `## [Unreleased]` until you cut a release.
6. Regenerate docs before publishing a new version.

## Example

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

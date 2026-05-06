#!/usr/bin/env psh
# Pipery Cloud Run CD — push step
# Structured logging via psh: every command is captured to $INPUT_LOG_FILE

set -euo pipefail

echo "::group::Push"
echo "project_path=$INPUT_PROJECT_PATH"
echo "::endgroup::"

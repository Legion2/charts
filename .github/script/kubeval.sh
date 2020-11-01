#!/bin/bash

set -euo pipefail

source "$(dirname "$0")/utils.sh"

charts=($(changed-charts))

install-kubeval

for chart_dir in "${charts[@]}"; do
  values_yaml="$chart_dir/ci/ci-values.yaml"
  values_opt=$([ -f "$values_yaml" ] && echo "-f $values_yaml" || echo "")

  log "Validating $chart_dir"
  helm dependency update $chart_dir
  helm template $chart_dir $values_opt | kubeval --strict
done
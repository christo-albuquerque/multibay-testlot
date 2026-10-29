#!/usr/bin/env bash
# Trigger demo pipeline runs for the DirectedByMultiBay factory.
# Usage: scripts/demo.sh [success|fail-lint|fail-build|fail-test|matrix|cancel|release|tour] [delay-seconds]
set -euo pipefail

scenario="${1:-success}"
delay="${2:-8}"
repo="${REPO:-christo-albuquerque/multibay-testlot}"

run() { # fail_at matrix cancel
  gh workflow run controllable.yml -R "$repo" -f "fail_at=$1" -f "delay_seconds=$delay" -f "matrix=$2" -f "cancel_me=$3"
  echo "Triggered: fail_at=$1 matrix=$2 cancel=$3"
}

case "$scenario" in
  success)    run none false false ;;
  fail-lint)  run lint false false ;;
  fail-build) run build false false ;;
  fail-test)  run test false false ;;
  matrix)     run none true false ;;
  cancel)     run none false true ;;
  release)    gh workflow run release.yml -R "$repo"; echo "Triggered: a real release" ;;
  tour)
    run none false false
    sleep 45; run build false false
    sleep 30; run test false false
    sleep 30; run lint false false
    sleep 30; run none true false
    sleep 60; run none false true
    sleep 60; run none false false ;;
  *) echo "Unknown scenario: $scenario" >&2; exit 1 ;;
esac

echo "Watch it at https://christo-albuquerque.github.io/directed-by-multibay/"

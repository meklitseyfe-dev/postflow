#!/usr/bin/env bash
# Runs a CI command and, if it fails, also reports its output as a GitHub
# Actions error annotation so the failure is visible on the run summary page
# (and through the API) without opening the raw log.
#
# Usage: tool/ci_run.sh "<title>" <command> [args...]
set -uo pipefail

title="$1"
shift

output_file="$(mktemp)"
"$@" 2>&1 | tee "$output_file"
status=${PIPESTATUS[0]}

if [ "$status" -ne 0 ]; then
  # Keep the annotation readable: last 120 lines, newlines escaped per
  # https://docs.github.com/actions/reference/workflow-commands-for-github-actions
  message="$(tail -n 120 "$output_file" | sed -e 's/%/%25/g' -e 's/\r/%0D/g' | awk 'BEGIN{ORS="%0A"} {print}')"
  echo "::error title=${title} failed::${message}"
fi

rm -f "$output_file"
exit "$status"

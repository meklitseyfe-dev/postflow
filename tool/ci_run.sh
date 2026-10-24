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
  # Summary of key failure lines first, then the end of the output.
  summary="$(grep -E '\(failed\)|overflowed|Expected:|Actual:|Which:|^The following|Error:|error •|\.dart:[0-9]+:[0-9]+' "$output_file" | grep -v 'package:flutter' | head -n 80)"
  report="$(printf '%s\n----- last lines -----\n%s' "$summary" "$(tail -n 40 "$output_file")")"
  message="$(printf '%s\n' "$report" | sed -e 's/%/%25/g' -e 's/\r/%0D/g' | awk 'BEGIN{ORS="%0A"} {print}')"
  echo "::error title=${title} failed::${message}"
fi

rm -f "$output_file"
exit "$status"

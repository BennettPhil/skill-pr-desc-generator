#!/usr/bin/env bash

# PR Description Generator
# Analyzes git diffs and produces a structured summary.

set -euo pipefail

usage() {
  echo "Usage: $0 [DIFF_FILE]"
  echo "Analyzes a git diff and generates a PR description."
  echo "If DIFF_FILE is omitted, reads from stdin."
  exit 1
}

if [[ "${1:-}" == "--help" ]]; then
  usage
fi

INPUT="${1:-/dev/stdin}"

if [[ ! -e "$INPUT" ]]; then
  echo "Error: Input '$INPUT' not found." >&2
  exit 2
fi

# Extract changed files
# Use a temporary file to store the grep output to avoid subshell issues
TMP_FILES=$(mktemp)
grep "^diff --git" "$INPUT" | sed 's/diff --git a\///;s/ b\/.*//' | sort | uniq > "$TMP_FILES"

echo "# PR Description"
echo ""
echo "## Summary"
echo "Briefly describe the purpose of these changes."
echo ""
echo "## Changes"
if [[ ! -s "$TMP_FILES" ]]; then
  echo "No files changed."
else
  while IFS= read -r f; do
    echo "- \`$f\`: Describe changes to this file."
  done < "$TMP_FILES"
fi
echo ""
echo "## Testing"
echo "- [ ] Manually tested"
echo "- [ ] Unit tests added/updated"
echo ""
echo "## Review Checklist"
echo "- [ ] Code follows project style guidelines"
echo "- [ ] No sensitive information committed"

rm "$TMP_FILES"

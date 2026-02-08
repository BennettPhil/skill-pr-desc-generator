#!/usr/bin/env bash
# Test contract for pr-desc-generator

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RUN="$SCRIPT_DIR/run.sh"
PASS=0; FAIL=0; TOTAL=0

assert_contains() {
  local desc="$1" needle="$2" haystack="$3"
  ((TOTAL++))
  if echo "$haystack" | grep -qiF -- "$needle"; then
    ((PASS++)); echo "  PASS: $desc"
  else
    ((FAIL++)); echo "  FAIL: $desc (missing '$needle')"
  fi
}

echo "=== Tests for pr-desc-generator ==="

# Test 1: Simple diff analysis
SAMPLE_DIFF="
diff --git a/README.md b/README.md
--- a/README.md
+++ b/README.md
@@ -1 +1,2 @@
 # Project
+New feature added.
"
OUTPUT1=$(echo "$SAMPLE_DIFF" | "$RUN")
assert_contains "summary section" "## Summary" "$OUTPUT1"
assert_contains "changes section" "## Changes" "$OUTPUT1"
assert_contains "detected file" "README.md" "$OUTPUT1"

# Test 2: Multiple files
SAMPLE_DIFF2="
diff --git a/src/main.py b/src/main.py
+++ b/src/main.py
+def new_func(): pass
diff --git a/tests/test_main.py b/tests/test_main.py
+++ b/tests/test_main.py
+def test_new_func(): pass
"
OUTPUT2=$(echo "$SAMPLE_DIFF2" | "$RUN")
assert_contains "detected python file" "main.py" "$OUTPUT2"
assert_contains "detected test file" "test_main.py" "$OUTPUT2"

# Test 3: Help flag
assert_contains "help flag" "usage:" "$($RUN --help 2>&1)"

echo ""
echo "=== Results: $PASS/$TOTAL passed ==="
[ "$FAIL" -eq 0 ] || { echo "BLOCKED: $FAIL test(s) failed"; exit 1; }

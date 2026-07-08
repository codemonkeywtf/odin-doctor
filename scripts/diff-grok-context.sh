#!/usr/bin/env bash
#
# diff-grok-context.sh
#
# Compare the local working copies of the Grok context files against
# the canonical versions in the private gist (the single source of truth).
#
# Run this any time to see if an EOD / "update context" is actually needed,
# or after you manually edited the local files.
#
# Usage:
#   scripts/diff-grok-context.sh
#
# Exit code is 0 if everything matches, non-zero if any differences were found
# (but we still print the full diff for visibility).

set -euo pipefail

GIST_ID="ff7c85e6f7e474c2b18c634523c76a4c"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

GROK_CONTEXT_LOCAL="${PROJECT_ROOT}/GROK_CONTEXT.md"
CARE_LOCAL="${PROJECT_ROOT}/How_To_Care_and_Feed_Your_AI_Assistant"

echo "=== Grok context drift check ==="
echo "Gist (single source of truth): https://gist.github.com/pahosler/${GIST_ID}"
echo "Local working copies: ${PROJECT_ROOT}"
echo

had_diff=0

echo "----- GROK_CONTEXT.md (local vs gist) -----"
if diff -u <(gh gist view "$GIST_ID" --filename GROK_CONTEXT.md) "$GROK_CONTEXT_LOCAL"; then
  echo "(identical)"
else
  had_diff=1
fi
echo

echo "----- How_To_Care_and_Feed_Your_AI_Assistant (local vs gist) -----"
if diff -u <(gh gist view "$GIST_ID" --filename How_To_Care_and_Feed_Your_AI_Assistant) "$CARE_LOCAL"; then
  echo "(identical)"
else
  had_diff=1
fi
echo

if [[ $had_diff -eq 0 ]]; then
  echo "✓ Local working copies are in sync with the gist."
  echo "  No EOD / update needed unless you have new changes in this conversation."
else
  echo "✗ Differences found above."
  echo "  Say 'EOD' (or 'update context') to push the local working copies to the gist."
fi

exit $had_diff

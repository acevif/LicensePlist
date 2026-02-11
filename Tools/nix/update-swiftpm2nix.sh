#!/usr/bin/env bash
set -euo pipefail

# This script cannot be triggered from `nix build`: Nix builds are read-only
# (cannot update nix/default.nix) and sandboxed with no network access
# (cannot compute dependency hashes).

if ! command -v swiftpm2nix >/dev/null; then
  exec nix shell nixpkgs#swiftpm2nix --command "$0" "$@"
fi

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
spm_workspace_state="$root/.build/workspace-state.json"

if [[ ! -f "$spm_workspace_state" ]]; then
  echo "SwiftPM workspace state not found at $spm_workspace_state" >&2
  echo "Run 'swift package resolve' to generate it." >&2
  exit 1
fi

cd "$root"
swiftpm2nix

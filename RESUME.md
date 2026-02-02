# RESUME

## Goal
- Build a reproducible darwin package for `license-plist` following the Nixpkgs SwiftPM guidance (no runtime Swift dependencies).

## Current State
- `flake.nix` uses flake-parts and exposes `packages.default` via `nix/license-plist.nix`.
- `nix/license-plist.nix` consumes `swiftpm2nix` outputs (`nix/default.nix` / `nix/workspace-state.json`).
- `Tools/nix/update-swiftpm2nix.sh` and Make targets `nix_update` / `nix_build` are in place.
- `nix build .#` currently triggers a **source build** of the Swift toolchain (`swift-5.10.1`, `swiftpm`, etc.), which is very slow and times out.
- `NIX.md` documents that Swift toolchain builds can take ~1 hour or more.

## Next Actions
1. Decide how to supply Swift toolchain (Xcode 26.2 toolchain, prebuilt binary cache, or accept long source builds).
2. Update `nix/license-plist.nix` to use the chosen toolchain source.
3. Re-run `nix build .#` to confirm the package builds.

## Notes
- `nix build` assumes a read-only source tree and no network, so dependency hash generation must be done via `make nix_update` beforehand.
- Current configuration uses nixpkgs-provided `swift` / `swiftpm`, which triggers the expensive toolchain build on darwin.

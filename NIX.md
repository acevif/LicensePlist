# Nix

## Overview

This branch packages `license-plist` with the toolchain and `swiftpm2nix` shipped by `nixpkgs`.
It keeps the build on a pure Swift toolchain (`swift`/`swiftpm`) without Xcode.

## Usage

### Resolve SwiftPM state with nixpkgs swiftpm

```sh
nix develop --command swift package resolve
```

### Regenerate `nix/default.nix`

```sh
nix develop
make nix_update
```

### Build

```sh
nix build
```

## Notes

- `swiftpm2nix` reads `.build/workspace-state.json` and generates `nix/default.nix` plus `nix/workspace-state.json`.
- `nix/workspace-state.json` is a generated copy with SwiftPM artifacts removed for sandboxed Nix builds.
- Run `make nix_update` inside the devShell (`nix develop`) where `swiftpm2nix` is available in PATH.

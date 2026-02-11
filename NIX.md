# Nix

## Overview

This branch packages `license-plist` with the toolchain and `swiftpm2nix` shipped by `nixpkgs`.
It targets `LicensePlist` `3.25.1` and keeps the build on a pure Swift toolchain (`swift`/`swiftpm`) without Xcode.

## Usage

### Resolve SwiftPM state with nixpkgs swiftpm

```sh
nix develop --command swift package resolve
```

### Regenerate `nix/default.nix`

```sh
make nix_update
```

### Build

```sh
nix build
```

## Notes

- `nix/default.nix` is generated from `.build/workspace-state.json`.
- `nix/patches/remove-spm-plugin-binary-target.patch` is applied in Nix builds to remove SwiftPM plugin/binary-target entries from `Package.swift`.
- That patch is Nix-only and avoids remote artifact download during sandboxed builds.

# Nix

## Goal

- Build a reproducible darwin package for `license-plist` following the Nixpkgs SwiftPM guidance (no runtime Swift dependencies).

## Project Status

### Current State

- `flake.nix` uses flake-parts and exposes `packages.default` via `nix/license-plist.nix`.
- `nix/license-plist.nix` consumes `swiftpm2nix` outputs (`nix/default.nix` / `nix/workspace-state.json`).
- `Tools/nix/update-swiftpm2nix.sh` and Make targets `nix_update` / `nix_build` are in place.
- `nix build .#` currently triggers a source build of the Swift toolchain (`swift-5.10.1`, `swiftpm`, etc.), which is very slow and times out.
- The Nix build must use a pure Swift toolchain (no Xcode dependency), matching how LicensePlist builds via `swift build`.

### TODO

- [ ] NEXTACTION: Decide how to supply a pure Swift toolchain (prebuilt binary cache, alternative toolchain source, or accept long source builds).
- [ ] NEXTACTION: Update `nix/license-plist.nix` to use the chosen toolchain source.
- [ ] NEXTACTION: Re-run `nix build .#` to confirm the package builds.
- [ ] Mention `nix_update` target in README (Nix section).
- [ ] Add a build-time check to fail if `nix/` is stale.

### Notes

- `nix build` assumes a read-only source tree and no network, so dependency hash generation must be done via `make nix_update` beforehand.
- Current configuration uses nixpkgs-provided `swift` / `swiftpm`, which triggers the expensive toolchain build on darwin.

This repository uses `swiftpm2nix` to make SwiftPM dependencies reproducible in Nix.
The files `nix/workspace-state.json` and `nix/default.nix` are generated.

## Usage

## Update Nix Inputs and Build

Use the Make target to update Nix inputs and build:

```sh
make nix_build
```

## Update Dependencies

When `Package.resolved` changes, regenerate the SwiftPM metadata and hashes:

```sh
make nix_update
```

## Reference Examples

Good real-world `swiftpm2nix` examples in Nixpkgs include:

- `swift-docc` under `pkgs/development/compilers/swift/swift-docc` (https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/compilers/swift/swift-docc/default.nix)
- `swift-format` under `pkgs/development/compilers/swift/swift-format` (https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/compilers/swift/swift-format/default.nix)
- `sourcekit-lsp` under `pkgs/development/compilers/swift/sourcekit-lsp` (https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/compilers/swift/sourcekit-lsp/default.nix)

Other Swift packages using `swiftpm2nix` (stars as of 2026-02-03):

- `arianvp/server-optimised-nixos` (https://github.com/arianvp/server-optimised-nixos) — 90 stars
- `AUCOHL/Fault` (https://github.com/AUCOHL/Fault) — 179 stars
- `dominicegginton/spinner` (https://github.com/dominicegginton/spinner) — 50 stars
- `kradalby/munin` (https://github.com/kradalby/munin) — 11 stars
- `Samasaur1/pam_watchid` (https://github.com/Samasaur1/pam_watchid) — 1 star

## Notes

### Swift Build Time

Building the Swift toolchain (Swift package) can take around 1 hour; with debug settings it can exceed 4 hours.
Given this, consider using prebuilt binaries when possible.
LicensePlist itself builds via `swift build` and does not require Xcode toolchains; therefore the Nix build
must also avoid an Xcode dependency and use a pure Swift toolchain.

Sources:
- https://forums.swift.org/t/long-compile-times-of-toolchain-rebuilds/64863
- https://forums.swift.org/t/new-contributor-feedback-development-workflow-advice/74992
- https://akrabat.com/compiling-swift-on-linux/
- https://johnfairh.github.io/site/swift_source_basics.html

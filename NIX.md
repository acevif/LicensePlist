# Nix

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

## Reference Example

A good real-world `swiftpm2nix` example is the `swift-docc` package in Nixpkgs.
It uses `swiftpm2nix`-generated inputs under `pkgs/development/compilers/swift/swift-docc`.

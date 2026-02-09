{
  description = "LicensePlist (Nix flake)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # Upstream PR: https://github.com/NixOS/nixpkgs/pull/414914
    nixpkgs-swiftpm2nix-v7.url = "github:bryango/nixpkgs/cc11088180a698f24261fb3e135a395841ed559a";
    # Community branch carrying Swift 6.2.x toolchain updates.
    nixpkgs-swift62.url = "github:reckenrode/nixpkgs/swift-update-mk2";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "aarch64-darwin" "x86_64-darwin" ];

      perSystem = { system, ... }:
        let
          pkgsSwiftpm2nixV7 = import inputs.nixpkgs-swiftpm2nix-v7 { inherit system; };
          pkgsSwift62 = import inputs.nixpkgs-swift62 { inherit system; };
          pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [
              (final: prev: {
                swiftpm2nix = pkgsSwiftpm2nixV7.swiftpm2nix;
                swift = pkgsSwift62.swift;
                swiftpm = pkgsSwift62.swiftpm;
              })
            ];
          };
        in
        {
          devShells.default = pkgs.mkShell {
            packages = [
              pkgs.swift
              pkgs.swiftpm
            ];
          };

          packages.default = pkgs.callPackage ./nix/license-plist.nix {
            src = self;
          };
        };
    };
}

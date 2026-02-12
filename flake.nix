{
  description = "LicensePlist (Nix flake)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs@{ self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "aarch64-darwin"
        "x86_64-darwin"
      ];

      perSystem =
        { pkgs, ... }:
        {
          formatter = pkgs.nixfmt;

          devShells.default = pkgs.mkShell {
            packages = [
              pkgs.swift
              pkgs.swiftpm
              pkgs.swiftpm2nix
            ];
          };

          packages.default = pkgs.callPackage ./nix/license-plist.nix {
            src = self;
          };
        };
    };
}

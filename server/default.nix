{ pkgs ? import <nixpkgs> {},
  rustc ? pkgs.rustc }:
let
  security = if pkgs.stdenv.isDarwin
    then [ pkgs.darwin.apple_sdk.frameworks.Security ]
    else [];
  cratesIO = import ./crates-io.nix {
    inherit (pkgs) lib buildRustCrate buildRustCrateHelpers;
  };
  cargo = import ./Cargo.nix {
    inherit (pkgs) lib buildPlatform buildRustCrate buildRustCrateHelpers fetchgit;
    inherit cratesIO;
  };
in (cargo.fitnesstrax_server {}).override {
    rust = rustc;
    buildInputs = [ security ];
    crateOverrides = pkgs.defaultCrateOverrides // {
      mime_guess = attrs: { buildInputs = [ security ]; };
      orizentic = attrs: { buildInputs = [ security ]; };
      fitnesstrax = attrs: { buildInputs = [ security ]; };
    };
  }

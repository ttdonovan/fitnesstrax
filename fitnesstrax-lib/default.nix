{ pkgs ? import <nixpkgs> {},
  rustc ? pkgs.rustc }:
let
  security = if pkgs.stdenv.isDarwin
    then [ pkgs.darwin.apple_sdk.frameworks.Security ]
    else [];
  cratesIO = import ./crates-io.nix {
    inherit (pkgs) lib buildRustCrate buildRustCrateHelpers;
  };
  fitnesstrax_crate = ((import ./Cargo.nix {
    inherit (pkgs) lib buildPlatform buildRustCrate
                   buildRustCrateHelpers fetchgit;
    cratesIO = cratesIO;
  }).fitnesstrax {}).override {
    rust = rustc;
    crateOverrides = pkgs.defaultCrateOverrides // {
      orizentic = attrs: { buildInputs = [ security ]; };
    };
  };

in pkgs.stdenv.mkDerivation rec {
  name = "fitnesstrax-lib";

  src = ./.;
  buildInputs = [ fitnesstrax_crate ];
  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/lib
    ls -l ${fitnesstrax_crate.out}/lib
    cp ${fitnesstrax_crate.out}/lib/libfitnesstrax-*.rlib $out/lib/libfitnesstrax.rlib
    '';
}

{ pkgs, rustc }:
let
  buildRustCrate = pkgs.buildRustCrate.override {
    inherit rustc;
  };

  darwin_frameworks = if pkgs.stdenv.buildPlatform.system == "x86_64-darwin"
    then with pkgs.darwin.apple_sdk.frameworks; [
        Security
      ]
    else [];

  cargo = import ./Cargo.nix {
    inherit buildRustCrate;
    inherit (pkgs) lib buildPlatform fetchgit;
    inherit (pkgs) buildRustCrateHelpers;
    cratesIO = import ./crates-io.nix {
      inherit (pkgs) lib;
      inherit (pkgs) buildRustCrateHelpers;
      inherit buildRustCrate;
    };
  };

  fitnesstrax_server_crate = (cargo.fitnesstrax_server {}).override {
    crateOverrides = pkgs.defaultCrateOverrides // {
      mime_guess = attrs: { buildInputs = darwin_frameworks; };
      orizentic = attrs: { buildInputs = darwin_frameworks; };
      fitnesstrax = attrs: { buildInputs = darwin_frameworks; };
    };
  };

in pkgs.stdenv.mkDerivation rec {
  name = "fitnesstrax-server";

  buildInputs = [ fitnesstrax_server_crate ];

  src = ./.;

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    cp ${fitnesstrax_server_crate.out}/bin/fitnesstrax-server $out/bin/fitnesstrax-server
    '';
}

{ pkgs ? import <nixpkgs-19.03> {} }:
let
  rustc = import nixpkgs/rust-1.33.nix {
    inherit (pkgs.stdenv) mkDerivation;
    inherit (pkgs) stdenv fetchurl patchelf;
  };
  nodejs = import nixpkgs/node10.nix { pkgs = pkgs; };

  server = import server/default.nix { pkgs = pkgs; rustc = rustc; };
  client = import client/default.nix { pkgs = pkgs; nodejs = nodejs; };

  wrapper = pkgs.writeScript "fitnesstrax"
    ''
    #!/bin/bash

    export HOST=$([ ! -z $HOST ] && echo "$HOST" || echo "localhost")
    export PORT=$([ ! -z $PORT ] && echo "$PORT" || echo 7000)
    export WEBAPP_PATH="${client}/"
    ${server}/bin/fitnesstrax-server
    '';


in pkgs.stdenv.mkDerivation rec {
  name = "fitnesstrax-${version}";
  version = "0.1.0";

  #paths = [ server wrapper ];
  buildInputs = [ server client pkgs.makeWrapper ];

  src = ./.;

  phases = [ "installPhase" "postInstallPhase" ];
  installPhase = ''
    mkdir -p $out/bin
    cp ${wrapper} $out/bin/fitnesstrax
    '';

  postInstallPhase = ''
    patchShebangs $out/bin/fitnesstrax
    '';

  meta = with pkgs.stdenv.lib; {
    description = "Privacy-first fitness tracking. Your health, your data, your machine.";
    homepage = "https://github.com/luminescent-dreams/fitnesstrax";
    license = licenses.bsd3;
    maintainers = [ "savanni@luminescent-dreams.com" ];
  };
}

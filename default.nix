{ pkgs ? import <nixpkgs-19.03> {},
  ld ? import <luminescent-dreams> {} }:
let
  app = import gtk/default.nix { pkgs = pkgs; rustc = ld.rust_1_39; };

in pkgs.stdenv.mkDerivation rec {
  name = "fitnesstrax-${version}";
  version = "0.0.3";

  #paths = [ server wrapper ];
  buildInputs = [ app ];

  src = ./.;

  phases = [ "installPhase" ];
  installPhase = ''
    mkdir -p $out/bin
    cp ${app}/bin/fitnesstrax-gtk $out/bin/fitnesstrax
    '';

  meta = with pkgs.stdenv.lib; {
    description = "Privacy-first fitness tracking. Your health, your data, your machine.";
    homepage = "https://github.com/luminescent-dreams/fitnesstrax";
    license = licenses.bsd3;
    maintainers = [ "savanni@luminescent-dreams.com" ];
  };
}

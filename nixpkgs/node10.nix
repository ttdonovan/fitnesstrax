{ pkgs
, stdenv ? pkgs.stdenv
, fetchurl ? pkgs.fetchurl
, buildFHS ? pkgs.buildFHSUserEnv
, mkDerivation ? pkgs.stdenv.mkDerivation
}:
let
    ver = "10.15.3";
    platform = if stdenv.system == "x86_64-linux" then "linux-x64"
        else if stdenv.system == "x86_64-darwin" then "darwin-x64"
        else abort "unsupported platform";
    pkgSha = if stdenv.system == "x86_64-linux" then "0llx6v13wxb96rms38k4r2n3x91c5dxjfm43ayvql66lgidbhdbc"
        else if stdenv.system == "x86_64-darwin" then "7a5eaa1f69614375a695ccb62017248e5dcc15b0b8edffa7db5b52997cf992ba"
        else abort "unsupported platform";

in mkDerivation rec {
    name = "node";

    src = fetchurl {
        url = "https://nodejs.org/download/release/v${ver}/node-v${ver}-${platform}.tar.gz";
        sha256 = pkgSha;
    };

    phases = [ "unpackPhase" "installPhase" "postInstallPhase" ];
    installPhase = ''
        mkdir -p $out
        cp -r * $out
    '';

    postInstallPhase = ''
      if [ "${stdenv.system}" = "x86_64-linux" ]; then
        interp="$(cat $NIX_CC/nix-support/dynamic-linker)"
        patchelf --set-interpreter $interp \
                 --set-rpath ${stdenv.cc.cc.lib}/lib${stdenv.lib.optionalString stdenv.is64bit "64"} \
                 $out/bin/node
      fi
      '';
}

{ pkgs ? import <nixos> {}
, stdenv ? pkgs.stdenv
, fetchurl ? pkgs.fetchurl
, buildFHS ? pkgs.buildFHSUserEnv
, mkDerivation ? pkgs.stdenv.mkDerivation
}:
let
    ver = "9.10.0";
    platform = if stdenv.system == "x86_64-linux" then "linux-x64"
        else if stdenv.system == "x86_64-darwin" then "darwin-x64"
        else abort "unsupported platform";
    pkgSha = if stdenv.system == "x86_64-linux" then "2ff3351616e58d1355b643f6013cb45b30bf84aad523de05cdbf01d6c7b68e30"
        else if stdenv.system == "x86_64-darwin" then "c4b98cc2f3c00b770f24549de112902b56d57be7963a1047cd116b357bc61569"
        else abort "unsupported platform";

in mkDerivation rec {
    name = "node";

    src = fetchurl {
        url = "https://nodejs.org/download/release/v${ver}/node-v${ver}-${platform}.tar.gz";
        sha256 = pkgSha;
    };

    phases = [ "unpackPhase" "installPhase" ];

    installPhase = ''
        mkdir -p $out
        cp -r * $out
    '';


    # node-env = mkDerivation {
    #     name = "node-env";

    #     src = fetchurl {
    #         url = "https://nodejs.org/dist/v${ver}/node-v${ver}-${platform}.tar.gz";
    #         sha256 = pkgSha;
    #     };

    #     phases = [ "unpackPhase" "installPhase" ];

    #     installPhase = ''
    #         mkdir -p $out
    #         cp -r * $out
    #     '';
    # };

    # node = buildFHS {
    #     name = "node";
    #     # targetPkgs = pkgs: [ node-env
    #     #                      # pkgs.git
    #     #                    ];
    #     runScript = "node";
    # };

    # npm = buildFHS {
    #     name = "npm";
    #     # targetPkgs = pkgs: [ node-env
    #     #                      # pkgs.git
    #     #                    ];
    #     runScript = "npm";
    # };
}


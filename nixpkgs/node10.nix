{ pkgs ? import <nixos> {}
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
    pkgSha = if stdenv.system == "x86_64-linux" then "faddbe418064baf2226c2fcbd038c3ef4ae6f936eb952a1138c7ff8cfe862438"
        else if stdenv.system == "x86_64-darwin" then "7a5eaa1f69614375a695ccb62017248e5dcc15b0b8edffa7db5b52997cf992ba"
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

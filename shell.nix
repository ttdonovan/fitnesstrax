let
    pkgs = import <nixpkgs-18.09> {};
    unstable = import <nixpkgs> {};
    frameworks = pkgs.darwin.apple_sdk.frameworks;
    rust = import ./nixpkgs/rust-1.33.nix {
      mkDerivation = pkgs.stdenv.mkDerivation;
      fetchurl = pkgs.fetchurl;
      stdenv = pkgs.stdenv;
    };
    node = import ./nixpkgs/node10.nix { pkgs = pkgs; };
in pkgs.stdenv.mkDerivation {
    name = "fitnesstrax";

    buildInputs = [ rust
                    unstable.carnix
                    frameworks.Security
                    node
                  ];

    RUST_BACKTRACE = "full";
}

let
    pkgs = import <nixpkgs-18.09> {};
    unstable = import <nixpkgs> {};
    frameworks = pkgs.darwin.apple_sdk.frameworks;
    node = import ./nixpkgs/node9.nix { pkgs = pkgs; };
in pkgs.stdenv.mkDerivation {
    name = "fitnesstrax";

    buildInputs = [ pkgs.rustc
                    pkgs.cargo
                    pkgs.rustfmt
                    unstable.carnix
                    frameworks.Security
                    node
                  ];

    RUST_BACKTRACE = "full";
}

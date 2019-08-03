let
    pkgs = import <nixpkgs-19.03> {};
    frameworks = pkgs.darwin.apple_sdk.frameworks;
    rust = import ./nixpkgs/rust-1.33.nix {
      inherit (pkgs.stdenv) mkDerivation;
      inherit (pkgs) fetchurl stdenv patchelf;
    };
    node = import ./nixpkgs/node10.nix { pkgs = pkgs; };

    darwin_frameworks = if pkgs.stdenv.buildPlatform.system == "x86_64-darwin"
      then with pkgs.darwin.apple_sdk.frameworks; [
          Security
        ]
      else [];

in pkgs.stdenv.mkDerivation {
    name = "fitnesstrax";

    buildInputs = [ node
                    pkgs.carnix
                    rust
                  ] ++ darwin_frameworks;

    RUST_BACKTRACE = "full";
}

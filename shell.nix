let
    pkgs = import <nixpkgs-19.03> {};
    ld = import <luminescent-dreams> {};
    frameworks = pkgs.darwin.apple_sdk.frameworks;

    darwin_frameworks = if pkgs.stdenv.buildPlatform.system == "x86_64-darwin"
      then with pkgs.darwin.apple_sdk.frameworks; [
          Security
        ]
      else [];

in pkgs.mkShell {
    name = "fitnesstrax";

    buildInputs = [ ld.nodejs_10_15_3
                    pkgs.carnix
                    ld.rust_1_33_0
                  ] ++ darwin_frameworks;

    RUST_BACKTRACE = "full";

    shellHook = ''if [ -e ~/.nixpkgs/shellhook.sh ]; then . ~/.nixpkgs/shellhook.sh; fi'';
}

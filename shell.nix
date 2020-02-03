let
    pkgs = import <nixpkgs-19.09> {};
    ld = import <luminescent-dreams> {};
    frameworks = pkgs.darwin.apple_sdk.frameworks;

    darwin_frameworks = if pkgs.stdenv.buildPlatform.system == "x86_64-darwin"
      then with pkgs.darwin.apple_sdk.frameworks; [
          Security
        ]
      else [];

in pkgs.mkShell {
    name = "fitnesstrax";

    buildInputs = [ pkgs.pkgconfig
                    pkgs.carnix
                    pkgs.glib
                    pkgs.gtk3-x11
                    ld.rust_1_39
                  ] ++ darwin_frameworks;

    RUST_BACKTRACE = "full";

    shellHook = ''if [ -e ~/.nixpkgs/shellhook.sh ]; then . ~/.nixpkgs/shellhook.sh; fi'';
}

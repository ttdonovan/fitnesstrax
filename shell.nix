let
    pkgs = import <nixpkgs-18.09> {};
    unstable = import <nixpkgs> {};
    frameworks = pkgs.darwin.apple_sdk.frameworks;
in pkgs.stdenv.mkDerivation {
    name = "fitnesstrax";

    buildInputs = [ pkgs.rustc
                    pkgs.cargo
                    unstable.carnix
                    frameworks.Security
                    frameworks.CoreFoundation
                    frameworks.AppKit
                    frameworks.Cocoa
                  ];

    shellHook = ''
        export PS1="[$name] \[$txtgrn\]\u@\h\[$txtwht\]:\[$bldpur\]\w \[$txtcyn\]\$git_branch\[$txtred\]\$git_dirty \[$bldylw\]\$aws_env\[$txtrst\]\$ "
        export NIX_LDFLAGS="-F${frameworks.CoreFoundation}/Library/Frameworks -framework CoreFoundation $NIX_LDFLAGS";
    '';
}

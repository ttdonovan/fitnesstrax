{ pkgs, nodejs }:
pkgs.stdenv.mkDerivation {
  name = "fitnesstrax-client";
  buildInputs = [ nodejs ];

  src = ./.;

  phases = [ "buildPhase" "installPhase" ];

  buildPhase = ''
    set -x

    export HOME="$TMP"
    cp -r $src/package-lock.json $src/package.json $src/src $src/tsconfig.json $src/webpack.config.js $src/setupBeforeEachTest.ts $src/setupOnFileLoad.ts .
    npm install
    npm run build
    '';

  installPhase = ''
    mkdir -p $out
    cp -r dist/* $out
    '';
}

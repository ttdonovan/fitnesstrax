{ mkDerivation, stdenv, fetchurl }:
mkDerivation rec {
    ver = "1.33.0";
    name = "rust-${ver}";
    platform = if stdenv.system == "x86_64-linux" then "x86_64-unknown-linux-gnu"
        else if stdenv.system == "x86_64-darwin" then "x86_64-apple-darwin"
        else abort "unsupported platform";
    pkgSha = if stdenv.system == "x86_64-linux" then "6623168b9ee9de79deb0d9274c577d741ea92003768660aca184e04fe774393f"
        else if stdenv.system == "x86_64-darwin" then "864e7c074a0b88e38883c87c169513d072300bb52e1d320a067bd34cf14f66bd"
        else abort "unsupported platform";

    src = fetchurl {
        url = "https://static.rust-lang.org/dist/rust-${ver}-${platform}.tar.gz";
        sha256 = pkgSha;
    };

    phases = ["unpackPhase" "installPhase"];
    installPhase = ''
        mkdir -p $out
        ./install.sh --prefix=$out
    '';
}

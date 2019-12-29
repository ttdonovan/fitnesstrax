{ pkgs ? import <nixpkgs> {},
  rustc ? pkgs.rustc }:
let
  cratesIO = import ./crates-io.nix {
    inherit (pkgs) lib buildRustCrate buildRustCrateHelpers;
  };
  cargo = import ./Cargo.nix {
    inherit (pkgs) lib buildPlatform buildRustCrate buildRustCrateHelpers fetchgit;
    inherit cratesIO;
  };
in (cargo.fitnesstrax_gtk {}).override {
  rust = rustc;
  buildInputs = [ pkgs.atk pkgs.cairo pkgs.gdk_pixbuf pkgs.glib pkgs.gnome2.pango pkgs.gtkd ];
  crateOverrides = pkgs.defaultCrateOverrides // {
    #gobject_sys = attrs: { buildInputs = [ pkgs.gtk3-x11 pkgs.glib ]; };
    atk-sys = attrs: { buildInputs = [ pkgs.glib ]; };
    atk = attrs: { buildInputs = [ pkgs.atk pkgs.glib ]; };
    gio = attrs: { buildInputs = [ pkgs.glib ]; };
    cairo-sys-rs = attrs: { buildInputs = [ pkgs.glib ]; };
    pango-sys = attrs: { buildInputs = [ pkgs.glib ]; };
    pango = attrs: { buildInputs = [ pkgs.glib pkgs.gnome2.pango ]; };
    gdk-sys = attrs: { buildInputs = [ pkgs.cairo pkgs.glib pkgs.gnome2.pango pkgs.gdk_pixbuf ]; };
    gdk = attrs: { buildInputs = [ pkgs.glib pkgs.cairo pkgs.gnome2.pango pkgs.gdk_pixbuf pkgs.gtkd ]; };
    gtk-sys = attrs: { buildInputs = [ pkgs.atk pkgs.glib pkgs.cairo pkgs.gnome2.pango pkgs.gdk_pixbuf pkgs.gtkd ]; };
    gtk = attrs: { buildInputs = [ pkgs.atk pkgs.glib pkgs.cairo pkgs.gnome2.pango pkgs.gdk_pixbuf pkgs.gtkd ]; };
  };
}

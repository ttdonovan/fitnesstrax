{ lib, buildRustCrate, buildRustCrateHelpers }:
with buildRustCrateHelpers;
let inherit (lib.lists) fold;
    inherit (lib.attrsets) recursiveUpdate;
in
rec {

# aho-corasick-0.5.3

  crates.aho_corasick."0.5.3" = deps: { features?(features_.aho_corasick."0.5.3" deps {}) }: buildRustCrate {
    crateName = "aho-corasick";
    version = "0.5.3";
    description = "Fast multiple substring searching with finite state machines.";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" ];
    sha256 = "1igab46mvgknga3sxkqc917yfff0wsjxjzabdigmh240p5qxqlnn";
    libName = "aho_corasick";
    crateBin =
      [{  name = "aho-corasick-dot"; }];
    dependencies = mapFeatures features ([
      (crates."memchr"."${deps."aho_corasick"."0.5.3"."memchr"}" deps)
    ]);
  };
  features_.aho_corasick."0.5.3" = deps: f: updateFeatures f (rec {
    aho_corasick."0.5.3".default = (f.aho_corasick."0.5.3".default or true);
    memchr."${deps.aho_corasick."0.5.3".memchr}".default = true;
  }) [
    (features_.memchr."${deps."aho_corasick"."0.5.3"."memchr"}" deps)
  ];


# end
# aho-corasick-0.6.10

  crates.aho_corasick."0.6.10" = deps: { features?(features_.aho_corasick."0.6.10" deps {}) }: buildRustCrate {
    crateName = "aho-corasick";
    version = "0.6.10";
    description = "Fast multiple substring searching with finite state machines.";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" ];
    sha256 = "0bhasxfpmfmz1460chwsx59vdld05axvmk1nbp3sd48xav3d108p";
    libName = "aho_corasick";
    crateBin =
      [{  name = "aho-corasick-dot";  path = "src/main.rs"; }];
    dependencies = mapFeatures features ([
      (crates."memchr"."${deps."aho_corasick"."0.6.10"."memchr"}" deps)
    ]);
  };
  features_.aho_corasick."0.6.10" = deps: f: updateFeatures f (rec {
    aho_corasick."0.6.10".default = (f.aho_corasick."0.6.10".default or true);
    memchr."${deps.aho_corasick."0.6.10".memchr}".default = true;
  }) [
    (features_.memchr."${deps."aho_corasick"."0.6.10"."memchr"}" deps)
  ];


# end
# aho-corasick-0.7.6

  crates.aho_corasick."0.7.6" = deps: { features?(features_.aho_corasick."0.7.6" deps {}) }: buildRustCrate {
    crateName = "aho-corasick";
    version = "0.7.6";
    description = "Fast multiple substring searching.";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" ];
    sha256 = "1srdggg7iawz7rfyb79qfnz6vmzkgl6g6gabyd9ad6pbx7zzj8gz";
    libName = "aho_corasick";
    dependencies = mapFeatures features ([
      (crates."memchr"."${deps."aho_corasick"."0.7.6"."memchr"}" deps)
    ]);
    features = mkFeatures (features."aho_corasick"."0.7.6" or {});
  };
  features_.aho_corasick."0.7.6" = deps: f: updateFeatures f (rec {
    aho_corasick = fold recursiveUpdate {} [
      { "0.7.6"."std" =
        (f.aho_corasick."0.7.6"."std" or false) ||
        (f.aho_corasick."0.7.6".default or false) ||
        (aho_corasick."0.7.6"."default" or false); }
      { "0.7.6".default = (f.aho_corasick."0.7.6".default or true); }
    ];
    memchr = fold recursiveUpdate {} [
      { "${deps.aho_corasick."0.7.6".memchr}"."use_std" =
        (f.memchr."${deps.aho_corasick."0.7.6".memchr}"."use_std" or false) ||
        (aho_corasick."0.7.6"."std" or false) ||
        (f."aho_corasick"."0.7.6"."std" or false); }
      { "${deps.aho_corasick."0.7.6".memchr}".default = (f.memchr."${deps.aho_corasick."0.7.6".memchr}".default or false); }
    ];
  }) [
    (features_.memchr."${deps."aho_corasick"."0.7.6"."memchr"}" deps)
  ];


# end
# atk-0.8.0

  crates.atk."0.8.0" = deps: { features?(features_.atk."0.8.0" deps {}) }: buildRustCrate {
    crateName = "atk";
    version = "0.8.0";
    description = "Rust bindings for the ATK library";
    authors = [ "The Gtk-rs Project Developers" ];
    sha256 = "05m0cxqlszgqmkj86jrf99kc374n797irjc4mbbmmm8hy9fxb6qg";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."atk_sys"."${deps."atk"."0.8.0"."atk_sys"}" deps)
      (crates."bitflags"."${deps."atk"."0.8.0"."bitflags"}" deps)
      (crates."glib"."${deps."atk"."0.8.0"."glib"}" deps)
      (crates."glib_sys"."${deps."atk"."0.8.0"."glib_sys"}" deps)
      (crates."gobject_sys"."${deps."atk"."0.8.0"."gobject_sys"}" deps)
      (crates."libc"."${deps."atk"."0.8.0"."libc"}" deps)
    ]);

    buildDependencies = mapFeatures features ([
]);
    features = mkFeatures (features."atk"."0.8.0" or {});
  };
  features_.atk."0.8.0" = deps: f: updateFeatures f (rec {
    atk = fold recursiveUpdate {} [
      { "0.8.0"."gtk-rs-lgpl-docs" =
        (f.atk."0.8.0"."gtk-rs-lgpl-docs" or false) ||
        (f.atk."0.8.0".embed-lgpl-docs or false) ||
        (atk."0.8.0"."embed-lgpl-docs" or false) ||
        (f.atk."0.8.0".purge-lgpl-docs or false) ||
        (atk."0.8.0"."purge-lgpl-docs" or false); }
      { "0.8.0"."v2_30" =
        (f.atk."0.8.0"."v2_30" or false) ||
        (f.atk."0.8.0".v2_32 or false) ||
        (atk."0.8.0"."v2_32" or false); }
      { "0.8.0"."v2_32" =
        (f.atk."0.8.0"."v2_32" or false) ||
        (f.atk."0.8.0".v2_34 or false) ||
        (atk."0.8.0"."v2_34" or false); }
      { "0.8.0".default = (f.atk."0.8.0".default or true); }
    ];
    atk_sys = fold recursiveUpdate {} [
      { "${deps.atk."0.8.0".atk_sys}"."dox" =
        (f.atk_sys."${deps.atk."0.8.0".atk_sys}"."dox" or false) ||
        (atk."0.8.0"."dox" or false) ||
        (f."atk"."0.8.0"."dox" or false); }
      { "${deps.atk."0.8.0".atk_sys}"."v2_30" =
        (f.atk_sys."${deps.atk."0.8.0".atk_sys}"."v2_30" or false) ||
        (atk."0.8.0"."v2_30" or false) ||
        (f."atk"."0.8.0"."v2_30" or false); }
      { "${deps.atk."0.8.0".atk_sys}"."v2_32" =
        (f.atk_sys."${deps.atk."0.8.0".atk_sys}"."v2_32" or false) ||
        (atk."0.8.0"."v2_32" or false) ||
        (f."atk"."0.8.0"."v2_32" or false); }
      { "${deps.atk."0.8.0".atk_sys}"."v2_34" =
        (f.atk_sys."${deps.atk."0.8.0".atk_sys}"."v2_34" or false) ||
        (atk."0.8.0"."v2_34" or false) ||
        (f."atk"."0.8.0"."v2_34" or false); }
      { "${deps.atk."0.8.0".atk_sys}".default = true; }
    ];
    bitflags."${deps.atk."0.8.0".bitflags}".default = true;
    glib."${deps.atk."0.8.0".glib}".default = true;
    glib_sys."${deps.atk."0.8.0".glib_sys}".default = true;
    gobject_sys."${deps.atk."0.8.0".gobject_sys}".default = true;
    libc."${deps.atk."0.8.0".libc}".default = true;
  }) [
    (features_.atk_sys."${deps."atk"."0.8.0"."atk_sys"}" deps)
    (features_.bitflags."${deps."atk"."0.8.0"."bitflags"}" deps)
    (features_.glib."${deps."atk"."0.8.0"."glib"}" deps)
    (features_.glib_sys."${deps."atk"."0.8.0"."glib_sys"}" deps)
    (features_.gobject_sys."${deps."atk"."0.8.0"."gobject_sys"}" deps)
    (features_.libc."${deps."atk"."0.8.0"."libc"}" deps)
  ];


# end
# atk-sys-0.9.1

  crates.atk_sys."0.9.1" = deps: { features?(features_.atk_sys."0.9.1" deps {}) }: buildRustCrate {
    crateName = "atk-sys";
    version = "0.9.1";
    description = "FFI bindings to libatk-1";
    authors = [ "The Gtk-rs Project Developers" ];
    sha256 = "0hj7csxrg4w8a6cd3qnviaz52ybn5kzsvg2y563c96m9zdg1338h";
    libName = "atk_sys";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."glib_sys"."${deps."atk_sys"."0.9.1"."glib_sys"}" deps)
      (crates."gobject_sys"."${deps."atk_sys"."0.9.1"."gobject_sys"}" deps)
      (crates."libc"."${deps."atk_sys"."0.9.1"."libc"}" deps)
    ]);

    buildDependencies = mapFeatures features ([
      (crates."pkg_config"."${deps."atk_sys"."0.9.1"."pkg_config"}" deps)
    ]);
    features = mkFeatures (features."atk_sys"."0.9.1" or {});
  };
  features_.atk_sys."0.9.1" = deps: f: updateFeatures f (rec {
    atk_sys = fold recursiveUpdate {} [
      { "0.9.1"."v2_30" =
        (f.atk_sys."0.9.1"."v2_30" or false) ||
        (f.atk_sys."0.9.1".v2_32 or false) ||
        (atk_sys."0.9.1"."v2_32" or false); }
      { "0.9.1"."v2_32" =
        (f.atk_sys."0.9.1"."v2_32" or false) ||
        (f.atk_sys."0.9.1".v2_34 or false) ||
        (atk_sys."0.9.1"."v2_34" or false); }
      { "0.9.1".default = (f.atk_sys."0.9.1".default or true); }
    ];
    glib_sys."${deps.atk_sys."0.9.1".glib_sys}".default = true;
    gobject_sys."${deps.atk_sys."0.9.1".gobject_sys}".default = true;
    libc."${deps.atk_sys."0.9.1".libc}".default = true;
    pkg_config."${deps.atk_sys."0.9.1".pkg_config}".default = true;
  }) [
    (features_.glib_sys."${deps."atk_sys"."0.9.1"."glib_sys"}" deps)
    (features_.gobject_sys."${deps."atk_sys"."0.9.1"."gobject_sys"}" deps)
    (features_.libc."${deps."atk_sys"."0.9.1"."libc"}" deps)
    (features_.pkg_config."${deps."atk_sys"."0.9.1"."pkg_config"}" deps)
  ];


# end
# autocfg-0.1.7

  crates.autocfg."0.1.7" = deps: { features?(features_.autocfg."0.1.7" deps {}) }: buildRustCrate {
    crateName = "autocfg";
    version = "0.1.7";
    description = "Automatic cfg for Rust compiler features";
    authors = [ "Josh Stone <cuviper@gmail.com>" ];
    sha256 = "01iq4rs9kanj88pbwjxzqp5k4bgdsvz3y398nljz441rfws11mi4";
  };
  features_.autocfg."0.1.7" = deps: f: updateFeatures f (rec {
    autocfg."0.1.7".default = (f.autocfg."0.1.7".default or true);
  }) [];


# end
# bitflags-1.2.1

  crates.bitflags."1.2.1" = deps: { features?(features_.bitflags."1.2.1" deps {}) }: buildRustCrate {
    crateName = "bitflags";
    version = "1.2.1";
    description = "A macro to generate structures which behave like bitflags.\n";
    authors = [ "The Rust Project Developers" ];
    sha256 = "0b77awhpn7yaqjjibm69ginfn996azx5vkzfjj39g3wbsqs7mkxg";
    build = "build.rs";
    features = mkFeatures (features."bitflags"."1.2.1" or {});
  };
  features_.bitflags."1.2.1" = deps: f: updateFeatures f (rec {
    bitflags."1.2.1".default = (f.bitflags."1.2.1".default or true);
  }) [];


# end
# byteorder-0.4.2

  crates.byteorder."0.4.2" = deps: { features?(features_.byteorder."0.4.2" deps {}) }: buildRustCrate {
    crateName = "byteorder";
    version = "0.4.2";
    description = "Library for reading/writing numbers in big-endian and little-endian.";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" ];
    sha256 = "1z9r38lfr9cbd3pf60dn8n5qhy7iyczi8972b0cl15941masxsv9";
    features = mkFeatures (features."byteorder"."0.4.2" or {});
  };
  features_.byteorder."0.4.2" = deps: f: updateFeatures f (rec {
    byteorder."0.4.2".default = (f.byteorder."0.4.2".default or true);
  }) [];


# end
# cairo-rs-0.8.0

  crates.cairo_rs."0.8.0" = deps: { features?(features_.cairo_rs."0.8.0" deps {}) }: buildRustCrate {
    crateName = "cairo-rs";
    version = "0.8.0";
    description = "Rust bindings for the Cairo library";
    authors = [ "The Gtk-rs Project Developers" ];
    sha256 = "0s38s4as0nfwccpsksa6qyb1l8cyms6wy63dal1l434wllhk69bv";
    libName = "cairo";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."bitflags"."${deps."cairo_rs"."0.8.0"."bitflags"}" deps)
      (crates."cairo_sys_rs"."${deps."cairo_rs"."0.8.0"."cairo_sys_rs"}" deps)
      (crates."libc"."${deps."cairo_rs"."0.8.0"."libc"}" deps)
    ]
      ++ (if features.cairo_rs."0.8.0".glib or false then [ (crates.glib."${deps."cairo_rs"."0.8.0".glib}" deps) ] else [])
      ++ (if features.cairo_rs."0.8.0".glib-sys or false then [ (crates.glib_sys."${deps."cairo_rs"."0.8.0".glib_sys}" deps) ] else [])
      ++ (if features.cairo_rs."0.8.0".gobject-sys or false then [ (crates.gobject_sys."${deps."cairo_rs"."0.8.0".gobject_sys}" deps) ] else []));

    buildDependencies = mapFeatures features ([
]);
    features = mkFeatures (features."cairo_rs"."0.8.0" or {});
  };
  features_.cairo_rs."0.8.0" = deps: f: updateFeatures f (rec {
    bitflags."${deps.cairo_rs."0.8.0".bitflags}".default = true;
    cairo_rs = fold recursiveUpdate {} [
      { "0.8.0"."glib" =
        (f.cairo_rs."0.8.0"."glib" or false) ||
        (f.cairo_rs."0.8.0".use_glib or false) ||
        (cairo_rs."0.8.0"."use_glib" or false); }
      { "0.8.0"."glib-sys" =
        (f.cairo_rs."0.8.0"."glib-sys" or false) ||
        (f.cairo_rs."0.8.0".use_glib or false) ||
        (cairo_rs."0.8.0"."use_glib" or false); }
      { "0.8.0"."gobject-sys" =
        (f.cairo_rs."0.8.0"."gobject-sys" or false) ||
        (f.cairo_rs."0.8.0".use_glib or false) ||
        (cairo_rs."0.8.0"."use_glib" or false); }
      { "0.8.0"."gtk-rs-lgpl-docs" =
        (f.cairo_rs."0.8.0"."gtk-rs-lgpl-docs" or false) ||
        (f.cairo_rs."0.8.0".embed-lgpl-docs or false) ||
        (cairo_rs."0.8.0"."embed-lgpl-docs" or false) ||
        (f.cairo_rs."0.8.0".purge-lgpl-docs or false) ||
        (cairo_rs."0.8.0"."purge-lgpl-docs" or false); }
      { "0.8.0"."use_glib" =
        (f.cairo_rs."0.8.0"."use_glib" or false) ||
        (f.cairo_rs."0.8.0".default or false) ||
        (cairo_rs."0.8.0"."default" or false); }
      { "0.8.0"."v1_14" =
        (f.cairo_rs."0.8.0"."v1_14" or false) ||
        (f.cairo_rs."0.8.0".v1_16 or false) ||
        (cairo_rs."0.8.0"."v1_16" or false); }
      { "0.8.0".default = (f.cairo_rs."0.8.0".default or true); }
    ];
    cairo_sys_rs = fold recursiveUpdate {} [
      { "${deps.cairo_rs."0.8.0".cairo_sys_rs}"."dox" =
        (f.cairo_sys_rs."${deps.cairo_rs."0.8.0".cairo_sys_rs}"."dox" or false) ||
        (cairo_rs."0.8.0"."dox" or false) ||
        (f."cairo_rs"."0.8.0"."dox" or false); }
      { "${deps.cairo_rs."0.8.0".cairo_sys_rs}"."pdf" =
        (f.cairo_sys_rs."${deps.cairo_rs."0.8.0".cairo_sys_rs}"."pdf" or false) ||
        (cairo_rs."0.8.0"."pdf" or false) ||
        (f."cairo_rs"."0.8.0"."pdf" or false); }
      { "${deps.cairo_rs."0.8.0".cairo_sys_rs}"."png" =
        (f.cairo_sys_rs."${deps.cairo_rs."0.8.0".cairo_sys_rs}"."png" or false) ||
        (cairo_rs."0.8.0"."png" or false) ||
        (f."cairo_rs"."0.8.0"."png" or false); }
      { "${deps.cairo_rs."0.8.0".cairo_sys_rs}"."ps" =
        (f.cairo_sys_rs."${deps.cairo_rs."0.8.0".cairo_sys_rs}"."ps" or false) ||
        (cairo_rs."0.8.0"."ps" or false) ||
        (f."cairo_rs"."0.8.0"."ps" or false); }
      { "${deps.cairo_rs."0.8.0".cairo_sys_rs}"."svg" =
        (f.cairo_sys_rs."${deps.cairo_rs."0.8.0".cairo_sys_rs}"."svg" or false) ||
        (cairo_rs."0.8.0"."svg" or false) ||
        (f."cairo_rs"."0.8.0"."svg" or false); }
      { "${deps.cairo_rs."0.8.0".cairo_sys_rs}"."use_glib" =
        (f.cairo_sys_rs."${deps.cairo_rs."0.8.0".cairo_sys_rs}"."use_glib" or false) ||
        (cairo_rs."0.8.0"."use_glib" or false) ||
        (f."cairo_rs"."0.8.0"."use_glib" or false); }
      { "${deps.cairo_rs."0.8.0".cairo_sys_rs}"."v1_14" =
        (f.cairo_sys_rs."${deps.cairo_rs."0.8.0".cairo_sys_rs}"."v1_14" or false) ||
        (cairo_rs."0.8.0"."v1_14" or false) ||
        (f."cairo_rs"."0.8.0"."v1_14" or false); }
      { "${deps.cairo_rs."0.8.0".cairo_sys_rs}"."v1_16" =
        (f.cairo_sys_rs."${deps.cairo_rs."0.8.0".cairo_sys_rs}"."v1_16" or false) ||
        (cairo_rs."0.8.0"."v1_16" or false) ||
        (f."cairo_rs"."0.8.0"."v1_16" or false); }
      { "${deps.cairo_rs."0.8.0".cairo_sys_rs}"."win32-surface" =
        (f.cairo_sys_rs."${deps.cairo_rs."0.8.0".cairo_sys_rs}"."win32-surface" or false) ||
        (cairo_rs."0.8.0"."win32-surface" or false) ||
        (f."cairo_rs"."0.8.0"."win32-surface" or false); }
      { "${deps.cairo_rs."0.8.0".cairo_sys_rs}"."xcb" =
        (f.cairo_sys_rs."${deps.cairo_rs."0.8.0".cairo_sys_rs}"."xcb" or false) ||
        (cairo_rs."0.8.0"."xcb" or false) ||
        (f."cairo_rs"."0.8.0"."xcb" or false); }
      { "${deps.cairo_rs."0.8.0".cairo_sys_rs}"."xlib" =
        (f.cairo_sys_rs."${deps.cairo_rs."0.8.0".cairo_sys_rs}"."xlib" or false) ||
        (cairo_rs."0.8.0"."xlib" or false) ||
        (f."cairo_rs"."0.8.0"."xlib" or false); }
      { "${deps.cairo_rs."0.8.0".cairo_sys_rs}".default = true; }
    ];
    glib = fold recursiveUpdate {} [
      { "${deps.cairo_rs."0.8.0".glib}"."dox" =
        (f.glib."${deps.cairo_rs."0.8.0".glib}"."dox" or false) ||
        (cairo_rs."0.8.0"."dox" or false) ||
        (f."cairo_rs"."0.8.0"."dox" or false); }
      { "${deps.cairo_rs."0.8.0".glib}".default = true; }
    ];
    glib_sys."${deps.cairo_rs."0.8.0".glib_sys}".default = true;
    gobject_sys."${deps.cairo_rs."0.8.0".gobject_sys}".default = true;
    libc."${deps.cairo_rs."0.8.0".libc}".default = true;
  }) [
    (features_.bitflags."${deps."cairo_rs"."0.8.0"."bitflags"}" deps)
    (features_.cairo_sys_rs."${deps."cairo_rs"."0.8.0"."cairo_sys_rs"}" deps)
    (features_.glib."${deps."cairo_rs"."0.8.0"."glib"}" deps)
    (features_.glib_sys."${deps."cairo_rs"."0.8.0"."glib_sys"}" deps)
    (features_.gobject_sys."${deps."cairo_rs"."0.8.0"."gobject_sys"}" deps)
    (features_.libc."${deps."cairo_rs"."0.8.0"."libc"}" deps)
  ];


# end
# cairo-sys-rs-0.9.2

  crates.cairo_sys_rs."0.9.2" = deps: { features?(features_.cairo_sys_rs."0.9.2" deps {}) }: buildRustCrate {
    crateName = "cairo-sys-rs";
    version = "0.9.2";
    description = "FFI bindings to libcairo";
    authors = [ "The Gtk-rs Project Developers" ];
    sha256 = "11npicpam4gsg62h72ypyzxnvpqxbm676sz31nv6xr87fz1lclqk";
    libName = "cairo_sys";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."libc"."${deps."cairo_sys_rs"."0.9.2"."libc"}" deps)
    ]
      ++ (if features.cairo_sys_rs."0.9.2".glib-sys or false then [ (crates.glib_sys."${deps."cairo_sys_rs"."0.9.2".glib_sys}" deps) ] else []))
      ++ (if kernel == "windows" then mapFeatures features ([
]) else []);

    buildDependencies = mapFeatures features ([
      (crates."pkg_config"."${deps."cairo_sys_rs"."0.9.2"."pkg_config"}" deps)
    ]);
    features = mkFeatures (features."cairo_sys_rs"."0.9.2" or {});
  };
  features_.cairo_sys_rs."0.9.2" = deps: f: updateFeatures f (rec {
    cairo_sys_rs = fold recursiveUpdate {} [
      { "0.9.2"."glib-sys" =
        (f.cairo_sys_rs."0.9.2"."glib-sys" or false) ||
        (f.cairo_sys_rs."0.9.2".use_glib or false) ||
        (cairo_sys_rs."0.9.2"."use_glib" or false); }
      { "0.9.2"."v1_14" =
        (f.cairo_sys_rs."0.9.2"."v1_14" or false) ||
        (f.cairo_sys_rs."0.9.2".v1_16 or false) ||
        (cairo_sys_rs."0.9.2"."v1_16" or false); }
      { "0.9.2"."winapi" =
        (f.cairo_sys_rs."0.9.2"."winapi" or false) ||
        (f.cairo_sys_rs."0.9.2".win32-surface or false) ||
        (cairo_sys_rs."0.9.2"."win32-surface" or false); }
      { "0.9.2"."x11" =
        (f.cairo_sys_rs."0.9.2"."x11" or false) ||
        (f.cairo_sys_rs."0.9.2".xlib or false) ||
        (cairo_sys_rs."0.9.2"."xlib" or false); }
      { "0.9.2".default = (f.cairo_sys_rs."0.9.2".default or true); }
    ];
    glib_sys."${deps.cairo_sys_rs."0.9.2".glib_sys}".default = true;
    libc."${deps.cairo_sys_rs."0.9.2".libc}".default = true;
    pkg_config."${deps.cairo_sys_rs."0.9.2".pkg_config}".default = true;
  }) [
    (features_.glib_sys."${deps."cairo_sys_rs"."0.9.2"."glib_sys"}" deps)
    (features_.libc."${deps."cairo_sys_rs"."0.9.2"."libc"}" deps)
    (features_.pkg_config."${deps."cairo_sys_rs"."0.9.2"."pkg_config"}" deps)
  ];


# end
# cc-1.0.48

  crates.cc."1.0.48" = deps: { features?(features_.cc."1.0.48" deps {}) }: buildRustCrate {
    crateName = "cc";
    version = "1.0.48";
    description = "A build-time dependency for Cargo build scripts to assist in invoking the native\nC compiler to compile native C code into a static archive to be linked into Rust\ncode.\n";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    edition = "2018";
    sha256 = "1i8h3f949i0ymlyj8nn80v8q5h4cqz6m953vks1lhii9gz0gq329";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."cc"."1.0.48" or {});
  };
  features_.cc."1.0.48" = deps: f: updateFeatures f (rec {
    cc = fold recursiveUpdate {} [
      { "1.0.48"."jobserver" =
        (f.cc."1.0.48"."jobserver" or false) ||
        (f.cc."1.0.48".parallel or false) ||
        (cc."1.0.48"."parallel" or false); }
      { "1.0.48"."num_cpus" =
        (f.cc."1.0.48"."num_cpus" or false) ||
        (f.cc."1.0.48".parallel or false) ||
        (cc."1.0.48"."parallel" or false); }
      { "1.0.48".default = (f.cc."1.0.48".default or true); }
    ];
  }) [];


# end
# cfg-if-0.1.10

  crates.cfg_if."0.1.10" = deps: { features?(features_.cfg_if."0.1.10" deps {}) }: buildRustCrate {
    crateName = "cfg-if";
    version = "0.1.10";
    description = "A macro to ergonomically define an item depending on a large number of #[cfg]\nparameters. Structured like an if-else chain, the first matching branch is the\nitem that gets emitted.\n";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    edition = "2018";
    sha256 = "0x52qzpbyl2f2jqs7kkqzgfki2cpq99gpfjjigdp8pwwfqk01007";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."cfg_if"."0.1.10" or {});
  };
  features_.cfg_if."0.1.10" = deps: f: updateFeatures f (rec {
    cfg_if = fold recursiveUpdate {} [
      { "0.1.10"."compiler_builtins" =
        (f.cfg_if."0.1.10"."compiler_builtins" or false) ||
        (f.cfg_if."0.1.10".rustc-dep-of-std or false) ||
        (cfg_if."0.1.10"."rustc-dep-of-std" or false); }
      { "0.1.10"."core" =
        (f.cfg_if."0.1.10"."core" or false) ||
        (f.cfg_if."0.1.10".rustc-dep-of-std or false) ||
        (cfg_if."0.1.10"."rustc-dep-of-std" or false); }
      { "0.1.10".default = (f.cfg_if."0.1.10".default or true); }
    ];
  }) [];


# end
# chrono-0.4.10

  crates.chrono."0.4.10" = deps: { features?(features_.chrono."0.4.10" deps {}) }: buildRustCrate {
    crateName = "chrono";
    version = "0.4.10";
    description = "Date and time library for Rust";
    authors = [ "Kang Seonghoon <public+rust@mearie.org>" "Brandon W Maister <quodlibetor@gmail.com>" ];
    sha256 = "13yj8csdvzzcrw8g4946rip5wgvviafg6cg01m1r32vgnssb2kr5";
    dependencies = mapFeatures features ([
      (crates."num_integer"."${deps."chrono"."0.4.10"."num_integer"}" deps)
      (crates."num_traits"."${deps."chrono"."0.4.10"."num_traits"}" deps)
    ]
      ++ (if features.chrono."0.4.10".serde or false then [ (crates.serde."${deps."chrono"."0.4.10".serde}" deps) ] else [])
      ++ (if features.chrono."0.4.10".time or false then [ (crates.time."${deps."chrono"."0.4.10".time}" deps) ] else []))
      ++ (if cpu == "wasm32" && !(kernel == "emscripten") then mapFeatures features ([
]) else []);
    features = mkFeatures (features."chrono"."0.4.10" or {});
  };
  features_.chrono."0.4.10" = deps: f: updateFeatures f (rec {
    chrono = fold recursiveUpdate {} [
      { "0.4.10"."clock" =
        (f.chrono."0.4.10"."clock" or false) ||
        (f.chrono."0.4.10".default or false) ||
        (chrono."0.4.10"."default" or false); }
      { "0.4.10"."js-sys" =
        (f.chrono."0.4.10"."js-sys" or false) ||
        (f.chrono."0.4.10".wasmbind or false) ||
        (chrono."0.4.10"."wasmbind" or false); }
      { "0.4.10"."std" =
        (f.chrono."0.4.10"."std" or false) ||
        (f.chrono."0.4.10".bench or false) ||
        (chrono."0.4.10"."bench" or false) ||
        (f.chrono."0.4.10".clock or false) ||
        (chrono."0.4.10"."clock" or false) ||
        (f.chrono."0.4.10".default or false) ||
        (chrono."0.4.10"."default" or false); }
      { "0.4.10"."time" =
        (f.chrono."0.4.10"."time" or false) ||
        (f.chrono."0.4.10".clock or false) ||
        (chrono."0.4.10"."clock" or false); }
      { "0.4.10"."wasm-bindgen" =
        (f.chrono."0.4.10"."wasm-bindgen" or false) ||
        (f.chrono."0.4.10".wasmbind or false) ||
        (chrono."0.4.10"."wasmbind" or false); }
      { "0.4.10".default = (f.chrono."0.4.10".default or true); }
    ];
    num_integer."${deps.chrono."0.4.10".num_integer}".default = (f.num_integer."${deps.chrono."0.4.10".num_integer}".default or false);
    num_traits."${deps.chrono."0.4.10".num_traits}".default = (f.num_traits."${deps.chrono."0.4.10".num_traits}".default or false);
    serde."${deps.chrono."0.4.10".serde}".default = (f.serde."${deps.chrono."0.4.10".serde}".default or false);
    time."${deps.chrono."0.4.10".time}".default = true;
  }) [
    (features_.num_integer."${deps."chrono"."0.4.10"."num_integer"}" deps)
    (features_.num_traits."${deps."chrono"."0.4.10"."num_traits"}" deps)
    (features_.serde."${deps."chrono"."0.4.10"."serde"}" deps)
    (features_.time."${deps."chrono"."0.4.10"."time"}" deps)
  ];


# end
# chrono-tz-0.4.1

  crates.chrono_tz."0.4.1" = deps: { features?(features_.chrono_tz."0.4.1" deps {}) }: buildRustCrate {
    crateName = "chrono-tz";
    version = "0.4.1";
    description = "TimeZone implementations for rust-chrono from the IANA database";
    authors = [ "Djzin" ];
    sha256 = "02nb3n9pq361hx7b4qlr6yisgaaan54wca478yfyisyz1x5vm8n9";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."chrono"."${deps."chrono_tz"."0.4.1"."chrono"}" deps)
    ]
      ++ (if features.chrono_tz."0.4.1".serde or false then [ (crates.serde."${deps."chrono_tz"."0.4.1".serde}" deps) ] else []));

    buildDependencies = mapFeatures features ([
      (crates."parse_zoneinfo"."${deps."chrono_tz"."0.4.1"."parse_zoneinfo"}" deps)
    ]);
    features = mkFeatures (features."chrono_tz"."0.4.1" or {});
  };
  features_.chrono_tz."0.4.1" = deps: f: updateFeatures f (rec {
    chrono."${deps.chrono_tz."0.4.1".chrono}".default = true;
    chrono_tz."0.4.1".default = (f.chrono_tz."0.4.1".default or true);
    parse_zoneinfo."${deps.chrono_tz."0.4.1".parse_zoneinfo}".default = true;
    serde."${deps.chrono_tz."0.4.1".serde}".default = true;
  }) [
    (features_.chrono."${deps."chrono_tz"."0.4.1"."chrono"}" deps)
    (features_.serde."${deps."chrono_tz"."0.4.1"."serde"}" deps)
    (features_.parse_zoneinfo."${deps."chrono_tz"."0.4.1"."parse_zoneinfo"}" deps)
  ];


# end
# dimensioned-0.7.0

  crates.dimensioned."0.7.0" = deps: { features?(features_.dimensioned."0.7.0" deps {}) }: buildRustCrate {
    crateName = "dimensioned";
    version = "0.7.0";
    description = "Compile-time dimensional analysis for various unit systems using Rust's type system.\n\nDimensioned aims to build on Rust's safety features by adding unit safety with no runtime cost. In\naddition, it aims to be as easy to use as possible, hopefully making things easier for you not just\nby avoiding bugs but also by making it clear what units things are.\n\nNever again should you need to specify units in a comment!";
    authors = [ "Paho Lurie-Gregg <paho@paholg.com>" ];
    sha256 = "1qr5v55i8drj78411q1plmq6b5s9mv6r67c58v8mh2wb0n7lffjh";
    build = "src/build/mod.rs";
    dependencies = mapFeatures features ([
      (crates."generic_array"."${deps."dimensioned"."0.7.0"."generic_array"}" deps)
      (crates."num_traits"."${deps."dimensioned"."0.7.0"."num_traits"}" deps)
      (crates."typenum"."${deps."dimensioned"."0.7.0"."typenum"}" deps)
    ]
      ++ (if features.dimensioned."0.7.0".serde or false then [ (crates.serde."${deps."dimensioned"."0.7.0".serde}" deps) ] else []));
    features = mkFeatures (features."dimensioned"."0.7.0" or {});
  };
  features_.dimensioned."0.7.0" = deps: f: updateFeatures f (rec {
    dimensioned = fold recursiveUpdate {} [
      { "0.7.0"."approx" =
        (f.dimensioned."0.7.0"."approx" or false) ||
        (f.dimensioned."0.7.0".test or false) ||
        (dimensioned."0.7.0"."test" or false); }
      { "0.7.0"."ci" =
        (f.dimensioned."0.7.0"."ci" or false) ||
        (f.dimensioned."0.7.0".test or false) ||
        (dimensioned."0.7.0"."test" or false); }
      { "0.7.0"."clapme" =
        (f.dimensioned."0.7.0"."clapme" or false) ||
        (f.dimensioned."0.7.0".test or false) ||
        (dimensioned."0.7.0"."test" or false); }
      { "0.7.0"."quickcheck" =
        (f.dimensioned."0.7.0"."quickcheck" or false) ||
        (f.dimensioned."0.7.0".test or false) ||
        (dimensioned."0.7.0"."test" or false); }
      { "0.7.0"."serde" =
        (f.dimensioned."0.7.0"."serde" or false) ||
        (f.dimensioned."0.7.0".test or false) ||
        (dimensioned."0.7.0"."test" or false); }
      { "0.7.0"."serde_test" =
        (f.dimensioned."0.7.0"."serde_test" or false) ||
        (f.dimensioned."0.7.0".test or false) ||
        (dimensioned."0.7.0"."test" or false); }
      { "0.7.0"."std" =
        (f.dimensioned."0.7.0"."std" or false) ||
        (f.dimensioned."0.7.0".default or false) ||
        (dimensioned."0.7.0"."default" or false); }
      { "0.7.0".default = (f.dimensioned."0.7.0".default or true); }
    ];
    generic_array."${deps.dimensioned."0.7.0".generic_array}".default = true;
    num_traits."${deps.dimensioned."0.7.0".num_traits}".default = (f.num_traits."${deps.dimensioned."0.7.0".num_traits}".default or false);
    serde."${deps.dimensioned."0.7.0".serde}".default = true;
    typenum."${deps.dimensioned."0.7.0".typenum}".default = true;
  }) [
    (features_.generic_array."${deps."dimensioned"."0.7.0"."generic_array"}" deps)
    (features_.num_traits."${deps."dimensioned"."0.7.0"."num_traits"}" deps)
    (features_.serde."${deps."dimensioned"."0.7.0"."serde"}" deps)
    (features_.typenum."${deps."dimensioned"."0.7.0"."typenum"}" deps)
  ];


# end
# dtoa-0.4.4

  crates.dtoa."0.4.4" = deps: { features?(features_.dtoa."0.4.4" deps {}) }: buildRustCrate {
    crateName = "dtoa";
    version = "0.4.4";
    description = "Fast functions for printing floating-point primitives to an io::Write";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "1nbq72nc2kp8lbx6i1ml5ird5c0cy4i6dvm7wfydybmanw4m07xz";
  };
  features_.dtoa."0.4.4" = deps: f: updateFeatures f (rec {
    dtoa."0.4.4".default = (f.dtoa."0.4.4".default or true);
  }) [];


# end
# emseries-0.4.0

  crates.emseries."0.4.0" = deps: { features?(features_.emseries."0.4.0" deps {}) }: buildRustCrate {
    crateName = "emseries";
    version = "0.4.0";
    description = "an Embedded Time Series database";
    authors = [ "Savanni D'Gerinel <savanni@luminescent-dreams.com>" ];
    sha256 = "1fm7zc91kfl4qbafy9h7428i8mp17pkc57rgqjyx2hq7nayph4di";
    dependencies = mapFeatures features ([
      (crates."chrono"."${deps."emseries"."0.4.0"."chrono"}" deps)
      (crates."chrono_tz"."${deps."emseries"."0.4.0"."chrono_tz"}" deps)
      (crates."dimensioned"."${deps."emseries"."0.4.0"."dimensioned"}" deps)
      (crates."serde"."${deps."emseries"."0.4.0"."serde"}" deps)
      (crates."serde_derive"."${deps."emseries"."0.4.0"."serde_derive"}" deps)
      (crates."serde_json"."${deps."emseries"."0.4.0"."serde_json"}" deps)
      (crates."uuid"."${deps."emseries"."0.4.0"."uuid"}" deps)
      (crates."yaml_rust"."${deps."emseries"."0.4.0"."yaml_rust"}" deps)
    ]);
  };
  features_.emseries."0.4.0" = deps: f: updateFeatures f (rec {
    chrono = fold recursiveUpdate {} [
      { "${deps.emseries."0.4.0".chrono}"."serde" = true; }
      { "${deps.emseries."0.4.0".chrono}".default = true; }
    ];
    chrono_tz = fold recursiveUpdate {} [
      { "${deps.emseries."0.4.0".chrono_tz}"."serde" = true; }
      { "${deps.emseries."0.4.0".chrono_tz}".default = true; }
    ];
    dimensioned = fold recursiveUpdate {} [
      { "${deps.emseries."0.4.0".dimensioned}"."serde" = true; }
      { "${deps.emseries."0.4.0".dimensioned}".default = true; }
    ];
    emseries."0.4.0".default = (f.emseries."0.4.0".default or true);
    serde."${deps.emseries."0.4.0".serde}".default = true;
    serde_derive."${deps.emseries."0.4.0".serde_derive}".default = true;
    serde_json."${deps.emseries."0.4.0".serde_json}".default = true;
    uuid = fold recursiveUpdate {} [
      { "${deps.emseries."0.4.0".uuid}"."serde" = true; }
      { "${deps.emseries."0.4.0".uuid}"."v4" = true; }
      { "${deps.emseries."0.4.0".uuid}".default = true; }
    ];
    yaml_rust."${deps.emseries."0.4.0".yaml_rust}".default = true;
  }) [
    (features_.chrono."${deps."emseries"."0.4.0"."chrono"}" deps)
    (features_.chrono_tz."${deps."emseries"."0.4.0"."chrono_tz"}" deps)
    (features_.dimensioned."${deps."emseries"."0.4.0"."dimensioned"}" deps)
    (features_.serde."${deps."emseries"."0.4.0"."serde"}" deps)
    (features_.serde_derive."${deps."emseries"."0.4.0"."serde_derive"}" deps)
    (features_.serde_json."${deps."emseries"."0.4.0"."serde_json"}" deps)
    (features_.uuid."${deps."emseries"."0.4.0"."uuid"}" deps)
    (features_.yaml_rust."${deps."emseries"."0.4.0"."yaml_rust"}" deps)
  ];


# end
# fuchsia-cprng-0.1.1

  crates.fuchsia_cprng."0.1.1" = deps: { features?(features_.fuchsia_cprng."0.1.1" deps {}) }: buildRustCrate {
    crateName = "fuchsia-cprng";
    version = "0.1.1";
    description = "Rust crate for the Fuchsia cryptographically secure pseudorandom number generator";
    authors = [ "Erick Tryzelaar <etryzelaar@google.com>" ];
    edition = "2018";
    sha256 = "07apwv9dj716yjlcj29p94vkqn5zmfh7hlrqvrjx3wzshphc95h9";
  };
  features_.fuchsia_cprng."0.1.1" = deps: f: updateFeatures f (rec {
    fuchsia_cprng."0.1.1".default = (f.fuchsia_cprng."0.1.1".default or true);
  }) [];


# end
# futures-channel-0.3.1

  crates.futures_channel."0.3.1" = deps: { features?(features_.futures_channel."0.3.1" deps {}) }: buildRustCrate {
    crateName = "futures-channel";
    version = "0.3.1";
    description = "Channels for asynchronous communication using futures-rs.\n";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    edition = "2018";
    sha256 = "1qrqhzkb09ci138w1cpr0mzrrcq12v0b941xli8i1sk6cmikh35m";
    libName = "futures_channel";
    dependencies = mapFeatures features ([
      (crates."futures_core"."${deps."futures_channel"."0.3.1"."futures_core"}" deps)
    ]);
    features = mkFeatures (features."futures_channel"."0.3.1" or {});
  };
  features_.futures_channel."0.3.1" = deps: f: updateFeatures f (rec {
    futures_channel = fold recursiveUpdate {} [
      { "0.3.1"."alloc" =
        (f.futures_channel."0.3.1"."alloc" or false) ||
        (f.futures_channel."0.3.1".std or false) ||
        (futures_channel."0.3.1"."std" or false); }
      { "0.3.1"."futures-sink" =
        (f.futures_channel."0.3.1"."futures-sink" or false) ||
        (f.futures_channel."0.3.1".sink or false) ||
        (futures_channel."0.3.1"."sink" or false); }
      { "0.3.1"."std" =
        (f.futures_channel."0.3.1"."std" or false) ||
        (f.futures_channel."0.3.1".default or false) ||
        (futures_channel."0.3.1"."default" or false); }
      { "0.3.1".default = (f.futures_channel."0.3.1".default or true); }
    ];
    futures_core = fold recursiveUpdate {} [
      { "${deps.futures_channel."0.3.1".futures_core}"."alloc" =
        (f.futures_core."${deps.futures_channel."0.3.1".futures_core}"."alloc" or false) ||
        (futures_channel."0.3.1"."alloc" or false) ||
        (f."futures_channel"."0.3.1"."alloc" or false); }
      { "${deps.futures_channel."0.3.1".futures_core}"."cfg-target-has-atomic" =
        (f.futures_core."${deps.futures_channel."0.3.1".futures_core}"."cfg-target-has-atomic" or false) ||
        (futures_channel."0.3.1"."cfg-target-has-atomic" or false) ||
        (f."futures_channel"."0.3.1"."cfg-target-has-atomic" or false); }
      { "${deps.futures_channel."0.3.1".futures_core}"."std" =
        (f.futures_core."${deps.futures_channel."0.3.1".futures_core}"."std" or false) ||
        (futures_channel."0.3.1"."std" or false) ||
        (f."futures_channel"."0.3.1"."std" or false); }
      { "${deps.futures_channel."0.3.1".futures_core}"."unstable" =
        (f.futures_core."${deps.futures_channel."0.3.1".futures_core}"."unstable" or false) ||
        (futures_channel."0.3.1"."unstable" or false) ||
        (f."futures_channel"."0.3.1"."unstable" or false); }
      { "${deps.futures_channel."0.3.1".futures_core}".default = (f.futures_core."${deps.futures_channel."0.3.1".futures_core}".default or false); }
    ];
  }) [
    (features_.futures_core."${deps."futures_channel"."0.3.1"."futures_core"}" deps)
  ];


# end
# futures-core-0.3.1

  crates.futures_core."0.3.1" = deps: { features?(features_.futures_core."0.3.1" deps {}) }: buildRustCrate {
    crateName = "futures-core";
    version = "0.3.1";
    description = "The core traits and types in for the `futures` library.\n";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    edition = "2018";
    sha256 = "1bl5lwri88ck9hhdgxvqx0nhylpnzmml3vg4kgpcjqgm8vf0vqcl";
    libName = "futures_core";
    features = mkFeatures (features."futures_core"."0.3.1" or {});
  };
  features_.futures_core."0.3.1" = deps: f: updateFeatures f (rec {
    futures_core = fold recursiveUpdate {} [
      { "0.3.1"."alloc" =
        (f.futures_core."0.3.1"."alloc" or false) ||
        (f.futures_core."0.3.1".std or false) ||
        (futures_core."0.3.1"."std" or false); }
      { "0.3.1"."std" =
        (f.futures_core."0.3.1"."std" or false) ||
        (f.futures_core."0.3.1".default or false) ||
        (futures_core."0.3.1"."default" or false); }
      { "0.3.1".default = (f.futures_core."0.3.1".default or true); }
    ];
  }) [];


# end
# futures-executor-0.3.1

  crates.futures_executor."0.3.1" = deps: { features?(features_.futures_executor."0.3.1" deps {}) }: buildRustCrate {
    crateName = "futures-executor";
    version = "0.3.1";
    description = "Executors for asynchronous tasks based on the futures-rs library.\n";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    edition = "2018";
    sha256 = "1wsklyzxhjnj27y28rb7r03v1xpq0zbr5rf4drh30j2rxaiarxam";
    libName = "futures_executor";
    dependencies = mapFeatures features ([
      (crates."futures_core"."${deps."futures_executor"."0.3.1"."futures_core"}" deps)
      (crates."futures_task"."${deps."futures_executor"."0.3.1"."futures_task"}" deps)
      (crates."futures_util"."${deps."futures_executor"."0.3.1"."futures_util"}" deps)
    ]);
    features = mkFeatures (features."futures_executor"."0.3.1" or {});
  };
  features_.futures_executor."0.3.1" = deps: f: updateFeatures f (rec {
    futures_core = fold recursiveUpdate {} [
      { "${deps.futures_executor."0.3.1".futures_core}"."std" =
        (f.futures_core."${deps.futures_executor."0.3.1".futures_core}"."std" or false) ||
        (futures_executor."0.3.1"."std" or false) ||
        (f."futures_executor"."0.3.1"."std" or false); }
      { "${deps.futures_executor."0.3.1".futures_core}".default = (f.futures_core."${deps.futures_executor."0.3.1".futures_core}".default or false); }
    ];
    futures_executor = fold recursiveUpdate {} [
      { "0.3.1"."num_cpus" =
        (f.futures_executor."0.3.1"."num_cpus" or false) ||
        (f.futures_executor."0.3.1".thread-pool or false) ||
        (futures_executor."0.3.1"."thread-pool" or false); }
      { "0.3.1"."std" =
        (f.futures_executor."0.3.1"."std" or false) ||
        (f.futures_executor."0.3.1".default or false) ||
        (futures_executor."0.3.1"."default" or false) ||
        (f.futures_executor."0.3.1".thread-pool or false) ||
        (futures_executor."0.3.1"."thread-pool" or false); }
      { "0.3.1".default = (f.futures_executor."0.3.1".default or true); }
    ];
    futures_task = fold recursiveUpdate {} [
      { "${deps.futures_executor."0.3.1".futures_task}"."std" =
        (f.futures_task."${deps.futures_executor."0.3.1".futures_task}"."std" or false) ||
        (futures_executor."0.3.1"."std" or false) ||
        (f."futures_executor"."0.3.1"."std" or false); }
      { "${deps.futures_executor."0.3.1".futures_task}".default = (f.futures_task."${deps.futures_executor."0.3.1".futures_task}".default or false); }
    ];
    futures_util = fold recursiveUpdate {} [
      { "${deps.futures_executor."0.3.1".futures_util}"."std" =
        (f.futures_util."${deps.futures_executor."0.3.1".futures_util}"."std" or false) ||
        (futures_executor."0.3.1"."std" or false) ||
        (f."futures_executor"."0.3.1"."std" or false); }
      { "${deps.futures_executor."0.3.1".futures_util}".default = (f.futures_util."${deps.futures_executor."0.3.1".futures_util}".default or false); }
    ];
  }) [
    (features_.futures_core."${deps."futures_executor"."0.3.1"."futures_core"}" deps)
    (features_.futures_task."${deps."futures_executor"."0.3.1"."futures_task"}" deps)
    (features_.futures_util."${deps."futures_executor"."0.3.1"."futures_util"}" deps)
  ];


# end
# futures-io-0.3.1

  crates.futures_io."0.3.1" = deps: { features?(features_.futures_io."0.3.1" deps {}) }: buildRustCrate {
    crateName = "futures-io";
    version = "0.3.1";
    description = "The `AsyncRead` and `AsyncWrite` traits for the futures-rs library.\n";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    edition = "2018";
    sha256 = "1vrpfkd9cckc43kjckm2js151f6nhsq3q5vxks1c72zmigl02b9n";
    libName = "futures_io";
    features = mkFeatures (features."futures_io"."0.3.1" or {});
  };
  features_.futures_io."0.3.1" = deps: f: updateFeatures f (rec {
    futures_io = fold recursiveUpdate {} [
      { "0.3.1"."std" =
        (f.futures_io."0.3.1"."std" or false) ||
        (f.futures_io."0.3.1".default or false) ||
        (futures_io."0.3.1"."default" or false); }
      { "0.3.1".default = (f.futures_io."0.3.1".default or true); }
    ];
  }) [];


# end
# futures-macro-0.3.1

  crates.futures_macro."0.3.1" = deps: { features?(features_.futures_macro."0.3.1" deps {}) }: buildRustCrate {
    crateName = "futures-macro";
    version = "0.3.1";
    description = "The futures-rs procedural macro implementations.\n";
    authors = [ "Taylor Cramer <cramertj@google.com>" "Taiki Endo <te316e89@gmail.com>" ];
    edition = "2018";
    sha256 = "0jk0zg4vldb7x4pilqaiis6403w1l5iv8r7y2xzqbndx14g1gf47";
    libName = "futures_macro";
    procMacro = true;
    dependencies = mapFeatures features ([
      (crates."proc_macro_hack"."${deps."futures_macro"."0.3.1"."proc_macro_hack"}" deps)
      (crates."proc_macro2"."${deps."futures_macro"."0.3.1"."proc_macro2"}" deps)
      (crates."quote"."${deps."futures_macro"."0.3.1"."quote"}" deps)
      (crates."syn"."${deps."futures_macro"."0.3.1"."syn"}" deps)
    ]);
  };
  features_.futures_macro."0.3.1" = deps: f: updateFeatures f (rec {
    futures_macro."0.3.1".default = (f.futures_macro."0.3.1".default or true);
    proc_macro2."${deps.futures_macro."0.3.1".proc_macro2}".default = true;
    proc_macro_hack."${deps.futures_macro."0.3.1".proc_macro_hack}".default = true;
    quote."${deps.futures_macro."0.3.1".quote}".default = true;
    syn = fold recursiveUpdate {} [
      { "${deps.futures_macro."0.3.1".syn}"."full" = true; }
      { "${deps.futures_macro."0.3.1".syn}".default = true; }
    ];
  }) [
    (features_.proc_macro_hack."${deps."futures_macro"."0.3.1"."proc_macro_hack"}" deps)
    (features_.proc_macro2."${deps."futures_macro"."0.3.1"."proc_macro2"}" deps)
    (features_.quote."${deps."futures_macro"."0.3.1"."quote"}" deps)
    (features_.syn."${deps."futures_macro"."0.3.1"."syn"}" deps)
  ];


# end
# futures-task-0.3.1

  crates.futures_task."0.3.1" = deps: { features?(features_.futures_task."0.3.1" deps {}) }: buildRustCrate {
    crateName = "futures-task";
    version = "0.3.1";
    description = "Tools for working with tasks.\n";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    edition = "2018";
    sha256 = "1j6cq3nkmx8c4jw8021jah7r9ksxdx4r4ddxqr5x0a9gfvz05pyv";
    libName = "futures_task";
    features = mkFeatures (features."futures_task"."0.3.1" or {});
  };
  features_.futures_task."0.3.1" = deps: f: updateFeatures f (rec {
    futures_task = fold recursiveUpdate {} [
      { "0.3.1"."alloc" =
        (f.futures_task."0.3.1"."alloc" or false) ||
        (f.futures_task."0.3.1".std or false) ||
        (futures_task."0.3.1"."std" or false); }
      { "0.3.1"."std" =
        (f.futures_task."0.3.1"."std" or false) ||
        (f.futures_task."0.3.1".default or false) ||
        (futures_task."0.3.1"."default" or false); }
      { "0.3.1".default = (f.futures_task."0.3.1".default or true); }
    ];
  }) [];


# end
# futures-util-0.3.1

  crates.futures_util."0.3.1" = deps: { features?(features_.futures_util."0.3.1" deps {}) }: buildRustCrate {
    crateName = "futures-util";
    version = "0.3.1";
    description = "Common utilities and extension traits for the futures-rs library.\n";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    edition = "2018";
    sha256 = "133pqb8r8581qvzlp0mhzpk638v486k9zwp8cgd0sm6knyzj7s0b";
    libName = "futures_util";
    dependencies = mapFeatures features ([
      (crates."futures_core"."${deps."futures_util"."0.3.1"."futures_core"}" deps)
      (crates."futures_task"."${deps."futures_util"."0.3.1"."futures_task"}" deps)
      (crates."pin_utils"."${deps."futures_util"."0.3.1"."pin_utils"}" deps)
    ]
      ++ (if features.futures_util."0.3.1".futures-macro or false then [ (crates.futures_macro."${deps."futures_util"."0.3.1".futures_macro}" deps) ] else [])
      ++ (if features.futures_util."0.3.1".proc-macro-hack or false then [ (crates.proc_macro_hack."${deps."futures_util"."0.3.1".proc_macro_hack}" deps) ] else [])
      ++ (if features.futures_util."0.3.1".proc-macro-nested or false then [ (crates.proc_macro_nested."${deps."futures_util"."0.3.1".proc_macro_nested}" deps) ] else [])
      ++ (if features.futures_util."0.3.1".slab or false then [ (crates.slab."${deps."futures_util"."0.3.1".slab}" deps) ] else []));
    features = mkFeatures (features."futures_util"."0.3.1" or {});
  };
  features_.futures_util."0.3.1" = deps: f: updateFeatures f (rec {
    futures_core = fold recursiveUpdate {} [
      { "${deps.futures_util."0.3.1".futures_core}"."alloc" =
        (f.futures_core."${deps.futures_util."0.3.1".futures_core}"."alloc" or false) ||
        (futures_util."0.3.1"."alloc" or false) ||
        (f."futures_util"."0.3.1"."alloc" or false); }
      { "${deps.futures_util."0.3.1".futures_core}"."cfg-target-has-atomic" =
        (f.futures_core."${deps.futures_util."0.3.1".futures_core}"."cfg-target-has-atomic" or false) ||
        (futures_util."0.3.1"."cfg-target-has-atomic" or false) ||
        (f."futures_util"."0.3.1"."cfg-target-has-atomic" or false); }
      { "${deps.futures_util."0.3.1".futures_core}"."std" =
        (f.futures_core."${deps.futures_util."0.3.1".futures_core}"."std" or false) ||
        (futures_util."0.3.1"."std" or false) ||
        (f."futures_util"."0.3.1"."std" or false); }
      { "${deps.futures_util."0.3.1".futures_core}"."unstable" =
        (f.futures_core."${deps.futures_util."0.3.1".futures_core}"."unstable" or false) ||
        (futures_util."0.3.1"."unstable" or false) ||
        (f."futures_util"."0.3.1"."unstable" or false); }
      { "${deps.futures_util."0.3.1".futures_core}".default = (f.futures_core."${deps.futures_util."0.3.1".futures_core}".default or false); }
    ];
    futures_macro."${deps.futures_util."0.3.1".futures_macro}".default = (f.futures_macro."${deps.futures_util."0.3.1".futures_macro}".default or false);
    futures_task = fold recursiveUpdate {} [
      { "${deps.futures_util."0.3.1".futures_task}"."alloc" =
        (f.futures_task."${deps.futures_util."0.3.1".futures_task}"."alloc" or false) ||
        (futures_util."0.3.1"."alloc" or false) ||
        (f."futures_util"."0.3.1"."alloc" or false); }
      { "${deps.futures_util."0.3.1".futures_task}"."cfg-target-has-atomic" =
        (f.futures_task."${deps.futures_util."0.3.1".futures_task}"."cfg-target-has-atomic" or false) ||
        (futures_util."0.3.1"."cfg-target-has-atomic" or false) ||
        (f."futures_util"."0.3.1"."cfg-target-has-atomic" or false); }
      { "${deps.futures_util."0.3.1".futures_task}"."std" =
        (f.futures_task."${deps.futures_util."0.3.1".futures_task}"."std" or false) ||
        (futures_util."0.3.1"."std" or false) ||
        (f."futures_util"."0.3.1"."std" or false); }
      { "${deps.futures_util."0.3.1".futures_task}"."unstable" =
        (f.futures_task."${deps.futures_util."0.3.1".futures_task}"."unstable" or false) ||
        (futures_util."0.3.1"."unstable" or false) ||
        (f."futures_util"."0.3.1"."unstable" or false); }
      { "${deps.futures_util."0.3.1".futures_task}".default = (f.futures_task."${deps.futures_util."0.3.1".futures_task}".default or false); }
    ];
    futures_util = fold recursiveUpdate {} [
      { "0.3.1"."alloc" =
        (f.futures_util."0.3.1"."alloc" or false) ||
        (f.futures_util."0.3.1".std or false) ||
        (futures_util."0.3.1"."std" or false); }
      { "0.3.1"."async-await" =
        (f.futures_util."0.3.1"."async-await" or false) ||
        (f.futures_util."0.3.1".async-await-macro or false) ||
        (futures_util."0.3.1"."async-await-macro" or false) ||
        (f.futures_util."0.3.1".default or false) ||
        (futures_util."0.3.1"."default" or false); }
      { "0.3.1"."async-await-macro" =
        (f.futures_util."0.3.1"."async-await-macro" or false) ||
        (f.futures_util."0.3.1".default or false) ||
        (futures_util."0.3.1"."default" or false); }
      { "0.3.1"."compat" =
        (f.futures_util."0.3.1"."compat" or false) ||
        (f.futures_util."0.3.1".io-compat or false) ||
        (futures_util."0.3.1"."io-compat" or false); }
      { "0.3.1"."futures-channel" =
        (f.futures_util."0.3.1"."futures-channel" or false) ||
        (f.futures_util."0.3.1".channel or false) ||
        (futures_util."0.3.1"."channel" or false); }
      { "0.3.1"."futures-io" =
        (f.futures_util."0.3.1"."futures-io" or false) ||
        (f.futures_util."0.3.1".io or false) ||
        (futures_util."0.3.1"."io" or false); }
      { "0.3.1"."futures-macro" =
        (f.futures_util."0.3.1"."futures-macro" or false) ||
        (f.futures_util."0.3.1".async-await-macro or false) ||
        (futures_util."0.3.1"."async-await-macro" or false); }
      { "0.3.1"."futures-sink" =
        (f.futures_util."0.3.1"."futures-sink" or false) ||
        (f.futures_util."0.3.1".sink or false) ||
        (futures_util."0.3.1"."sink" or false); }
      { "0.3.1"."futures_01" =
        (f.futures_util."0.3.1"."futures_01" or false) ||
        (f.futures_util."0.3.1".compat or false) ||
        (futures_util."0.3.1"."compat" or false); }
      { "0.3.1"."io" =
        (f.futures_util."0.3.1"."io" or false) ||
        (f.futures_util."0.3.1".io-compat or false) ||
        (futures_util."0.3.1"."io-compat" or false) ||
        (f.futures_util."0.3.1".read-initializer or false) ||
        (futures_util."0.3.1"."read-initializer" or false); }
      { "0.3.1"."memchr" =
        (f.futures_util."0.3.1"."memchr" or false) ||
        (f.futures_util."0.3.1".io or false) ||
        (futures_util."0.3.1"."io" or false); }
      { "0.3.1"."proc-macro-hack" =
        (f.futures_util."0.3.1"."proc-macro-hack" or false) ||
        (f.futures_util."0.3.1".async-await-macro or false) ||
        (futures_util."0.3.1"."async-await-macro" or false); }
      { "0.3.1"."proc-macro-nested" =
        (f.futures_util."0.3.1"."proc-macro-nested" or false) ||
        (f.futures_util."0.3.1".async-await-macro or false) ||
        (futures_util."0.3.1"."async-await-macro" or false); }
      { "0.3.1"."slab" =
        (f.futures_util."0.3.1"."slab" or false) ||
        (f.futures_util."0.3.1".std or false) ||
        (futures_util."0.3.1"."std" or false); }
      { "0.3.1"."std" =
        (f.futures_util."0.3.1"."std" or false) ||
        (f.futures_util."0.3.1".channel or false) ||
        (futures_util."0.3.1"."channel" or false) ||
        (f.futures_util."0.3.1".compat or false) ||
        (futures_util."0.3.1"."compat" or false) ||
        (f.futures_util."0.3.1".default or false) ||
        (futures_util."0.3.1"."default" or false) ||
        (f.futures_util."0.3.1".io or false) ||
        (futures_util."0.3.1"."io" or false); }
      { "0.3.1"."tokio-io" =
        (f.futures_util."0.3.1"."tokio-io" or false) ||
        (f.futures_util."0.3.1".io-compat or false) ||
        (futures_util."0.3.1"."io-compat" or false); }
      { "0.3.1".default = (f.futures_util."0.3.1".default or true); }
    ];
    pin_utils."${deps.futures_util."0.3.1".pin_utils}".default = true;
    proc_macro_hack."${deps.futures_util."0.3.1".proc_macro_hack}".default = true;
    proc_macro_nested."${deps.futures_util."0.3.1".proc_macro_nested}".default = true;
    slab."${deps.futures_util."0.3.1".slab}".default = true;
  }) [
    (features_.futures_core."${deps."futures_util"."0.3.1"."futures_core"}" deps)
    (features_.futures_macro."${deps."futures_util"."0.3.1"."futures_macro"}" deps)
    (features_.futures_task."${deps."futures_util"."0.3.1"."futures_task"}" deps)
    (features_.pin_utils."${deps."futures_util"."0.3.1"."pin_utils"}" deps)
    (features_.proc_macro_hack."${deps."futures_util"."0.3.1"."proc_macro_hack"}" deps)
    (features_.proc_macro_nested."${deps."futures_util"."0.3.1"."proc_macro_nested"}" deps)
    (features_.slab."${deps."futures_util"."0.3.1"."slab"}" deps)
  ];


# end
# gdk-0.12.0

  crates.gdk."0.12.0" = deps: { features?(features_.gdk."0.12.0" deps {}) }: buildRustCrate {
    crateName = "gdk";
    version = "0.12.0";
    description = "Rust bindings for the GDK 3 library";
    authors = [ "The Gtk-rs Project Developers" ];
    sha256 = "0cn104gn8455j9379j22z9m0b1r00yhn4zxbv0j3jfkwhnmi0sb1";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."bitflags"."${deps."gdk"."0.12.0"."bitflags"}" deps)
      (crates."cairo_rs"."${deps."gdk"."0.12.0"."cairo_rs"}" deps)
      (crates."cairo_sys_rs"."${deps."gdk"."0.12.0"."cairo_sys_rs"}" deps)
      (crates."gdk_pixbuf"."${deps."gdk"."0.12.0"."gdk_pixbuf"}" deps)
      (crates."gdk_sys"."${deps."gdk"."0.12.0"."gdk_sys"}" deps)
      (crates."gio"."${deps."gdk"."0.12.0"."gio"}" deps)
      (crates."gio_sys"."${deps."gdk"."0.12.0"."gio_sys"}" deps)
      (crates."glib"."${deps."gdk"."0.12.0"."glib"}" deps)
      (crates."glib_sys"."${deps."gdk"."0.12.0"."glib_sys"}" deps)
      (crates."gobject_sys"."${deps."gdk"."0.12.0"."gobject_sys"}" deps)
      (crates."libc"."${deps."gdk"."0.12.0"."libc"}" deps)
      (crates."pango"."${deps."gdk"."0.12.0"."pango"}" deps)
    ]);

    buildDependencies = mapFeatures features ([
]);
    features = mkFeatures (features."gdk"."0.12.0" or {});
  };
  features_.gdk."0.12.0" = deps: f: updateFeatures f (rec {
    bitflags."${deps.gdk."0.12.0".bitflags}".default = true;
    cairo_rs = fold recursiveUpdate {} [
      { "${deps.gdk."0.12.0".cairo_rs}"."dox" =
        (f.cairo_rs."${deps.gdk."0.12.0".cairo_rs}"."dox" or false) ||
        (gdk."0.12.0"."dox" or false) ||
        (f."gdk"."0.12.0"."dox" or false); }
      { "${deps.gdk."0.12.0".cairo_rs}"."embed-lgpl-docs" =
        (f.cairo_rs."${deps.gdk."0.12.0".cairo_rs}"."embed-lgpl-docs" or false) ||
        (gdk."0.12.0"."embed-lgpl-docs" or false) ||
        (f."gdk"."0.12.0"."embed-lgpl-docs" or false); }
      { "${deps.gdk."0.12.0".cairo_rs}"."purge-lgpl-docs" =
        (f.cairo_rs."${deps.gdk."0.12.0".cairo_rs}"."purge-lgpl-docs" or false) ||
        (gdk."0.12.0"."purge-lgpl-docs" or false) ||
        (f."gdk"."0.12.0"."purge-lgpl-docs" or false); }
      { "${deps.gdk."0.12.0".cairo_rs}".default = true; }
    ];
    cairo_sys_rs."${deps.gdk."0.12.0".cairo_sys_rs}".default = true;
    gdk = fold recursiveUpdate {} [
      { "0.12.0"."gtk-rs-lgpl-docs" =
        (f.gdk."0.12.0"."gtk-rs-lgpl-docs" or false) ||
        (f.gdk."0.12.0".embed-lgpl-docs or false) ||
        (gdk."0.12.0"."embed-lgpl-docs" or false) ||
        (f.gdk."0.12.0".purge-lgpl-docs or false) ||
        (gdk."0.12.0"."purge-lgpl-docs" or false); }
      { "0.12.0"."v3_16" =
        (f.gdk."0.12.0"."v3_16" or false) ||
        (f.gdk."0.12.0".v3_18 or false) ||
        (gdk."0.12.0"."v3_18" or false); }
      { "0.12.0"."v3_18" =
        (f.gdk."0.12.0"."v3_18" or false) ||
        (f.gdk."0.12.0".v3_20 or false) ||
        (gdk."0.12.0"."v3_20" or false); }
      { "0.12.0"."v3_20" =
        (f.gdk."0.12.0"."v3_20" or false) ||
        (f.gdk."0.12.0".v3_22 or false) ||
        (gdk."0.12.0"."v3_22" or false); }
      { "0.12.0"."v3_22" =
        (f.gdk."0.12.0"."v3_22" or false) ||
        (f.gdk."0.12.0".v3_24 or false) ||
        (gdk."0.12.0"."v3_24" or false); }
      { "0.12.0".default = (f.gdk."0.12.0".default or true); }
    ];
    gdk_pixbuf = fold recursiveUpdate {} [
      { "${deps.gdk."0.12.0".gdk_pixbuf}"."dox" =
        (f.gdk_pixbuf."${deps.gdk."0.12.0".gdk_pixbuf}"."dox" or false) ||
        (gdk."0.12.0"."dox" or false) ||
        (f."gdk"."0.12.0"."dox" or false); }
      { "${deps.gdk."0.12.0".gdk_pixbuf}"."embed-lgpl-docs" =
        (f.gdk_pixbuf."${deps.gdk."0.12.0".gdk_pixbuf}"."embed-lgpl-docs" or false) ||
        (gdk."0.12.0"."embed-lgpl-docs" or false) ||
        (f."gdk"."0.12.0"."embed-lgpl-docs" or false); }
      { "${deps.gdk."0.12.0".gdk_pixbuf}"."purge-lgpl-docs" =
        (f.gdk_pixbuf."${deps.gdk."0.12.0".gdk_pixbuf}"."purge-lgpl-docs" or false) ||
        (gdk."0.12.0"."purge-lgpl-docs" or false) ||
        (f."gdk"."0.12.0"."purge-lgpl-docs" or false); }
      { "${deps.gdk."0.12.0".gdk_pixbuf}".default = true; }
    ];
    gdk_sys = fold recursiveUpdate {} [
      { "${deps.gdk."0.12.0".gdk_sys}"."dox" =
        (f.gdk_sys."${deps.gdk."0.12.0".gdk_sys}"."dox" or false) ||
        (gdk."0.12.0"."dox" or false) ||
        (f."gdk"."0.12.0"."dox" or false); }
      { "${deps.gdk."0.12.0".gdk_sys}"."v3_16" =
        (f.gdk_sys."${deps.gdk."0.12.0".gdk_sys}"."v3_16" or false) ||
        (gdk."0.12.0"."v3_16" or false) ||
        (f."gdk"."0.12.0"."v3_16" or false); }
      { "${deps.gdk."0.12.0".gdk_sys}"."v3_18" =
        (f.gdk_sys."${deps.gdk."0.12.0".gdk_sys}"."v3_18" or false) ||
        (gdk."0.12.0"."v3_18" or false) ||
        (f."gdk"."0.12.0"."v3_18" or false); }
      { "${deps.gdk."0.12.0".gdk_sys}"."v3_20" =
        (f.gdk_sys."${deps.gdk."0.12.0".gdk_sys}"."v3_20" or false) ||
        (gdk."0.12.0"."v3_20" or false) ||
        (f."gdk"."0.12.0"."v3_20" or false); }
      { "${deps.gdk."0.12.0".gdk_sys}"."v3_22" =
        (f.gdk_sys."${deps.gdk."0.12.0".gdk_sys}"."v3_22" or false) ||
        (gdk."0.12.0"."v3_22" or false) ||
        (f."gdk"."0.12.0"."v3_22" or false); }
      { "${deps.gdk."0.12.0".gdk_sys}"."v3_24" =
        (f.gdk_sys."${deps.gdk."0.12.0".gdk_sys}"."v3_24" or false) ||
        (gdk."0.12.0"."v3_24" or false) ||
        (f."gdk"."0.12.0"."v3_24" or false); }
      { "${deps.gdk."0.12.0".gdk_sys}".default = true; }
    ];
    gio = fold recursiveUpdate {} [
      { "${deps.gdk."0.12.0".gio}"."dox" =
        (f.gio."${deps.gdk."0.12.0".gio}"."dox" or false) ||
        (gdk."0.12.0"."dox" or false) ||
        (f."gdk"."0.12.0"."dox" or false); }
      { "${deps.gdk."0.12.0".gio}"."embed-lgpl-docs" =
        (f.gio."${deps.gdk."0.12.0".gio}"."embed-lgpl-docs" or false) ||
        (gdk."0.12.0"."embed-lgpl-docs" or false) ||
        (f."gdk"."0.12.0"."embed-lgpl-docs" or false); }
      { "${deps.gdk."0.12.0".gio}"."purge-lgpl-docs" =
        (f.gio."${deps.gdk."0.12.0".gio}"."purge-lgpl-docs" or false) ||
        (gdk."0.12.0"."purge-lgpl-docs" or false) ||
        (f."gdk"."0.12.0"."purge-lgpl-docs" or false); }
      { "${deps.gdk."0.12.0".gio}".default = true; }
    ];
    gio_sys."${deps.gdk."0.12.0".gio_sys}".default = true;
    glib = fold recursiveUpdate {} [
      { "${deps.gdk."0.12.0".glib}"."dox" =
        (f.glib."${deps.gdk."0.12.0".glib}"."dox" or false) ||
        (gdk."0.12.0"."dox" or false) ||
        (f."gdk"."0.12.0"."dox" or false); }
      { "${deps.gdk."0.12.0".glib}".default = true; }
    ];
    glib_sys."${deps.gdk."0.12.0".glib_sys}".default = true;
    gobject_sys."${deps.gdk."0.12.0".gobject_sys}".default = true;
    libc."${deps.gdk."0.12.0".libc}".default = true;
    pango = fold recursiveUpdate {} [
      { "${deps.gdk."0.12.0".pango}"."dox" =
        (f.pango."${deps.gdk."0.12.0".pango}"."dox" or false) ||
        (gdk."0.12.0"."dox" or false) ||
        (f."gdk"."0.12.0"."dox" or false); }
      { "${deps.gdk."0.12.0".pango}".default = true; }
    ];
  }) [
    (features_.bitflags."${deps."gdk"."0.12.0"."bitflags"}" deps)
    (features_.cairo_rs."${deps."gdk"."0.12.0"."cairo_rs"}" deps)
    (features_.cairo_sys_rs."${deps."gdk"."0.12.0"."cairo_sys_rs"}" deps)
    (features_.gdk_pixbuf."${deps."gdk"."0.12.0"."gdk_pixbuf"}" deps)
    (features_.gdk_sys."${deps."gdk"."0.12.0"."gdk_sys"}" deps)
    (features_.gio."${deps."gdk"."0.12.0"."gio"}" deps)
    (features_.gio_sys."${deps."gdk"."0.12.0"."gio_sys"}" deps)
    (features_.glib."${deps."gdk"."0.12.0"."glib"}" deps)
    (features_.glib_sys."${deps."gdk"."0.12.0"."glib_sys"}" deps)
    (features_.gobject_sys."${deps."gdk"."0.12.0"."gobject_sys"}" deps)
    (features_.libc."${deps."gdk"."0.12.0"."libc"}" deps)
    (features_.pango."${deps."gdk"."0.12.0"."pango"}" deps)
  ];


# end
# gdk-pixbuf-0.8.0

  crates.gdk_pixbuf."0.8.0" = deps: { features?(features_.gdk_pixbuf."0.8.0" deps {}) }: buildRustCrate {
    crateName = "gdk-pixbuf";
    version = "0.8.0";
    description = "Rust bindings for the GdkPixbuf library";
    authors = [ "The Gtk-rs Project Developers" ];
    sha256 = "0lrs7vmamd9532glskpfs7j2mx418191lnfr8xjfi9z1q3bhnfqq";
    libName = "gdk_pixbuf";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."gdk_pixbuf_sys"."${deps."gdk_pixbuf"."0.8.0"."gdk_pixbuf_sys"}" deps)
      (crates."gio"."${deps."gdk_pixbuf"."0.8.0"."gio"}" deps)
      (crates."gio_sys"."${deps."gdk_pixbuf"."0.8.0"."gio_sys"}" deps)
      (crates."glib"."${deps."gdk_pixbuf"."0.8.0"."glib"}" deps)
      (crates."glib_sys"."${deps."gdk_pixbuf"."0.8.0"."glib_sys"}" deps)
      (crates."gobject_sys"."${deps."gdk_pixbuf"."0.8.0"."gobject_sys"}" deps)
      (crates."libc"."${deps."gdk_pixbuf"."0.8.0"."libc"}" deps)
    ]);

    buildDependencies = mapFeatures features ([
]);
    features = mkFeatures (features."gdk_pixbuf"."0.8.0" or {});
  };
  features_.gdk_pixbuf."0.8.0" = deps: f: updateFeatures f (rec {
    gdk_pixbuf = fold recursiveUpdate {} [
      { "0.8.0"."gtk-rs-lgpl-docs" =
        (f.gdk_pixbuf."0.8.0"."gtk-rs-lgpl-docs" or false) ||
        (f.gdk_pixbuf."0.8.0".embed-lgpl-docs or false) ||
        (gdk_pixbuf."0.8.0"."embed-lgpl-docs" or false) ||
        (f.gdk_pixbuf."0.8.0".purge-lgpl-docs or false) ||
        (gdk_pixbuf."0.8.0"."purge-lgpl-docs" or false); }
      { "0.8.0"."v2_32" =
        (f.gdk_pixbuf."0.8.0"."v2_32" or false) ||
        (f.gdk_pixbuf."0.8.0".v2_36 or false) ||
        (gdk_pixbuf."0.8.0"."v2_36" or false); }
      { "0.8.0"."v2_36" =
        (f.gdk_pixbuf."0.8.0"."v2_36" or false) ||
        (f.gdk_pixbuf."0.8.0".v2_36_8 or false) ||
        (gdk_pixbuf."0.8.0"."v2_36_8" or false); }
      { "0.8.0"."v2_36_8" =
        (f.gdk_pixbuf."0.8.0"."v2_36_8" or false) ||
        (f.gdk_pixbuf."0.8.0".v2_40 or false) ||
        (gdk_pixbuf."0.8.0"."v2_40" or false); }
      { "0.8.0".default = (f.gdk_pixbuf."0.8.0".default or true); }
    ];
    gdk_pixbuf_sys = fold recursiveUpdate {} [
      { "${deps.gdk_pixbuf."0.8.0".gdk_pixbuf_sys}"."dox" =
        (f.gdk_pixbuf_sys."${deps.gdk_pixbuf."0.8.0".gdk_pixbuf_sys}"."dox" or false) ||
        (gdk_pixbuf."0.8.0"."dox" or false) ||
        (f."gdk_pixbuf"."0.8.0"."dox" or false); }
      { "${deps.gdk_pixbuf."0.8.0".gdk_pixbuf_sys}"."v2_32" =
        (f.gdk_pixbuf_sys."${deps.gdk_pixbuf."0.8.0".gdk_pixbuf_sys}"."v2_32" or false) ||
        (gdk_pixbuf."0.8.0"."v2_32" or false) ||
        (f."gdk_pixbuf"."0.8.0"."v2_32" or false); }
      { "${deps.gdk_pixbuf."0.8.0".gdk_pixbuf_sys}"."v2_36" =
        (f.gdk_pixbuf_sys."${deps.gdk_pixbuf."0.8.0".gdk_pixbuf_sys}"."v2_36" or false) ||
        (gdk_pixbuf."0.8.0"."v2_36" or false) ||
        (f."gdk_pixbuf"."0.8.0"."v2_36" or false); }
      { "${deps.gdk_pixbuf."0.8.0".gdk_pixbuf_sys}"."v2_36_8" =
        (f.gdk_pixbuf_sys."${deps.gdk_pixbuf."0.8.0".gdk_pixbuf_sys}"."v2_36_8" or false) ||
        (gdk_pixbuf."0.8.0"."v2_36_8" or false) ||
        (f."gdk_pixbuf"."0.8.0"."v2_36_8" or false); }
      { "${deps.gdk_pixbuf."0.8.0".gdk_pixbuf_sys}"."v2_40" =
        (f.gdk_pixbuf_sys."${deps.gdk_pixbuf."0.8.0".gdk_pixbuf_sys}"."v2_40" or false) ||
        (gdk_pixbuf."0.8.0"."v2_40" or false) ||
        (f."gdk_pixbuf"."0.8.0"."v2_40" or false); }
      { "${deps.gdk_pixbuf."0.8.0".gdk_pixbuf_sys}".default = true; }
    ];
    gio."${deps.gdk_pixbuf."0.8.0".gio}".default = true;
    gio_sys."${deps.gdk_pixbuf."0.8.0".gio_sys}".default = true;
    glib = fold recursiveUpdate {} [
      { "${deps.gdk_pixbuf."0.8.0".glib}"."dox" =
        (f.glib."${deps.gdk_pixbuf."0.8.0".glib}"."dox" or false) ||
        (gdk_pixbuf."0.8.0"."dox" or false) ||
        (f."gdk_pixbuf"."0.8.0"."dox" or false); }
      { "${deps.gdk_pixbuf."0.8.0".glib}".default = true; }
    ];
    glib_sys."${deps.gdk_pixbuf."0.8.0".glib_sys}".default = true;
    gobject_sys."${deps.gdk_pixbuf."0.8.0".gobject_sys}".default = true;
    libc."${deps.gdk_pixbuf."0.8.0".libc}".default = true;
  }) [
    (features_.gdk_pixbuf_sys."${deps."gdk_pixbuf"."0.8.0"."gdk_pixbuf_sys"}" deps)
    (features_.gio."${deps."gdk_pixbuf"."0.8.0"."gio"}" deps)
    (features_.gio_sys."${deps."gdk_pixbuf"."0.8.0"."gio_sys"}" deps)
    (features_.glib."${deps."gdk_pixbuf"."0.8.0"."glib"}" deps)
    (features_.glib_sys."${deps."gdk_pixbuf"."0.8.0"."glib_sys"}" deps)
    (features_.gobject_sys."${deps."gdk_pixbuf"."0.8.0"."gobject_sys"}" deps)
    (features_.libc."${deps."gdk_pixbuf"."0.8.0"."libc"}" deps)
  ];


# end
# gdk-pixbuf-sys-0.9.1

  crates.gdk_pixbuf_sys."0.9.1" = deps: { features?(features_.gdk_pixbuf_sys."0.9.1" deps {}) }: buildRustCrate {
    crateName = "gdk-pixbuf-sys";
    version = "0.9.1";
    description = "FFI bindings to libgdk_pixbuf-2.0";
    authors = [ "The Gtk-rs Project Developers" ];
    sha256 = "07isp0942mfdscdqcy2xlv5scwkpcmmcxn5a8a9jy3sszgg8f6wv";
    libName = "gdk_pixbuf_sys";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."gio_sys"."${deps."gdk_pixbuf_sys"."0.9.1"."gio_sys"}" deps)
      (crates."glib_sys"."${deps."gdk_pixbuf_sys"."0.9.1"."glib_sys"}" deps)
      (crates."gobject_sys"."${deps."gdk_pixbuf_sys"."0.9.1"."gobject_sys"}" deps)
      (crates."libc"."${deps."gdk_pixbuf_sys"."0.9.1"."libc"}" deps)
    ]);

    buildDependencies = mapFeatures features ([
      (crates."pkg_config"."${deps."gdk_pixbuf_sys"."0.9.1"."pkg_config"}" deps)
    ]);
    features = mkFeatures (features."gdk_pixbuf_sys"."0.9.1" or {});
  };
  features_.gdk_pixbuf_sys."0.9.1" = deps: f: updateFeatures f (rec {
    gdk_pixbuf_sys = fold recursiveUpdate {} [
      { "0.9.1"."v2_32" =
        (f.gdk_pixbuf_sys."0.9.1"."v2_32" or false) ||
        (f.gdk_pixbuf_sys."0.9.1".v2_36 or false) ||
        (gdk_pixbuf_sys."0.9.1"."v2_36" or false); }
      { "0.9.1"."v2_36" =
        (f.gdk_pixbuf_sys."0.9.1"."v2_36" or false) ||
        (f.gdk_pixbuf_sys."0.9.1".v2_36_8 or false) ||
        (gdk_pixbuf_sys."0.9.1"."v2_36_8" or false); }
      { "0.9.1"."v2_36_8" =
        (f.gdk_pixbuf_sys."0.9.1"."v2_36_8" or false) ||
        (f.gdk_pixbuf_sys."0.9.1".v2_40 or false) ||
        (gdk_pixbuf_sys."0.9.1"."v2_40" or false); }
      { "0.9.1".default = (f.gdk_pixbuf_sys."0.9.1".default or true); }
    ];
    gio_sys."${deps.gdk_pixbuf_sys."0.9.1".gio_sys}".default = true;
    glib_sys."${deps.gdk_pixbuf_sys."0.9.1".glib_sys}".default = true;
    gobject_sys."${deps.gdk_pixbuf_sys."0.9.1".gobject_sys}".default = true;
    libc."${deps.gdk_pixbuf_sys."0.9.1".libc}".default = true;
    pkg_config."${deps.gdk_pixbuf_sys."0.9.1".pkg_config}".default = true;
  }) [
    (features_.gio_sys."${deps."gdk_pixbuf_sys"."0.9.1"."gio_sys"}" deps)
    (features_.glib_sys."${deps."gdk_pixbuf_sys"."0.9.1"."glib_sys"}" deps)
    (features_.gobject_sys."${deps."gdk_pixbuf_sys"."0.9.1"."gobject_sys"}" deps)
    (features_.libc."${deps."gdk_pixbuf_sys"."0.9.1"."libc"}" deps)
    (features_.pkg_config."${deps."gdk_pixbuf_sys"."0.9.1"."pkg_config"}" deps)
  ];


# end
# gdk-sys-0.9.1

  crates.gdk_sys."0.9.1" = deps: { features?(features_.gdk_sys."0.9.1" deps {}) }: buildRustCrate {
    crateName = "gdk-sys";
    version = "0.9.1";
    description = "FFI bindings to libgdk-3";
    authors = [ "The Gtk-rs Project Developers" ];
    sha256 = "1kq467cvcwvya6mll83wvkdv6rls43jlsv4giim57q4q7x7zk4v2";
    libName = "gdk_sys";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."cairo_sys_rs"."${deps."gdk_sys"."0.9.1"."cairo_sys_rs"}" deps)
      (crates."gdk_pixbuf_sys"."${deps."gdk_sys"."0.9.1"."gdk_pixbuf_sys"}" deps)
      (crates."gio_sys"."${deps."gdk_sys"."0.9.1"."gio_sys"}" deps)
      (crates."glib_sys"."${deps."gdk_sys"."0.9.1"."glib_sys"}" deps)
      (crates."gobject_sys"."${deps."gdk_sys"."0.9.1"."gobject_sys"}" deps)
      (crates."libc"."${deps."gdk_sys"."0.9.1"."libc"}" deps)
      (crates."pango_sys"."${deps."gdk_sys"."0.9.1"."pango_sys"}" deps)
    ]);

    buildDependencies = mapFeatures features ([
      (crates."pkg_config"."${deps."gdk_sys"."0.9.1"."pkg_config"}" deps)
    ]);
    features = mkFeatures (features."gdk_sys"."0.9.1" or {});
  };
  features_.gdk_sys."0.9.1" = deps: f: updateFeatures f (rec {
    cairo_sys_rs."${deps.gdk_sys."0.9.1".cairo_sys_rs}".default = true;
    gdk_pixbuf_sys."${deps.gdk_sys."0.9.1".gdk_pixbuf_sys}".default = true;
    gdk_sys = fold recursiveUpdate {} [
      { "0.9.1"."v3_16" =
        (f.gdk_sys."0.9.1"."v3_16" or false) ||
        (f.gdk_sys."0.9.1".v3_18 or false) ||
        (gdk_sys."0.9.1"."v3_18" or false); }
      { "0.9.1"."v3_18" =
        (f.gdk_sys."0.9.1"."v3_18" or false) ||
        (f.gdk_sys."0.9.1".v3_20 or false) ||
        (gdk_sys."0.9.1"."v3_20" or false); }
      { "0.9.1"."v3_20" =
        (f.gdk_sys."0.9.1"."v3_20" or false) ||
        (f.gdk_sys."0.9.1".v3_22 or false) ||
        (gdk_sys."0.9.1"."v3_22" or false); }
      { "0.9.1"."v3_22" =
        (f.gdk_sys."0.9.1"."v3_22" or false) ||
        (f.gdk_sys."0.9.1".v3_24 or false) ||
        (gdk_sys."0.9.1"."v3_24" or false); }
      { "0.9.1".default = (f.gdk_sys."0.9.1".default or true); }
    ];
    gio_sys."${deps.gdk_sys."0.9.1".gio_sys}".default = true;
    glib_sys."${deps.gdk_sys."0.9.1".glib_sys}".default = true;
    gobject_sys."${deps.gdk_sys."0.9.1".gobject_sys}".default = true;
    libc."${deps.gdk_sys."0.9.1".libc}".default = true;
    pango_sys."${deps.gdk_sys."0.9.1".pango_sys}".default = true;
    pkg_config."${deps.gdk_sys."0.9.1".pkg_config}".default = true;
  }) [
    (features_.cairo_sys_rs."${deps."gdk_sys"."0.9.1"."cairo_sys_rs"}" deps)
    (features_.gdk_pixbuf_sys."${deps."gdk_sys"."0.9.1"."gdk_pixbuf_sys"}" deps)
    (features_.gio_sys."${deps."gdk_sys"."0.9.1"."gio_sys"}" deps)
    (features_.glib_sys."${deps."gdk_sys"."0.9.1"."glib_sys"}" deps)
    (features_.gobject_sys."${deps."gdk_sys"."0.9.1"."gobject_sys"}" deps)
    (features_.libc."${deps."gdk_sys"."0.9.1"."libc"}" deps)
    (features_.pango_sys."${deps."gdk_sys"."0.9.1"."pango_sys"}" deps)
    (features_.pkg_config."${deps."gdk_sys"."0.9.1"."pkg_config"}" deps)
  ];


# end
# generic-array-0.11.1

  crates.generic_array."0.11.1" = deps: { features?(features_.generic_array."0.11.1" deps {}) }: buildRustCrate {
    crateName = "generic-array";
    version = "0.11.1";
    description = "Generic types implementing functionality of arrays";
    authors = [ "Bartłomiej Kamiński <fizyk20@gmail.com>" "Aaron Trent <novacrazy@gmail.com>" ];
    sha256 = "1fiyqqmfxll9j67sw2j1c64mr7njbw7cl4j9xsckpah3brhhhj1x";
    libName = "generic_array";
    dependencies = mapFeatures features ([
      (crates."typenum"."${deps."generic_array"."0.11.1"."typenum"}" deps)
    ]);
  };
  features_.generic_array."0.11.1" = deps: f: updateFeatures f (rec {
    generic_array."0.11.1".default = (f.generic_array."0.11.1".default or true);
    typenum."${deps.generic_array."0.11.1".typenum}".default = true;
  }) [
    (features_.typenum."${deps."generic_array"."0.11.1"."typenum"}" deps)
  ];


# end
# gio-0.8.0

  crates.gio."0.8.0" = deps: { features?(features_.gio."0.8.0" deps {}) }: buildRustCrate {
    crateName = "gio";
    version = "0.8.0";
    description = "Rust bindings for the Gio library";
    authors = [ "The Gtk-rs Project Developers" ];
    sha256 = "030xxbflqxmdgb02g8bwn6rf1pyyw0kjmjybsqawh5wc8hxnpz81";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."bitflags"."${deps."gio"."0.8.0"."bitflags"}" deps)
      (crates."futures_channel"."${deps."gio"."0.8.0"."futures_channel"}" deps)
      (crates."futures_core"."${deps."gio"."0.8.0"."futures_core"}" deps)
      (crates."futures_io"."${deps."gio"."0.8.0"."futures_io"}" deps)
      (crates."futures_util"."${deps."gio"."0.8.0"."futures_util"}" deps)
      (crates."gio_sys"."${deps."gio"."0.8.0"."gio_sys"}" deps)
      (crates."glib"."${deps."gio"."0.8.0"."glib"}" deps)
      (crates."glib_sys"."${deps."gio"."0.8.0"."glib_sys"}" deps)
      (crates."gobject_sys"."${deps."gio"."0.8.0"."gobject_sys"}" deps)
      (crates."lazy_static"."${deps."gio"."0.8.0"."lazy_static"}" deps)
      (crates."libc"."${deps."gio"."0.8.0"."libc"}" deps)
    ]);

    buildDependencies = mapFeatures features ([
]);
    features = mkFeatures (features."gio"."0.8.0" or {});
  };
  features_.gio."0.8.0" = deps: f: updateFeatures f (rec {
    bitflags."${deps.gio."0.8.0".bitflags}".default = true;
    futures_channel."${deps.gio."0.8.0".futures_channel}".default = true;
    futures_core."${deps.gio."0.8.0".futures_core}".default = true;
    futures_io."${deps.gio."0.8.0".futures_io}".default = true;
    futures_util."${deps.gio."0.8.0".futures_util}".default = true;
    gio = fold recursiveUpdate {} [
      { "0.8.0"."gtk-rs-lgpl-docs" =
        (f.gio."0.8.0"."gtk-rs-lgpl-docs" or false) ||
        (f.gio."0.8.0".embed-lgpl-docs or false) ||
        (gio."0.8.0"."embed-lgpl-docs" or false) ||
        (f.gio."0.8.0".purge-lgpl-docs or false) ||
        (gio."0.8.0"."purge-lgpl-docs" or false); }
      { "0.8.0"."v2_44" =
        (f.gio."0.8.0"."v2_44" or false) ||
        (f.gio."0.8.0".v2_46 or false) ||
        (gio."0.8.0"."v2_46" or false); }
      { "0.8.0"."v2_46" =
        (f.gio."0.8.0"."v2_46" or false) ||
        (f.gio."0.8.0".v2_48 or false) ||
        (gio."0.8.0"."v2_48" or false); }
      { "0.8.0"."v2_48" =
        (f.gio."0.8.0"."v2_48" or false) ||
        (f.gio."0.8.0".v2_50 or false) ||
        (gio."0.8.0"."v2_50" or false); }
      { "0.8.0"."v2_50" =
        (f.gio."0.8.0"."v2_50" or false) ||
        (f.gio."0.8.0".v2_52 or false) ||
        (gio."0.8.0"."v2_52" or false); }
      { "0.8.0"."v2_52" =
        (f.gio."0.8.0"."v2_52" or false) ||
        (f.gio."0.8.0".v2_54 or false) ||
        (gio."0.8.0"."v2_54" or false); }
      { "0.8.0"."v2_54" =
        (f.gio."0.8.0"."v2_54" or false) ||
        (f.gio."0.8.0".v2_56 or false) ||
        (gio."0.8.0"."v2_56" or false); }
      { "0.8.0"."v2_56" =
        (f.gio."0.8.0"."v2_56" or false) ||
        (f.gio."0.8.0".v2_58 or false) ||
        (gio."0.8.0"."v2_58" or false); }
      { "0.8.0"."v2_58" =
        (f.gio."0.8.0"."v2_58" or false) ||
        (f.gio."0.8.0".v2_60 or false) ||
        (gio."0.8.0"."v2_60" or false); }
      { "0.8.0".default = (f.gio."0.8.0".default or true); }
    ];
    gio_sys = fold recursiveUpdate {} [
      { "${deps.gio."0.8.0".gio_sys}"."dox" =
        (f.gio_sys."${deps.gio."0.8.0".gio_sys}"."dox" or false) ||
        (gio."0.8.0"."dox" or false) ||
        (f."gio"."0.8.0"."dox" or false); }
      { "${deps.gio."0.8.0".gio_sys}"."v2_44" =
        (f.gio_sys."${deps.gio."0.8.0".gio_sys}"."v2_44" or false) ||
        (gio."0.8.0"."v2_44" or false) ||
        (f."gio"."0.8.0"."v2_44" or false); }
      { "${deps.gio."0.8.0".gio_sys}"."v2_46" =
        (f.gio_sys."${deps.gio."0.8.0".gio_sys}"."v2_46" or false) ||
        (gio."0.8.0"."v2_46" or false) ||
        (f."gio"."0.8.0"."v2_46" or false); }
      { "${deps.gio."0.8.0".gio_sys}"."v2_48" =
        (f.gio_sys."${deps.gio."0.8.0".gio_sys}"."v2_48" or false) ||
        (gio."0.8.0"."v2_48" or false) ||
        (f."gio"."0.8.0"."v2_48" or false); }
      { "${deps.gio."0.8.0".gio_sys}"."v2_50" =
        (f.gio_sys."${deps.gio."0.8.0".gio_sys}"."v2_50" or false) ||
        (gio."0.8.0"."v2_50" or false) ||
        (f."gio"."0.8.0"."v2_50" or false); }
      { "${deps.gio."0.8.0".gio_sys}"."v2_52" =
        (f.gio_sys."${deps.gio."0.8.0".gio_sys}"."v2_52" or false) ||
        (gio."0.8.0"."v2_52" or false) ||
        (f."gio"."0.8.0"."v2_52" or false); }
      { "${deps.gio."0.8.0".gio_sys}"."v2_54" =
        (f.gio_sys."${deps.gio."0.8.0".gio_sys}"."v2_54" or false) ||
        (gio."0.8.0"."v2_54" or false) ||
        (f."gio"."0.8.0"."v2_54" or false); }
      { "${deps.gio."0.8.0".gio_sys}"."v2_56" =
        (f.gio_sys."${deps.gio."0.8.0".gio_sys}"."v2_56" or false) ||
        (gio."0.8.0"."v2_56" or false) ||
        (f."gio"."0.8.0"."v2_56" or false); }
      { "${deps.gio."0.8.0".gio_sys}"."v2_58" =
        (f.gio_sys."${deps.gio."0.8.0".gio_sys}"."v2_58" or false) ||
        (gio."0.8.0"."v2_58" or false) ||
        (f."gio"."0.8.0"."v2_58" or false); }
      { "${deps.gio."0.8.0".gio_sys}"."v2_60" =
        (f.gio_sys."${deps.gio."0.8.0".gio_sys}"."v2_60" or false) ||
        (gio."0.8.0"."v2_60" or false) ||
        (f."gio"."0.8.0"."v2_60" or false); }
      { "${deps.gio."0.8.0".gio_sys}".default = true; }
    ];
    glib = fold recursiveUpdate {} [
      { "${deps.gio."0.8.0".glib}"."dox" =
        (f.glib."${deps.gio."0.8.0".glib}"."dox" or false) ||
        (gio."0.8.0"."dox" or false) ||
        (f."gio"."0.8.0"."dox" or false); }
      { "${deps.gio."0.8.0".glib}"."v2_44" =
        (f.glib."${deps.gio."0.8.0".glib}"."v2_44" or false) ||
        (gio."0.8.0"."v2_44" or false) ||
        (f."gio"."0.8.0"."v2_44" or false); }
      { "${deps.gio."0.8.0".glib}"."v2_46" =
        (f.glib."${deps.gio."0.8.0".glib}"."v2_46" or false) ||
        (gio."0.8.0"."v2_46" or false) ||
        (f."gio"."0.8.0"."v2_46" or false); }
      { "${deps.gio."0.8.0".glib}"."v2_48" =
        (f.glib."${deps.gio."0.8.0".glib}"."v2_48" or false) ||
        (gio."0.8.0"."v2_48" or false) ||
        (f."gio"."0.8.0"."v2_48" or false); }
      { "${deps.gio."0.8.0".glib}"."v2_50" =
        (f.glib."${deps.gio."0.8.0".glib}"."v2_50" or false) ||
        (gio."0.8.0"."v2_50" or false) ||
        (f."gio"."0.8.0"."v2_50" or false); }
      { "${deps.gio."0.8.0".glib}"."v2_52" =
        (f.glib."${deps.gio."0.8.0".glib}"."v2_52" or false) ||
        (gio."0.8.0"."v2_52" or false) ||
        (f."gio"."0.8.0"."v2_52" or false); }
      { "${deps.gio."0.8.0".glib}"."v2_54" =
        (f.glib."${deps.gio."0.8.0".glib}"."v2_54" or false) ||
        (gio."0.8.0"."v2_54" or false) ||
        (f."gio"."0.8.0"."v2_54" or false); }
      { "${deps.gio."0.8.0".glib}"."v2_56" =
        (f.glib."${deps.gio."0.8.0".glib}"."v2_56" or false) ||
        (gio."0.8.0"."v2_56" or false) ||
        (f."gio"."0.8.0"."v2_56" or false); }
      { "${deps.gio."0.8.0".glib}"."v2_58" =
        (f.glib."${deps.gio."0.8.0".glib}"."v2_58" or false) ||
        (gio."0.8.0"."v2_58" or false) ||
        (f."gio"."0.8.0"."v2_58" or false); }
      { "${deps.gio."0.8.0".glib}"."v2_60" =
        (f.glib."${deps.gio."0.8.0".glib}"."v2_60" or false) ||
        (gio."0.8.0"."v2_60" or false) ||
        (f."gio"."0.8.0"."v2_60" or false); }
      { "${deps.gio."0.8.0".glib}".default = true; }
    ];
    glib_sys."${deps.gio."0.8.0".glib_sys}".default = true;
    gobject_sys."${deps.gio."0.8.0".gobject_sys}".default = true;
    lazy_static."${deps.gio."0.8.0".lazy_static}".default = true;
    libc."${deps.gio."0.8.0".libc}".default = true;
  }) [
    (features_.bitflags."${deps."gio"."0.8.0"."bitflags"}" deps)
    (features_.futures_channel."${deps."gio"."0.8.0"."futures_channel"}" deps)
    (features_.futures_core."${deps."gio"."0.8.0"."futures_core"}" deps)
    (features_.futures_io."${deps."gio"."0.8.0"."futures_io"}" deps)
    (features_.futures_util."${deps."gio"."0.8.0"."futures_util"}" deps)
    (features_.gio_sys."${deps."gio"."0.8.0"."gio_sys"}" deps)
    (features_.glib."${deps."gio"."0.8.0"."glib"}" deps)
    (features_.glib_sys."${deps."gio"."0.8.0"."glib_sys"}" deps)
    (features_.gobject_sys."${deps."gio"."0.8.0"."gobject_sys"}" deps)
    (features_.lazy_static."${deps."gio"."0.8.0"."lazy_static"}" deps)
    (features_.libc."${deps."gio"."0.8.0"."libc"}" deps)
  ];


# end
# gio-sys-0.9.1

  crates.gio_sys."0.9.1" = deps: { features?(features_.gio_sys."0.9.1" deps {}) }: buildRustCrate {
    crateName = "gio-sys";
    version = "0.9.1";
    description = "FFI bindings to libgio-2.0";
    authors = [ "The Gtk-rs Project Developers" ];
    sha256 = "04w5f6mxr7hm68idgyf9yg3fdwfxib0jl4ykphhfkpghyr1f3d9n";
    libName = "gio_sys";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."glib_sys"."${deps."gio_sys"."0.9.1"."glib_sys"}" deps)
      (crates."gobject_sys"."${deps."gio_sys"."0.9.1"."gobject_sys"}" deps)
      (crates."libc"."${deps."gio_sys"."0.9.1"."libc"}" deps)
    ]);

    buildDependencies = mapFeatures features ([
      (crates."pkg_config"."${deps."gio_sys"."0.9.1"."pkg_config"}" deps)
    ]);
    features = mkFeatures (features."gio_sys"."0.9.1" or {});
  };
  features_.gio_sys."0.9.1" = deps: f: updateFeatures f (rec {
    gio_sys = fold recursiveUpdate {} [
      { "0.9.1"."v2_44" =
        (f.gio_sys."0.9.1"."v2_44" or false) ||
        (f.gio_sys."0.9.1".v2_46 or false) ||
        (gio_sys."0.9.1"."v2_46" or false); }
      { "0.9.1"."v2_46" =
        (f.gio_sys."0.9.1"."v2_46" or false) ||
        (f.gio_sys."0.9.1".v2_48 or false) ||
        (gio_sys."0.9.1"."v2_48" or false); }
      { "0.9.1"."v2_48" =
        (f.gio_sys."0.9.1"."v2_48" or false) ||
        (f.gio_sys."0.9.1".v2_50 or false) ||
        (gio_sys."0.9.1"."v2_50" or false); }
      { "0.9.1"."v2_50" =
        (f.gio_sys."0.9.1"."v2_50" or false) ||
        (f.gio_sys."0.9.1".v2_52 or false) ||
        (gio_sys."0.9.1"."v2_52" or false); }
      { "0.9.1"."v2_52" =
        (f.gio_sys."0.9.1"."v2_52" or false) ||
        (f.gio_sys."0.9.1".v2_54 or false) ||
        (gio_sys."0.9.1"."v2_54" or false); }
      { "0.9.1"."v2_54" =
        (f.gio_sys."0.9.1"."v2_54" or false) ||
        (f.gio_sys."0.9.1".v2_56 or false) ||
        (gio_sys."0.9.1"."v2_56" or false); }
      { "0.9.1"."v2_56" =
        (f.gio_sys."0.9.1"."v2_56" or false) ||
        (f.gio_sys."0.9.1".v2_58 or false) ||
        (gio_sys."0.9.1"."v2_58" or false); }
      { "0.9.1"."v2_58" =
        (f.gio_sys."0.9.1"."v2_58" or false) ||
        (f.gio_sys."0.9.1".v2_60 or false) ||
        (gio_sys."0.9.1"."v2_60" or false); }
      { "0.9.1"."v2_60" =
        (f.gio_sys."0.9.1"."v2_60" or false) ||
        (f.gio_sys."0.9.1".v2_62 or false) ||
        (gio_sys."0.9.1"."v2_62" or false); }
      { "0.9.1".default = (f.gio_sys."0.9.1".default or true); }
    ];
    glib_sys."${deps.gio_sys."0.9.1".glib_sys}".default = true;
    gobject_sys."${deps.gio_sys."0.9.1".gobject_sys}".default = true;
    libc."${deps.gio_sys."0.9.1".libc}".default = true;
    pkg_config."${deps.gio_sys."0.9.1".pkg_config}".default = true;
  }) [
    (features_.glib_sys."${deps."gio_sys"."0.9.1"."glib_sys"}" deps)
    (features_.gobject_sys."${deps."gio_sys"."0.9.1"."gobject_sys"}" deps)
    (features_.libc."${deps."gio_sys"."0.9.1"."libc"}" deps)
    (features_.pkg_config."${deps."gio_sys"."0.9.1"."pkg_config"}" deps)
  ];


# end
# glib-0.8.2

  crates.glib."0.8.2" = deps: { features?(features_.glib."0.8.2" deps {}) }: buildRustCrate {
    crateName = "glib";
    version = "0.8.2";
    description = "Rust bindings for the GLib library";
    authors = [ "The Gtk-rs Project Developers" ];
    sha256 = "055v6lkrr480mbn85gvybjawsk242hmrbwmfimbi73hmxr7rp7dw";
    dependencies = mapFeatures features ([
      (crates."bitflags"."${deps."glib"."0.8.2"."bitflags"}" deps)
      (crates."glib_sys"."${deps."glib"."0.8.2"."glib_sys"}" deps)
      (crates."gobject_sys"."${deps."glib"."0.8.2"."gobject_sys"}" deps)
      (crates."lazy_static"."${deps."glib"."0.8.2"."lazy_static"}" deps)
      (crates."libc"."${deps."glib"."0.8.2"."libc"}" deps)
    ]);
    features = mkFeatures (features."glib"."0.8.2" or {});
  };
  features_.glib."0.8.2" = deps: f: updateFeatures f (rec {
    bitflags."${deps.glib."0.8.2".bitflags}".default = true;
    glib = fold recursiveUpdate {} [
      { "0.8.2"."futures-preview" =
        (f.glib."0.8.2"."futures-preview" or false) ||
        (f.glib."0.8.2".futures or false) ||
        (glib."0.8.2"."futures" or false); }
      { "0.8.2"."v2_44" =
        (f.glib."0.8.2"."v2_44" or false) ||
        (f.glib."0.8.2".v2_46 or false) ||
        (glib."0.8.2"."v2_46" or false); }
      { "0.8.2"."v2_46" =
        (f.glib."0.8.2"."v2_46" or false) ||
        (f.glib."0.8.2".v2_48 or false) ||
        (glib."0.8.2"."v2_48" or false); }
      { "0.8.2"."v2_48" =
        (f.glib."0.8.2"."v2_48" or false) ||
        (f.glib."0.8.2".v2_50 or false) ||
        (glib."0.8.2"."v2_50" or false); }
      { "0.8.2"."v2_50" =
        (f.glib."0.8.2"."v2_50" or false) ||
        (f.glib."0.8.2".v2_52 or false) ||
        (glib."0.8.2"."v2_52" or false); }
      { "0.8.2"."v2_52" =
        (f.glib."0.8.2"."v2_52" or false) ||
        (f.glib."0.8.2".v2_54 or false) ||
        (glib."0.8.2"."v2_54" or false); }
      { "0.8.2"."v2_54" =
        (f.glib."0.8.2"."v2_54" or false) ||
        (f.glib."0.8.2".v2_56 or false) ||
        (glib."0.8.2"."v2_56" or false); }
      { "0.8.2"."v2_56" =
        (f.glib."0.8.2"."v2_56" or false) ||
        (f.glib."0.8.2".v2_58 or false) ||
        (glib."0.8.2"."v2_58" or false); }
      { "0.8.2".default = (f.glib."0.8.2".default or true); }
    ];
    glib_sys = fold recursiveUpdate {} [
      { "${deps.glib."0.8.2".glib_sys}"."dox" =
        (f.glib_sys."${deps.glib."0.8.2".glib_sys}"."dox" or false) ||
        (glib."0.8.2"."dox" or false) ||
        (f."glib"."0.8.2"."dox" or false); }
      { "${deps.glib."0.8.2".glib_sys}"."v2_44" =
        (f.glib_sys."${deps.glib."0.8.2".glib_sys}"."v2_44" or false) ||
        (glib."0.8.2"."v2_44" or false) ||
        (f."glib"."0.8.2"."v2_44" or false); }
      { "${deps.glib."0.8.2".glib_sys}"."v2_46" =
        (f.glib_sys."${deps.glib."0.8.2".glib_sys}"."v2_46" or false) ||
        (glib."0.8.2"."v2_46" or false) ||
        (f."glib"."0.8.2"."v2_46" or false); }
      { "${deps.glib."0.8.2".glib_sys}"."v2_48" =
        (f.glib_sys."${deps.glib."0.8.2".glib_sys}"."v2_48" or false) ||
        (glib."0.8.2"."v2_48" or false) ||
        (f."glib"."0.8.2"."v2_48" or false); }
      { "${deps.glib."0.8.2".glib_sys}"."v2_50" =
        (f.glib_sys."${deps.glib."0.8.2".glib_sys}"."v2_50" or false) ||
        (glib."0.8.2"."v2_50" or false) ||
        (f."glib"."0.8.2"."v2_50" or false); }
      { "${deps.glib."0.8.2".glib_sys}"."v2_52" =
        (f.glib_sys."${deps.glib."0.8.2".glib_sys}"."v2_52" or false) ||
        (glib."0.8.2"."v2_52" or false) ||
        (f."glib"."0.8.2"."v2_52" or false); }
      { "${deps.glib."0.8.2".glib_sys}"."v2_54" =
        (f.glib_sys."${deps.glib."0.8.2".glib_sys}"."v2_54" or false) ||
        (glib."0.8.2"."v2_54" or false) ||
        (f."glib"."0.8.2"."v2_54" or false); }
      { "${deps.glib."0.8.2".glib_sys}"."v2_56" =
        (f.glib_sys."${deps.glib."0.8.2".glib_sys}"."v2_56" or false) ||
        (glib."0.8.2"."v2_56" or false) ||
        (f."glib"."0.8.2"."v2_56" or false); }
      { "${deps.glib."0.8.2".glib_sys}"."v2_58" =
        (f.glib_sys."${deps.glib."0.8.2".glib_sys}"."v2_58" or false) ||
        (glib."0.8.2"."v2_58" or false) ||
        (f."glib"."0.8.2"."v2_58" or false); }
      { "${deps.glib."0.8.2".glib_sys}".default = true; }
    ];
    gobject_sys = fold recursiveUpdate {} [
      { "${deps.glib."0.8.2".gobject_sys}"."dox" =
        (f.gobject_sys."${deps.glib."0.8.2".gobject_sys}"."dox" or false) ||
        (glib."0.8.2"."dox" or false) ||
        (f."glib"."0.8.2"."dox" or false); }
      { "${deps.glib."0.8.2".gobject_sys}"."v2_44" =
        (f.gobject_sys."${deps.glib."0.8.2".gobject_sys}"."v2_44" or false) ||
        (glib."0.8.2"."v2_44" or false) ||
        (f."glib"."0.8.2"."v2_44" or false); }
      { "${deps.glib."0.8.2".gobject_sys}"."v2_46" =
        (f.gobject_sys."${deps.glib."0.8.2".gobject_sys}"."v2_46" or false) ||
        (glib."0.8.2"."v2_46" or false) ||
        (f."glib"."0.8.2"."v2_46" or false); }
      { "${deps.glib."0.8.2".gobject_sys}"."v2_54" =
        (f.gobject_sys."${deps.glib."0.8.2".gobject_sys}"."v2_54" or false) ||
        (glib."0.8.2"."v2_54" or false) ||
        (f."glib"."0.8.2"."v2_54" or false); }
      { "${deps.glib."0.8.2".gobject_sys}".default = true; }
    ];
    lazy_static."${deps.glib."0.8.2".lazy_static}".default = true;
    libc."${deps.glib."0.8.2".libc}".default = true;
  }) [
    (features_.bitflags."${deps."glib"."0.8.2"."bitflags"}" deps)
    (features_.glib_sys."${deps."glib"."0.8.2"."glib_sys"}" deps)
    (features_.gobject_sys."${deps."glib"."0.8.2"."gobject_sys"}" deps)
    (features_.lazy_static."${deps."glib"."0.8.2"."lazy_static"}" deps)
    (features_.libc."${deps."glib"."0.8.2"."libc"}" deps)
  ];


# end
# glib-0.9.0

  crates.glib."0.9.0" = deps: { features?(features_.glib."0.9.0" deps {}) }: buildRustCrate {
    crateName = "glib";
    version = "0.9.0";
    description = "Rust bindings for the GLib library";
    authors = [ "The Gtk-rs Project Developers" ];
    sha256 = "1734rnq950b37qwkgqsxd6835h6a6v83x8arqrv45hf7f98d3w5p";
    dependencies = mapFeatures features ([
      (crates."bitflags"."${deps."glib"."0.9.0"."bitflags"}" deps)
      (crates."futures_channel"."${deps."glib"."0.9.0"."futures_channel"}" deps)
      (crates."futures_core"."${deps."glib"."0.9.0"."futures_core"}" deps)
      (crates."futures_executor"."${deps."glib"."0.9.0"."futures_executor"}" deps)
      (crates."futures_task"."${deps."glib"."0.9.0"."futures_task"}" deps)
      (crates."futures_util"."${deps."glib"."0.9.0"."futures_util"}" deps)
      (crates."glib_sys"."${deps."glib"."0.9.0"."glib_sys"}" deps)
      (crates."gobject_sys"."${deps."glib"."0.9.0"."gobject_sys"}" deps)
      (crates."lazy_static"."${deps."glib"."0.9.0"."lazy_static"}" deps)
      (crates."libc"."${deps."glib"."0.9.0"."libc"}" deps)
    ]);
    features = mkFeatures (features."glib"."0.9.0" or {});
  };
  features_.glib."0.9.0" = deps: f: updateFeatures f (rec {
    bitflags."${deps.glib."0.9.0".bitflags}".default = true;
    futures_channel."${deps.glib."0.9.0".futures_channel}".default = true;
    futures_core."${deps.glib."0.9.0".futures_core}".default = true;
    futures_executor."${deps.glib."0.9.0".futures_executor}".default = true;
    futures_task."${deps.glib."0.9.0".futures_task}".default = true;
    futures_util."${deps.glib."0.9.0".futures_util}".default = true;
    glib = fold recursiveUpdate {} [
      { "0.9.0"."v2_44" =
        (f.glib."0.9.0"."v2_44" or false) ||
        (f.glib."0.9.0".v2_46 or false) ||
        (glib."0.9.0"."v2_46" or false); }
      { "0.9.0"."v2_46" =
        (f.glib."0.9.0"."v2_46" or false) ||
        (f.glib."0.9.0".v2_48 or false) ||
        (glib."0.9.0"."v2_48" or false); }
      { "0.9.0"."v2_48" =
        (f.glib."0.9.0"."v2_48" or false) ||
        (f.glib."0.9.0".v2_50 or false) ||
        (glib."0.9.0"."v2_50" or false); }
      { "0.9.0"."v2_50" =
        (f.glib."0.9.0"."v2_50" or false) ||
        (f.glib."0.9.0".v2_52 or false) ||
        (glib."0.9.0"."v2_52" or false); }
      { "0.9.0"."v2_52" =
        (f.glib."0.9.0"."v2_52" or false) ||
        (f.glib."0.9.0".v2_54 or false) ||
        (glib."0.9.0"."v2_54" or false); }
      { "0.9.0"."v2_54" =
        (f.glib."0.9.0"."v2_54" or false) ||
        (f.glib."0.9.0".v2_56 or false) ||
        (glib."0.9.0"."v2_56" or false); }
      { "0.9.0"."v2_56" =
        (f.glib."0.9.0"."v2_56" or false) ||
        (f.glib."0.9.0".v2_58 or false) ||
        (glib."0.9.0"."v2_58" or false); }
      { "0.9.0"."v2_58" =
        (f.glib."0.9.0"."v2_58" or false) ||
        (f.glib."0.9.0".v2_60 or false) ||
        (glib."0.9.0"."v2_60" or false); }
      { "0.9.0".default = (f.glib."0.9.0".default or true); }
    ];
    glib_sys = fold recursiveUpdate {} [
      { "${deps.glib."0.9.0".glib_sys}"."dox" =
        (f.glib_sys."${deps.glib."0.9.0".glib_sys}"."dox" or false) ||
        (glib."0.9.0"."dox" or false) ||
        (f."glib"."0.9.0"."dox" or false); }
      { "${deps.glib."0.9.0".glib_sys}"."v2_44" =
        (f.glib_sys."${deps.glib."0.9.0".glib_sys}"."v2_44" or false) ||
        (glib."0.9.0"."v2_44" or false) ||
        (f."glib"."0.9.0"."v2_44" or false); }
      { "${deps.glib."0.9.0".glib_sys}"."v2_46" =
        (f.glib_sys."${deps.glib."0.9.0".glib_sys}"."v2_46" or false) ||
        (glib."0.9.0"."v2_46" or false) ||
        (f."glib"."0.9.0"."v2_46" or false); }
      { "${deps.glib."0.9.0".glib_sys}"."v2_48" =
        (f.glib_sys."${deps.glib."0.9.0".glib_sys}"."v2_48" or false) ||
        (glib."0.9.0"."v2_48" or false) ||
        (f."glib"."0.9.0"."v2_48" or false); }
      { "${deps.glib."0.9.0".glib_sys}"."v2_50" =
        (f.glib_sys."${deps.glib."0.9.0".glib_sys}"."v2_50" or false) ||
        (glib."0.9.0"."v2_50" or false) ||
        (f."glib"."0.9.0"."v2_50" or false); }
      { "${deps.glib."0.9.0".glib_sys}"."v2_52" =
        (f.glib_sys."${deps.glib."0.9.0".glib_sys}"."v2_52" or false) ||
        (glib."0.9.0"."v2_52" or false) ||
        (f."glib"."0.9.0"."v2_52" or false); }
      { "${deps.glib."0.9.0".glib_sys}"."v2_54" =
        (f.glib_sys."${deps.glib."0.9.0".glib_sys}"."v2_54" or false) ||
        (glib."0.9.0"."v2_54" or false) ||
        (f."glib"."0.9.0"."v2_54" or false); }
      { "${deps.glib."0.9.0".glib_sys}"."v2_56" =
        (f.glib_sys."${deps.glib."0.9.0".glib_sys}"."v2_56" or false) ||
        (glib."0.9.0"."v2_56" or false) ||
        (f."glib"."0.9.0"."v2_56" or false); }
      { "${deps.glib."0.9.0".glib_sys}"."v2_58" =
        (f.glib_sys."${deps.glib."0.9.0".glib_sys}"."v2_58" or false) ||
        (glib."0.9.0"."v2_58" or false) ||
        (f."glib"."0.9.0"."v2_58" or false); }
      { "${deps.glib."0.9.0".glib_sys}"."v2_60" =
        (f.glib_sys."${deps.glib."0.9.0".glib_sys}"."v2_60" or false) ||
        (glib."0.9.0"."v2_60" or false) ||
        (f."glib"."0.9.0"."v2_60" or false); }
      { "${deps.glib."0.9.0".glib_sys}".default = true; }
    ];
    gobject_sys = fold recursiveUpdate {} [
      { "${deps.glib."0.9.0".gobject_sys}"."dox" =
        (f.gobject_sys."${deps.glib."0.9.0".gobject_sys}"."dox" or false) ||
        (glib."0.9.0"."dox" or false) ||
        (f."glib"."0.9.0"."dox" or false); }
      { "${deps.glib."0.9.0".gobject_sys}"."v2_44" =
        (f.gobject_sys."${deps.glib."0.9.0".gobject_sys}"."v2_44" or false) ||
        (glib."0.9.0"."v2_44" or false) ||
        (f."glib"."0.9.0"."v2_44" or false); }
      { "${deps.glib."0.9.0".gobject_sys}"."v2_46" =
        (f.gobject_sys."${deps.glib."0.9.0".gobject_sys}"."v2_46" or false) ||
        (glib."0.9.0"."v2_46" or false) ||
        (f."glib"."0.9.0"."v2_46" or false); }
      { "${deps.glib."0.9.0".gobject_sys}"."v2_54" =
        (f.gobject_sys."${deps.glib."0.9.0".gobject_sys}"."v2_54" or false) ||
        (glib."0.9.0"."v2_54" or false) ||
        (f."glib"."0.9.0"."v2_54" or false); }
      { "${deps.glib."0.9.0".gobject_sys}".default = true; }
    ];
    lazy_static."${deps.glib."0.9.0".lazy_static}".default = true;
    libc."${deps.glib."0.9.0".libc}".default = true;
  }) [
    (features_.bitflags."${deps."glib"."0.9.0"."bitflags"}" deps)
    (features_.futures_channel."${deps."glib"."0.9.0"."futures_channel"}" deps)
    (features_.futures_core."${deps."glib"."0.9.0"."futures_core"}" deps)
    (features_.futures_executor."${deps."glib"."0.9.0"."futures_executor"}" deps)
    (features_.futures_task."${deps."glib"."0.9.0"."futures_task"}" deps)
    (features_.futures_util."${deps."glib"."0.9.0"."futures_util"}" deps)
    (features_.glib_sys."${deps."glib"."0.9.0"."glib_sys"}" deps)
    (features_.gobject_sys."${deps."glib"."0.9.0"."gobject_sys"}" deps)
    (features_.lazy_static."${deps."glib"."0.9.0"."lazy_static"}" deps)
    (features_.libc."${deps."glib"."0.9.0"."libc"}" deps)
  ];


# end
# glib-sys-0.9.1

  crates.glib_sys."0.9.1" = deps: { features?(features_.glib_sys."0.9.1" deps {}) }: buildRustCrate {
    crateName = "glib-sys";
    version = "0.9.1";
    description = "FFI bindings to libglib-2.0";
    authors = [ "The Gtk-rs Project Developers" ];
    sha256 = "1pi7xhy03nzwx5460l2f8dh57wxga3kcmqn6rhhjqgd5gxif1803";
    libName = "glib_sys";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."libc"."${deps."glib_sys"."0.9.1"."libc"}" deps)
    ]);

    buildDependencies = mapFeatures features ([
      (crates."pkg_config"."${deps."glib_sys"."0.9.1"."pkg_config"}" deps)
    ]);
    features = mkFeatures (features."glib_sys"."0.9.1" or {});
  };
  features_.glib_sys."0.9.1" = deps: f: updateFeatures f (rec {
    glib_sys = fold recursiveUpdate {} [
      { "0.9.1"."v2_44" =
        (f.glib_sys."0.9.1"."v2_44" or false) ||
        (f.glib_sys."0.9.1".v2_46 or false) ||
        (glib_sys."0.9.1"."v2_46" or false); }
      { "0.9.1"."v2_46" =
        (f.glib_sys."0.9.1"."v2_46" or false) ||
        (f.glib_sys."0.9.1".v2_48 or false) ||
        (glib_sys."0.9.1"."v2_48" or false); }
      { "0.9.1"."v2_48" =
        (f.glib_sys."0.9.1"."v2_48" or false) ||
        (f.glib_sys."0.9.1".v2_50 or false) ||
        (glib_sys."0.9.1"."v2_50" or false); }
      { "0.9.1"."v2_50" =
        (f.glib_sys."0.9.1"."v2_50" or false) ||
        (f.glib_sys."0.9.1".v2_52 or false) ||
        (glib_sys."0.9.1"."v2_52" or false); }
      { "0.9.1"."v2_52" =
        (f.glib_sys."0.9.1"."v2_52" or false) ||
        (f.glib_sys."0.9.1".v2_54 or false) ||
        (glib_sys."0.9.1"."v2_54" or false); }
      { "0.9.1"."v2_54" =
        (f.glib_sys."0.9.1"."v2_54" or false) ||
        (f.glib_sys."0.9.1".v2_56 or false) ||
        (glib_sys."0.9.1"."v2_56" or false); }
      { "0.9.1"."v2_56" =
        (f.glib_sys."0.9.1"."v2_56" or false) ||
        (f.glib_sys."0.9.1".v2_58 or false) ||
        (glib_sys."0.9.1"."v2_58" or false); }
      { "0.9.1"."v2_58" =
        (f.glib_sys."0.9.1"."v2_58" or false) ||
        (f.glib_sys."0.9.1".v2_60 or false) ||
        (glib_sys."0.9.1"."v2_60" or false); }
      { "0.9.1"."v2_60" =
        (f.glib_sys."0.9.1"."v2_60" or false) ||
        (f.glib_sys."0.9.1".v2_62 or false) ||
        (glib_sys."0.9.1"."v2_62" or false); }
      { "0.9.1".default = (f.glib_sys."0.9.1".default or true); }
    ];
    libc."${deps.glib_sys."0.9.1".libc}".default = true;
    pkg_config."${deps.glib_sys."0.9.1".pkg_config}".default = true;
  }) [
    (features_.libc."${deps."glib_sys"."0.9.1"."libc"}" deps)
    (features_.pkg_config."${deps."glib_sys"."0.9.1"."pkg_config"}" deps)
  ];


# end
# gobject-sys-0.9.1

  crates.gobject_sys."0.9.1" = deps: { features?(features_.gobject_sys."0.9.1" deps {}) }: buildRustCrate {
    crateName = "gobject-sys";
    version = "0.9.1";
    description = "FFI bindings to libgobject-2.0";
    authors = [ "The Gtk-rs Project Developers" ];
    sha256 = "0rs3l3fgqxqh6xdw9w547j2p6ndy8m368s83d2x4797aljxcs7zr";
    libName = "gobject_sys";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."glib_sys"."${deps."gobject_sys"."0.9.1"."glib_sys"}" deps)
      (crates."libc"."${deps."gobject_sys"."0.9.1"."libc"}" deps)
    ]);

    buildDependencies = mapFeatures features ([
      (crates."pkg_config"."${deps."gobject_sys"."0.9.1"."pkg_config"}" deps)
    ]);
    features = mkFeatures (features."gobject_sys"."0.9.1" or {});
  };
  features_.gobject_sys."0.9.1" = deps: f: updateFeatures f (rec {
    glib_sys."${deps.gobject_sys."0.9.1".glib_sys}".default = true;
    gobject_sys = fold recursiveUpdate {} [
      { "0.9.1"."v2_44" =
        (f.gobject_sys."0.9.1"."v2_44" or false) ||
        (f.gobject_sys."0.9.1".v2_46 or false) ||
        (gobject_sys."0.9.1"."v2_46" or false); }
      { "0.9.1"."v2_46" =
        (f.gobject_sys."0.9.1"."v2_46" or false) ||
        (f.gobject_sys."0.9.1".v2_54 or false) ||
        (gobject_sys."0.9.1"."v2_54" or false); }
      { "0.9.1"."v2_54" =
        (f.gobject_sys."0.9.1"."v2_54" or false) ||
        (f.gobject_sys."0.9.1".v2_58 or false) ||
        (gobject_sys."0.9.1"."v2_58" or false); }
      { "0.9.1"."v2_58" =
        (f.gobject_sys."0.9.1"."v2_58" or false) ||
        (f.gobject_sys."0.9.1".v2_62 or false) ||
        (gobject_sys."0.9.1"."v2_62" or false); }
      { "0.9.1".default = (f.gobject_sys."0.9.1".default or true); }
    ];
    libc."${deps.gobject_sys."0.9.1".libc}".default = true;
    pkg_config."${deps.gobject_sys."0.9.1".pkg_config}".default = true;
  }) [
    (features_.glib_sys."${deps."gobject_sys"."0.9.1"."glib_sys"}" deps)
    (features_.libc."${deps."gobject_sys"."0.9.1"."libc"}" deps)
    (features_.pkg_config."${deps."gobject_sys"."0.9.1"."pkg_config"}" deps)
  ];


# end
# gtk-0.8.0

  crates.gtk."0.8.0" = deps: { features?(features_.gtk."0.8.0" deps {}) }: buildRustCrate {
    crateName = "gtk";
    version = "0.8.0";
    description = "Rust bindings for the GTK+ 3 library";
    authors = [ "The Gtk-rs Project Developers" ];
    sha256 = "0rnzmc6xck0akhz8x6v3rwvdfyzw698j1a64hqqqp2ri0g3fx6j4";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."atk"."${deps."gtk"."0.8.0"."atk"}" deps)
      (crates."bitflags"."${deps."gtk"."0.8.0"."bitflags"}" deps)
      (crates."cairo_rs"."${deps."gtk"."0.8.0"."cairo_rs"}" deps)
      (crates."cairo_sys_rs"."${deps."gtk"."0.8.0"."cairo_sys_rs"}" deps)
      (crates."gdk"."${deps."gtk"."0.8.0"."gdk"}" deps)
      (crates."gdk_pixbuf"."${deps."gtk"."0.8.0"."gdk_pixbuf"}" deps)
      (crates."gdk_pixbuf_sys"."${deps."gtk"."0.8.0"."gdk_pixbuf_sys"}" deps)
      (crates."gdk_sys"."${deps."gtk"."0.8.0"."gdk_sys"}" deps)
      (crates."gio"."${deps."gtk"."0.8.0"."gio"}" deps)
      (crates."gio_sys"."${deps."gtk"."0.8.0"."gio_sys"}" deps)
      (crates."glib"."${deps."gtk"."0.8.0"."glib"}" deps)
      (crates."glib_sys"."${deps."gtk"."0.8.0"."glib_sys"}" deps)
      (crates."gobject_sys"."${deps."gtk"."0.8.0"."gobject_sys"}" deps)
      (crates."gtk_sys"."${deps."gtk"."0.8.0"."gtk_sys"}" deps)
      (crates."lazy_static"."${deps."gtk"."0.8.0"."lazy_static"}" deps)
      (crates."libc"."${deps."gtk"."0.8.0"."libc"}" deps)
      (crates."pango"."${deps."gtk"."0.8.0"."pango"}" deps)
      (crates."pango_sys"."${deps."gtk"."0.8.0"."pango_sys"}" deps)
    ])
      ++ (if kernel == "darwin" then mapFeatures features ([
]) else []);

    buildDependencies = mapFeatures features ([
]);
    features = mkFeatures (features."gtk"."0.8.0" or {});
  };
  features_.gtk."0.8.0" = deps: f: updateFeatures f (rec {
    atk."${deps.gtk."0.8.0".atk}".default = true;
    bitflags."${deps.gtk."0.8.0".bitflags}".default = true;
    cairo_rs."${deps.gtk."0.8.0".cairo_rs}".default = true;
    cairo_sys_rs."${deps.gtk."0.8.0".cairo_sys_rs}".default = true;
    gdk = fold recursiveUpdate {} [
      { "${deps.gtk."0.8.0".gdk}"."dox" =
        (f.gdk."${deps.gtk."0.8.0".gdk}"."dox" or false) ||
        (gtk."0.8.0"."dox" or false) ||
        (f."gtk"."0.8.0"."dox" or false); }
      { "${deps.gtk."0.8.0".gdk}"."embed-lgpl-docs" =
        (f.gdk."${deps.gtk."0.8.0".gdk}"."embed-lgpl-docs" or false) ||
        (gtk."0.8.0"."embed-lgpl-docs" or false) ||
        (f."gtk"."0.8.0"."embed-lgpl-docs" or false); }
      { "${deps.gtk."0.8.0".gdk}"."purge-lgpl-docs" =
        (f.gdk."${deps.gtk."0.8.0".gdk}"."purge-lgpl-docs" or false) ||
        (gtk."0.8.0"."purge-lgpl-docs" or false) ||
        (f."gtk"."0.8.0"."purge-lgpl-docs" or false); }
      { "${deps.gtk."0.8.0".gdk}"."v3_16" =
        (f.gdk."${deps.gtk."0.8.0".gdk}"."v3_16" or false) ||
        (gtk."0.8.0"."v3_16" or false) ||
        (f."gtk"."0.8.0"."v3_16" or false); }
      { "${deps.gtk."0.8.0".gdk}"."v3_22" =
        (f.gdk."${deps.gtk."0.8.0".gdk}"."v3_22" or false) ||
        (gtk."0.8.0"."v3_22" or false) ||
        (f."gtk"."0.8.0"."v3_22" or false); }
      { "${deps.gtk."0.8.0".gdk}".default = true; }
    ];
    gdk_pixbuf."${deps.gtk."0.8.0".gdk_pixbuf}".default = true;
    gdk_pixbuf_sys."${deps.gtk."0.8.0".gdk_pixbuf_sys}".default = true;
    gdk_sys."${deps.gtk."0.8.0".gdk_sys}".default = true;
    gio = fold recursiveUpdate {} [
      { "${deps.gtk."0.8.0".gio}"."v2_44" =
        (f.gio."${deps.gtk."0.8.0".gio}"."v2_44" or false) ||
        (gtk."0.8.0"."v3_16" or false) ||
        (f."gtk"."0.8.0"."v3_16" or false); }
      { "${deps.gtk."0.8.0".gio}".default = true; }
    ];
    gio_sys."${deps.gtk."0.8.0".gio_sys}".default = true;
    glib."${deps.gtk."0.8.0".glib}".default = true;
    glib_sys."${deps.gtk."0.8.0".glib_sys}".default = true;
    gobject_sys."${deps.gtk."0.8.0".gobject_sys}".default = true;
    gtk = fold recursiveUpdate {} [
      { "0.8.0"."gtk-rs-lgpl-docs" =
        (f.gtk."0.8.0"."gtk-rs-lgpl-docs" or false) ||
        (f.gtk."0.8.0".embed-lgpl-docs or false) ||
        (gtk."0.8.0"."embed-lgpl-docs" or false) ||
        (f.gtk."0.8.0".purge-lgpl-docs or false) ||
        (gtk."0.8.0"."purge-lgpl-docs" or false); }
      { "0.8.0"."v3_16" =
        (f.gtk."0.8.0"."v3_16" or false) ||
        (f.gtk."0.8.0".v3_18 or false) ||
        (gtk."0.8.0"."v3_18" or false); }
      { "0.8.0"."v3_18" =
        (f.gtk."0.8.0"."v3_18" or false) ||
        (f.gtk."0.8.0".v3_20 or false) ||
        (gtk."0.8.0"."v3_20" or false); }
      { "0.8.0"."v3_20" =
        (f.gtk."0.8.0"."v3_20" or false) ||
        (f.gtk."0.8.0".v3_22 or false) ||
        (gtk."0.8.0"."v3_22" or false); }
      { "0.8.0"."v3_22" =
        (f.gtk."0.8.0"."v3_22" or false) ||
        (f.gtk."0.8.0".v3_22_20 or false) ||
        (gtk."0.8.0"."v3_22_20" or false); }
      { "0.8.0"."v3_22_20" =
        (f.gtk."0.8.0"."v3_22_20" or false) ||
        (f.gtk."0.8.0".v3_22_26 or false) ||
        (gtk."0.8.0"."v3_22_26" or false); }
      { "0.8.0"."v3_22_26" =
        (f.gtk."0.8.0"."v3_22_26" or false) ||
        (f.gtk."0.8.0".v3_22_27 or false) ||
        (gtk."0.8.0"."v3_22_27" or false); }
      { "0.8.0"."v3_22_27" =
        (f.gtk."0.8.0"."v3_22_27" or false) ||
        (f.gtk."0.8.0".v3_22_29 or false) ||
        (gtk."0.8.0"."v3_22_29" or false); }
      { "0.8.0"."v3_22_29" =
        (f.gtk."0.8.0"."v3_22_29" or false) ||
        (f.gtk."0.8.0".v3_22_30 or false) ||
        (gtk."0.8.0"."v3_22_30" or false); }
      { "0.8.0"."v3_22_30" =
        (f.gtk."0.8.0"."v3_22_30" or false) ||
        (f.gtk."0.8.0".v3_24 or false) ||
        (gtk."0.8.0"."v3_24" or false); }
      { "0.8.0"."v3_24" =
        (f.gtk."0.8.0"."v3_24" or false) ||
        (f.gtk."0.8.0".v3_24_8 or false) ||
        (gtk."0.8.0"."v3_24_8" or false); }
      { "0.8.0".default = (f.gtk."0.8.0".default or true); }
    ];
    gtk_sys = fold recursiveUpdate {} [
      { "${deps.gtk."0.8.0".gtk_sys}"."dox" =
        (f.gtk_sys."${deps.gtk."0.8.0".gtk_sys}"."dox" or false) ||
        (gtk."0.8.0"."dox" or false) ||
        (f."gtk"."0.8.0"."dox" or false); }
      { "${deps.gtk."0.8.0".gtk_sys}"."v3_16" =
        (f.gtk_sys."${deps.gtk."0.8.0".gtk_sys}"."v3_16" or false) ||
        (gtk."0.8.0"."v3_16" or false) ||
        (f."gtk"."0.8.0"."v3_16" or false); }
      { "${deps.gtk."0.8.0".gtk_sys}"."v3_18" =
        (f.gtk_sys."${deps.gtk."0.8.0".gtk_sys}"."v3_18" or false) ||
        (gtk."0.8.0"."v3_18" or false) ||
        (f."gtk"."0.8.0"."v3_18" or false); }
      { "${deps.gtk."0.8.0".gtk_sys}"."v3_20" =
        (f.gtk_sys."${deps.gtk."0.8.0".gtk_sys}"."v3_20" or false) ||
        (gtk."0.8.0"."v3_20" or false) ||
        (f."gtk"."0.8.0"."v3_20" or false); }
      { "${deps.gtk."0.8.0".gtk_sys}"."v3_22" =
        (f.gtk_sys."${deps.gtk."0.8.0".gtk_sys}"."v3_22" or false) ||
        (gtk."0.8.0"."v3_22" or false) ||
        (f."gtk"."0.8.0"."v3_22" or false) ||
        (gtk."0.8.0"."v3_22_20" or false) ||
        (f."gtk"."0.8.0"."v3_22_20" or false); }
      { "${deps.gtk."0.8.0".gtk_sys}"."v3_22_26" =
        (f.gtk_sys."${deps.gtk."0.8.0".gtk_sys}"."v3_22_26" or false) ||
        (gtk."0.8.0"."v3_22_26" or false) ||
        (f."gtk"."0.8.0"."v3_22_26" or false); }
      { "${deps.gtk."0.8.0".gtk_sys}"."v3_22_27" =
        (f.gtk_sys."${deps.gtk."0.8.0".gtk_sys}"."v3_22_27" or false) ||
        (gtk."0.8.0"."v3_22_27" or false) ||
        (f."gtk"."0.8.0"."v3_22_27" or false); }
      { "${deps.gtk."0.8.0".gtk_sys}"."v3_22_29" =
        (f.gtk_sys."${deps.gtk."0.8.0".gtk_sys}"."v3_22_29" or false) ||
        (gtk."0.8.0"."v3_22_29" or false) ||
        (f."gtk"."0.8.0"."v3_22_29" or false); }
      { "${deps.gtk."0.8.0".gtk_sys}"."v3_22_30" =
        (f.gtk_sys."${deps.gtk."0.8.0".gtk_sys}"."v3_22_30" or false) ||
        (gtk."0.8.0"."v3_22_30" or false) ||
        (f."gtk"."0.8.0"."v3_22_30" or false); }
      { "${deps.gtk."0.8.0".gtk_sys}"."v3_24" =
        (f.gtk_sys."${deps.gtk."0.8.0".gtk_sys}"."v3_24" or false) ||
        (gtk."0.8.0"."v3_24" or false) ||
        (f."gtk"."0.8.0"."v3_24" or false); }
      { "${deps.gtk."0.8.0".gtk_sys}"."v3_24_8" =
        (f.gtk_sys."${deps.gtk."0.8.0".gtk_sys}"."v3_24_8" or false) ||
        (gtk."0.8.0"."v3_24_8" or false) ||
        (f."gtk"."0.8.0"."v3_24_8" or false); }
      { "${deps.gtk."0.8.0".gtk_sys}".default = true; }
    ];
    lazy_static."${deps.gtk."0.8.0".lazy_static}".default = true;
    libc."${deps.gtk."0.8.0".libc}".default = true;
    pango."${deps.gtk."0.8.0".pango}".default = true;
    pango_sys."${deps.gtk."0.8.0".pango_sys}".default = true;
  }) [
    (features_.atk."${deps."gtk"."0.8.0"."atk"}" deps)
    (features_.bitflags."${deps."gtk"."0.8.0"."bitflags"}" deps)
    (features_.cairo_rs."${deps."gtk"."0.8.0"."cairo_rs"}" deps)
    (features_.cairo_sys_rs."${deps."gtk"."0.8.0"."cairo_sys_rs"}" deps)
    (features_.gdk."${deps."gtk"."0.8.0"."gdk"}" deps)
    (features_.gdk_pixbuf."${deps."gtk"."0.8.0"."gdk_pixbuf"}" deps)
    (features_.gdk_pixbuf_sys."${deps."gtk"."0.8.0"."gdk_pixbuf_sys"}" deps)
    (features_.gdk_sys."${deps."gtk"."0.8.0"."gdk_sys"}" deps)
    (features_.gio."${deps."gtk"."0.8.0"."gio"}" deps)
    (features_.gio_sys."${deps."gtk"."0.8.0"."gio_sys"}" deps)
    (features_.glib."${deps."gtk"."0.8.0"."glib"}" deps)
    (features_.glib_sys."${deps."gtk"."0.8.0"."glib_sys"}" deps)
    (features_.gobject_sys."${deps."gtk"."0.8.0"."gobject_sys"}" deps)
    (features_.gtk_sys."${deps."gtk"."0.8.0"."gtk_sys"}" deps)
    (features_.lazy_static."${deps."gtk"."0.8.0"."lazy_static"}" deps)
    (features_.libc."${deps."gtk"."0.8.0"."libc"}" deps)
    (features_.pango."${deps."gtk"."0.8.0"."pango"}" deps)
    (features_.pango_sys."${deps."gtk"."0.8.0"."pango_sys"}" deps)
  ];


# end
# gtk-sys-0.9.2

  crates.gtk_sys."0.9.2" = deps: { features?(features_.gtk_sys."0.9.2" deps {}) }: buildRustCrate {
    crateName = "gtk-sys";
    version = "0.9.2";
    description = "FFI bindings to libgtk-3";
    authors = [ "The Gtk-rs Project Developers" ];
    sha256 = "0qrzys178ns4975f3nbq49l807cmpdhfakwn80z68mp566silzlr";
    libName = "gtk_sys";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."atk_sys"."${deps."gtk_sys"."0.9.2"."atk_sys"}" deps)
      (crates."cairo_sys_rs"."${deps."gtk_sys"."0.9.2"."cairo_sys_rs"}" deps)
      (crates."gdk_pixbuf_sys"."${deps."gtk_sys"."0.9.2"."gdk_pixbuf_sys"}" deps)
      (crates."gdk_sys"."${deps."gtk_sys"."0.9.2"."gdk_sys"}" deps)
      (crates."gio_sys"."${deps."gtk_sys"."0.9.2"."gio_sys"}" deps)
      (crates."glib_sys"."${deps."gtk_sys"."0.9.2"."glib_sys"}" deps)
      (crates."gobject_sys"."${deps."gtk_sys"."0.9.2"."gobject_sys"}" deps)
      (crates."libc"."${deps."gtk_sys"."0.9.2"."libc"}" deps)
      (crates."pango_sys"."${deps."gtk_sys"."0.9.2"."pango_sys"}" deps)
    ]);

    buildDependencies = mapFeatures features ([
      (crates."pkg_config"."${deps."gtk_sys"."0.9.2"."pkg_config"}" deps)
    ]);
    features = mkFeatures (features."gtk_sys"."0.9.2" or {});
  };
  features_.gtk_sys."0.9.2" = deps: f: updateFeatures f (rec {
    atk_sys."${deps.gtk_sys."0.9.2".atk_sys}".default = true;
    cairo_sys_rs."${deps.gtk_sys."0.9.2".cairo_sys_rs}".default = true;
    gdk_pixbuf_sys."${deps.gtk_sys."0.9.2".gdk_pixbuf_sys}".default = true;
    gdk_sys."${deps.gtk_sys."0.9.2".gdk_sys}".default = true;
    gio_sys."${deps.gtk_sys."0.9.2".gio_sys}".default = true;
    glib_sys."${deps.gtk_sys."0.9.2".glib_sys}".default = true;
    gobject_sys."${deps.gtk_sys."0.9.2".gobject_sys}".default = true;
    gtk_sys = fold recursiveUpdate {} [
      { "0.9.2"."v3_16" =
        (f.gtk_sys."0.9.2"."v3_16" or false) ||
        (f.gtk_sys."0.9.2".v3_18 or false) ||
        (gtk_sys."0.9.2"."v3_18" or false); }
      { "0.9.2"."v3_18" =
        (f.gtk_sys."0.9.2"."v3_18" or false) ||
        (f.gtk_sys."0.9.2".v3_20 or false) ||
        (gtk_sys."0.9.2"."v3_20" or false); }
      { "0.9.2"."v3_20" =
        (f.gtk_sys."0.9.2"."v3_20" or false) ||
        (f.gtk_sys."0.9.2".v3_22 or false) ||
        (gtk_sys."0.9.2"."v3_22" or false); }
      { "0.9.2"."v3_22" =
        (f.gtk_sys."0.9.2"."v3_22" or false) ||
        (f.gtk_sys."0.9.2".v3_22_6 or false) ||
        (gtk_sys."0.9.2"."v3_22_6" or false); }
      { "0.9.2"."v3_22_26" =
        (f.gtk_sys."0.9.2"."v3_22_26" or false) ||
        (f.gtk_sys."0.9.2".v3_22_27 or false) ||
        (gtk_sys."0.9.2"."v3_22_27" or false); }
      { "0.9.2"."v3_22_27" =
        (f.gtk_sys."0.9.2"."v3_22_27" or false) ||
        (f.gtk_sys."0.9.2".v3_22_29 or false) ||
        (gtk_sys."0.9.2"."v3_22_29" or false); }
      { "0.9.2"."v3_22_29" =
        (f.gtk_sys."0.9.2"."v3_22_29" or false) ||
        (f.gtk_sys."0.9.2".v3_22_30 or false) ||
        (gtk_sys."0.9.2"."v3_22_30" or false); }
      { "0.9.2"."v3_22_30" =
        (f.gtk_sys."0.9.2"."v3_22_30" or false) ||
        (f.gtk_sys."0.9.2".v3_24 or false) ||
        (gtk_sys."0.9.2"."v3_24" or false); }
      { "0.9.2"."v3_22_6" =
        (f.gtk_sys."0.9.2"."v3_22_6" or false) ||
        (f.gtk_sys."0.9.2".v3_22_26 or false) ||
        (gtk_sys."0.9.2"."v3_22_26" or false); }
      { "0.9.2"."v3_24" =
        (f.gtk_sys."0.9.2"."v3_24" or false) ||
        (f.gtk_sys."0.9.2".v3_24_8 or false) ||
        (gtk_sys."0.9.2"."v3_24_8" or false); }
      { "0.9.2"."v3_24_8" =
        (f.gtk_sys."0.9.2"."v3_24_8" or false) ||
        (f.gtk_sys."0.9.2".v3_24_9 or false) ||
        (gtk_sys."0.9.2"."v3_24_9" or false); }
      { "0.9.2".default = (f.gtk_sys."0.9.2".default or true); }
    ];
    libc."${deps.gtk_sys."0.9.2".libc}".default = true;
    pango_sys."${deps.gtk_sys."0.9.2".pango_sys}".default = true;
    pkg_config."${deps.gtk_sys."0.9.2".pkg_config}".default = true;
  }) [
    (features_.atk_sys."${deps."gtk_sys"."0.9.2"."atk_sys"}" deps)
    (features_.cairo_sys_rs."${deps."gtk_sys"."0.9.2"."cairo_sys_rs"}" deps)
    (features_.gdk_pixbuf_sys."${deps."gtk_sys"."0.9.2"."gdk_pixbuf_sys"}" deps)
    (features_.gdk_sys."${deps."gtk_sys"."0.9.2"."gdk_sys"}" deps)
    (features_.gio_sys."${deps."gtk_sys"."0.9.2"."gio_sys"}" deps)
    (features_.glib_sys."${deps."gtk_sys"."0.9.2"."glib_sys"}" deps)
    (features_.gobject_sys."${deps."gtk_sys"."0.9.2"."gobject_sys"}" deps)
    (features_.libc."${deps."gtk_sys"."0.9.2"."libc"}" deps)
    (features_.pango_sys."${deps."gtk_sys"."0.9.2"."pango_sys"}" deps)
    (features_.pkg_config."${deps."gtk_sys"."0.9.2"."pkg_config"}" deps)
  ];


# end
# itoa-0.4.4

  crates.itoa."0.4.4" = deps: { features?(features_.itoa."0.4.4" deps {}) }: buildRustCrate {
    crateName = "itoa";
    version = "0.4.4";
    description = "Fast functions for printing integer primitives to an io::Write";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "1fqc34xzzl2spfdawxd9awhzl0fwf1y6y4i94l8bq8rfrzd90awl";
    features = mkFeatures (features."itoa"."0.4.4" or {});
  };
  features_.itoa."0.4.4" = deps: f: updateFeatures f (rec {
    itoa = fold recursiveUpdate {} [
      { "0.4.4"."std" =
        (f.itoa."0.4.4"."std" or false) ||
        (f.itoa."0.4.4".default or false) ||
        (itoa."0.4.4"."default" or false); }
      { "0.4.4".default = (f.itoa."0.4.4".default or true); }
    ];
  }) [];


# end
# kernel32-sys-0.2.2

  crates.kernel32_sys."0.2.2" = deps: { features?(features_.kernel32_sys."0.2.2" deps {}) }: buildRustCrate {
    crateName = "kernel32-sys";
    version = "0.2.2";
    description = "Contains function definitions for the Windows API library kernel32. See winapi for types and constants.";
    authors = [ "Peter Atashian <retep998@gmail.com>" ];
    sha256 = "1lrw1hbinyvr6cp28g60z97w32w8vsk6pahk64pmrv2fmby8srfj";
    libName = "kernel32";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."winapi"."${deps."kernel32_sys"."0.2.2"."winapi"}" deps)
    ]);

    buildDependencies = mapFeatures features ([
      (crates."winapi_build"."${deps."kernel32_sys"."0.2.2"."winapi_build"}" deps)
    ]);
  };
  features_.kernel32_sys."0.2.2" = deps: f: updateFeatures f (rec {
    kernel32_sys."0.2.2".default = (f.kernel32_sys."0.2.2".default or true);
    winapi."${deps.kernel32_sys."0.2.2".winapi}".default = true;
    winapi_build."${deps.kernel32_sys."0.2.2".winapi_build}".default = true;
  }) [
    (features_.winapi."${deps."kernel32_sys"."0.2.2"."winapi"}" deps)
    (features_.winapi_build."${deps."kernel32_sys"."0.2.2"."winapi_build"}" deps)
  ];


# end
# lazy_static-1.4.0

  crates.lazy_static."1.4.0" = deps: { features?(features_.lazy_static."1.4.0" deps {}) }: buildRustCrate {
    crateName = "lazy_static";
    version = "1.4.0";
    description = "A macro for declaring lazily evaluated statics in Rust.";
    authors = [ "Marvin Löbel <loebel.marvin@gmail.com>" ];
    sha256 = "13h6sdghdcy7vcqsm2gasfw3qg7ssa0fl3sw7lq6pdkbk52wbyfr";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."lazy_static"."1.4.0" or {});
  };
  features_.lazy_static."1.4.0" = deps: f: updateFeatures f (rec {
    lazy_static = fold recursiveUpdate {} [
      { "1.4.0"."spin" =
        (f.lazy_static."1.4.0"."spin" or false) ||
        (f.lazy_static."1.4.0".spin_no_std or false) ||
        (lazy_static."1.4.0"."spin_no_std" or false); }
      { "1.4.0".default = (f.lazy_static."1.4.0".default or true); }
    ];
  }) [];


# end
# libc-0.2.66

  crates.libc."0.2.66" = deps: { features?(features_.libc."0.2.66" deps {}) }: buildRustCrate {
    crateName = "libc";
    version = "0.2.66";
    description = "Raw FFI bindings to platform libraries like libc.\n";
    authors = [ "The Rust Project Developers" ];
    sha256 = "0wz5fdpjpj8qp7wx7gq9rqckd2bdv7hcm5631hq03amxy5ikhi3l";
    build = "build.rs";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."libc"."0.2.66" or {});
  };
  features_.libc."0.2.66" = deps: f: updateFeatures f (rec {
    libc = fold recursiveUpdate {} [
      { "0.2.66"."align" =
        (f.libc."0.2.66"."align" or false) ||
        (f.libc."0.2.66".rustc-dep-of-std or false) ||
        (libc."0.2.66"."rustc-dep-of-std" or false); }
      { "0.2.66"."rustc-std-workspace-core" =
        (f.libc."0.2.66"."rustc-std-workspace-core" or false) ||
        (f.libc."0.2.66".rustc-dep-of-std or false) ||
        (libc."0.2.66"."rustc-dep-of-std" or false); }
      { "0.2.66"."std" =
        (f.libc."0.2.66"."std" or false) ||
        (f.libc."0.2.66".default or false) ||
        (libc."0.2.66"."default" or false) ||
        (f.libc."0.2.66".use_std or false) ||
        (libc."0.2.66"."use_std" or false); }
      { "0.2.66".default = (f.libc."0.2.66".default or true); }
    ];
  }) [];


# end
# linked-hash-map-0.5.2

  crates.linked_hash_map."0.5.2" = deps: { features?(features_.linked_hash_map."0.5.2" deps {}) }: buildRustCrate {
    crateName = "linked-hash-map";
    version = "0.5.2";
    description = "A HashMap wrapper that holds key-value pairs in insertion order";
    authors = [ "Stepan Koltsov <stepan.koltsov@gmail.com>" "Andrew Paseltiner <apaseltiner@gmail.com>" ];
    sha256 = "17bpcphlhrxknzvikmihiqm690wwyr0zridyilh1dlxgmrxng7pd";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."linked_hash_map"."0.5.2" or {});
  };
  features_.linked_hash_map."0.5.2" = deps: f: updateFeatures f (rec {
    linked_hash_map = fold recursiveUpdate {} [
      { "0.5.2"."heapsize" =
        (f.linked_hash_map."0.5.2"."heapsize" or false) ||
        (f.linked_hash_map."0.5.2".heapsize_impl or false) ||
        (linked_hash_map."0.5.2"."heapsize_impl" or false); }
      { "0.5.2"."serde" =
        (f.linked_hash_map."0.5.2"."serde" or false) ||
        (f.linked_hash_map."0.5.2".serde_impl or false) ||
        (linked_hash_map."0.5.2"."serde_impl" or false); }
      { "0.5.2"."serde_test" =
        (f.linked_hash_map."0.5.2"."serde_test" or false) ||
        (f.linked_hash_map."0.5.2".serde_impl or false) ||
        (linked_hash_map."0.5.2"."serde_impl" or false); }
      { "0.5.2".default = (f.linked_hash_map."0.5.2".default or true); }
    ];
  }) [];


# end
# memchr-0.1.11

  crates.memchr."0.1.11" = deps: { features?(features_.memchr."0.1.11" deps {}) }: buildRustCrate {
    crateName = "memchr";
    version = "0.1.11";
    description = "Safe interface to memchr.";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" "bluss" ];
    sha256 = "0x73jghamvxxq5fsw9wb0shk5m6qp3q6fsf0nibn0i6bbqkw91s8";
    dependencies = mapFeatures features ([
      (crates."libc"."${deps."memchr"."0.1.11"."libc"}" deps)
    ]);
  };
  features_.memchr."0.1.11" = deps: f: updateFeatures f (rec {
    libc."${deps.memchr."0.1.11".libc}".default = true;
    memchr."0.1.11".default = (f.memchr."0.1.11".default or true);
  }) [
    (features_.libc."${deps."memchr"."0.1.11"."libc"}" deps)
  ];


# end
# memchr-2.2.1

  crates.memchr."2.2.1" = deps: { features?(features_.memchr."2.2.1" deps {}) }: buildRustCrate {
    crateName = "memchr";
    version = "2.2.1";
    description = "Safe interface to memchr.";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" "bluss" ];
    sha256 = "1mj5z8lhz6jbapslpq8a39pwcsl1p0jmgp7wgcj7nv4pcqhya7a0";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."memchr"."2.2.1" or {});
  };
  features_.memchr."2.2.1" = deps: f: updateFeatures f (rec {
    memchr = fold recursiveUpdate {} [
      { "2.2.1"."use_std" =
        (f.memchr."2.2.1"."use_std" or false) ||
        (f.memchr."2.2.1".default or false) ||
        (memchr."2.2.1"."default" or false); }
      { "2.2.1".default = (f.memchr."2.2.1".default or true); }
    ];
  }) [];


# end
# num-integer-0.1.41

  crates.num_integer."0.1.41" = deps: { features?(features_.num_integer."0.1.41" deps {}) }: buildRustCrate {
    crateName = "num-integer";
    version = "0.1.41";
    description = "Integer traits and functions";
    authors = [ "The Rust Project Developers" ];
    sha256 = "1y45nh9xlp2dra9svb1wfsy65fysm3k1w4m8jynywccq645yixid";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."num_traits"."${deps."num_integer"."0.1.41"."num_traits"}" deps)
    ]);

    buildDependencies = mapFeatures features ([
      (crates."autocfg"."${deps."num_integer"."0.1.41"."autocfg"}" deps)
    ]);
    features = mkFeatures (features."num_integer"."0.1.41" or {});
  };
  features_.num_integer."0.1.41" = deps: f: updateFeatures f (rec {
    autocfg."${deps.num_integer."0.1.41".autocfg}".default = true;
    num_integer = fold recursiveUpdate {} [
      { "0.1.41"."std" =
        (f.num_integer."0.1.41"."std" or false) ||
        (f.num_integer."0.1.41".default or false) ||
        (num_integer."0.1.41"."default" or false); }
      { "0.1.41".default = (f.num_integer."0.1.41".default or true); }
    ];
    num_traits = fold recursiveUpdate {} [
      { "${deps.num_integer."0.1.41".num_traits}"."i128" =
        (f.num_traits."${deps.num_integer."0.1.41".num_traits}"."i128" or false) ||
        (num_integer."0.1.41"."i128" or false) ||
        (f."num_integer"."0.1.41"."i128" or false); }
      { "${deps.num_integer."0.1.41".num_traits}"."std" =
        (f.num_traits."${deps.num_integer."0.1.41".num_traits}"."std" or false) ||
        (num_integer."0.1.41"."std" or false) ||
        (f."num_integer"."0.1.41"."std" or false); }
      { "${deps.num_integer."0.1.41".num_traits}".default = (f.num_traits."${deps.num_integer."0.1.41".num_traits}".default or false); }
    ];
  }) [
    (features_.num_traits."${deps."num_integer"."0.1.41"."num_traits"}" deps)
    (features_.autocfg."${deps."num_integer"."0.1.41"."autocfg"}" deps)
  ];


# end
# num-traits-0.2.10

  crates.num_traits."0.2.10" = deps: { features?(features_.num_traits."0.2.10" deps {}) }: buildRustCrate {
    crateName = "num-traits";
    version = "0.2.10";
    description = "Numeric traits for generic mathematics";
    authors = [ "The Rust Project Developers" ];
    sha256 = "0f2974brqrfqinws35249ac1g0slr9viqkyf2fkgxckcllssmzfi";
    build = "build.rs";
    dependencies = mapFeatures features ([
]);

    buildDependencies = mapFeatures features ([
      (crates."autocfg"."${deps."num_traits"."0.2.10"."autocfg"}" deps)
    ]);
    features = mkFeatures (features."num_traits"."0.2.10" or {});
  };
  features_.num_traits."0.2.10" = deps: f: updateFeatures f (rec {
    autocfg."${deps.num_traits."0.2.10".autocfg}".default = true;
    num_traits = fold recursiveUpdate {} [
      { "0.2.10"."std" =
        (f.num_traits."0.2.10"."std" or false) ||
        (f.num_traits."0.2.10".default or false) ||
        (num_traits."0.2.10"."default" or false); }
      { "0.2.10".default = (f.num_traits."0.2.10".default or true); }
    ];
  }) [
    (features_.autocfg."${deps."num_traits"."0.2.10"."autocfg"}" deps)
  ];


# end
# pango-0.8.0

  crates.pango."0.8.0" = deps: { features?(features_.pango."0.8.0" deps {}) }: buildRustCrate {
    crateName = "pango";
    version = "0.8.0";
    description = "Rust bindings for the Pango library";
    authors = [ "The Gtk-rs Project Developers" ];
    sha256 = "0rfc5iqa79anjcm5v3qpycl889xml1gq5v4y7lknwbwmrpklx84f";
    dependencies = mapFeatures features ([
      (crates."bitflags"."${deps."pango"."0.8.0"."bitflags"}" deps)
      (crates."glib"."${deps."pango"."0.8.0"."glib"}" deps)
      (crates."glib_sys"."${deps."pango"."0.8.0"."glib_sys"}" deps)
      (crates."gobject_sys"."${deps."pango"."0.8.0"."gobject_sys"}" deps)
      (crates."lazy_static"."${deps."pango"."0.8.0"."lazy_static"}" deps)
      (crates."libc"."${deps."pango"."0.8.0"."libc"}" deps)
      (crates."pango_sys"."${deps."pango"."0.8.0"."pango_sys"}" deps)
    ]);

    buildDependencies = mapFeatures features ([
]);
    features = mkFeatures (features."pango"."0.8.0" or {});
  };
  features_.pango."0.8.0" = deps: f: updateFeatures f (rec {
    bitflags."${deps.pango."0.8.0".bitflags}".default = true;
    glib = fold recursiveUpdate {} [
      { "${deps.pango."0.8.0".glib}"."dox" =
        (f.glib."${deps.pango."0.8.0".glib}"."dox" or false) ||
        (pango."0.8.0"."dox" or false) ||
        (f."pango"."0.8.0"."dox" or false); }
      { "${deps.pango."0.8.0".glib}".default = true; }
    ];
    glib_sys."${deps.pango."0.8.0".glib_sys}".default = true;
    gobject_sys."${deps.pango."0.8.0".gobject_sys}".default = true;
    lazy_static."${deps.pango."0.8.0".lazy_static}".default = true;
    libc."${deps.pango."0.8.0".libc}".default = true;
    pango = fold recursiveUpdate {} [
      { "0.8.0"."gtk-rs-lgpl-docs" =
        (f.pango."0.8.0"."gtk-rs-lgpl-docs" or false) ||
        (f.pango."0.8.0".embed-lgpl-docs or false) ||
        (pango."0.8.0"."embed-lgpl-docs" or false) ||
        (f.pango."0.8.0".purge-lgpl-docs or false) ||
        (pango."0.8.0"."purge-lgpl-docs" or false); }
      { "0.8.0"."v1_38" =
        (f.pango."0.8.0"."v1_38" or false) ||
        (f.pango."0.8.0".v1_40 or false) ||
        (pango."0.8.0"."v1_40" or false); }
      { "0.8.0"."v1_40" =
        (f.pango."0.8.0"."v1_40" or false) ||
        (f.pango."0.8.0".v1_42 or false) ||
        (pango."0.8.0"."v1_42" or false); }
      { "0.8.0".default = (f.pango."0.8.0".default or true); }
    ];
    pango_sys = fold recursiveUpdate {} [
      { "${deps.pango."0.8.0".pango_sys}"."dox" =
        (f.pango_sys."${deps.pango."0.8.0".pango_sys}"."dox" or false) ||
        (pango."0.8.0"."dox" or false) ||
        (f."pango"."0.8.0"."dox" or false); }
      { "${deps.pango."0.8.0".pango_sys}"."v1_38" =
        (f.pango_sys."${deps.pango."0.8.0".pango_sys}"."v1_38" or false) ||
        (pango."0.8.0"."v1_38" or false) ||
        (f."pango"."0.8.0"."v1_38" or false); }
      { "${deps.pango."0.8.0".pango_sys}"."v1_42" =
        (f.pango_sys."${deps.pango."0.8.0".pango_sys}"."v1_42" or false) ||
        (pango."0.8.0"."v1_42" or false) ||
        (f."pango"."0.8.0"."v1_42" or false); }
      { "${deps.pango."0.8.0".pango_sys}".default = true; }
    ];
  }) [
    (features_.bitflags."${deps."pango"."0.8.0"."bitflags"}" deps)
    (features_.glib."${deps."pango"."0.8.0"."glib"}" deps)
    (features_.glib_sys."${deps."pango"."0.8.0"."glib_sys"}" deps)
    (features_.gobject_sys."${deps."pango"."0.8.0"."gobject_sys"}" deps)
    (features_.lazy_static."${deps."pango"."0.8.0"."lazy_static"}" deps)
    (features_.libc."${deps."pango"."0.8.0"."libc"}" deps)
    (features_.pango_sys."${deps."pango"."0.8.0"."pango_sys"}" deps)
  ];


# end
# pango-sys-0.9.1

  crates.pango_sys."0.9.1" = deps: { features?(features_.pango_sys."0.9.1" deps {}) }: buildRustCrate {
    crateName = "pango-sys";
    version = "0.9.1";
    description = "FFI bindings to libpango-1.0";
    authors = [ "The Gtk-rs Project Developers" ];
    sha256 = "1p74zah368ydfarq15q4yks1068iswv9y55grjln5mfqqppf23ak";
    libName = "pango_sys";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."glib_sys"."${deps."pango_sys"."0.9.1"."glib_sys"}" deps)
      (crates."gobject_sys"."${deps."pango_sys"."0.9.1"."gobject_sys"}" deps)
      (crates."libc"."${deps."pango_sys"."0.9.1"."libc"}" deps)
    ]);

    buildDependencies = mapFeatures features ([
      (crates."pkg_config"."${deps."pango_sys"."0.9.1"."pkg_config"}" deps)
    ]);
    features = mkFeatures (features."pango_sys"."0.9.1" or {});
  };
  features_.pango_sys."0.9.1" = deps: f: updateFeatures f (rec {
    glib_sys."${deps.pango_sys."0.9.1".glib_sys}".default = true;
    gobject_sys."${deps.pango_sys."0.9.1".gobject_sys}".default = true;
    libc."${deps.pango_sys."0.9.1".libc}".default = true;
    pango_sys = fold recursiveUpdate {} [
      { "0.9.1"."v1_36_7" =
        (f.pango_sys."0.9.1"."v1_36_7" or false) ||
        (f.pango_sys."0.9.1".v1_38 or false) ||
        (pango_sys."0.9.1"."v1_38" or false); }
      { "0.9.1"."v1_38" =
        (f.pango_sys."0.9.1"."v1_38" or false) ||
        (f.pango_sys."0.9.1".v1_42 or false) ||
        (pango_sys."0.9.1"."v1_42" or false); }
      { "0.9.1".default = (f.pango_sys."0.9.1".default or true); }
    ];
    pkg_config."${deps.pango_sys."0.9.1".pkg_config}".default = true;
  }) [
    (features_.glib_sys."${deps."pango_sys"."0.9.1"."glib_sys"}" deps)
    (features_.gobject_sys."${deps."pango_sys"."0.9.1"."gobject_sys"}" deps)
    (features_.libc."${deps."pango_sys"."0.9.1"."libc"}" deps)
    (features_.pkg_config."${deps."pango_sys"."0.9.1"."pkg_config"}" deps)
  ];


# end
# parse-zoneinfo-0.1.1

  crates.parse_zoneinfo."0.1.1" = deps: { features?(features_.parse_zoneinfo."0.1.1" deps {}) }: buildRustCrate {
    crateName = "parse-zoneinfo";
    version = "0.1.1";
    description = "Parse zoneinfo files from the IANA database";
    authors = [ "Djzin <djzin@users.noreply.github.com>" ];
    sha256 = "1dgbkwac4m3xl816ld5snzn26f2pl20psdfm9522b69ks9bi8qnr";
    dependencies = mapFeatures features ([
      (crates."regex"."${deps."parse_zoneinfo"."0.1.1"."regex"}" deps)
    ]);
  };
  features_.parse_zoneinfo."0.1.1" = deps: f: updateFeatures f (rec {
    parse_zoneinfo."0.1.1".default = (f.parse_zoneinfo."0.1.1".default or true);
    regex."${deps.parse_zoneinfo."0.1.1".regex}".default = true;
  }) [
    (features_.regex."${deps."parse_zoneinfo"."0.1.1"."regex"}" deps)
  ];


# end
# pin-utils-0.1.0-alpha.4

  crates.pin_utils."0.1.0-alpha.4" = deps: { features?(features_.pin_utils."0.1.0-alpha.4" deps {}) }: buildRustCrate {
    crateName = "pin-utils";
    version = "0.1.0-alpha.4";
    description = "Utilities for pinning\n";
    authors = [ "Josef Brandl <mail@josefbrandl.de>" ];
    edition = "2018";
    sha256 = "1fl7h1f6gr7qj903k3ir2vw993gbj4dd775s0idq4pzsbjqjj3x1";
  };
  features_.pin_utils."0.1.0-alpha.4" = deps: f: updateFeatures f (rec {
    pin_utils."0.1.0-alpha.4".default = (f.pin_utils."0.1.0-alpha.4".default or true);
  }) [];


# end
# pkg-config-0.3.17

  crates.pkg_config."0.3.17" = deps: { features?(features_.pkg_config."0.3.17" deps {}) }: buildRustCrate {
    crateName = "pkg-config";
    version = "0.3.17";
    description = "A library to run the pkg-config system tool at build time in order to be used in\nCargo build scripts.\n";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "0f83cnls5a6y97k8b3a54xhmyrjybj29qq6rwvz450qdsy5ff8vj";
  };
  features_.pkg_config."0.3.17" = deps: f: updateFeatures f (rec {
    pkg_config."0.3.17".default = (f.pkg_config."0.3.17".default or true);
  }) [];


# end
# proc-macro-hack-0.5.11

  crates.proc_macro_hack."0.5.11" = deps: { features?(features_.proc_macro_hack."0.5.11" deps {}) }: buildRustCrate {
    crateName = "proc-macro-hack";
    version = "0.5.11";
    description = "Procedural macros in expression position";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    edition = "2018";
    sha256 = "0cnpfl5x7cac9d94in5r93b29frski33jhvgp7n6qih9gpsxqn80";
    procMacro = true;
    dependencies = mapFeatures features ([
      (crates."proc_macro2"."${deps."proc_macro_hack"."0.5.11"."proc_macro2"}" deps)
      (crates."quote"."${deps."proc_macro_hack"."0.5.11"."quote"}" deps)
      (crates."syn"."${deps."proc_macro_hack"."0.5.11"."syn"}" deps)
    ]);
  };
  features_.proc_macro_hack."0.5.11" = deps: f: updateFeatures f (rec {
    proc_macro2."${deps.proc_macro_hack."0.5.11".proc_macro2}".default = true;
    proc_macro_hack."0.5.11".default = (f.proc_macro_hack."0.5.11".default or true);
    quote."${deps.proc_macro_hack."0.5.11".quote}".default = true;
    syn."${deps.proc_macro_hack."0.5.11".syn}".default = true;
  }) [
    (features_.proc_macro2."${deps."proc_macro_hack"."0.5.11"."proc_macro2"}" deps)
    (features_.quote."${deps."proc_macro_hack"."0.5.11"."quote"}" deps)
    (features_.syn."${deps."proc_macro_hack"."0.5.11"."syn"}" deps)
  ];


# end
# proc-macro-nested-0.1.3

  crates.proc_macro_nested."0.1.3" = deps: { features?(features_.proc_macro_nested."0.1.3" deps {}) }: buildRustCrate {
    crateName = "proc-macro-nested";
    version = "0.1.3";
    description = "Support for nested proc-macro-hack invocations";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "1xbai316ygv2gxc9vjb8b2nr6xia3ahc19nh66vkwnvz1nc90gya";
  };
  features_.proc_macro_nested."0.1.3" = deps: f: updateFeatures f (rec {
    proc_macro_nested."0.1.3".default = (f.proc_macro_nested."0.1.3".default or true);
  }) [];


# end
# proc-macro2-1.0.6

  crates.proc_macro2."1.0.6" = deps: { features?(features_.proc_macro2."1.0.6" deps {}) }: buildRustCrate {
    crateName = "proc-macro2";
    version = "1.0.6";
    description = "A stable implementation of the upcoming new `proc_macro` API. Comes with an\noption, off by default, to also reimplement itself in terms of the upstream\nunstable API.\n";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    edition = "2018";
    sha256 = "1l56ss9ip8cg6764cpi9y8dv7nsyqf2i4hb7sn29zx61n03jr81z";
    dependencies = mapFeatures features ([
      (crates."unicode_xid"."${deps."proc_macro2"."1.0.6"."unicode_xid"}" deps)
    ]);
    features = mkFeatures (features."proc_macro2"."1.0.6" or {});
  };
  features_.proc_macro2."1.0.6" = deps: f: updateFeatures f (rec {
    proc_macro2 = fold recursiveUpdate {} [
      { "1.0.6"."proc-macro" =
        (f.proc_macro2."1.0.6"."proc-macro" or false) ||
        (f.proc_macro2."1.0.6".default or false) ||
        (proc_macro2."1.0.6"."default" or false); }
      { "1.0.6".default = (f.proc_macro2."1.0.6".default or true); }
    ];
    unicode_xid."${deps.proc_macro2."1.0.6".unicode_xid}".default = true;
  }) [
    (features_.unicode_xid."${deps."proc_macro2"."1.0.6"."unicode_xid"}" deps)
  ];


# end
# quote-1.0.2

  crates.quote."1.0.2" = deps: { features?(features_.quote."1.0.2" deps {}) }: buildRustCrate {
    crateName = "quote";
    version = "1.0.2";
    description = "Quasi-quoting macro quote!(...)";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    edition = "2018";
    sha256 = "0r7030w7dymarn92gjgm02hsm04fwsfs6f1l20wdqiyrm9z8rs5q";
    dependencies = mapFeatures features ([
      (crates."proc_macro2"."${deps."quote"."1.0.2"."proc_macro2"}" deps)
    ]);
    features = mkFeatures (features."quote"."1.0.2" or {});
  };
  features_.quote."1.0.2" = deps: f: updateFeatures f (rec {
    proc_macro2 = fold recursiveUpdate {} [
      { "${deps.quote."1.0.2".proc_macro2}"."proc-macro" =
        (f.proc_macro2."${deps.quote."1.0.2".proc_macro2}"."proc-macro" or false) ||
        (quote."1.0.2"."proc-macro" or false) ||
        (f."quote"."1.0.2"."proc-macro" or false); }
      { "${deps.quote."1.0.2".proc_macro2}".default = (f.proc_macro2."${deps.quote."1.0.2".proc_macro2}".default or false); }
    ];
    quote = fold recursiveUpdate {} [
      { "1.0.2"."proc-macro" =
        (f.quote."1.0.2"."proc-macro" or false) ||
        (f.quote."1.0.2".default or false) ||
        (quote."1.0.2"."default" or false); }
      { "1.0.2".default = (f.quote."1.0.2".default or true); }
    ];
  }) [
    (features_.proc_macro2."${deps."quote"."1.0.2"."proc_macro2"}" deps)
  ];


# end
# rand-0.4.6

  crates.rand."0.4.6" = deps: { features?(features_.rand."0.4.6" deps {}) }: buildRustCrate {
    crateName = "rand";
    version = "0.4.6";
    description = "Random number generators and other randomness functionality.\n";
    authors = [ "The Rust Project Developers" ];
    sha256 = "0c3rmg5q7d6qdi7cbmg5py9alm70wd3xsg0mmcawrnl35qv37zfs";
    dependencies = (if abi == "sgx" then mapFeatures features ([
      (crates."rand_core"."${deps."rand"."0.4.6"."rand_core"}" deps)
      (crates."rdrand"."${deps."rand"."0.4.6"."rdrand"}" deps)
    ]) else [])
      ++ (if kernel == "fuchsia" then mapFeatures features ([
      (crates."fuchsia_cprng"."${deps."rand"."0.4.6"."fuchsia_cprng"}" deps)
    ]) else [])
      ++ (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([
    ]
      ++ (if features.rand."0.4.6".libc or false then [ (crates.libc."${deps."rand"."0.4.6".libc}" deps) ] else [])) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."winapi"."${deps."rand"."0.4.6"."winapi"}" deps)
    ]) else []);
    features = mkFeatures (features."rand"."0.4.6" or {});
  };
  features_.rand."0.4.6" = deps: f: updateFeatures f (rec {
    fuchsia_cprng."${deps.rand."0.4.6".fuchsia_cprng}".default = true;
    libc."${deps.rand."0.4.6".libc}".default = true;
    rand = fold recursiveUpdate {} [
      { "0.4.6"."i128_support" =
        (f.rand."0.4.6"."i128_support" or false) ||
        (f.rand."0.4.6".nightly or false) ||
        (rand."0.4.6"."nightly" or false); }
      { "0.4.6"."libc" =
        (f.rand."0.4.6"."libc" or false) ||
        (f.rand."0.4.6".std or false) ||
        (rand."0.4.6"."std" or false); }
      { "0.4.6"."std" =
        (f.rand."0.4.6"."std" or false) ||
        (f.rand."0.4.6".default or false) ||
        (rand."0.4.6"."default" or false); }
      { "0.4.6".default = (f.rand."0.4.6".default or true); }
    ];
    rand_core."${deps.rand."0.4.6".rand_core}".default = (f.rand_core."${deps.rand."0.4.6".rand_core}".default or false);
    rdrand."${deps.rand."0.4.6".rdrand}".default = true;
    winapi = fold recursiveUpdate {} [
      { "${deps.rand."0.4.6".winapi}"."minwindef" = true; }
      { "${deps.rand."0.4.6".winapi}"."ntsecapi" = true; }
      { "${deps.rand."0.4.6".winapi}"."profileapi" = true; }
      { "${deps.rand."0.4.6".winapi}"."winnt" = true; }
      { "${deps.rand."0.4.6".winapi}".default = true; }
    ];
  }) [
    (features_.rand_core."${deps."rand"."0.4.6"."rand_core"}" deps)
    (features_.rdrand."${deps."rand"."0.4.6"."rdrand"}" deps)
    (features_.fuchsia_cprng."${deps."rand"."0.4.6"."fuchsia_cprng"}" deps)
    (features_.libc."${deps."rand"."0.4.6"."libc"}" deps)
    (features_.winapi."${deps."rand"."0.4.6"."winapi"}" deps)
  ];


# end
# rand_core-0.3.1

  crates.rand_core."0.3.1" = deps: { features?(features_.rand_core."0.3.1" deps {}) }: buildRustCrate {
    crateName = "rand_core";
    version = "0.3.1";
    description = "Core random number generator traits and tools for implementation.\n";
    authors = [ "The Rand Project Developers" "The Rust Project Developers" ];
    sha256 = "0q0ssgpj9x5a6fda83nhmfydy7a6c0wvxm0jhncsmjx8qp8gw91m";
    dependencies = mapFeatures features ([
      (crates."rand_core"."${deps."rand_core"."0.3.1"."rand_core"}" deps)
    ]);
    features = mkFeatures (features."rand_core"."0.3.1" or {});
  };
  features_.rand_core."0.3.1" = deps: f: updateFeatures f (rec {
    rand_core = fold recursiveUpdate {} [
      { "${deps.rand_core."0.3.1".rand_core}"."alloc" =
        (f.rand_core."${deps.rand_core."0.3.1".rand_core}"."alloc" or false) ||
        (rand_core."0.3.1"."alloc" or false) ||
        (f."rand_core"."0.3.1"."alloc" or false); }
      { "${deps.rand_core."0.3.1".rand_core}"."serde1" =
        (f.rand_core."${deps.rand_core."0.3.1".rand_core}"."serde1" or false) ||
        (rand_core."0.3.1"."serde1" or false) ||
        (f."rand_core"."0.3.1"."serde1" or false); }
      { "${deps.rand_core."0.3.1".rand_core}"."std" =
        (f.rand_core."${deps.rand_core."0.3.1".rand_core}"."std" or false) ||
        (rand_core."0.3.1"."std" or false) ||
        (f."rand_core"."0.3.1"."std" or false); }
      { "${deps.rand_core."0.3.1".rand_core}".default = true; }
      { "0.3.1"."std" =
        (f.rand_core."0.3.1"."std" or false) ||
        (f.rand_core."0.3.1".default or false) ||
        (rand_core."0.3.1"."default" or false); }
      { "0.3.1".default = (f.rand_core."0.3.1".default or true); }
    ];
  }) [
    (features_.rand_core."${deps."rand_core"."0.3.1"."rand_core"}" deps)
  ];


# end
# rand_core-0.4.2

  crates.rand_core."0.4.2" = deps: { features?(features_.rand_core."0.4.2" deps {}) }: buildRustCrate {
    crateName = "rand_core";
    version = "0.4.2";
    description = "Core random number generator traits and tools for implementation.\n";
    authors = [ "The Rand Project Developers" "The Rust Project Developers" ];
    sha256 = "18zpzwn4bl7lp9f36iacy8mvdnfrhfmzsl35gmln98dcindff2ly";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."rand_core"."0.4.2" or {});
  };
  features_.rand_core."0.4.2" = deps: f: updateFeatures f (rec {
    rand_core = fold recursiveUpdate {} [
      { "0.4.2"."alloc" =
        (f.rand_core."0.4.2"."alloc" or false) ||
        (f.rand_core."0.4.2".std or false) ||
        (rand_core."0.4.2"."std" or false); }
      { "0.4.2"."serde" =
        (f.rand_core."0.4.2"."serde" or false) ||
        (f.rand_core."0.4.2".serde1 or false) ||
        (rand_core."0.4.2"."serde1" or false); }
      { "0.4.2"."serde_derive" =
        (f.rand_core."0.4.2"."serde_derive" or false) ||
        (f.rand_core."0.4.2".serde1 or false) ||
        (rand_core."0.4.2"."serde1" or false); }
      { "0.4.2".default = (f.rand_core."0.4.2".default or true); }
    ];
  }) [];


# end
# rdrand-0.4.0

  crates.rdrand."0.4.0" = deps: { features?(features_.rdrand."0.4.0" deps {}) }: buildRustCrate {
    crateName = "rdrand";
    version = "0.4.0";
    description = "An implementation of random number generator based on rdrand and rdseed instructions";
    authors = [ "Simonas Kazlauskas <rdrand@kazlauskas.me>" ];
    sha256 = "15hrcasn0v876wpkwab1dwbk9kvqwrb3iv4y4dibb6yxnfvzwajk";
    dependencies = mapFeatures features ([
      (crates."rand_core"."${deps."rdrand"."0.4.0"."rand_core"}" deps)
    ]);
    features = mkFeatures (features."rdrand"."0.4.0" or {});
  };
  features_.rdrand."0.4.0" = deps: f: updateFeatures f (rec {
    rand_core."${deps.rdrand."0.4.0".rand_core}".default = (f.rand_core."${deps.rdrand."0.4.0".rand_core}".default or false);
    rdrand = fold recursiveUpdate {} [
      { "0.4.0"."std" =
        (f.rdrand."0.4.0"."std" or false) ||
        (f.rdrand."0.4.0".default or false) ||
        (rdrand."0.4.0"."default" or false); }
      { "0.4.0".default = (f.rdrand."0.4.0".default or true); }
    ];
  }) [
    (features_.rand_core."${deps."rdrand"."0.4.0"."rand_core"}" deps)
  ];


# end
# redox_syscall-0.1.56

  crates.redox_syscall."0.1.56" = deps: { features?(features_.redox_syscall."0.1.56" deps {}) }: buildRustCrate {
    crateName = "redox_syscall";
    version = "0.1.56";
    description = "A Rust library to access raw Redox system calls";
    authors = [ "Jeremy Soller <jackpot51@gmail.com>" ];
    sha256 = "0jcp8nd947zcy938bz09pzlmi3vyxfdzg92pjxdvvk0699vwcc26";
    libName = "syscall";
  };
  features_.redox_syscall."0.1.56" = deps: f: updateFeatures f (rec {
    redox_syscall."0.1.56".default = (f.redox_syscall."0.1.56".default or true);
  }) [];


# end
# regex-0.1.80

  crates.regex."0.1.80" = deps: { features?(features_.regex."0.1.80" deps {}) }: buildRustCrate {
    crateName = "regex";
    version = "0.1.80";
    description = "An implementation of regular expressions for Rust. This implementation uses\nfinite automata and guarantees linear time matching on all inputs.\n";
    authors = [ "The Rust Project Developers" ];
    sha256 = "0y4s8ghhx6sgzb35irwivm3w0l2hhqhmdcd2px9hirqnkagal9l6";
    dependencies = mapFeatures features ([
      (crates."aho_corasick"."${deps."regex"."0.1.80"."aho_corasick"}" deps)
      (crates."memchr"."${deps."regex"."0.1.80"."memchr"}" deps)
      (crates."regex_syntax"."${deps."regex"."0.1.80"."regex_syntax"}" deps)
      (crates."thread_local"."${deps."regex"."0.1.80"."thread_local"}" deps)
      (crates."utf8_ranges"."${deps."regex"."0.1.80"."utf8_ranges"}" deps)
    ]);
    features = mkFeatures (features."regex"."0.1.80" or {});
  };
  features_.regex."0.1.80" = deps: f: updateFeatures f (rec {
    aho_corasick."${deps.regex."0.1.80".aho_corasick}".default = true;
    memchr."${deps.regex."0.1.80".memchr}".default = true;
    regex = fold recursiveUpdate {} [
      { "0.1.80"."simd" =
        (f.regex."0.1.80"."simd" or false) ||
        (f.regex."0.1.80".simd-accel or false) ||
        (regex."0.1.80"."simd-accel" or false); }
      { "0.1.80".default = (f.regex."0.1.80".default or true); }
    ];
    regex_syntax."${deps.regex."0.1.80".regex_syntax}".default = true;
    thread_local."${deps.regex."0.1.80".thread_local}".default = true;
    utf8_ranges."${deps.regex."0.1.80".utf8_ranges}".default = true;
  }) [
    (features_.aho_corasick."${deps."regex"."0.1.80"."aho_corasick"}" deps)
    (features_.memchr."${deps."regex"."0.1.80"."memchr"}" deps)
    (features_.regex_syntax."${deps."regex"."0.1.80"."regex_syntax"}" deps)
    (features_.thread_local."${deps."regex"."0.1.80"."thread_local"}" deps)
    (features_.utf8_ranges."${deps."regex"."0.1.80"."utf8_ranges"}" deps)
  ];


# end
# regex-0.2.11

  crates.regex."0.2.11" = deps: { features?(features_.regex."0.2.11" deps {}) }: buildRustCrate {
    crateName = "regex";
    version = "0.2.11";
    description = "An implementation of regular expressions for Rust. This implementation uses\nfinite automata and guarantees linear time matching on all inputs.\n";
    authors = [ "The Rust Project Developers" ];
    sha256 = "0r50cymxdqp0fv1dxd22mjr6y32q450nwacd279p9s7lh0cafijj";
    dependencies = mapFeatures features ([
      (crates."aho_corasick"."${deps."regex"."0.2.11"."aho_corasick"}" deps)
      (crates."memchr"."${deps."regex"."0.2.11"."memchr"}" deps)
      (crates."regex_syntax"."${deps."regex"."0.2.11"."regex_syntax"}" deps)
      (crates."thread_local"."${deps."regex"."0.2.11"."thread_local"}" deps)
      (crates."utf8_ranges"."${deps."regex"."0.2.11"."utf8_ranges"}" deps)
    ]);
    features = mkFeatures (features."regex"."0.2.11" or {});
  };
  features_.regex."0.2.11" = deps: f: updateFeatures f (rec {
    aho_corasick."${deps.regex."0.2.11".aho_corasick}".default = true;
    memchr."${deps.regex."0.2.11".memchr}".default = true;
    regex = fold recursiveUpdate {} [
      { "0.2.11"."pattern" =
        (f.regex."0.2.11"."pattern" or false) ||
        (f.regex."0.2.11".unstable or false) ||
        (regex."0.2.11"."unstable" or false); }
      { "0.2.11".default = (f.regex."0.2.11".default or true); }
    ];
    regex_syntax."${deps.regex."0.2.11".regex_syntax}".default = true;
    thread_local."${deps.regex."0.2.11".thread_local}".default = true;
    utf8_ranges."${deps.regex."0.2.11".utf8_ranges}".default = true;
  }) [
    (features_.aho_corasick."${deps."regex"."0.2.11"."aho_corasick"}" deps)
    (features_.memchr."${deps."regex"."0.2.11"."memchr"}" deps)
    (features_.regex_syntax."${deps."regex"."0.2.11"."regex_syntax"}" deps)
    (features_.thread_local."${deps."regex"."0.2.11"."thread_local"}" deps)
    (features_.utf8_ranges."${deps."regex"."0.2.11"."utf8_ranges"}" deps)
  ];


# end
# regex-1.3.1

  crates.regex."1.3.1" = deps: { features?(features_.regex."1.3.1" deps {}) }: buildRustCrate {
    crateName = "regex";
    version = "1.3.1";
    description = "An implementation of regular expressions for Rust. This implementation uses\nfinite automata and guarantees linear time matching on all inputs.\n";
    authors = [ "The Rust Project Developers" ];
    sha256 = "0508b01q7iwky5gzp1cc3lpz6al1qam8skgcvkfgxr67nikiz7jn";
    dependencies = mapFeatures features ([
      (crates."regex_syntax"."${deps."regex"."1.3.1"."regex_syntax"}" deps)
    ]
      ++ (if features.regex."1.3.1".aho-corasick or false then [ (crates.aho_corasick."${deps."regex"."1.3.1".aho_corasick}" deps) ] else [])
      ++ (if features.regex."1.3.1".memchr or false then [ (crates.memchr."${deps."regex"."1.3.1".memchr}" deps) ] else [])
      ++ (if features.regex."1.3.1".thread_local or false then [ (crates.thread_local."${deps."regex"."1.3.1".thread_local}" deps) ] else []));
    features = mkFeatures (features."regex"."1.3.1" or {});
  };
  features_.regex."1.3.1" = deps: f: updateFeatures f (rec {
    aho_corasick."${deps.regex."1.3.1".aho_corasick}".default = true;
    memchr."${deps.regex."1.3.1".memchr}".default = true;
    regex = fold recursiveUpdate {} [
      { "1.3.1"."aho-corasick" =
        (f.regex."1.3.1"."aho-corasick" or false) ||
        (f.regex."1.3.1".perf-literal or false) ||
        (regex."1.3.1"."perf-literal" or false); }
      { "1.3.1"."memchr" =
        (f.regex."1.3.1"."memchr" or false) ||
        (f.regex."1.3.1".perf-literal or false) ||
        (regex."1.3.1"."perf-literal" or false); }
      { "1.3.1"."pattern" =
        (f.regex."1.3.1"."pattern" or false) ||
        (f.regex."1.3.1".unstable or false) ||
        (regex."1.3.1"."unstable" or false); }
      { "1.3.1"."perf" =
        (f.regex."1.3.1"."perf" or false) ||
        (f.regex."1.3.1".default or false) ||
        (regex."1.3.1"."default" or false); }
      { "1.3.1"."perf-cache" =
        (f.regex."1.3.1"."perf-cache" or false) ||
        (f.regex."1.3.1".perf or false) ||
        (regex."1.3.1"."perf" or false); }
      { "1.3.1"."perf-dfa" =
        (f.regex."1.3.1"."perf-dfa" or false) ||
        (f.regex."1.3.1".perf or false) ||
        (regex."1.3.1"."perf" or false); }
      { "1.3.1"."perf-inline" =
        (f.regex."1.3.1"."perf-inline" or false) ||
        (f.regex."1.3.1".perf or false) ||
        (regex."1.3.1"."perf" or false); }
      { "1.3.1"."perf-literal" =
        (f.regex."1.3.1"."perf-literal" or false) ||
        (f.regex."1.3.1".perf or false) ||
        (regex."1.3.1"."perf" or false); }
      { "1.3.1"."std" =
        (f.regex."1.3.1"."std" or false) ||
        (f.regex."1.3.1".default or false) ||
        (regex."1.3.1"."default" or false) ||
        (f.regex."1.3.1".use_std or false) ||
        (regex."1.3.1"."use_std" or false); }
      { "1.3.1"."thread_local" =
        (f.regex."1.3.1"."thread_local" or false) ||
        (f.regex."1.3.1".perf-cache or false) ||
        (regex."1.3.1"."perf-cache" or false); }
      { "1.3.1"."unicode" =
        (f.regex."1.3.1"."unicode" or false) ||
        (f.regex."1.3.1".default or false) ||
        (regex."1.3.1"."default" or false); }
      { "1.3.1"."unicode-age" =
        (f.regex."1.3.1"."unicode-age" or false) ||
        (f.regex."1.3.1".unicode or false) ||
        (regex."1.3.1"."unicode" or false); }
      { "1.3.1"."unicode-bool" =
        (f.regex."1.3.1"."unicode-bool" or false) ||
        (f.regex."1.3.1".unicode or false) ||
        (regex."1.3.1"."unicode" or false); }
      { "1.3.1"."unicode-case" =
        (f.regex."1.3.1"."unicode-case" or false) ||
        (f.regex."1.3.1".unicode or false) ||
        (regex."1.3.1"."unicode" or false); }
      { "1.3.1"."unicode-gencat" =
        (f.regex."1.3.1"."unicode-gencat" or false) ||
        (f.regex."1.3.1".unicode or false) ||
        (regex."1.3.1"."unicode" or false); }
      { "1.3.1"."unicode-perl" =
        (f.regex."1.3.1"."unicode-perl" or false) ||
        (f.regex."1.3.1".unicode or false) ||
        (regex."1.3.1"."unicode" or false); }
      { "1.3.1"."unicode-script" =
        (f.regex."1.3.1"."unicode-script" or false) ||
        (f.regex."1.3.1".unicode or false) ||
        (regex."1.3.1"."unicode" or false); }
      { "1.3.1"."unicode-segment" =
        (f.regex."1.3.1"."unicode-segment" or false) ||
        (f.regex."1.3.1".unicode or false) ||
        (regex."1.3.1"."unicode" or false); }
      { "1.3.1".default = (f.regex."1.3.1".default or true); }
    ];
    regex_syntax = fold recursiveUpdate {} [
      { "${deps.regex."1.3.1".regex_syntax}"."unicode-age" =
        (f.regex_syntax."${deps.regex."1.3.1".regex_syntax}"."unicode-age" or false) ||
        (regex."1.3.1"."unicode-age" or false) ||
        (f."regex"."1.3.1"."unicode-age" or false); }
      { "${deps.regex."1.3.1".regex_syntax}"."unicode-bool" =
        (f.regex_syntax."${deps.regex."1.3.1".regex_syntax}"."unicode-bool" or false) ||
        (regex."1.3.1"."unicode-bool" or false) ||
        (f."regex"."1.3.1"."unicode-bool" or false); }
      { "${deps.regex."1.3.1".regex_syntax}"."unicode-case" =
        (f.regex_syntax."${deps.regex."1.3.1".regex_syntax}"."unicode-case" or false) ||
        (regex."1.3.1"."unicode-case" or false) ||
        (f."regex"."1.3.1"."unicode-case" or false); }
      { "${deps.regex."1.3.1".regex_syntax}"."unicode-gencat" =
        (f.regex_syntax."${deps.regex."1.3.1".regex_syntax}"."unicode-gencat" or false) ||
        (regex."1.3.1"."unicode-gencat" or false) ||
        (f."regex"."1.3.1"."unicode-gencat" or false); }
      { "${deps.regex."1.3.1".regex_syntax}"."unicode-perl" =
        (f.regex_syntax."${deps.regex."1.3.1".regex_syntax}"."unicode-perl" or false) ||
        (regex."1.3.1"."unicode-perl" or false) ||
        (f."regex"."1.3.1"."unicode-perl" or false); }
      { "${deps.regex."1.3.1".regex_syntax}"."unicode-script" =
        (f.regex_syntax."${deps.regex."1.3.1".regex_syntax}"."unicode-script" or false) ||
        (regex."1.3.1"."unicode-script" or false) ||
        (f."regex"."1.3.1"."unicode-script" or false); }
      { "${deps.regex."1.3.1".regex_syntax}"."unicode-segment" =
        (f.regex_syntax."${deps.regex."1.3.1".regex_syntax}"."unicode-segment" or false) ||
        (regex."1.3.1"."unicode-segment" or false) ||
        (f."regex"."1.3.1"."unicode-segment" or false); }
      { "${deps.regex."1.3.1".regex_syntax}".default = (f.regex_syntax."${deps.regex."1.3.1".regex_syntax}".default or false); }
    ];
    thread_local."${deps.regex."1.3.1".thread_local}".default = true;
  }) [
    (features_.aho_corasick."${deps."regex"."1.3.1"."aho_corasick"}" deps)
    (features_.memchr."${deps."regex"."1.3.1"."memchr"}" deps)
    (features_.regex_syntax."${deps."regex"."1.3.1"."regex_syntax"}" deps)
    (features_.thread_local."${deps."regex"."1.3.1"."thread_local"}" deps)
  ];


# end
# regex-syntax-0.3.9

  crates.regex_syntax."0.3.9" = deps: { features?(features_.regex_syntax."0.3.9" deps {}) }: buildRustCrate {
    crateName = "regex-syntax";
    version = "0.3.9";
    description = "A regular expression parser.";
    authors = [ "The Rust Project Developers" ];
    sha256 = "1mzhphkbwppwd1zam2jkgjk550cqgf6506i87bw2yzrvcsraiw7m";
  };
  features_.regex_syntax."0.3.9" = deps: f: updateFeatures f (rec {
    regex_syntax."0.3.9".default = (f.regex_syntax."0.3.9".default or true);
  }) [];


# end
# regex-syntax-0.5.6

  crates.regex_syntax."0.5.6" = deps: { features?(features_.regex_syntax."0.5.6" deps {}) }: buildRustCrate {
    crateName = "regex-syntax";
    version = "0.5.6";
    description = "A regular expression parser.";
    authors = [ "The Rust Project Developers" ];
    sha256 = "10vf3r34bgjnbrnqd5aszn35bjvm8insw498l1vjy8zx5yms3427";
    dependencies = mapFeatures features ([
      (crates."ucd_util"."${deps."regex_syntax"."0.5.6"."ucd_util"}" deps)
    ]);
  };
  features_.regex_syntax."0.5.6" = deps: f: updateFeatures f (rec {
    regex_syntax."0.5.6".default = (f.regex_syntax."0.5.6".default or true);
    ucd_util."${deps.regex_syntax."0.5.6".ucd_util}".default = true;
  }) [
    (features_.ucd_util."${deps."regex_syntax"."0.5.6"."ucd_util"}" deps)
  ];


# end
# regex-syntax-0.6.12

  crates.regex_syntax."0.6.12" = deps: { features?(features_.regex_syntax."0.6.12" deps {}) }: buildRustCrate {
    crateName = "regex-syntax";
    version = "0.6.12";
    description = "A regular expression parser.";
    authors = [ "The Rust Project Developers" ];
    sha256 = "1lqhddhwzpgq8zfkxhm241n7g4m3yc11fb4098dkgawbxvybr53v";
    features = mkFeatures (features."regex_syntax"."0.6.12" or {});
  };
  features_.regex_syntax."0.6.12" = deps: f: updateFeatures f (rec {
    regex_syntax = fold recursiveUpdate {} [
      { "0.6.12"."unicode" =
        (f.regex_syntax."0.6.12"."unicode" or false) ||
        (f.regex_syntax."0.6.12".default or false) ||
        (regex_syntax."0.6.12"."default" or false); }
      { "0.6.12"."unicode-age" =
        (f.regex_syntax."0.6.12"."unicode-age" or false) ||
        (f.regex_syntax."0.6.12".unicode or false) ||
        (regex_syntax."0.6.12"."unicode" or false); }
      { "0.6.12"."unicode-bool" =
        (f.regex_syntax."0.6.12"."unicode-bool" or false) ||
        (f.regex_syntax."0.6.12".unicode or false) ||
        (regex_syntax."0.6.12"."unicode" or false); }
      { "0.6.12"."unicode-case" =
        (f.regex_syntax."0.6.12"."unicode-case" or false) ||
        (f.regex_syntax."0.6.12".unicode or false) ||
        (regex_syntax."0.6.12"."unicode" or false); }
      { "0.6.12"."unicode-gencat" =
        (f.regex_syntax."0.6.12"."unicode-gencat" or false) ||
        (f.regex_syntax."0.6.12".unicode or false) ||
        (regex_syntax."0.6.12"."unicode" or false); }
      { "0.6.12"."unicode-perl" =
        (f.regex_syntax."0.6.12"."unicode-perl" or false) ||
        (f.regex_syntax."0.6.12".unicode or false) ||
        (regex_syntax."0.6.12"."unicode" or false); }
      { "0.6.12"."unicode-script" =
        (f.regex_syntax."0.6.12"."unicode-script" or false) ||
        (f.regex_syntax."0.6.12".unicode or false) ||
        (regex_syntax."0.6.12"."unicode" or false); }
      { "0.6.12"."unicode-segment" =
        (f.regex_syntax."0.6.12"."unicode-segment" or false) ||
        (f.regex_syntax."0.6.12".unicode or false) ||
        (regex_syntax."0.6.12"."unicode" or false); }
      { "0.6.12".default = (f.regex_syntax."0.6.12".default or true); }
    ];
  }) [];


# end
# ryu-1.0.2

  crates.ryu."1.0.2" = deps: { features?(features_.ryu."1.0.2" deps {}) }: buildRustCrate {
    crateName = "ryu";
    version = "1.0.2";
    description = "Fast floating point to string conversion";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "04pxfhps9ix078qyml7hifjdmy4bg1n047ki0wx6i1007z85wjp1";
    build = "build.rs";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."ryu"."1.0.2" or {});
  };
  features_.ryu."1.0.2" = deps: f: updateFeatures f (rec {
    ryu."1.0.2".default = (f.ryu."1.0.2".default or true);
  }) [];


# end
# serde-1.0.104

  crates.serde."1.0.104" = deps: { features?(features_.serde."1.0.104" deps {}) }: buildRustCrate {
    crateName = "serde";
    version = "1.0.104";
    description = "A generic serialization/deserialization framework";
    authors = [ "Erick Tryzelaar <erick.tryzelaar@gmail.com>" "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "0dsn86dafbfm5hhngzay7s4pmb4hskpjjyw2f9l7wm9s28gs5ckf";
    build = "build.rs";
    dependencies = mapFeatures features ([
    ]
      ++ (if features.serde."1.0.104".serde_derive or false then [ (crates.serde_derive."${deps."serde"."1.0.104".serde_derive}" deps) ] else []));
    features = mkFeatures (features."serde"."1.0.104" or {});
  };
  features_.serde."1.0.104" = deps: f: updateFeatures f (rec {
    serde = fold recursiveUpdate {} [
      { "1.0.104"."serde_derive" =
        (f.serde."1.0.104"."serde_derive" or false) ||
        (f.serde."1.0.104".derive or false) ||
        (serde."1.0.104"."derive" or false); }
      { "1.0.104"."std" =
        (f.serde."1.0.104"."std" or false) ||
        (f.serde."1.0.104".default or false) ||
        (serde."1.0.104"."default" or false); }
      { "1.0.104".default = (f.serde."1.0.104".default or true); }
    ];
    serde_derive."${deps.serde."1.0.104".serde_derive}".default = true;
  }) [
    (features_.serde_derive."${deps."serde"."1.0.104"."serde_derive"}" deps)
  ];


# end
# serde_derive-1.0.104

  crates.serde_derive."1.0.104" = deps: { features?(features_.serde_derive."1.0.104" deps {}) }: buildRustCrate {
    crateName = "serde_derive";
    version = "1.0.104";
    description = "Macros 1.1 implementation of #[derive(Serialize, Deserialize)]";
    authors = [ "Erick Tryzelaar <erick.tryzelaar@gmail.com>" "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "0c29n10yb2n9gfsaxk86w3ap7zdciiirmqf6i7vwd0fk3y0mpkc8";
    procMacro = true;
    dependencies = mapFeatures features ([
      (crates."proc_macro2"."${deps."serde_derive"."1.0.104"."proc_macro2"}" deps)
      (crates."quote"."${deps."serde_derive"."1.0.104"."quote"}" deps)
      (crates."syn"."${deps."serde_derive"."1.0.104"."syn"}" deps)
    ]);
    features = mkFeatures (features."serde_derive"."1.0.104" or {});
  };
  features_.serde_derive."1.0.104" = deps: f: updateFeatures f (rec {
    proc_macro2."${deps.serde_derive."1.0.104".proc_macro2}".default = true;
    quote."${deps.serde_derive."1.0.104".quote}".default = true;
    serde_derive."1.0.104".default = (f.serde_derive."1.0.104".default or true);
    syn = fold recursiveUpdate {} [
      { "${deps.serde_derive."1.0.104".syn}"."visit" = true; }
      { "${deps.serde_derive."1.0.104".syn}".default = true; }
    ];
  }) [
    (features_.proc_macro2."${deps."serde_derive"."1.0.104"."proc_macro2"}" deps)
    (features_.quote."${deps."serde_derive"."1.0.104"."quote"}" deps)
    (features_.syn."${deps."serde_derive"."1.0.104"."syn"}" deps)
  ];


# end
# serde_json-1.0.44

  crates.serde_json."1.0.44" = deps: { features?(features_.serde_json."1.0.44" deps {}) }: buildRustCrate {
    crateName = "serde_json";
    version = "1.0.44";
    description = "A JSON serialization file format";
    authors = [ "Erick Tryzelaar <erick.tryzelaar@gmail.com>" "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "04i068sibjfwg67nvg2yddj0iwznwk9cpcx6rxd1q5gqc76mvl7b";
    dependencies = mapFeatures features ([
      (crates."itoa"."${deps."serde_json"."1.0.44"."itoa"}" deps)
      (crates."ryu"."${deps."serde_json"."1.0.44"."ryu"}" deps)
      (crates."serde"."${deps."serde_json"."1.0.44"."serde"}" deps)
    ]);
    features = mkFeatures (features."serde_json"."1.0.44" or {});
  };
  features_.serde_json."1.0.44" = deps: f: updateFeatures f (rec {
    itoa."${deps.serde_json."1.0.44".itoa}".default = true;
    ryu."${deps.serde_json."1.0.44".ryu}".default = true;
    serde."${deps.serde_json."1.0.44".serde}".default = true;
    serde_json = fold recursiveUpdate {} [
      { "1.0.44"."indexmap" =
        (f.serde_json."1.0.44"."indexmap" or false) ||
        (f.serde_json."1.0.44".preserve_order or false) ||
        (serde_json."1.0.44"."preserve_order" or false); }
      { "1.0.44".default = (f.serde_json."1.0.44".default or true); }
    ];
  }) [
    (features_.itoa."${deps."serde_json"."1.0.44"."itoa"}" deps)
    (features_.ryu."${deps."serde_json"."1.0.44"."ryu"}" deps)
    (features_.serde."${deps."serde_json"."1.0.44"."serde"}" deps)
  ];


# end
# serde_yaml-0.8.11

  crates.serde_yaml."0.8.11" = deps: { features?(features_.serde_yaml."0.8.11" deps {}) }: buildRustCrate {
    crateName = "serde_yaml";
    version = "0.8.11";
    description = "YAML support for Serde";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    edition = "2018";
    sha256 = "0727jwg07binrwimzxqpbpp26lyssiy9krrn73sdhal75ba4mzyn";
    dependencies = mapFeatures features ([
      (crates."dtoa"."${deps."serde_yaml"."0.8.11"."dtoa"}" deps)
      (crates."linked_hash_map"."${deps."serde_yaml"."0.8.11"."linked_hash_map"}" deps)
      (crates."serde"."${deps."serde_yaml"."0.8.11"."serde"}" deps)
      (crates."yaml_rust"."${deps."serde_yaml"."0.8.11"."yaml_rust"}" deps)
    ]);
  };
  features_.serde_yaml."0.8.11" = deps: f: updateFeatures f (rec {
    dtoa."${deps.serde_yaml."0.8.11".dtoa}".default = true;
    linked_hash_map."${deps.serde_yaml."0.8.11".linked_hash_map}".default = true;
    serde."${deps.serde_yaml."0.8.11".serde}".default = true;
    serde_yaml."0.8.11".default = (f.serde_yaml."0.8.11".default or true);
    yaml_rust."${deps.serde_yaml."0.8.11".yaml_rust}".default = true;
  }) [
    (features_.dtoa."${deps."serde_yaml"."0.8.11"."dtoa"}" deps)
    (features_.linked_hash_map."${deps."serde_yaml"."0.8.11"."linked_hash_map"}" deps)
    (features_.serde."${deps."serde_yaml"."0.8.11"."serde"}" deps)
    (features_.yaml_rust."${deps."serde_yaml"."0.8.11"."yaml_rust"}" deps)
  ];


# end
# slab-0.4.2

  crates.slab."0.4.2" = deps: { features?(features_.slab."0.4.2" deps {}) }: buildRustCrate {
    crateName = "slab";
    version = "0.4.2";
    description = "Pre-allocated storage for a uniform data type";
    authors = [ "Carl Lerche <me@carllerche.com>" ];
    sha256 = "0h1l2z7qy6207kv0v3iigdf2xfk9yrhbwj1svlxk6wxjmdxvgdl7";
  };
  features_.slab."0.4.2" = deps: f: updateFeatures f (rec {
    slab."0.4.2".default = (f.slab."0.4.2".default or true);
  }) [];


# end
# syn-1.0.11

  crates.syn."1.0.11" = deps: { features?(features_.syn."1.0.11" deps {}) }: buildRustCrate {
    crateName = "syn";
    version = "1.0.11";
    description = "Parser for Rust source code";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    edition = "2018";
    sha256 = "0s6yg3yag6xs3cpdbm165fjka7b4kq6bmpwfsifvsskvm4flbw19";
    dependencies = mapFeatures features ([
      (crates."proc_macro2"."${deps."syn"."1.0.11"."proc_macro2"}" deps)
      (crates."unicode_xid"."${deps."syn"."1.0.11"."unicode_xid"}" deps)
    ]
      ++ (if features.syn."1.0.11".quote or false then [ (crates.quote."${deps."syn"."1.0.11".quote}" deps) ] else []));
    features = mkFeatures (features."syn"."1.0.11" or {});
  };
  features_.syn."1.0.11" = deps: f: updateFeatures f (rec {
    proc_macro2 = fold recursiveUpdate {} [
      { "${deps.syn."1.0.11".proc_macro2}"."proc-macro" =
        (f.proc_macro2."${deps.syn."1.0.11".proc_macro2}"."proc-macro" or false) ||
        (syn."1.0.11"."proc-macro" or false) ||
        (f."syn"."1.0.11"."proc-macro" or false); }
      { "${deps.syn."1.0.11".proc_macro2}".default = (f.proc_macro2."${deps.syn."1.0.11".proc_macro2}".default or false); }
    ];
    quote = fold recursiveUpdate {} [
      { "${deps.syn."1.0.11".quote}"."proc-macro" =
        (f.quote."${deps.syn."1.0.11".quote}"."proc-macro" or false) ||
        (syn."1.0.11"."proc-macro" or false) ||
        (f."syn"."1.0.11"."proc-macro" or false); }
      { "${deps.syn."1.0.11".quote}".default = (f.quote."${deps.syn."1.0.11".quote}".default or false); }
    ];
    syn = fold recursiveUpdate {} [
      { "1.0.11"."clone-impls" =
        (f.syn."1.0.11"."clone-impls" or false) ||
        (f.syn."1.0.11".default or false) ||
        (syn."1.0.11"."default" or false); }
      { "1.0.11"."derive" =
        (f.syn."1.0.11"."derive" or false) ||
        (f.syn."1.0.11".default or false) ||
        (syn."1.0.11"."default" or false); }
      { "1.0.11"."parsing" =
        (f.syn."1.0.11"."parsing" or false) ||
        (f.syn."1.0.11".default or false) ||
        (syn."1.0.11"."default" or false); }
      { "1.0.11"."printing" =
        (f.syn."1.0.11"."printing" or false) ||
        (f.syn."1.0.11".default or false) ||
        (syn."1.0.11"."default" or false); }
      { "1.0.11"."proc-macro" =
        (f.syn."1.0.11"."proc-macro" or false) ||
        (f.syn."1.0.11".default or false) ||
        (syn."1.0.11"."default" or false); }
      { "1.0.11"."quote" =
        (f.syn."1.0.11"."quote" or false) ||
        (f.syn."1.0.11".printing or false) ||
        (syn."1.0.11"."printing" or false); }
      { "1.0.11".default = (f.syn."1.0.11".default or true); }
    ];
    unicode_xid."${deps.syn."1.0.11".unicode_xid}".default = true;
  }) [
    (features_.proc_macro2."${deps."syn"."1.0.11"."proc_macro2"}" deps)
    (features_.quote."${deps."syn"."1.0.11"."quote"}" deps)
    (features_.unicode_xid."${deps."syn"."1.0.11"."unicode_xid"}" deps)
  ];


# end
# thread-id-2.0.0

  crates.thread_id."2.0.0" = deps: { features?(features_.thread_id."2.0.0" deps {}) }: buildRustCrate {
    crateName = "thread-id";
    version = "2.0.0";
    description = "Get a unique thread ID";
    authors = [ "Ruud van Asseldonk <dev@veniogames.com>" ];
    sha256 = "06i3c8ckn97i5rp16civ2vpqbknlkx66dkrl070iw60nawi0kjc3";
    dependencies = mapFeatures features ([
      (crates."kernel32_sys"."${deps."thread_id"."2.0.0"."kernel32_sys"}" deps)
      (crates."libc"."${deps."thread_id"."2.0.0"."libc"}" deps)
    ]);
  };
  features_.thread_id."2.0.0" = deps: f: updateFeatures f (rec {
    kernel32_sys."${deps.thread_id."2.0.0".kernel32_sys}".default = true;
    libc."${deps.thread_id."2.0.0".libc}".default = true;
    thread_id."2.0.0".default = (f.thread_id."2.0.0".default or true);
  }) [
    (features_.kernel32_sys."${deps."thread_id"."2.0.0"."kernel32_sys"}" deps)
    (features_.libc."${deps."thread_id"."2.0.0"."libc"}" deps)
  ];


# end
# thread_local-0.2.7

  crates.thread_local."0.2.7" = deps: { features?(features_.thread_local."0.2.7" deps {}) }: buildRustCrate {
    crateName = "thread_local";
    version = "0.2.7";
    description = "Per-object thread-local storage";
    authors = [ "Amanieu d'Antras <amanieu@gmail.com>" ];
    sha256 = "19p0zrs24rdwjvpi10jig5ms3sxj00pv8shkr9cpddri8cdghqp7";
    dependencies = mapFeatures features ([
      (crates."thread_id"."${deps."thread_local"."0.2.7"."thread_id"}" deps)
    ]);
  };
  features_.thread_local."0.2.7" = deps: f: updateFeatures f (rec {
    thread_id."${deps.thread_local."0.2.7".thread_id}".default = true;
    thread_local."0.2.7".default = (f.thread_local."0.2.7".default or true);
  }) [
    (features_.thread_id."${deps."thread_local"."0.2.7"."thread_id"}" deps)
  ];


# end
# thread_local-0.3.6

  crates.thread_local."0.3.6" = deps: { features?(features_.thread_local."0.3.6" deps {}) }: buildRustCrate {
    crateName = "thread_local";
    version = "0.3.6";
    description = "Per-object thread-local storage";
    authors = [ "Amanieu d'Antras <amanieu@gmail.com>" ];
    sha256 = "02rksdwjmz2pw9bmgbb4c0bgkbq5z6nvg510sq1s6y2j1gam0c7i";
    dependencies = mapFeatures features ([
      (crates."lazy_static"."${deps."thread_local"."0.3.6"."lazy_static"}" deps)
    ]);
  };
  features_.thread_local."0.3.6" = deps: f: updateFeatures f (rec {
    lazy_static."${deps.thread_local."0.3.6".lazy_static}".default = true;
    thread_local."0.3.6".default = (f.thread_local."0.3.6".default or true);
  }) [
    (features_.lazy_static."${deps."thread_local"."0.3.6"."lazy_static"}" deps)
  ];


# end
# time-0.1.42

  crates.time."0.1.42" = deps: { features?(features_.time."0.1.42" deps {}) }: buildRustCrate {
    crateName = "time";
    version = "0.1.42";
    description = "Utilities for working with time-related functions in Rust.\n";
    authors = [ "The Rust Project Developers" ];
    sha256 = "1ny809kmdjwd4b478ipc33dz7q6nq7rxk766x8cnrg6zygcksmmx";
    dependencies = mapFeatures features ([
      (crates."libc"."${deps."time"."0.1.42"."libc"}" deps)
    ])
      ++ (if kernel == "redox" then mapFeatures features ([
      (crates."redox_syscall"."${deps."time"."0.1.42"."redox_syscall"}" deps)
    ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."winapi"."${deps."time"."0.1.42"."winapi"}" deps)
    ]) else []);
  };
  features_.time."0.1.42" = deps: f: updateFeatures f (rec {
    libc."${deps.time."0.1.42".libc}".default = true;
    redox_syscall."${deps.time."0.1.42".redox_syscall}".default = true;
    time."0.1.42".default = (f.time."0.1.42".default or true);
    winapi = fold recursiveUpdate {} [
      { "${deps.time."0.1.42".winapi}"."minwinbase" = true; }
      { "${deps.time."0.1.42".winapi}"."minwindef" = true; }
      { "${deps.time."0.1.42".winapi}"."ntdef" = true; }
      { "${deps.time."0.1.42".winapi}"."profileapi" = true; }
      { "${deps.time."0.1.42".winapi}"."std" = true; }
      { "${deps.time."0.1.42".winapi}"."sysinfoapi" = true; }
      { "${deps.time."0.1.42".winapi}"."timezoneapi" = true; }
      { "${deps.time."0.1.42".winapi}".default = true; }
    ];
  }) [
    (features_.libc."${deps."time"."0.1.42"."libc"}" deps)
    (features_.redox_syscall."${deps."time"."0.1.42"."redox_syscall"}" deps)
    (features_.winapi."${deps."time"."0.1.42"."winapi"}" deps)
  ];


# end
# typenum-1.11.2

  crates.typenum."1.11.2" = deps: { features?(features_.typenum."1.11.2" deps {}) }: buildRustCrate {
    crateName = "typenum";
    version = "1.11.2";
    description = "Typenum is a Rust library for type-level numbers evaluated at compile time. It currently supports bits, unsigned integers, and signed integers. It also provides a type-level array of type-level numbers, but its implementation is incomplete.";
    authors = [ "Paho Lurie-Gregg <paho@paholg.com>" "Andre Bogus <bogusandre@gmail.com>" ];
    sha256 = "0pdbfkqzp4hwj21b2gv79kh1s1sgr587bd4s039qzalg5jiniiz8";
    build = "build/main.rs";
    features = mkFeatures (features."typenum"."1.11.2" or {});
  };
  features_.typenum."1.11.2" = deps: f: updateFeatures f (rec {
    typenum."1.11.2".default = (f.typenum."1.11.2".default or true);
  }) [];


# end
# tzdata-0.4.1

  crates.tzdata."0.4.1" = deps: { features?(features_.tzdata."0.4.1" deps {}) }: buildRustCrate {
    crateName = "tzdata";
    version = "0.4.1";
    description = "see hourglass";
    authors = [ "Maxime Lenoir <lenoir.maxime0@gmail.com>" ];
    sha256 = "1vgkginrfcdzfh5yvpz07zrx82nhpg1sapkxrk6dr5hjhgzigpa7";
    dependencies = mapFeatures features ([
      (crates."byteorder"."${deps."tzdata"."0.4.1"."byteorder"}" deps)
      (crates."regex"."${deps."tzdata"."0.4.1"."regex"}" deps)
      (crates."time"."${deps."tzdata"."0.4.1"."time"}" deps)
    ]);
  };
  features_.tzdata."0.4.1" = deps: f: updateFeatures f (rec {
    byteorder."${deps.tzdata."0.4.1".byteorder}".default = true;
    regex."${deps.tzdata."0.4.1".regex}".default = true;
    time."${deps.tzdata."0.4.1".time}".default = true;
    tzdata."0.4.1".default = (f.tzdata."0.4.1".default or true);
  }) [
    (features_.byteorder."${deps."tzdata"."0.4.1"."byteorder"}" deps)
    (features_.regex."${deps."tzdata"."0.4.1"."regex"}" deps)
    (features_.time."${deps."tzdata"."0.4.1"."time"}" deps)
  ];


# end
# ucd-util-0.1.5

  crates.ucd_util."0.1.5" = deps: { features?(features_.ucd_util."0.1.5" deps {}) }: buildRustCrate {
    crateName = "ucd-util";
    version = "0.1.5";
    description = "A small utility library for working with the Unicode character database.\n";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" ];
    sha256 = "0c2lxv2b382n3pw1vnx4plnp371qplhfaag6w67qs11cmfflxhl6";
  };
  features_.ucd_util."0.1.5" = deps: f: updateFeatures f (rec {
    ucd_util."0.1.5".default = (f.ucd_util."0.1.5".default or true);
  }) [];


# end
# unicode-xid-0.2.0

  crates.unicode_xid."0.2.0" = deps: { features?(features_.unicode_xid."0.2.0" deps {}) }: buildRustCrate {
    crateName = "unicode-xid";
    version = "0.2.0";
    description = "Determine whether characters have the XID_Start\nor XID_Continue properties according to\nUnicode Standard Annex #31.\n";
    authors = [ "erick.tryzelaar <erick.tryzelaar@gmail.com>" "kwantam <kwantam@gmail.com>" ];
    sha256 = "1c85gb3p3qhbjvfyjb31m06la4f024jx319k10ig7n47dz2fk8v7";
    features = mkFeatures (features."unicode_xid"."0.2.0" or {});
  };
  features_.unicode_xid."0.2.0" = deps: f: updateFeatures f (rec {
    unicode_xid."0.2.0".default = (f.unicode_xid."0.2.0".default or true);
  }) [];


# end
# utf8-ranges-0.1.3

  crates.utf8_ranges."0.1.3" = deps: { features?(features_.utf8_ranges."0.1.3" deps {}) }: buildRustCrate {
    crateName = "utf8-ranges";
    version = "0.1.3";
    description = "Convert ranges of Unicode codepoints to UTF-8 byte ranges.";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" ];
    sha256 = "1cj548a91a93j8375p78qikaiam548xh84cb0ck8y119adbmsvbp";
  };
  features_.utf8_ranges."0.1.3" = deps: f: updateFeatures f (rec {
    utf8_ranges."0.1.3".default = (f.utf8_ranges."0.1.3".default or true);
  }) [];


# end
# utf8-ranges-1.0.4

  crates.utf8_ranges."1.0.4" = deps: { features?(features_.utf8_ranges."1.0.4" deps {}) }: buildRustCrate {
    crateName = "utf8-ranges";
    version = "1.0.4";
    description = "DEPRECATED. Use regex-syntax::utf8 submodule instead.";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" ];
    sha256 = "0arhv375dh3l9pydbvzdfqyx9v1car0msdc91wjv227l22p9vqci";
  };
  features_.utf8_ranges."1.0.4" = deps: f: updateFeatures f (rec {
    utf8_ranges."1.0.4".default = (f.utf8_ranges."1.0.4".default or true);
  }) [];


# end
# uuid-0.6.5

  crates.uuid."0.6.5" = deps: { features?(features_.uuid."0.6.5" deps {}) }: buildRustCrate {
    crateName = "uuid";
    version = "0.6.5";
    description = "A library to generate and parse UUIDs.";
    authors = [ "Ashley Mannix<ashleymannix@live.com.au>" "Christopher Armstrong" "Dylan DPC<dylan.dpc@gmail.com>" "Hunar Roop Kahlon<hunar.roop@gmail.com>" ];
    sha256 = "1jy15m4yxxwma0jsy070garhbgfprky23i77rawjkk75vqhnnhlf";
    dependencies = mapFeatures features ([
      (crates."cfg_if"."${deps."uuid"."0.6.5"."cfg_if"}" deps)
    ]
      ++ (if features.uuid."0.6.5".rand or false then [ (crates.rand."${deps."uuid"."0.6.5".rand}" deps) ] else [])
      ++ (if features.uuid."0.6.5".serde or false then [ (crates.serde."${deps."uuid"."0.6.5".serde}" deps) ] else []));
    features = mkFeatures (features."uuid"."0.6.5" or {});
  };
  features_.uuid."0.6.5" = deps: f: updateFeatures f (rec {
    cfg_if."${deps.uuid."0.6.5".cfg_if}".default = true;
    rand."${deps.uuid."0.6.5".rand}".default = true;
    serde."${deps.uuid."0.6.5".serde}".default = (f.serde."${deps.uuid."0.6.5".serde}".default or false);
    uuid = fold recursiveUpdate {} [
      { "0.6.5"."byteorder" =
        (f.uuid."0.6.5"."byteorder" or false) ||
        (f.uuid."0.6.5".u128 or false) ||
        (uuid."0.6.5"."u128" or false); }
      { "0.6.5"."md5" =
        (f.uuid."0.6.5"."md5" or false) ||
        (f.uuid."0.6.5".v3 or false) ||
        (uuid."0.6.5"."v3" or false); }
      { "0.6.5"."nightly" =
        (f.uuid."0.6.5"."nightly" or false) ||
        (f.uuid."0.6.5".const_fn or false) ||
        (uuid."0.6.5"."const_fn" or false); }
      { "0.6.5"."rand" =
        (f.uuid."0.6.5"."rand" or false) ||
        (f.uuid."0.6.5".v3 or false) ||
        (uuid."0.6.5"."v3" or false) ||
        (f.uuid."0.6.5".v4 or false) ||
        (uuid."0.6.5"."v4" or false) ||
        (f.uuid."0.6.5".v5 or false) ||
        (uuid."0.6.5"."v5" or false); }
      { "0.6.5"."sha1" =
        (f.uuid."0.6.5"."sha1" or false) ||
        (f.uuid."0.6.5".v5 or false) ||
        (uuid."0.6.5"."v5" or false); }
      { "0.6.5"."std" =
        (f.uuid."0.6.5"."std" or false) ||
        (f.uuid."0.6.5".default or false) ||
        (uuid."0.6.5"."default" or false) ||
        (f.uuid."0.6.5".use_std or false) ||
        (uuid."0.6.5"."use_std" or false); }
      { "0.6.5".default = (f.uuid."0.6.5".default or true); }
    ];
  }) [
    (features_.cfg_if."${deps."uuid"."0.6.5"."cfg_if"}" deps)
    (features_.rand."${deps."uuid"."0.6.5"."rand"}" deps)
    (features_.serde."${deps."uuid"."0.6.5"."serde"}" deps)
  ];


# end
# winapi-0.2.8

  crates.winapi."0.2.8" = deps: { features?(features_.winapi."0.2.8" deps {}) }: buildRustCrate {
    crateName = "winapi";
    version = "0.2.8";
    description = "Types and constants for WinAPI bindings. See README for list of crates providing function bindings.";
    authors = [ "Peter Atashian <retep998@gmail.com>" ];
    sha256 = "0a45b58ywf12vb7gvj6h3j264nydynmzyqz8d8rqxsj6icqv82as";
  };
  features_.winapi."0.2.8" = deps: f: updateFeatures f (rec {
    winapi."0.2.8".default = (f.winapi."0.2.8".default or true);
  }) [];


# end
# winapi-0.3.8

  crates.winapi."0.3.8" = deps: { features?(features_.winapi."0.3.8" deps {}) }: buildRustCrate {
    crateName = "winapi";
    version = "0.3.8";
    description = "Raw FFI bindings for all of Windows API.";
    authors = [ "Peter Atashian <retep998@gmail.com>" ];
    sha256 = "084ialbgww1vxry341fmkg5crgpvab3w52ahx1wa54yqjgym0vxs";
    build = "build.rs";
    dependencies = (if kernel == "i686-pc-windows-gnu" then mapFeatures features ([
      (crates."winapi_i686_pc_windows_gnu"."${deps."winapi"."0.3.8"."winapi_i686_pc_windows_gnu"}" deps)
    ]) else [])
      ++ (if kernel == "x86_64-pc-windows-gnu" then mapFeatures features ([
      (crates."winapi_x86_64_pc_windows_gnu"."${deps."winapi"."0.3.8"."winapi_x86_64_pc_windows_gnu"}" deps)
    ]) else []);
    features = mkFeatures (features."winapi"."0.3.8" or {});
  };
  features_.winapi."0.3.8" = deps: f: updateFeatures f (rec {
    winapi = fold recursiveUpdate {} [
      { "0.3.8"."impl-debug" =
        (f.winapi."0.3.8"."impl-debug" or false) ||
        (f.winapi."0.3.8".debug or false) ||
        (winapi."0.3.8"."debug" or false); }
      { "0.3.8".default = (f.winapi."0.3.8".default or true); }
    ];
    winapi_i686_pc_windows_gnu."${deps.winapi."0.3.8".winapi_i686_pc_windows_gnu}".default = true;
    winapi_x86_64_pc_windows_gnu."${deps.winapi."0.3.8".winapi_x86_64_pc_windows_gnu}".default = true;
  }) [
    (features_.winapi_i686_pc_windows_gnu."${deps."winapi"."0.3.8"."winapi_i686_pc_windows_gnu"}" deps)
    (features_.winapi_x86_64_pc_windows_gnu."${deps."winapi"."0.3.8"."winapi_x86_64_pc_windows_gnu"}" deps)
  ];


# end
# winapi-build-0.1.1

  crates.winapi_build."0.1.1" = deps: { features?(features_.winapi_build."0.1.1" deps {}) }: buildRustCrate {
    crateName = "winapi-build";
    version = "0.1.1";
    description = "Common code for build.rs in WinAPI -sys crates.";
    authors = [ "Peter Atashian <retep998@gmail.com>" ];
    sha256 = "1lxlpi87rkhxcwp2ykf1ldw3p108hwm24nywf3jfrvmff4rjhqga";
    libName = "build";
  };
  features_.winapi_build."0.1.1" = deps: f: updateFeatures f (rec {
    winapi_build."0.1.1".default = (f.winapi_build."0.1.1".default or true);
  }) [];


# end
# winapi-i686-pc-windows-gnu-0.4.0

  crates.winapi_i686_pc_windows_gnu."0.4.0" = deps: { features?(features_.winapi_i686_pc_windows_gnu."0.4.0" deps {}) }: buildRustCrate {
    crateName = "winapi-i686-pc-windows-gnu";
    version = "0.4.0";
    description = "Import libraries for the i686-pc-windows-gnu target. Please don't use this crate directly, depend on winapi instead.";
    authors = [ "Peter Atashian <retep998@gmail.com>" ];
    sha256 = "05ihkij18r4gamjpxj4gra24514can762imjzlmak5wlzidplzrp";
    build = "build.rs";
  };
  features_.winapi_i686_pc_windows_gnu."0.4.0" = deps: f: updateFeatures f (rec {
    winapi_i686_pc_windows_gnu."0.4.0".default = (f.winapi_i686_pc_windows_gnu."0.4.0".default or true);
  }) [];


# end
# winapi-x86_64-pc-windows-gnu-0.4.0

  crates.winapi_x86_64_pc_windows_gnu."0.4.0" = deps: { features?(features_.winapi_x86_64_pc_windows_gnu."0.4.0" deps {}) }: buildRustCrate {
    crateName = "winapi-x86_64-pc-windows-gnu";
    version = "0.4.0";
    description = "Import libraries for the x86_64-pc-windows-gnu target. Please don't use this crate directly, depend on winapi instead.";
    authors = [ "Peter Atashian <retep998@gmail.com>" ];
    sha256 = "0n1ylmlsb8yg1v583i4xy0qmqg42275flvbc51hdqjjfjcl9vlbj";
    build = "build.rs";
  };
  features_.winapi_x86_64_pc_windows_gnu."0.4.0" = deps: f: updateFeatures f (rec {
    winapi_x86_64_pc_windows_gnu."0.4.0".default = (f.winapi_x86_64_pc_windows_gnu."0.4.0".default or true);
  }) [];


# end
# yaml-rust-0.4.3

  crates.yaml_rust."0.4.3" = deps: { features?(features_.yaml_rust."0.4.3" deps {}) }: buildRustCrate {
    crateName = "yaml-rust";
    version = "0.4.3";
    description = "The missing YAML 1.2 parser for rust";
    authors = [ "Yuheng Chen <yuhengchen@sensetime.com>" ];
    sha256 = "09p179lz1gjdpa0c58164dc4cs7ijw3j1aqflpshnl1zwvfsgwyx";
    dependencies = mapFeatures features ([
      (crates."linked_hash_map"."${deps."yaml_rust"."0.4.3"."linked_hash_map"}" deps)
    ]);
  };
  features_.yaml_rust."0.4.3" = deps: f: updateFeatures f (rec {
    linked_hash_map."${deps.yaml_rust."0.4.3".linked_hash_map}".default = true;
    yaml_rust."0.4.3".default = (f.yaml_rust."0.4.3".default or true);
  }) [
    (features_.linked_hash_map."${deps."yaml_rust"."0.4.3"."linked_hash_map"}" deps)
  ];


# end
}

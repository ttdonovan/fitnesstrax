{ lib, buildRustCrate, buildRustCrateHelpers }:
with buildRustCrateHelpers;
let inherit (lib.lists) fold;
    inherit (lib.attrsets) recursiveUpdate;
in
rec {

# aho-corasick-0.6.10

  crates.aho_corasick."0.6.10" = deps: { features?(features_.aho_corasick."0.6.10" deps {}) }: buildRustCrate {
    crateName = "aho-corasick";
    version = "0.6.10";
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
# ansi_term-0.11.0

  crates.ansi_term."0.11.0" = deps: { features?(features_.ansi_term."0.11.0" deps {}) }: buildRustCrate {
    crateName = "ansi_term";
    version = "0.11.0";
    authors = [ "ogham@bsago.me" "Ryan Scheel (Havvy) <ryan.havvy@gmail.com>" "Josh Triplett <josh@joshtriplett.org>" ];
    sha256 = "08fk0p2xvkqpmz3zlrwnf6l8sj2vngw464rvzspzp31sbgxbwm4v";
    dependencies = (if kernel == "windows" then mapFeatures features ([
      (crates."winapi"."${deps."ansi_term"."0.11.0"."winapi"}" deps)
    ]) else []);
  };
  features_.ansi_term."0.11.0" = deps: f: updateFeatures f (rec {
    ansi_term."0.11.0".default = (f.ansi_term."0.11.0".default or true);
    winapi = fold recursiveUpdate {} [
      { "${deps.ansi_term."0.11.0".winapi}"."consoleapi" = true; }
      { "${deps.ansi_term."0.11.0".winapi}"."errhandlingapi" = true; }
      { "${deps.ansi_term."0.11.0".winapi}"."processenv" = true; }
      { "${deps.ansi_term."0.11.0".winapi}".default = true; }
    ];
  }) [
    (features_.winapi."${deps."ansi_term"."0.11.0"."winapi"}" deps)
  ];


# end
# atty-0.2.11

  crates.atty."0.2.11" = deps: { features?(features_.atty."0.2.11" deps {}) }: buildRustCrate {
    crateName = "atty";
    version = "0.2.11";
    authors = [ "softprops <d.tangren@gmail.com>" ];
    sha256 = "0by1bj2km9jxi4i4g76zzi76fc2rcm9934jpnyrqd95zw344pb20";
    dependencies = (if kernel == "redox" then mapFeatures features ([
      (crates."termion"."${deps."atty"."0.2.11"."termion"}" deps)
    ]) else [])
      ++ (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([
      (crates."libc"."${deps."atty"."0.2.11"."libc"}" deps)
    ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."winapi"."${deps."atty"."0.2.11"."winapi"}" deps)
    ]) else []);
  };
  features_.atty."0.2.11" = deps: f: updateFeatures f (rec {
    atty."0.2.11".default = (f.atty."0.2.11".default or true);
    libc."${deps.atty."0.2.11".libc}".default = (f.libc."${deps.atty."0.2.11".libc}".default or false);
    termion."${deps.atty."0.2.11".termion}".default = true;
    winapi = fold recursiveUpdate {} [
      { "${deps.atty."0.2.11".winapi}"."consoleapi" = true; }
      { "${deps.atty."0.2.11".winapi}"."minwinbase" = true; }
      { "${deps.atty."0.2.11".winapi}"."minwindef" = true; }
      { "${deps.atty."0.2.11".winapi}"."processenv" = true; }
      { "${deps.atty."0.2.11".winapi}"."winbase" = true; }
      { "${deps.atty."0.2.11".winapi}".default = true; }
    ];
  }) [
    (features_.termion."${deps."atty"."0.2.11"."termion"}" deps)
    (features_.libc."${deps."atty"."0.2.11"."libc"}" deps)
    (features_.winapi."${deps."atty"."0.2.11"."winapi"}" deps)
  ];


# end
# autocfg-0.1.2

  crates.autocfg."0.1.2" = deps: { features?(features_.autocfg."0.1.2" deps {}) }: buildRustCrate {
    crateName = "autocfg";
    version = "0.1.2";
    authors = [ "Josh Stone <cuviper@gmail.com>" ];
    sha256 = "0dv81dwnp1al3j4ffz007yrjv4w1c7hw09gnf0xs3icxiw6qqfs3";
  };
  features_.autocfg."0.1.2" = deps: f: updateFeatures f (rec {
    autocfg."0.1.2".default = (f.autocfg."0.1.2".default or true);
  }) [];


# end
# base64-0.9.3

  crates.base64."0.9.3" = deps: { features?(features_.base64."0.9.3" deps {}) }: buildRustCrate {
    crateName = "base64";
    version = "0.9.3";
    authors = [ "Alice Maz <alice@alicemaz.com>" "Marshall Pierce <marshall@mpierce.org>" ];
    sha256 = "11hhz8ln4zbpn2h2gm9fbbb9j254wrd4fpmddlyah2rrnqsmmqkd";
    dependencies = mapFeatures features ([
      (crates."byteorder"."${deps."base64"."0.9.3"."byteorder"}" deps)
      (crates."safemem"."${deps."base64"."0.9.3"."safemem"}" deps)
    ]);
  };
  features_.base64."0.9.3" = deps: f: updateFeatures f (rec {
    base64."0.9.3".default = (f.base64."0.9.3".default or true);
    byteorder."${deps.base64."0.9.3".byteorder}".default = true;
    safemem."${deps.base64."0.9.3".safemem}".default = true;
  }) [
    (features_.byteorder."${deps."base64"."0.9.3"."byteorder"}" deps)
    (features_.safemem."${deps."base64"."0.9.3"."safemem"}" deps)
  ];


# end
# bitflags-1.0.4

  crates.bitflags."1.0.4" = deps: { features?(features_.bitflags."1.0.4" deps {}) }: buildRustCrate {
    crateName = "bitflags";
    version = "1.0.4";
    authors = [ "The Rust Project Developers" ];
    sha256 = "1g1wmz2001qmfrd37dnd5qiss5njrw26aywmg6yhkmkbyrhjxb08";
    features = mkFeatures (features."bitflags"."1.0.4" or {});
  };
  features_.bitflags."1.0.4" = deps: f: updateFeatures f (rec {
    bitflags."1.0.4".default = (f.bitflags."1.0.4".default or true);
  }) [];


# end
# bodyparser-0.8.0

  crates.bodyparser."0.8.0" = deps: { features?(features_.bodyparser."0.8.0" deps {}) }: buildRustCrate {
    crateName = "bodyparser";
    version = "0.8.0";
    authors = [ "Patrick Tran <patrick.tran06@gmail.com>" "Jonathan Reem <jonathan.reem@gmail.com>" ];
    sha256 = "0nfc3g7qgv14hkv59ifbfcahkm8xiwkg0ajm746fqnps6c7h8z4m";
    dependencies = mapFeatures features ([
      (crates."iron"."${deps."bodyparser"."0.8.0"."iron"}" deps)
      (crates."persistent"."${deps."bodyparser"."0.8.0"."persistent"}" deps)
      (crates."plugin"."${deps."bodyparser"."0.8.0"."plugin"}" deps)
      (crates."serde"."${deps."bodyparser"."0.8.0"."serde"}" deps)
      (crates."serde_json"."${deps."bodyparser"."0.8.0"."serde_json"}" deps)
    ]);
  };
  features_.bodyparser."0.8.0" = deps: f: updateFeatures f (rec {
    bodyparser."0.8.0".default = (f.bodyparser."0.8.0".default or true);
    iron."${deps.bodyparser."0.8.0".iron}".default = true;
    persistent."${deps.bodyparser."0.8.0".persistent}".default = true;
    plugin."${deps.bodyparser."0.8.0".plugin}".default = true;
    serde."${deps.bodyparser."0.8.0".serde}".default = true;
    serde_json."${deps.bodyparser."0.8.0".serde_json}".default = true;
  }) [
    (features_.iron."${deps."bodyparser"."0.8.0"."iron"}" deps)
    (features_.persistent."${deps."bodyparser"."0.8.0"."persistent"}" deps)
    (features_.plugin."${deps."bodyparser"."0.8.0"."plugin"}" deps)
    (features_.serde."${deps."bodyparser"."0.8.0"."serde"}" deps)
    (features_.serde_json."${deps."bodyparser"."0.8.0"."serde_json"}" deps)
  ];


# end
# buf_redux-0.6.3

  crates.buf_redux."0.6.3" = deps: { features?(features_.buf_redux."0.6.3" deps {}) }: buildRustCrate {
    crateName = "buf_redux";
    version = "0.6.3";
    authors = [ "Austin Bonander <austin.bonander@gmail.com>" ];
    sha256 = "1cw80dlx27qmlcka69qixwnabjzy7fp3amiw8ij6a34yd4wzdrdj";
    dependencies = mapFeatures features ([
      (crates."memchr"."${deps."buf_redux"."0.6.3"."memchr"}" deps)
      (crates."safemem"."${deps."buf_redux"."0.6.3"."safemem"}" deps)
    ]);
    features = mkFeatures (features."buf_redux"."0.6.3" or {});
  };
  features_.buf_redux."0.6.3" = deps: f: updateFeatures f (rec {
    buf_redux."0.6.3".default = (f.buf_redux."0.6.3".default or true);
    memchr."${deps.buf_redux."0.6.3".memchr}".default = true;
    safemem."${deps.buf_redux."0.6.3".safemem}".default = true;
  }) [
    (features_.memchr."${deps."buf_redux"."0.6.3"."memchr"}" deps)
    (features_.safemem."${deps."buf_redux"."0.6.3"."safemem"}" deps)
  ];


# end
# byteorder-1.3.1

  crates.byteorder."1.3.1" = deps: { features?(features_.byteorder."1.3.1" deps {}) }: buildRustCrate {
    crateName = "byteorder";
    version = "1.3.1";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" ];
    sha256 = "1dd46l7fvmxfq90kh6ip1ghsxzzcdybac8f0mh2jivsdv9vy8k4w";
    build = "build.rs";
    features = mkFeatures (features."byteorder"."1.3.1" or {});
  };
  features_.byteorder."1.3.1" = deps: f: updateFeatures f (rec {
    byteorder = fold recursiveUpdate {} [
      { "1.3.1".default = (f.byteorder."1.3.1".default or true); }
      { "1.3.1".std =
        (f.byteorder."1.3.1".std or false) ||
        (f.byteorder."1.3.1".default or false) ||
        (byteorder."1.3.1"."default" or false); }
    ];
  }) [];


# end
# cc-1.0.31

  crates.cc."1.0.31" = deps: { features?(features_.cc."1.0.31" deps {}) }: buildRustCrate {
    crateName = "cc";
    version = "1.0.31";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "1a576gp1gp69v8kprwgk8ryxs3sc9v9g06cd3ggxm9jrzrcc4x5n";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."cc"."1.0.31" or {});
  };
  features_.cc."1.0.31" = deps: f: updateFeatures f (rec {
    cc = fold recursiveUpdate {} [
      { "1.0.31".default = (f.cc."1.0.31".default or true); }
      { "1.0.31".rayon =
        (f.cc."1.0.31".rayon or false) ||
        (f.cc."1.0.31".parallel or false) ||
        (cc."1.0.31"."parallel" or false); }
    ];
  }) [];


# end
# cfg-if-0.1.7

  crates.cfg_if."0.1.7" = deps: { features?(features_.cfg_if."0.1.7" deps {}) }: buildRustCrate {
    crateName = "cfg-if";
    version = "0.1.7";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "13gvcx1dxjq4mpmpj26hpg3yc97qffkx2zi58ykr1dwr8q2biiig";
  };
  features_.cfg_if."0.1.7" = deps: f: updateFeatures f (rec {
    cfg_if."0.1.7".default = (f.cfg_if."0.1.7".default or true);
  }) [];


# end
# chrono-0.4.6

  crates.chrono."0.4.6" = deps: { features?(features_.chrono."0.4.6" deps {}) }: buildRustCrate {
    crateName = "chrono";
    version = "0.4.6";
    authors = [ "Kang Seonghoon <public+rust@mearie.org>" "Brandon W Maister <quodlibetor@gmail.com>" ];
    sha256 = "0cxgqgf4lknsii1k806dpmzapi2zccjpa350ns5wpb568mij096x";
    dependencies = mapFeatures features ([
      (crates."num_integer"."${deps."chrono"."0.4.6"."num_integer"}" deps)
      (crates."num_traits"."${deps."chrono"."0.4.6"."num_traits"}" deps)
    ]
      ++ (if features.chrono."0.4.6".serde or false then [ (crates.serde."${deps."chrono"."0.4.6".serde}" deps) ] else [])
      ++ (if features.chrono."0.4.6".time or false then [ (crates.time."${deps."chrono"."0.4.6".time}" deps) ] else []));
    features = mkFeatures (features."chrono"."0.4.6" or {});
  };
  features_.chrono."0.4.6" = deps: f: updateFeatures f (rec {
    chrono = fold recursiveUpdate {} [
      { "0.4.6".clock =
        (f.chrono."0.4.6".clock or false) ||
        (f.chrono."0.4.6".default or false) ||
        (chrono."0.4.6"."default" or false); }
      { "0.4.6".default = (f.chrono."0.4.6".default or true); }
      { "0.4.6".time =
        (f.chrono."0.4.6".time or false) ||
        (f.chrono."0.4.6".clock or false) ||
        (chrono."0.4.6"."clock" or false); }
    ];
    num_integer."${deps.chrono."0.4.6".num_integer}".default = (f.num_integer."${deps.chrono."0.4.6".num_integer}".default or false);
    num_traits."${deps.chrono."0.4.6".num_traits}".default = (f.num_traits."${deps.chrono."0.4.6".num_traits}".default or false);
    serde."${deps.chrono."0.4.6".serde}".default = true;
    time."${deps.chrono."0.4.6".time}".default = true;
  }) [
    (features_.num_integer."${deps."chrono"."0.4.6"."num_integer"}" deps)
    (features_.num_traits."${deps."chrono"."0.4.6"."num_traits"}" deps)
    (features_.serde."${deps."chrono"."0.4.6"."serde"}" deps)
    (features_.time."${deps."chrono"."0.4.6"."time"}" deps)
  ];


# end
# chrono-tz-0.4.1

  crates.chrono_tz."0.4.1" = deps: { features?(features_.chrono_tz."0.4.1" deps {}) }: buildRustCrate {
    crateName = "chrono-tz";
    version = "0.4.1";
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
# clap-2.32.0

  crates.clap."2.32.0" = deps: { features?(features_.clap."2.32.0" deps {}) }: buildRustCrate {
    crateName = "clap";
    version = "2.32.0";
    authors = [ "Kevin K. <kbknapp@gmail.com>" ];
    sha256 = "1hdjf0janvpjkwrjdjx1mm2aayzr54k72w6mriyr0n5anjkcj1lx";
    dependencies = mapFeatures features ([
      (crates."bitflags"."${deps."clap"."2.32.0"."bitflags"}" deps)
      (crates."textwrap"."${deps."clap"."2.32.0"."textwrap"}" deps)
      (crates."unicode_width"."${deps."clap"."2.32.0"."unicode_width"}" deps)
    ]
      ++ (if features.clap."2.32.0".atty or false then [ (crates.atty."${deps."clap"."2.32.0".atty}" deps) ] else [])
      ++ (if features.clap."2.32.0".strsim or false then [ (crates.strsim."${deps."clap"."2.32.0".strsim}" deps) ] else [])
      ++ (if features.clap."2.32.0".vec_map or false then [ (crates.vec_map."${deps."clap"."2.32.0".vec_map}" deps) ] else []))
      ++ (if !(kernel == "windows") then mapFeatures features ([
    ]
      ++ (if features.clap."2.32.0".ansi_term or false then [ (crates.ansi_term."${deps."clap"."2.32.0".ansi_term}" deps) ] else [])) else []);
    features = mkFeatures (features."clap"."2.32.0" or {});
  };
  features_.clap."2.32.0" = deps: f: updateFeatures f (rec {
    ansi_term."${deps.clap."2.32.0".ansi_term}".default = true;
    atty."${deps.clap."2.32.0".atty}".default = true;
    bitflags."${deps.clap."2.32.0".bitflags}".default = true;
    clap = fold recursiveUpdate {} [
      { "2.32.0".ansi_term =
        (f.clap."2.32.0".ansi_term or false) ||
        (f.clap."2.32.0".color or false) ||
        (clap."2.32.0"."color" or false); }
      { "2.32.0".atty =
        (f.clap."2.32.0".atty or false) ||
        (f.clap."2.32.0".color or false) ||
        (clap."2.32.0"."color" or false); }
      { "2.32.0".clippy =
        (f.clap."2.32.0".clippy or false) ||
        (f.clap."2.32.0".lints or false) ||
        (clap."2.32.0"."lints" or false); }
      { "2.32.0".color =
        (f.clap."2.32.0".color or false) ||
        (f.clap."2.32.0".default or false) ||
        (clap."2.32.0"."default" or false); }
      { "2.32.0".default = (f.clap."2.32.0".default or true); }
      { "2.32.0".strsim =
        (f.clap."2.32.0".strsim or false) ||
        (f.clap."2.32.0".suggestions or false) ||
        (clap."2.32.0"."suggestions" or false); }
      { "2.32.0".suggestions =
        (f.clap."2.32.0".suggestions or false) ||
        (f.clap."2.32.0".default or false) ||
        (clap."2.32.0"."default" or false); }
      { "2.32.0".term_size =
        (f.clap."2.32.0".term_size or false) ||
        (f.clap."2.32.0".wrap_help or false) ||
        (clap."2.32.0"."wrap_help" or false); }
      { "2.32.0".vec_map =
        (f.clap."2.32.0".vec_map or false) ||
        (f.clap."2.32.0".default or false) ||
        (clap."2.32.0"."default" or false); }
      { "2.32.0".yaml =
        (f.clap."2.32.0".yaml or false) ||
        (f.clap."2.32.0".doc or false) ||
        (clap."2.32.0"."doc" or false); }
      { "2.32.0".yaml-rust =
        (f.clap."2.32.0".yaml-rust or false) ||
        (f.clap."2.32.0".yaml or false) ||
        (clap."2.32.0"."yaml" or false); }
    ];
    strsim."${deps.clap."2.32.0".strsim}".default = true;
    textwrap = fold recursiveUpdate {} [
      { "${deps.clap."2.32.0".textwrap}"."term_size" =
        (f.textwrap."${deps.clap."2.32.0".textwrap}"."term_size" or false) ||
        (clap."2.32.0"."wrap_help" or false) ||
        (f."clap"."2.32.0"."wrap_help" or false); }
      { "${deps.clap."2.32.0".textwrap}".default = true; }
    ];
    unicode_width."${deps.clap."2.32.0".unicode_width}".default = true;
    vec_map."${deps.clap."2.32.0".vec_map}".default = true;
  }) [
    (features_.atty."${deps."clap"."2.32.0"."atty"}" deps)
    (features_.bitflags."${deps."clap"."2.32.0"."bitflags"}" deps)
    (features_.strsim."${deps."clap"."2.32.0"."strsim"}" deps)
    (features_.textwrap."${deps."clap"."2.32.0"."textwrap"}" deps)
    (features_.unicode_width."${deps."clap"."2.32.0"."unicode_width"}" deps)
    (features_.vec_map."${deps."clap"."2.32.0"."vec_map"}" deps)
    (features_.ansi_term."${deps."clap"."2.32.0"."ansi_term"}" deps)
  ];


# end
# cloudabi-0.0.3

  crates.cloudabi."0.0.3" = deps: { features?(features_.cloudabi."0.0.3" deps {}) }: buildRustCrate {
    crateName = "cloudabi";
    version = "0.0.3";
    authors = [ "Nuxi (https://nuxi.nl/) and contributors" ];
    sha256 = "1z9lby5sr6vslfd14d6igk03s7awf91mxpsfmsp3prxbxlk0x7h5";
    libPath = "cloudabi.rs";
    dependencies = mapFeatures features ([
    ]
      ++ (if features.cloudabi."0.0.3".bitflags or false then [ (crates.bitflags."${deps."cloudabi"."0.0.3".bitflags}" deps) ] else []));
    features = mkFeatures (features."cloudabi"."0.0.3" or {});
  };
  features_.cloudabi."0.0.3" = deps: f: updateFeatures f (rec {
    bitflags."${deps.cloudabi."0.0.3".bitflags}".default = true;
    cloudabi = fold recursiveUpdate {} [
      { "0.0.3".bitflags =
        (f.cloudabi."0.0.3".bitflags or false) ||
        (f.cloudabi."0.0.3".default or false) ||
        (cloudabi."0.0.3"."default" or false); }
      { "0.0.3".default = (f.cloudabi."0.0.3".default or true); }
    ];
  }) [
    (features_.bitflags."${deps."cloudabi"."0.0.3"."bitflags"}" deps)
  ];


# end
# dimensioned-0.7.0

  crates.dimensioned."0.7.0" = deps: { features?(features_.dimensioned."0.7.0" deps {}) }: buildRustCrate {
    crateName = "dimensioned";
    version = "0.7.0";
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
      { "0.7.0".approx =
        (f.dimensioned."0.7.0".approx or false) ||
        (f.dimensioned."0.7.0".test or false) ||
        (dimensioned."0.7.0"."test" or false); }
      { "0.7.0".ci =
        (f.dimensioned."0.7.0".ci or false) ||
        (f.dimensioned."0.7.0".test or false) ||
        (dimensioned."0.7.0"."test" or false); }
      { "0.7.0".clapme =
        (f.dimensioned."0.7.0".clapme or false) ||
        (f.dimensioned."0.7.0".test or false) ||
        (dimensioned."0.7.0"."test" or false); }
      { "0.7.0".default = (f.dimensioned."0.7.0".default or true); }
      { "0.7.0".quickcheck =
        (f.dimensioned."0.7.0".quickcheck or false) ||
        (f.dimensioned."0.7.0".test or false) ||
        (dimensioned."0.7.0"."test" or false); }
      { "0.7.0".serde =
        (f.dimensioned."0.7.0".serde or false) ||
        (f.dimensioned."0.7.0".test or false) ||
        (dimensioned."0.7.0"."test" or false); }
      { "0.7.0".serde_test =
        (f.dimensioned."0.7.0".serde_test or false) ||
        (f.dimensioned."0.7.0".test or false) ||
        (dimensioned."0.7.0"."test" or false); }
      { "0.7.0".std =
        (f.dimensioned."0.7.0".std or false) ||
        (f.dimensioned."0.7.0".default or false) ||
        (dimensioned."0.7.0"."default" or false); }
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
# either-1.5.1

  crates.either."1.5.1" = deps: { features?(features_.either."1.5.1" deps {}) }: buildRustCrate {
    crateName = "either";
    version = "1.5.1";
    authors = [ "bluss" ];
    sha256 = "049dmvnyrrhf0fw955jrfazdapdl84x32grwwxllh8in39yv3783";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."either"."1.5.1" or {});
  };
  features_.either."1.5.1" = deps: f: updateFeatures f (rec {
    either = fold recursiveUpdate {} [
      { "1.5.1".default = (f.either."1.5.1".default or true); }
      { "1.5.1".use_std =
        (f.either."1.5.1".use_std or false) ||
        (f.either."1.5.1".default or false) ||
        (either."1.5.1"."default" or false); }
    ];
  }) [];


# end
# emseries-0.4.0

  crates.emseries."0.4.0" = deps: { features?(features_.emseries."0.4.0" deps {}) }: buildRustCrate {
    crateName = "emseries";
    version = "0.4.0";
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
    authors = [ "Erick Tryzelaar <etryzelaar@google.com>" ];
    edition = "2018";
    sha256 = "07apwv9dj716yjlcj29p94vkqn5zmfh7hlrqvrjx3wzshphc95h9";
  };
  features_.fuchsia_cprng."0.1.1" = deps: f: updateFeatures f (rec {
    fuchsia_cprng."0.1.1".default = (f.fuchsia_cprng."0.1.1".default or true);
  }) [];


# end
# generic-array-0.11.1

  crates.generic_array."0.11.1" = deps: { features?(features_.generic_array."0.11.1" deps {}) }: buildRustCrate {
    crateName = "generic-array";
    version = "0.11.1";
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
# heck-0.3.1

  crates.heck."0.3.1" = deps: { features?(features_.heck."0.3.1" deps {}) }: buildRustCrate {
    crateName = "heck";
    version = "0.3.1";
    authors = [ "Without Boats <woboats@gmail.com>" ];
    sha256 = "1q7vmnlh62kls6cvkfhbcacxkawaznaqa5wwm9dg1xkcza846c3d";
    dependencies = mapFeatures features ([
      (crates."unicode_segmentation"."${deps."heck"."0.3.1"."unicode_segmentation"}" deps)
    ]);
  };
  features_.heck."0.3.1" = deps: f: updateFeatures f (rec {
    heck."0.3.1".default = (f.heck."0.3.1".default or true);
    unicode_segmentation."${deps.heck."0.3.1".unicode_segmentation}".default = true;
  }) [
    (features_.unicode_segmentation."${deps."heck"."0.3.1"."unicode_segmentation"}" deps)
  ];


# end
# httparse-1.3.3

  crates.httparse."1.3.3" = deps: { features?(features_.httparse."1.3.3" deps {}) }: buildRustCrate {
    crateName = "httparse";
    version = "1.3.3";
    authors = [ "Sean McArthur <sean@seanmonstar.com>" ];
    sha256 = "1jymxy4bl0mzgp2dx0pzqzbr72sw5jmr5sjqiry4xr88z4z9qlyx";
    build = "build.rs";
    features = mkFeatures (features."httparse"."1.3.3" or {});
  };
  features_.httparse."1.3.3" = deps: f: updateFeatures f (rec {
    httparse = fold recursiveUpdate {} [
      { "1.3.3".default = (f.httparse."1.3.3".default or true); }
      { "1.3.3".std =
        (f.httparse."1.3.3".std or false) ||
        (f.httparse."1.3.3".default or false) ||
        (httparse."1.3.3"."default" or false); }
    ];
  }) [];


# end
# hyper-0.10.15

  crates.hyper."0.10.15" = deps: { features?(features_.hyper."0.10.15" deps {}) }: buildRustCrate {
    crateName = "hyper";
    version = "0.10.15";
    authors = [ "Sean McArthur <sean.monstar@gmail.com>" "Jonathan Reem <jonathan.reem@gmail.com>" ];
    sha256 = "14bf31dwwfvza3kfc4mmk4q0v7iq5ys3hiz7islij1x9g4c53s9p";
    dependencies = mapFeatures features ([
      (crates."base64"."${deps."hyper"."0.10.15"."base64"}" deps)
      (crates."httparse"."${deps."hyper"."0.10.15"."httparse"}" deps)
      (crates."language_tags"."${deps."hyper"."0.10.15"."language_tags"}" deps)
      (crates."log"."${deps."hyper"."0.10.15"."log"}" deps)
      (crates."mime"."${deps."hyper"."0.10.15"."mime"}" deps)
      (crates."num_cpus"."${deps."hyper"."0.10.15"."num_cpus"}" deps)
      (crates."time"."${deps."hyper"."0.10.15"."time"}" deps)
      (crates."traitobject"."${deps."hyper"."0.10.15"."traitobject"}" deps)
      (crates."typeable"."${deps."hyper"."0.10.15"."typeable"}" deps)
      (crates."unicase"."${deps."hyper"."0.10.15"."unicase"}" deps)
      (crates."url"."${deps."hyper"."0.10.15"."url"}" deps)
    ]);
    features = mkFeatures (features."hyper"."0.10.15" or {});
  };
  features_.hyper."0.10.15" = deps: f: updateFeatures f (rec {
    base64."${deps.hyper."0.10.15".base64}".default = true;
    httparse."${deps.hyper."0.10.15".httparse}".default = true;
    hyper."0.10.15".default = (f.hyper."0.10.15".default or true);
    language_tags."${deps.hyper."0.10.15".language_tags}".default = true;
    log."${deps.hyper."0.10.15".log}".default = true;
    mime."${deps.hyper."0.10.15".mime}".default = true;
    num_cpus."${deps.hyper."0.10.15".num_cpus}".default = true;
    time."${deps.hyper."0.10.15".time}".default = true;
    traitobject."${deps.hyper."0.10.15".traitobject}".default = true;
    typeable."${deps.hyper."0.10.15".typeable}".default = true;
    unicase."${deps.hyper."0.10.15".unicase}".default = true;
    url."${deps.hyper."0.10.15".url}".default = true;
  }) [
    (features_.base64."${deps."hyper"."0.10.15"."base64"}" deps)
    (features_.httparse."${deps."hyper"."0.10.15"."httparse"}" deps)
    (features_.language_tags."${deps."hyper"."0.10.15"."language_tags"}" deps)
    (features_.log."${deps."hyper"."0.10.15"."log"}" deps)
    (features_.mime."${deps."hyper"."0.10.15"."mime"}" deps)
    (features_.num_cpus."${deps."hyper"."0.10.15"."num_cpus"}" deps)
    (features_.time."${deps."hyper"."0.10.15"."time"}" deps)
    (features_.traitobject."${deps."hyper"."0.10.15"."traitobject"}" deps)
    (features_.typeable."${deps."hyper"."0.10.15"."typeable"}" deps)
    (features_.unicase."${deps."hyper"."0.10.15"."unicase"}" deps)
    (features_.url."${deps."hyper"."0.10.15"."url"}" deps)
  ];


# end
# idna-0.1.5

  crates.idna."0.1.5" = deps: { features?(features_.idna."0.1.5" deps {}) }: buildRustCrate {
    crateName = "idna";
    version = "0.1.5";
    authors = [ "The rust-url developers" ];
    sha256 = "1gwgl19rz5vzi67rrhamczhxy050f5ynx4ybabfapyalv7z1qmjy";
    dependencies = mapFeatures features ([
      (crates."matches"."${deps."idna"."0.1.5"."matches"}" deps)
      (crates."unicode_bidi"."${deps."idna"."0.1.5"."unicode_bidi"}" deps)
      (crates."unicode_normalization"."${deps."idna"."0.1.5"."unicode_normalization"}" deps)
    ]);
  };
  features_.idna."0.1.5" = deps: f: updateFeatures f (rec {
    idna."0.1.5".default = (f.idna."0.1.5".default or true);
    matches."${deps.idna."0.1.5".matches}".default = true;
    unicode_bidi."${deps.idna."0.1.5".unicode_bidi}".default = true;
    unicode_normalization."${deps.idna."0.1.5".unicode_normalization}".default = true;
  }) [
    (features_.matches."${deps."idna"."0.1.5"."matches"}" deps)
    (features_.unicode_bidi."${deps."idna"."0.1.5"."unicode_bidi"}" deps)
    (features_.unicode_normalization."${deps."idna"."0.1.5"."unicode_normalization"}" deps)
  ];


# end
# iron-0.6.0

  crates.iron."0.6.0" = deps: { features?(features_.iron."0.6.0" deps {}) }: buildRustCrate {
    crateName = "iron";
    version = "0.6.0";
    authors = [ "Jonathan Reem <jonathan.reem@gmail.com>" "Zach Pomerantz <zmp@umich.edu>" "Michael Sproul <micsproul@gmail.com>" "Patrick Tran <patrick.tran06@gmail.com>" ];
    sha256 = "0yf3j2wvb58q6h25mvyzy18i49ap1d6c3zr52vgj5chld0b7infj";
    libPath = "src/lib.rs";
    dependencies = mapFeatures features ([
      (crates."hyper"."${deps."iron"."0.6.0"."hyper"}" deps)
      (crates."log"."${deps."iron"."0.6.0"."log"}" deps)
      (crates."mime_guess"."${deps."iron"."0.6.0"."mime_guess"}" deps)
      (crates."modifier"."${deps."iron"."0.6.0"."modifier"}" deps)
      (crates."num_cpus"."${deps."iron"."0.6.0"."num_cpus"}" deps)
      (crates."plugin"."${deps."iron"."0.6.0"."plugin"}" deps)
      (crates."typemap"."${deps."iron"."0.6.0"."typemap"}" deps)
      (crates."url"."${deps."iron"."0.6.0"."url"}" deps)
    ]);
    features = mkFeatures (features."iron"."0.6.0" or {});
  };
  features_.iron."0.6.0" = deps: f: updateFeatures f (rec {
    hyper."${deps.iron."0.6.0".hyper}".default = true;
    iron = fold recursiveUpdate {} [
      { "0.6.0".default = (f.iron."0.6.0".default or true); }
      { "0.6.0".hyper-native-tls =
        (f.iron."0.6.0".hyper-native-tls or false) ||
        (f.iron."0.6.0".native-tls-example or false) ||
        (iron."0.6.0"."native-tls-example" or false); }
    ];
    log."${deps.iron."0.6.0".log}".default = true;
    mime_guess."${deps.iron."0.6.0".mime_guess}".default = true;
    modifier."${deps.iron."0.6.0".modifier}".default = true;
    num_cpus."${deps.iron."0.6.0".num_cpus}".default = true;
    plugin."${deps.iron."0.6.0".plugin}".default = true;
    typemap."${deps.iron."0.6.0".typemap}".default = true;
    url."${deps.iron."0.6.0".url}".default = true;
  }) [
    (features_.hyper."${deps."iron"."0.6.0"."hyper"}" deps)
    (features_.log."${deps."iron"."0.6.0"."log"}" deps)
    (features_.mime_guess."${deps."iron"."0.6.0"."mime_guess"}" deps)
    (features_.modifier."${deps."iron"."0.6.0"."modifier"}" deps)
    (features_.num_cpus."${deps."iron"."0.6.0"."num_cpus"}" deps)
    (features_.plugin."${deps."iron"."0.6.0"."plugin"}" deps)
    (features_.typemap."${deps."iron"."0.6.0"."typemap"}" deps)
    (features_.url."${deps."iron"."0.6.0"."url"}" deps)
  ];


# end
# iron-cors-0.8.0

  crates.iron_cors."0.8.0" = deps: { features?(features_.iron_cors."0.8.0" deps {}) }: buildRustCrate {
    crateName = "iron-cors";
    version = "0.8.0";
    authors = [ "Danilo Bargen <mail@dbrgn.ch>" ];
    sha256 = "0b5rj0r9r447zg4ypyglvvl0jlvmznmqn6mvfjd11045l0lw486z";
    dependencies = mapFeatures features ([
      (crates."iron"."${deps."iron_cors"."0.8.0"."iron"}" deps)
      (crates."log"."${deps."iron_cors"."0.8.0"."log"}" deps)
    ]);
  };
  features_.iron_cors."0.8.0" = deps: f: updateFeatures f (rec {
    iron."${deps.iron_cors."0.8.0".iron}".default = true;
    iron_cors."0.8.0".default = (f.iron_cors."0.8.0".default or true);
    log."${deps.iron_cors."0.8.0".log}".default = true;
  }) [
    (features_.iron."${deps."iron_cors"."0.8.0"."iron"}" deps)
    (features_.log."${deps."iron_cors"."0.8.0"."log"}" deps)
  ];


# end
# itertools-0.7.11

  crates.itertools."0.7.11" = deps: { features?(features_.itertools."0.7.11" deps {}) }: buildRustCrate {
    crateName = "itertools";
    version = "0.7.11";
    authors = [ "bluss" ];
    sha256 = "0gavmkvn2c3cwfwk5zl5p7saiqn4ww227am5ykn6pgfm7c6ppz56";
    dependencies = mapFeatures features ([
      (crates."either"."${deps."itertools"."0.7.11"."either"}" deps)
    ]);
    features = mkFeatures (features."itertools"."0.7.11" or {});
  };
  features_.itertools."0.7.11" = deps: f: updateFeatures f (rec {
    either."${deps.itertools."0.7.11".either}".default = (f.either."${deps.itertools."0.7.11".either}".default or false);
    itertools = fold recursiveUpdate {} [
      { "0.7.11".default = (f.itertools."0.7.11".default or true); }
      { "0.7.11".use_std =
        (f.itertools."0.7.11".use_std or false) ||
        (f.itertools."0.7.11".default or false) ||
        (itertools."0.7.11"."default" or false); }
    ];
  }) [
    (features_.either."${deps."itertools"."0.7.11"."either"}" deps)
  ];


# end
# itoa-0.4.3

  crates.itoa."0.4.3" = deps: { features?(features_.itoa."0.4.3" deps {}) }: buildRustCrate {
    crateName = "itoa";
    version = "0.4.3";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "0zadimmdgvili3gdwxqg7ljv3r4wcdg1kkdfp9nl15vnm23vrhy1";
    features = mkFeatures (features."itoa"."0.4.3" or {});
  };
  features_.itoa."0.4.3" = deps: f: updateFeatures f (rec {
    itoa = fold recursiveUpdate {} [
      { "0.4.3".default = (f.itoa."0.4.3".default or true); }
      { "0.4.3".std =
        (f.itoa."0.4.3".std or false) ||
        (f.itoa."0.4.3".default or false) ||
        (itoa."0.4.3"."default" or false); }
    ];
  }) [];


# end
# jsonwebtoken-5.0.1

  crates.jsonwebtoken."5.0.1" = deps: { features?(features_.jsonwebtoken."5.0.1" deps {}) }: buildRustCrate {
    crateName = "jsonwebtoken";
    version = "5.0.1";
    authors = [ "Vincent Prouillet <prouillet.vincent@gmail.com>" ];
    sha256 = "09jpcc86zpwdm41g45p5l4na4s48cn6ggcsaq8clfmqv0754c6id";
    dependencies = mapFeatures features ([
      (crates."base64"."${deps."jsonwebtoken"."5.0.1"."base64"}" deps)
      (crates."chrono"."${deps."jsonwebtoken"."5.0.1"."chrono"}" deps)
      (crates."ring"."${deps."jsonwebtoken"."5.0.1"."ring"}" deps)
      (crates."serde"."${deps."jsonwebtoken"."5.0.1"."serde"}" deps)
      (crates."serde_derive"."${deps."jsonwebtoken"."5.0.1"."serde_derive"}" deps)
      (crates."serde_json"."${deps."jsonwebtoken"."5.0.1"."serde_json"}" deps)
      (crates."untrusted"."${deps."jsonwebtoken"."5.0.1"."untrusted"}" deps)
    ]);
  };
  features_.jsonwebtoken."5.0.1" = deps: f: updateFeatures f (rec {
    base64."${deps.jsonwebtoken."5.0.1".base64}".default = true;
    chrono."${deps.jsonwebtoken."5.0.1".chrono}".default = true;
    jsonwebtoken."5.0.1".default = (f.jsonwebtoken."5.0.1".default or true);
    ring = fold recursiveUpdate {} [
      { "${deps.jsonwebtoken."5.0.1".ring}"."dev_urandom_fallback" = true; }
      { "${deps.jsonwebtoken."5.0.1".ring}"."rsa_signing" = true; }
      { "${deps.jsonwebtoken."5.0.1".ring}".default = true; }
    ];
    serde."${deps.jsonwebtoken."5.0.1".serde}".default = true;
    serde_derive."${deps.jsonwebtoken."5.0.1".serde_derive}".default = true;
    serde_json."${deps.jsonwebtoken."5.0.1".serde_json}".default = true;
    untrusted."${deps.jsonwebtoken."5.0.1".untrusted}".default = true;
  }) [
    (features_.base64."${deps."jsonwebtoken"."5.0.1"."base64"}" deps)
    (features_.chrono."${deps."jsonwebtoken"."5.0.1"."chrono"}" deps)
    (features_.ring."${deps."jsonwebtoken"."5.0.1"."ring"}" deps)
    (features_.serde."${deps."jsonwebtoken"."5.0.1"."serde"}" deps)
    (features_.serde_derive."${deps."jsonwebtoken"."5.0.1"."serde_derive"}" deps)
    (features_.serde_json."${deps."jsonwebtoken"."5.0.1"."serde_json"}" deps)
    (features_.untrusted."${deps."jsonwebtoken"."5.0.1"."untrusted"}" deps)
  ];


# end
# language-tags-0.2.2

  crates.language_tags."0.2.2" = deps: { features?(features_.language_tags."0.2.2" deps {}) }: buildRustCrate {
    crateName = "language-tags";
    version = "0.2.2";
    authors = [ "Pyfisch <pyfisch@gmail.com>" ];
    sha256 = "1zkrdzsqzzc7509kd7nngdwrp461glm2g09kqpzaqksp82frjdvy";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."language_tags"."0.2.2" or {});
  };
  features_.language_tags."0.2.2" = deps: f: updateFeatures f (rec {
    language_tags = fold recursiveUpdate {} [
      { "0.2.2".default = (f.language_tags."0.2.2".default or true); }
      { "0.2.2".heapsize =
        (f.language_tags."0.2.2".heapsize or false) ||
        (f.language_tags."0.2.2".heap_size or false) ||
        (language_tags."0.2.2"."heap_size" or false); }
      { "0.2.2".heapsize_plugin =
        (f.language_tags."0.2.2".heapsize_plugin or false) ||
        (f.language_tags."0.2.2".heap_size or false) ||
        (language_tags."0.2.2"."heap_size" or false); }
    ];
  }) [];


# end
# lazy_static-1.3.0

  crates.lazy_static."1.3.0" = deps: { features?(features_.lazy_static."1.3.0" deps {}) }: buildRustCrate {
    crateName = "lazy_static";
    version = "1.3.0";
    authors = [ "Marvin Löbel <loebel.marvin@gmail.com>" ];
    sha256 = "1vv47va18ydk7dx5paz88g3jy1d3lwbx6qpxkbj8gyfv770i4b1y";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."lazy_static"."1.3.0" or {});
  };
  features_.lazy_static."1.3.0" = deps: f: updateFeatures f (rec {
    lazy_static = fold recursiveUpdate {} [
      { "1.3.0".default = (f.lazy_static."1.3.0".default or true); }
      { "1.3.0".spin =
        (f.lazy_static."1.3.0".spin or false) ||
        (f.lazy_static."1.3.0".spin_no_std or false) ||
        (lazy_static."1.3.0"."spin_no_std" or false); }
    ];
  }) [];


# end
# libc-0.2.50

  crates.libc."0.2.50" = deps: { features?(features_.libc."0.2.50" deps {}) }: buildRustCrate {
    crateName = "libc";
    version = "0.2.50";
    authors = [ "The Rust Project Developers" ];
    sha256 = "14y4zm0xp2xbj3l1kxqf2wpl58xb7hglxdbfx5dcxjlchbvk5dzs";
    build = "build.rs";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."libc"."0.2.50" or {});
  };
  features_.libc."0.2.50" = deps: f: updateFeatures f (rec {
    libc = fold recursiveUpdate {} [
      { "0.2.50".align =
        (f.libc."0.2.50".align or false) ||
        (f.libc."0.2.50".rustc-dep-of-std or false) ||
        (libc."0.2.50"."rustc-dep-of-std" or false); }
      { "0.2.50".default = (f.libc."0.2.50".default or true); }
      { "0.2.50".rustc-std-workspace-core =
        (f.libc."0.2.50".rustc-std-workspace-core or false) ||
        (f.libc."0.2.50".rustc-dep-of-std or false) ||
        (libc."0.2.50"."rustc-dep-of-std" or false); }
      { "0.2.50".use_std =
        (f.libc."0.2.50".use_std or false) ||
        (f.libc."0.2.50".default or false) ||
        (libc."0.2.50"."default" or false); }
    ];
  }) [];


# end
# linked-hash-map-0.5.1

  crates.linked_hash_map."0.5.1" = deps: { features?(features_.linked_hash_map."0.5.1" deps {}) }: buildRustCrate {
    crateName = "linked-hash-map";
    version = "0.5.1";
    authors = [ "Stepan Koltsov <stepan.koltsov@gmail.com>" "Andrew Paseltiner <apaseltiner@gmail.com>" ];
    sha256 = "1f29c7j53z7w5v0g115yii9dmmbsahr93ak375g48vi75v3p4030";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."linked_hash_map"."0.5.1" or {});
  };
  features_.linked_hash_map."0.5.1" = deps: f: updateFeatures f (rec {
    linked_hash_map = fold recursiveUpdate {} [
      { "0.5.1".default = (f.linked_hash_map."0.5.1".default or true); }
      { "0.5.1".heapsize =
        (f.linked_hash_map."0.5.1".heapsize or false) ||
        (f.linked_hash_map."0.5.1".heapsize_impl or false) ||
        (linked_hash_map."0.5.1"."heapsize_impl" or false); }
      { "0.5.1".serde =
        (f.linked_hash_map."0.5.1".serde or false) ||
        (f.linked_hash_map."0.5.1".serde_impl or false) ||
        (linked_hash_map."0.5.1"."serde_impl" or false); }
      { "0.5.1".serde_test =
        (f.linked_hash_map."0.5.1".serde_test or false) ||
        (f.linked_hash_map."0.5.1".serde_impl or false) ||
        (linked_hash_map."0.5.1"."serde_impl" or false); }
    ];
  }) [];


# end
# log-0.3.9

  crates.log."0.3.9" = deps: { features?(features_.log."0.3.9" deps {}) }: buildRustCrate {
    crateName = "log";
    version = "0.3.9";
    authors = [ "The Rust Project Developers" ];
    sha256 = "19i9pwp7lhaqgzangcpw00kc3zsgcqcx84crv07xgz3v7d3kvfa2";
    dependencies = mapFeatures features ([
      (crates."log"."${deps."log"."0.3.9"."log"}" deps)
    ]);
    features = mkFeatures (features."log"."0.3.9" or {});
  };
  features_.log."0.3.9" = deps: f: updateFeatures f (rec {
    log = fold recursiveUpdate {} [
      { "${deps.log."0.3.9".log}"."max_level_debug" =
        (f.log."${deps.log."0.3.9".log}"."max_level_debug" or false) ||
        (log."0.3.9"."max_level_debug" or false) ||
        (f."log"."0.3.9"."max_level_debug" or false); }
      { "${deps.log."0.3.9".log}"."max_level_error" =
        (f.log."${deps.log."0.3.9".log}"."max_level_error" or false) ||
        (log."0.3.9"."max_level_error" or false) ||
        (f."log"."0.3.9"."max_level_error" or false); }
      { "${deps.log."0.3.9".log}"."max_level_info" =
        (f.log."${deps.log."0.3.9".log}"."max_level_info" or false) ||
        (log."0.3.9"."max_level_info" or false) ||
        (f."log"."0.3.9"."max_level_info" or false); }
      { "${deps.log."0.3.9".log}"."max_level_off" =
        (f.log."${deps.log."0.3.9".log}"."max_level_off" or false) ||
        (log."0.3.9"."max_level_off" or false) ||
        (f."log"."0.3.9"."max_level_off" or false); }
      { "${deps.log."0.3.9".log}"."max_level_trace" =
        (f.log."${deps.log."0.3.9".log}"."max_level_trace" or false) ||
        (log."0.3.9"."max_level_trace" or false) ||
        (f."log"."0.3.9"."max_level_trace" or false); }
      { "${deps.log."0.3.9".log}"."max_level_warn" =
        (f.log."${deps.log."0.3.9".log}"."max_level_warn" or false) ||
        (log."0.3.9"."max_level_warn" or false) ||
        (f."log"."0.3.9"."max_level_warn" or false); }
      { "${deps.log."0.3.9".log}"."release_max_level_debug" =
        (f.log."${deps.log."0.3.9".log}"."release_max_level_debug" or false) ||
        (log."0.3.9"."release_max_level_debug" or false) ||
        (f."log"."0.3.9"."release_max_level_debug" or false); }
      { "${deps.log."0.3.9".log}"."release_max_level_error" =
        (f.log."${deps.log."0.3.9".log}"."release_max_level_error" or false) ||
        (log."0.3.9"."release_max_level_error" or false) ||
        (f."log"."0.3.9"."release_max_level_error" or false); }
      { "${deps.log."0.3.9".log}"."release_max_level_info" =
        (f.log."${deps.log."0.3.9".log}"."release_max_level_info" or false) ||
        (log."0.3.9"."release_max_level_info" or false) ||
        (f."log"."0.3.9"."release_max_level_info" or false); }
      { "${deps.log."0.3.9".log}"."release_max_level_off" =
        (f.log."${deps.log."0.3.9".log}"."release_max_level_off" or false) ||
        (log."0.3.9"."release_max_level_off" or false) ||
        (f."log"."0.3.9"."release_max_level_off" or false); }
      { "${deps.log."0.3.9".log}"."release_max_level_trace" =
        (f.log."${deps.log."0.3.9".log}"."release_max_level_trace" or false) ||
        (log."0.3.9"."release_max_level_trace" or false) ||
        (f."log"."0.3.9"."release_max_level_trace" or false); }
      { "${deps.log."0.3.9".log}"."release_max_level_warn" =
        (f.log."${deps.log."0.3.9".log}"."release_max_level_warn" or false) ||
        (log."0.3.9"."release_max_level_warn" or false) ||
        (f."log"."0.3.9"."release_max_level_warn" or false); }
      { "${deps.log."0.3.9".log}"."std" =
        (f.log."${deps.log."0.3.9".log}"."std" or false) ||
        (log."0.3.9"."use_std" or false) ||
        (f."log"."0.3.9"."use_std" or false); }
      { "${deps.log."0.3.9".log}".default = true; }
      { "0.3.9".default = (f.log."0.3.9".default or true); }
      { "0.3.9".use_std =
        (f.log."0.3.9".use_std or false) ||
        (f.log."0.3.9".default or false) ||
        (log."0.3.9"."default" or false); }
    ];
  }) [
    (features_.log."${deps."log"."0.3.9"."log"}" deps)
  ];


# end
# log-0.4.6

  crates.log."0.4.6" = deps: { features?(features_.log."0.4.6" deps {}) }: buildRustCrate {
    crateName = "log";
    version = "0.4.6";
    authors = [ "The Rust Project Developers" ];
    sha256 = "1nd8dl9mvc9vd6fks5d4gsxaz990xi6rzlb8ymllshmwi153vngr";
    dependencies = mapFeatures features ([
      (crates."cfg_if"."${deps."log"."0.4.6"."cfg_if"}" deps)
    ]);
    features = mkFeatures (features."log"."0.4.6" or {});
  };
  features_.log."0.4.6" = deps: f: updateFeatures f (rec {
    cfg_if."${deps.log."0.4.6".cfg_if}".default = true;
    log."0.4.6".default = (f.log."0.4.6".default or true);
  }) [
    (features_.cfg_if."${deps."log"."0.4.6"."cfg_if"}" deps)
  ];


# end
# matches-0.1.8

  crates.matches."0.1.8" = deps: { features?(features_.matches."0.1.8" deps {}) }: buildRustCrate {
    crateName = "matches";
    version = "0.1.8";
    authors = [ "Simon Sapin <simon.sapin@exyr.org>" ];
    sha256 = "03hl636fg6xggy0a26200xs74amk3k9n0908rga2szn68agyz3cv";
    libPath = "lib.rs";
  };
  features_.matches."0.1.8" = deps: f: updateFeatures f (rec {
    matches."0.1.8".default = (f.matches."0.1.8".default or true);
  }) [];


# end
# memchr-1.0.2

  crates.memchr."1.0.2" = deps: { features?(features_.memchr."1.0.2" deps {}) }: buildRustCrate {
    crateName = "memchr";
    version = "1.0.2";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" "bluss" ];
    sha256 = "0dfb8ifl9nrc9kzgd5z91q6qg87sh285q1ih7xgrsglmqfav9lg7";
    dependencies = mapFeatures features ([
    ]
      ++ (if features.memchr."1.0.2".libc or false then [ (crates.libc."${deps."memchr"."1.0.2".libc}" deps) ] else []));
    features = mkFeatures (features."memchr"."1.0.2" or {});
  };
  features_.memchr."1.0.2" = deps: f: updateFeatures f (rec {
    libc = fold recursiveUpdate {} [
      { "${deps.memchr."1.0.2".libc}"."use_std" =
        (f.libc."${deps.memchr."1.0.2".libc}"."use_std" or false) ||
        (memchr."1.0.2"."use_std" or false) ||
        (f."memchr"."1.0.2"."use_std" or false); }
      { "${deps.memchr."1.0.2".libc}".default = (f.libc."${deps.memchr."1.0.2".libc}".default or false); }
    ];
    memchr = fold recursiveUpdate {} [
      { "1.0.2".default = (f.memchr."1.0.2".default or true); }
      { "1.0.2".libc =
        (f.memchr."1.0.2".libc or false) ||
        (f.memchr."1.0.2".default or false) ||
        (memchr."1.0.2"."default" or false) ||
        (f.memchr."1.0.2".use_std or false) ||
        (memchr."1.0.2"."use_std" or false); }
      { "1.0.2".use_std =
        (f.memchr."1.0.2".use_std or false) ||
        (f.memchr."1.0.2".default or false) ||
        (memchr."1.0.2"."default" or false); }
    ];
  }) [
    (features_.libc."${deps."memchr"."1.0.2"."libc"}" deps)
  ];


# end
# memchr-2.2.0

  crates.memchr."2.2.0" = deps: { features?(features_.memchr."2.2.0" deps {}) }: buildRustCrate {
    crateName = "memchr";
    version = "2.2.0";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" "bluss" ];
    sha256 = "11vwg8iig9jyjxq3n1cq15g29ikzw5l7ar87md54k1aisjs0997p";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."memchr"."2.2.0" or {});
  };
  features_.memchr."2.2.0" = deps: f: updateFeatures f (rec {
    memchr = fold recursiveUpdate {} [
      { "2.2.0".default = (f.memchr."2.2.0".default or true); }
      { "2.2.0".use_std =
        (f.memchr."2.2.0".use_std or false) ||
        (f.memchr."2.2.0".default or false) ||
        (memchr."2.2.0"."default" or false); }
    ];
  }) [];


# end
# micrologger-0.1.0

  crates.micrologger."0.1.0" = deps: { features?(features_.micrologger."0.1.0" deps {}) }: buildRustCrate {
    crateName = "micrologger";
    version = "0.1.0";
    authors = [ "Savanni D'Gerinel <savanni@luminescent-dreams.com>" ];
    sha256 = "18sdy0vdldpv2kbivl1zarcpxfd6646xmw217bnry0j3g35rq4x3";
    dependencies = mapFeatures features ([
      (crates."chrono"."${deps."micrologger"."0.1.0"."chrono"}" deps)
      (crates."serde"."${deps."micrologger"."0.1.0"."serde"}" deps)
      (crates."serde_derive"."${deps."micrologger"."0.1.0"."serde_derive"}" deps)
      (crates."serde_json"."${deps."micrologger"."0.1.0"."serde_json"}" deps)
    ]);
  };
  features_.micrologger."0.1.0" = deps: f: updateFeatures f (rec {
    chrono = fold recursiveUpdate {} [
      { "${deps.micrologger."0.1.0".chrono}"."serde" = true; }
      { "${deps.micrologger."0.1.0".chrono}".default = true; }
    ];
    micrologger."0.1.0".default = (f.micrologger."0.1.0".default or true);
    serde."${deps.micrologger."0.1.0".serde}".default = true;
    serde_derive."${deps.micrologger."0.1.0".serde_derive}".default = true;
    serde_json."${deps.micrologger."0.1.0".serde_json}".default = true;
  }) [
    (features_.chrono."${deps."micrologger"."0.1.0"."chrono"}" deps)
    (features_.serde."${deps."micrologger"."0.1.0"."serde"}" deps)
    (features_.serde_derive."${deps."micrologger"."0.1.0"."serde_derive"}" deps)
    (features_.serde_json."${deps."micrologger"."0.1.0"."serde_json"}" deps)
  ];


# end
# mime-0.2.6

  crates.mime."0.2.6" = deps: { features?(features_.mime."0.2.6" deps {}) }: buildRustCrate {
    crateName = "mime";
    version = "0.2.6";
    authors = [ "Sean McArthur <sean.monstar@gmail.com>" ];
    sha256 = "1skwwa0j3kqd8rm9387zgabjhp07zj99q71nzlhba4lrz9r911b3";
    dependencies = mapFeatures features ([
      (crates."log"."${deps."mime"."0.2.6"."log"}" deps)
    ]);
    features = mkFeatures (features."mime"."0.2.6" or {});
  };
  features_.mime."0.2.6" = deps: f: updateFeatures f (rec {
    log."${deps.mime."0.2.6".log}".default = true;
    mime = fold recursiveUpdate {} [
      { "0.2.6".default = (f.mime."0.2.6".default or true); }
      { "0.2.6".heapsize =
        (f.mime."0.2.6".heapsize or false) ||
        (f.mime."0.2.6".heap_size or false) ||
        (mime."0.2.6"."heap_size" or false); }
    ];
  }) [
    (features_.log."${deps."mime"."0.2.6"."log"}" deps)
  ];


# end
# mime_guess-1.8.6

  crates.mime_guess."1.8.6" = deps: { features?(features_.mime_guess."1.8.6" deps {}) }: buildRustCrate {
    crateName = "mime_guess";
    version = "1.8.6";
    authors = [ "Austin Bonander <austin.bonander@gmail.com>" ];
    sha256 = "0jh41m556lja23b139a4m5lgzydm3sc7msrfx4a64999hq19567l";
    dependencies = mapFeatures features ([
      (crates."mime"."${deps."mime_guess"."1.8.6"."mime"}" deps)
      (crates."phf"."${deps."mime_guess"."1.8.6"."phf"}" deps)
      (crates."unicase"."${deps."mime_guess"."1.8.6"."unicase"}" deps)
    ]);

    buildDependencies = mapFeatures features ([
      (crates."phf_codegen"."${deps."mime_guess"."1.8.6"."phf_codegen"}" deps)
      (crates."unicase"."${deps."mime_guess"."1.8.6"."unicase"}" deps)
    ]);
    features = mkFeatures (features."mime_guess"."1.8.6" or {});
  };
  features_.mime_guess."1.8.6" = deps: f: updateFeatures f (rec {
    mime."${deps.mime_guess."1.8.6".mime}".default = true;
    mime_guess."1.8.6".default = (f.mime_guess."1.8.6".default or true);
    phf = fold recursiveUpdate {} [
      { "${deps.mime_guess."1.8.6".phf}"."unicase" = true; }
      { "${deps.mime_guess."1.8.6".phf}".default = true; }
    ];
    phf_codegen."${deps.mime_guess."1.8.6".phf_codegen}".default = true;
    unicase."${deps.mime_guess."1.8.6".unicase}".default = true;
  }) [
    (features_.mime."${deps."mime_guess"."1.8.6"."mime"}" deps)
    (features_.phf."${deps."mime_guess"."1.8.6"."phf"}" deps)
    (features_.unicase."${deps."mime_guess"."1.8.6"."unicase"}" deps)
    (features_.phf_codegen."${deps."mime_guess"."1.8.6"."phf_codegen"}" deps)
    (features_.unicase."${deps."mime_guess"."1.8.6"."unicase"}" deps)
  ];


# end
# modifier-0.1.0

  crates.modifier."0.1.0" = deps: { features?(features_.modifier."0.1.0" deps {}) }: buildRustCrate {
    crateName = "modifier";
    version = "0.1.0";
    authors = [ "Jonathan Reem <jonathan.reem@gmail.com>" ];
    sha256 = "1zicszfn54wir5nf40jmpq55in2s7xcdqn496wpgj7ckxyh82gfd";
  };
  features_.modifier."0.1.0" = deps: f: updateFeatures f (rec {
    modifier."0.1.0".default = (f.modifier."0.1.0".default or true);
  }) [];


# end
# multipart-0.13.6

  crates.multipart."0.13.6" = deps: { features?(features_.multipart."0.13.6" deps {}) }: buildRustCrate {
    crateName = "multipart";
    version = "0.13.6";
    authors = [ "Austin Bonander <austin.bonander@gmail.com>" ];
    sha256 = "1lw6dinvzaw8yx9a7s1nji4mqyhr71vcj50c80bjc41nidggnan5";
    dependencies = mapFeatures features ([
      (crates."log"."${deps."multipart"."0.13.6"."log"}" deps)
      (crates."mime"."${deps."multipart"."0.13.6"."mime"}" deps)
      (crates."mime_guess"."${deps."multipart"."0.13.6"."mime_guess"}" deps)
      (crates."rand"."${deps."multipart"."0.13.6"."rand"}" deps)
      (crates."tempdir"."${deps."multipart"."0.13.6"."tempdir"}" deps)
    ]
      ++ (if features.multipart."0.13.6".buf_redux or false then [ (crates.buf_redux."${deps."multipart"."0.13.6".buf_redux}" deps) ] else [])
      ++ (if features.multipart."0.13.6".httparse or false then [ (crates.httparse."${deps."multipart"."0.13.6".httparse}" deps) ] else [])
      ++ (if features.multipart."0.13.6".safemem or false then [ (crates.safemem."${deps."multipart"."0.13.6".safemem}" deps) ] else [])
      ++ (if features.multipart."0.13.6".twoway or false then [ (crates.twoway."${deps."multipart"."0.13.6".twoway}" deps) ] else []));
    features = mkFeatures (features."multipart"."0.13.6" or {});
  };
  features_.multipart."0.13.6" = deps: f: updateFeatures f (rec {
    buf_redux."${deps.multipart."0.13.6".buf_redux}".default = true;
    httparse."${deps.multipart."0.13.6".httparse}".default = true;
    log."${deps.multipart."0.13.6".log}".default = true;
    mime."${deps.multipart."0.13.6".mime}".default = true;
    mime_guess."${deps.multipart."0.13.6".mime_guess}".default = true;
    multipart = fold recursiveUpdate {} [
      { "0.13.6".all =
        (f.multipart."0.13.6".all or false) ||
        (f.multipart."0.13.6".default or false) ||
        (multipart."0.13.6"."default" or false); }
      { "0.13.6".buf_redux =
        (f.multipart."0.13.6".buf_redux or false) ||
        (f.multipart."0.13.6".server or false) ||
        (multipart."0.13.6"."server" or false); }
      { "0.13.6".client =
        (f.multipart."0.13.6".client or false) ||
        (f.multipart."0.13.6".all or false) ||
        (multipart."0.13.6"."all" or false); }
      { "0.13.6".default = (f.multipart."0.13.6".default or true); }
      { "0.13.6".httparse =
        (f.multipart."0.13.6".httparse or false) ||
        (f.multipart."0.13.6".server or false) ||
        (multipart."0.13.6"."server" or false); }
      { "0.13.6".hyper =
        (f.multipart."0.13.6".hyper or false) ||
        (f.multipart."0.13.6".all or false) ||
        (multipart."0.13.6"."all" or false); }
      { "0.13.6".iron =
        (f.multipart."0.13.6".iron or false) ||
        (f.multipart."0.13.6".all or false) ||
        (multipart."0.13.6"."all" or false); }
      { "0.13.6".mock =
        (f.multipart."0.13.6".mock or false) ||
        (f.multipart."0.13.6".all or false) ||
        (multipart."0.13.6"."all" or false); }
      { "0.13.6".nightly =
        (f.multipart."0.13.6".nightly or false) ||
        (f.multipart."0.13.6".sse4 or false) ||
        (multipart."0.13.6"."sse4" or false); }
      { "0.13.6".safemem =
        (f.multipart."0.13.6".safemem or false) ||
        (f.multipart."0.13.6".server or false) ||
        (multipart."0.13.6"."server" or false); }
      { "0.13.6".server =
        (f.multipart."0.13.6".server or false) ||
        (f.multipart."0.13.6".all or false) ||
        (multipart."0.13.6"."all" or false); }
      { "0.13.6".tiny_http =
        (f.multipart."0.13.6".tiny_http or false) ||
        (f.multipart."0.13.6".all or false) ||
        (multipart."0.13.6"."all" or false); }
      { "0.13.6".twoway =
        (f.multipart."0.13.6".twoway or false) ||
        (f.multipart."0.13.6".server or false) ||
        (multipart."0.13.6"."server" or false); }
    ];
    rand."${deps.multipart."0.13.6".rand}".default = true;
    safemem."${deps.multipart."0.13.6".safemem}".default = true;
    tempdir."${deps.multipart."0.13.6".tempdir}".default = true;
    twoway = fold recursiveUpdate {} [
      { "${deps.multipart."0.13.6".twoway}"."pcmp" =
        (f.twoway."${deps.multipart."0.13.6".twoway}"."pcmp" or false) ||
        (multipart."0.13.6"."sse4" or false) ||
        (f."multipart"."0.13.6"."sse4" or false); }
      { "${deps.multipart."0.13.6".twoway}".default = true; }
    ];
  }) [
    (features_.buf_redux."${deps."multipart"."0.13.6"."buf_redux"}" deps)
    (features_.httparse."${deps."multipart"."0.13.6"."httparse"}" deps)
    (features_.log."${deps."multipart"."0.13.6"."log"}" deps)
    (features_.mime."${deps."multipart"."0.13.6"."mime"}" deps)
    (features_.mime_guess."${deps."multipart"."0.13.6"."mime_guess"}" deps)
    (features_.rand."${deps."multipart"."0.13.6"."rand"}" deps)
    (features_.safemem."${deps."multipart"."0.13.6"."safemem"}" deps)
    (features_.tempdir."${deps."multipart"."0.13.6"."tempdir"}" deps)
    (features_.twoway."${deps."multipart"."0.13.6"."twoway"}" deps)
  ];


# end
# num-0.1.42

  crates.num."0.1.42" = deps: { features?(features_.num."0.1.42" deps {}) }: buildRustCrate {
    crateName = "num";
    version = "0.1.42";
    authors = [ "The Rust Project Developers" ];
    sha256 = "1632gczzrmmxdsj3jignwcr793jq8vxw3qkdzpdvbip3vaf1ljgq";
    dependencies = mapFeatures features ([
      (crates."num_integer"."${deps."num"."0.1.42"."num_integer"}" deps)
      (crates."num_iter"."${deps."num"."0.1.42"."num_iter"}" deps)
      (crates."num_traits"."${deps."num"."0.1.42"."num_traits"}" deps)
    ]
      ++ (if features.num."0.1.42".num-bigint or false then [ (crates.num_bigint."${deps."num"."0.1.42".num_bigint}" deps) ] else [])
      ++ (if features.num."0.1.42".num-complex or false then [ (crates.num_complex."${deps."num"."0.1.42".num_complex}" deps) ] else [])
      ++ (if features.num."0.1.42".num-rational or false then [ (crates.num_rational."${deps."num"."0.1.42".num_rational}" deps) ] else []));
    features = mkFeatures (features."num"."0.1.42" or {});
  };
  features_.num."0.1.42" = deps: f: updateFeatures f (rec {
    num = fold recursiveUpdate {} [
      { "0.1.42".bigint =
        (f.num."0.1.42".bigint or false) ||
        (f.num."0.1.42".default or false) ||
        (num."0.1.42"."default" or false); }
      { "0.1.42".complex =
        (f.num."0.1.42".complex or false) ||
        (f.num."0.1.42".default or false) ||
        (num."0.1.42"."default" or false); }
      { "0.1.42".default = (f.num."0.1.42".default or true); }
      { "0.1.42".num-bigint =
        (f.num."0.1.42".num-bigint or false) ||
        (f.num."0.1.42".bigint or false) ||
        (num."0.1.42"."bigint" or false); }
      { "0.1.42".num-complex =
        (f.num."0.1.42".num-complex or false) ||
        (f.num."0.1.42".complex or false) ||
        (num."0.1.42"."complex" or false); }
      { "0.1.42".num-rational =
        (f.num."0.1.42".num-rational or false) ||
        (f.num."0.1.42".rational or false) ||
        (num."0.1.42"."rational" or false); }
      { "0.1.42".rational =
        (f.num."0.1.42".rational or false) ||
        (f.num."0.1.42".default or false) ||
        (num."0.1.42"."default" or false); }
      { "0.1.42".rustc-serialize =
        (f.num."0.1.42".rustc-serialize or false) ||
        (f.num."0.1.42".default or false) ||
        (num."0.1.42"."default" or false); }
    ];
    num_bigint = fold recursiveUpdate {} [
      { "${deps.num."0.1.42".num_bigint}"."rustc-serialize" =
        (f.num_bigint."${deps.num."0.1.42".num_bigint}"."rustc-serialize" or false) ||
        (num."0.1.42"."rustc-serialize" or false) ||
        (f."num"."0.1.42"."rustc-serialize" or false); }
      { "${deps.num."0.1.42".num_bigint}"."serde" =
        (f.num_bigint."${deps.num."0.1.42".num_bigint}"."serde" or false) ||
        (num."0.1.42"."serde" or false) ||
        (f."num"."0.1.42"."serde" or false); }
      { "${deps.num."0.1.42".num_bigint}".default = true; }
    ];
    num_complex = fold recursiveUpdate {} [
      { "${deps.num."0.1.42".num_complex}"."rustc-serialize" =
        (f.num_complex."${deps.num."0.1.42".num_complex}"."rustc-serialize" or false) ||
        (num."0.1.42"."rustc-serialize" or false) ||
        (f."num"."0.1.42"."rustc-serialize" or false); }
      { "${deps.num."0.1.42".num_complex}"."serde" =
        (f.num_complex."${deps.num."0.1.42".num_complex}"."serde" or false) ||
        (num."0.1.42"."serde" or false) ||
        (f."num"."0.1.42"."serde" or false); }
      { "${deps.num."0.1.42".num_complex}".default = true; }
    ];
    num_integer."${deps.num."0.1.42".num_integer}".default = true;
    num_iter."${deps.num."0.1.42".num_iter}".default = true;
    num_rational = fold recursiveUpdate {} [
      { "${deps.num."0.1.42".num_rational}"."rustc-serialize" =
        (f.num_rational."${deps.num."0.1.42".num_rational}"."rustc-serialize" or false) ||
        (num."0.1.42"."rustc-serialize" or false) ||
        (f."num"."0.1.42"."rustc-serialize" or false); }
      { "${deps.num."0.1.42".num_rational}"."serde" =
        (f.num_rational."${deps.num."0.1.42".num_rational}"."serde" or false) ||
        (num."0.1.42"."serde" or false) ||
        (f."num"."0.1.42"."serde" or false); }
      { "${deps.num."0.1.42".num_rational}".default = true; }
    ];
    num_traits."${deps.num."0.1.42".num_traits}".default = true;
  }) [
    (features_.num_bigint."${deps."num"."0.1.42"."num_bigint"}" deps)
    (features_.num_complex."${deps."num"."0.1.42"."num_complex"}" deps)
    (features_.num_integer."${deps."num"."0.1.42"."num_integer"}" deps)
    (features_.num_iter."${deps."num"."0.1.42"."num_iter"}" deps)
    (features_.num_rational."${deps."num"."0.1.42"."num_rational"}" deps)
    (features_.num_traits."${deps."num"."0.1.42"."num_traits"}" deps)
  ];


# end
# num-bigint-0.1.44

  crates.num_bigint."0.1.44" = deps: { features?(features_.num_bigint."0.1.44" deps {}) }: buildRustCrate {
    crateName = "num-bigint";
    version = "0.1.44";
    authors = [ "The Rust Project Developers" ];
    sha256 = "13sf3jhjs6y7cnfrdxns0k8vmbxwjl038wm3yl08b3dbrla7hvx1";
    dependencies = mapFeatures features ([
      (crates."num_integer"."${deps."num_bigint"."0.1.44"."num_integer"}" deps)
      (crates."num_traits"."${deps."num_bigint"."0.1.44"."num_traits"}" deps)
    ]
      ++ (if features.num_bigint."0.1.44".rand or false then [ (crates.rand."${deps."num_bigint"."0.1.44".rand}" deps) ] else [])
      ++ (if features.num_bigint."0.1.44".rustc-serialize or false then [ (crates.rustc_serialize."${deps."num_bigint"."0.1.44".rustc_serialize}" deps) ] else []));
    features = mkFeatures (features."num_bigint"."0.1.44" or {});
  };
  features_.num_bigint."0.1.44" = deps: f: updateFeatures f (rec {
    num_bigint = fold recursiveUpdate {} [
      { "0.1.44".default = (f.num_bigint."0.1.44".default or true); }
      { "0.1.44".rand =
        (f.num_bigint."0.1.44".rand or false) ||
        (f.num_bigint."0.1.44".default or false) ||
        (num_bigint."0.1.44"."default" or false); }
      { "0.1.44".rustc-serialize =
        (f.num_bigint."0.1.44".rustc-serialize or false) ||
        (f.num_bigint."0.1.44".default or false) ||
        (num_bigint."0.1.44"."default" or false); }
    ];
    num_integer."${deps.num_bigint."0.1.44".num_integer}".default = (f.num_integer."${deps.num_bigint."0.1.44".num_integer}".default or false);
    num_traits = fold recursiveUpdate {} [
      { "${deps.num_bigint."0.1.44".num_traits}"."std" = true; }
      { "${deps.num_bigint."0.1.44".num_traits}".default = (f.num_traits."${deps.num_bigint."0.1.44".num_traits}".default or false); }
    ];
    rand."${deps.num_bigint."0.1.44".rand}".default = true;
    rustc_serialize."${deps.num_bigint."0.1.44".rustc_serialize}".default = true;
  }) [
    (features_.num_integer."${deps."num_bigint"."0.1.44"."num_integer"}" deps)
    (features_.num_traits."${deps."num_bigint"."0.1.44"."num_traits"}" deps)
    (features_.rand."${deps."num_bigint"."0.1.44"."rand"}" deps)
    (features_.rustc_serialize."${deps."num_bigint"."0.1.44"."rustc_serialize"}" deps)
  ];


# end
# num-complex-0.1.43

  crates.num_complex."0.1.43" = deps: { features?(features_.num_complex."0.1.43" deps {}) }: buildRustCrate {
    crateName = "num-complex";
    version = "0.1.43";
    authors = [ "The Rust Project Developers" ];
    sha256 = "1rs1rhwcxsdamllz1p88ibi8g8s4hhx8rqvvp819x71zphgpqsa2";
    dependencies = mapFeatures features ([
      (crates."num_traits"."${deps."num_complex"."0.1.43"."num_traits"}" deps)
    ]
      ++ (if features.num_complex."0.1.43".rustc-serialize or false then [ (crates.rustc_serialize."${deps."num_complex"."0.1.43".rustc_serialize}" deps) ] else []));
    features = mkFeatures (features."num_complex"."0.1.43" or {});
  };
  features_.num_complex."0.1.43" = deps: f: updateFeatures f (rec {
    num_complex = fold recursiveUpdate {} [
      { "0.1.43".default = (f.num_complex."0.1.43".default or true); }
      { "0.1.43".rustc-serialize =
        (f.num_complex."0.1.43".rustc-serialize or false) ||
        (f.num_complex."0.1.43".default or false) ||
        (num_complex."0.1.43"."default" or false); }
    ];
    num_traits = fold recursiveUpdate {} [
      { "${deps.num_complex."0.1.43".num_traits}"."std" = true; }
      { "${deps.num_complex."0.1.43".num_traits}".default = (f.num_traits."${deps.num_complex."0.1.43".num_traits}".default or false); }
    ];
    rustc_serialize."${deps.num_complex."0.1.43".rustc_serialize}".default = true;
  }) [
    (features_.num_traits."${deps."num_complex"."0.1.43"."num_traits"}" deps)
    (features_.rustc_serialize."${deps."num_complex"."0.1.43"."rustc_serialize"}" deps)
  ];


# end
# num-integer-0.1.39

  crates.num_integer."0.1.39" = deps: { features?(features_.num_integer."0.1.39" deps {}) }: buildRustCrate {
    crateName = "num-integer";
    version = "0.1.39";
    authors = [ "The Rust Project Developers" ];
    sha256 = "1f42ls46cghs13qfzgbd7syib2zc6m7hlmv1qlar6c9mdxapvvbg";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."num_traits"."${deps."num_integer"."0.1.39"."num_traits"}" deps)
    ]);
    features = mkFeatures (features."num_integer"."0.1.39" or {});
  };
  features_.num_integer."0.1.39" = deps: f: updateFeatures f (rec {
    num_integer = fold recursiveUpdate {} [
      { "0.1.39".default = (f.num_integer."0.1.39".default or true); }
      { "0.1.39".std =
        (f.num_integer."0.1.39".std or false) ||
        (f.num_integer."0.1.39".default or false) ||
        (num_integer."0.1.39"."default" or false); }
    ];
    num_traits = fold recursiveUpdate {} [
      { "${deps.num_integer."0.1.39".num_traits}"."i128" =
        (f.num_traits."${deps.num_integer."0.1.39".num_traits}"."i128" or false) ||
        (num_integer."0.1.39"."i128" or false) ||
        (f."num_integer"."0.1.39"."i128" or false); }
      { "${deps.num_integer."0.1.39".num_traits}"."std" =
        (f.num_traits."${deps.num_integer."0.1.39".num_traits}"."std" or false) ||
        (num_integer."0.1.39"."std" or false) ||
        (f."num_integer"."0.1.39"."std" or false); }
      { "${deps.num_integer."0.1.39".num_traits}".default = (f.num_traits."${deps.num_integer."0.1.39".num_traits}".default or false); }
    ];
  }) [
    (features_.num_traits."${deps."num_integer"."0.1.39"."num_traits"}" deps)
  ];


# end
# num-iter-0.1.38

  crates.num_iter."0.1.38" = deps: { features?(features_.num_iter."0.1.38" deps {}) }: buildRustCrate {
    crateName = "num-iter";
    version = "0.1.38";
    authors = [ "The Rust Project Developers" ];
    sha256 = "0ydvbf1lmx46zsg8s4517zg7i93ishjgyc19dkl82mbawy58h82f";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."num_integer"."${deps."num_iter"."0.1.38"."num_integer"}" deps)
      (crates."num_traits"."${deps."num_iter"."0.1.38"."num_traits"}" deps)
    ]);

    buildDependencies = mapFeatures features ([
      (crates."autocfg"."${deps."num_iter"."0.1.38"."autocfg"}" deps)
    ]);
    features = mkFeatures (features."num_iter"."0.1.38" or {});
  };
  features_.num_iter."0.1.38" = deps: f: updateFeatures f (rec {
    autocfg."${deps.num_iter."0.1.38".autocfg}".default = true;
    num_integer = fold recursiveUpdate {} [
      { "${deps.num_iter."0.1.38".num_integer}"."i128" =
        (f.num_integer."${deps.num_iter."0.1.38".num_integer}"."i128" or false) ||
        (num_iter."0.1.38"."i128" or false) ||
        (f."num_iter"."0.1.38"."i128" or false); }
      { "${deps.num_iter."0.1.38".num_integer}"."std" =
        (f.num_integer."${deps.num_iter."0.1.38".num_integer}"."std" or false) ||
        (num_iter."0.1.38"."std" or false) ||
        (f."num_iter"."0.1.38"."std" or false); }
      { "${deps.num_iter."0.1.38".num_integer}".default = (f.num_integer."${deps.num_iter."0.1.38".num_integer}".default or false); }
    ];
    num_iter = fold recursiveUpdate {} [
      { "0.1.38".default = (f.num_iter."0.1.38".default or true); }
      { "0.1.38".std =
        (f.num_iter."0.1.38".std or false) ||
        (f.num_iter."0.1.38".default or false) ||
        (num_iter."0.1.38"."default" or false); }
    ];
    num_traits = fold recursiveUpdate {} [
      { "${deps.num_iter."0.1.38".num_traits}"."i128" =
        (f.num_traits."${deps.num_iter."0.1.38".num_traits}"."i128" or false) ||
        (num_iter."0.1.38"."i128" or false) ||
        (f."num_iter"."0.1.38"."i128" or false); }
      { "${deps.num_iter."0.1.38".num_traits}"."std" =
        (f.num_traits."${deps.num_iter."0.1.38".num_traits}"."std" or false) ||
        (num_iter."0.1.38"."std" or false) ||
        (f."num_iter"."0.1.38"."std" or false); }
      { "${deps.num_iter."0.1.38".num_traits}".default = (f.num_traits."${deps.num_iter."0.1.38".num_traits}".default or false); }
    ];
  }) [
    (features_.num_integer."${deps."num_iter"."0.1.38"."num_integer"}" deps)
    (features_.num_traits."${deps."num_iter"."0.1.38"."num_traits"}" deps)
    (features_.autocfg."${deps."num_iter"."0.1.38"."autocfg"}" deps)
  ];


# end
# num-rational-0.1.42

  crates.num_rational."0.1.42" = deps: { features?(features_.num_rational."0.1.42" deps {}) }: buildRustCrate {
    crateName = "num-rational";
    version = "0.1.42";
    authors = [ "The Rust Project Developers" ];
    sha256 = "09gfmmak5p77rvi2mcsqsalzi81nc93nc8ipchnjv5b8lwn8mm89";
    dependencies = mapFeatures features ([
      (crates."num_integer"."${deps."num_rational"."0.1.42"."num_integer"}" deps)
      (crates."num_traits"."${deps."num_rational"."0.1.42"."num_traits"}" deps)
    ]
      ++ (if features.num_rational."0.1.42".num-bigint or false then [ (crates.num_bigint."${deps."num_rational"."0.1.42".num_bigint}" deps) ] else [])
      ++ (if features.num_rational."0.1.42".rustc-serialize or false then [ (crates.rustc_serialize."${deps."num_rational"."0.1.42".rustc_serialize}" deps) ] else []));
    features = mkFeatures (features."num_rational"."0.1.42" or {});
  };
  features_.num_rational."0.1.42" = deps: f: updateFeatures f (rec {
    num_bigint."${deps.num_rational."0.1.42".num_bigint}".default = true;
    num_integer."${deps.num_rational."0.1.42".num_integer}".default = (f.num_integer."${deps.num_rational."0.1.42".num_integer}".default or false);
    num_rational = fold recursiveUpdate {} [
      { "0.1.42".bigint =
        (f.num_rational."0.1.42".bigint or false) ||
        (f.num_rational."0.1.42".default or false) ||
        (num_rational."0.1.42"."default" or false); }
      { "0.1.42".default = (f.num_rational."0.1.42".default or true); }
      { "0.1.42".num-bigint =
        (f.num_rational."0.1.42".num-bigint or false) ||
        (f.num_rational."0.1.42".bigint or false) ||
        (num_rational."0.1.42"."bigint" or false); }
      { "0.1.42".rustc-serialize =
        (f.num_rational."0.1.42".rustc-serialize or false) ||
        (f.num_rational."0.1.42".default or false) ||
        (num_rational."0.1.42"."default" or false); }
    ];
    num_traits = fold recursiveUpdate {} [
      { "${deps.num_rational."0.1.42".num_traits}"."std" = true; }
      { "${deps.num_rational."0.1.42".num_traits}".default = (f.num_traits."${deps.num_rational."0.1.42".num_traits}".default or false); }
    ];
    rustc_serialize."${deps.num_rational."0.1.42".rustc_serialize}".default = true;
  }) [
    (features_.num_bigint."${deps."num_rational"."0.1.42"."num_bigint"}" deps)
    (features_.num_integer."${deps."num_rational"."0.1.42"."num_integer"}" deps)
    (features_.num_traits."${deps."num_rational"."0.1.42"."num_traits"}" deps)
    (features_.rustc_serialize."${deps."num_rational"."0.1.42"."rustc_serialize"}" deps)
  ];


# end
# num-traits-0.2.6

  crates.num_traits."0.2.6" = deps: { features?(features_.num_traits."0.2.6" deps {}) }: buildRustCrate {
    crateName = "num-traits";
    version = "0.2.6";
    authors = [ "The Rust Project Developers" ];
    sha256 = "1d20sil9n0wgznd1nycm3yjfj1mzyl41ambb7by1apxlyiil1azk";
    build = "build.rs";
    features = mkFeatures (features."num_traits"."0.2.6" or {});
  };
  features_.num_traits."0.2.6" = deps: f: updateFeatures f (rec {
    num_traits = fold recursiveUpdate {} [
      { "0.2.6".default = (f.num_traits."0.2.6".default or true); }
      { "0.2.6".std =
        (f.num_traits."0.2.6".std or false) ||
        (f.num_traits."0.2.6".default or false) ||
        (num_traits."0.2.6"."default" or false); }
    ];
  }) [];


# end
# num_cpus-1.10.0

  crates.num_cpus."1.10.0" = deps: { features?(features_.num_cpus."1.10.0" deps {}) }: buildRustCrate {
    crateName = "num_cpus";
    version = "1.10.0";
    authors = [ "Sean McArthur <sean@seanmonstar.com>" ];
    sha256 = "1411jyxy1wd8d59mv7cf6ynkvvar92czmwhb9l2c1brdkxbbiqn7";
    dependencies = mapFeatures features ([
      (crates."libc"."${deps."num_cpus"."1.10.0"."libc"}" deps)
    ]);
  };
  features_.num_cpus."1.10.0" = deps: f: updateFeatures f (rec {
    libc."${deps.num_cpus."1.10.0".libc}".default = true;
    num_cpus."1.10.0".default = (f.num_cpus."1.10.0".default or true);
  }) [
    (features_.libc."${deps."num_cpus"."1.10.0"."libc"}" deps)
  ];


# end
# orizentic-1.0.0

  crates.orizentic."1.0.0" = deps: { features?(features_.orizentic."1.0.0" deps {}) }: buildRustCrate {
    crateName = "orizentic";
    version = "1.0.0";
    authors = [ "Savanni D'Gerinel <savanni@luminescent-dreams.com>" ];
    sha256 = "0ymf6i6j2qri0gigfm7i1bllxvgn60ly6nhvjq3lxdg96narz68p";
    libPath = "src/lib.rs";
    crateBin =
      [{  name = "orizentic";  path = "src/bin.rs"; }];
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."chrono"."${deps."orizentic"."1.0.0"."chrono"}" deps)
      (crates."clap"."${deps."orizentic"."1.0.0"."clap"}" deps)
      (crates."itertools"."${deps."orizentic"."1.0.0"."itertools"}" deps)
      (crates."jsonwebtoken"."${deps."orizentic"."1.0.0"."jsonwebtoken"}" deps)
      (crates."serde"."${deps."orizentic"."1.0.0"."serde"}" deps)
      (crates."serde_derive"."${deps."orizentic"."1.0.0"."serde_derive"}" deps)
      (crates."serde_json"."${deps."orizentic"."1.0.0"."serde_json"}" deps)
      (crates."uuid"."${deps."orizentic"."1.0.0"."uuid"}" deps)
      (crates."version_check"."${deps."orizentic"."1.0.0"."version_check"}" deps)
      (crates."yaml_rust"."${deps."orizentic"."1.0.0"."yaml_rust"}" deps)
    ]);

    buildDependencies = mapFeatures features ([
      (crates."version_check"."${deps."orizentic"."1.0.0"."version_check"}" deps)
    ]);
  };
  features_.orizentic."1.0.0" = deps: f: updateFeatures f (rec {
    chrono = fold recursiveUpdate {} [
      { "${deps.orizentic."1.0.0".chrono}"."serde" = true; }
      { "${deps.orizentic."1.0.0".chrono}".default = true; }
    ];
    clap."${deps.orizentic."1.0.0".clap}".default = true;
    itertools."${deps.orizentic."1.0.0".itertools}".default = true;
    jsonwebtoken."${deps.orizentic."1.0.0".jsonwebtoken}".default = true;
    orizentic."1.0.0".default = (f.orizentic."1.0.0".default or true);
    serde."${deps.orizentic."1.0.0".serde}".default = true;
    serde_derive."${deps.orizentic."1.0.0".serde_derive}".default = true;
    serde_json."${deps.orizentic."1.0.0".serde_json}".default = true;
    uuid = fold recursiveUpdate {} [
      { "${deps.orizentic."1.0.0".uuid}"."v4" = true; }
      { "${deps.orizentic."1.0.0".uuid}".default = true; }
    ];
    version_check."${deps.orizentic."1.0.0".version_check}".default = true;
    yaml_rust."${deps.orizentic."1.0.0".yaml_rust}".default = true;
  }) [
    (features_.chrono."${deps."orizentic"."1.0.0"."chrono"}" deps)
    (features_.clap."${deps."orizentic"."1.0.0"."clap"}" deps)
    (features_.itertools."${deps."orizentic"."1.0.0"."itertools"}" deps)
    (features_.jsonwebtoken."${deps."orizentic"."1.0.0"."jsonwebtoken"}" deps)
    (features_.serde."${deps."orizentic"."1.0.0"."serde"}" deps)
    (features_.serde_derive."${deps."orizentic"."1.0.0"."serde_derive"}" deps)
    (features_.serde_json."${deps."orizentic"."1.0.0"."serde_json"}" deps)
    (features_.uuid."${deps."orizentic"."1.0.0"."uuid"}" deps)
    (features_.version_check."${deps."orizentic"."1.0.0"."version_check"}" deps)
    (features_.yaml_rust."${deps."orizentic"."1.0.0"."yaml_rust"}" deps)
    (features_.version_check."${deps."orizentic"."1.0.0"."version_check"}" deps)
  ];


# end
# params-0.8.0

  crates.params."0.8.0" = deps: { features?(features_.params."0.8.0" deps {}) }: buildRustCrate {
    crateName = "params";
    version = "0.8.0";
    authors = [ "Skyler Lipthay <skyler.lipthay@gmail.com>" ];
    sha256 = "0a4232p60a1mrkmzm48np88gs9wnl4pqzm0g84dzrvc3kmpbszq8";
    dependencies = mapFeatures features ([
      (crates."bodyparser"."${deps."params"."0.8.0"."bodyparser"}" deps)
      (crates."iron"."${deps."params"."0.8.0"."iron"}" deps)
      (crates."multipart"."${deps."params"."0.8.0"."multipart"}" deps)
      (crates."num"."${deps."params"."0.8.0"."num"}" deps)
      (crates."plugin"."${deps."params"."0.8.0"."plugin"}" deps)
      (crates."serde_json"."${deps."params"."0.8.0"."serde_json"}" deps)
      (crates."tempdir"."${deps."params"."0.8.0"."tempdir"}" deps)
      (crates."urlencoded"."${deps."params"."0.8.0"."urlencoded"}" deps)
    ]);
  };
  features_.params."0.8.0" = deps: f: updateFeatures f (rec {
    bodyparser."${deps.params."0.8.0".bodyparser}".default = true;
    iron."${deps.params."0.8.0".iron}".default = true;
    multipart = fold recursiveUpdate {} [
      { "${deps.params."0.8.0".multipart}"."server" = true; }
      { "${deps.params."0.8.0".multipart}".default = (f.multipart."${deps.params."0.8.0".multipart}".default or false); }
    ];
    num."${deps.params."0.8.0".num}".default = true;
    params."0.8.0".default = (f.params."0.8.0".default or true);
    plugin."${deps.params."0.8.0".plugin}".default = true;
    serde_json."${deps.params."0.8.0".serde_json}".default = true;
    tempdir."${deps.params."0.8.0".tempdir}".default = true;
    urlencoded."${deps.params."0.8.0".urlencoded}".default = true;
  }) [
    (features_.bodyparser."${deps."params"."0.8.0"."bodyparser"}" deps)
    (features_.iron."${deps."params"."0.8.0"."iron"}" deps)
    (features_.multipart."${deps."params"."0.8.0"."multipart"}" deps)
    (features_.num."${deps."params"."0.8.0"."num"}" deps)
    (features_.plugin."${deps."params"."0.8.0"."plugin"}" deps)
    (features_.serde_json."${deps."params"."0.8.0"."serde_json"}" deps)
    (features_.tempdir."${deps."params"."0.8.0"."tempdir"}" deps)
    (features_.urlencoded."${deps."params"."0.8.0"."urlencoded"}" deps)
  ];


# end
# parse-zoneinfo-0.1.1

  crates.parse_zoneinfo."0.1.1" = deps: { features?(features_.parse_zoneinfo."0.1.1" deps {}) }: buildRustCrate {
    crateName = "parse-zoneinfo";
    version = "0.1.1";
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
# percent-encoding-1.0.1

  crates.percent_encoding."1.0.1" = deps: { features?(features_.percent_encoding."1.0.1" deps {}) }: buildRustCrate {
    crateName = "percent-encoding";
    version = "1.0.1";
    authors = [ "The rust-url developers" ];
    sha256 = "04ahrp7aw4ip7fmadb0bknybmkfav0kk0gw4ps3ydq5w6hr0ib5i";
    libPath = "lib.rs";
  };
  features_.percent_encoding."1.0.1" = deps: f: updateFeatures f (rec {
    percent_encoding."1.0.1".default = (f.percent_encoding."1.0.1".default or true);
  }) [];


# end
# persistent-0.4.0

  crates.persistent."0.4.0" = deps: { features?(features_.persistent."0.4.0" deps {}) }: buildRustCrate {
    crateName = "persistent";
    version = "0.4.0";
    authors = [ "Jonathan Reem <jonathan.reem@gmail.com>" ];
    sha256 = "18gxlf7np1l4nabfkhq686fbf1a0hwxpzys745f38gjh1k2sr9wr";
    dependencies = mapFeatures features ([
      (crates."iron"."${deps."persistent"."0.4.0"."iron"}" deps)
      (crates."plugin"."${deps."persistent"."0.4.0"."plugin"}" deps)
    ]);
  };
  features_.persistent."0.4.0" = deps: f: updateFeatures f (rec {
    iron."${deps.persistent."0.4.0".iron}".default = true;
    persistent."0.4.0".default = (f.persistent."0.4.0".default or true);
    plugin."${deps.persistent."0.4.0".plugin}".default = true;
  }) [
    (features_.iron."${deps."persistent"."0.4.0"."iron"}" deps)
    (features_.plugin."${deps."persistent"."0.4.0"."plugin"}" deps)
  ];


# end
# phf-0.7.24

  crates.phf."0.7.24" = deps: { features?(features_.phf."0.7.24" deps {}) }: buildRustCrate {
    crateName = "phf";
    version = "0.7.24";
    authors = [ "Steven Fackler <sfackler@gmail.com>" ];
    sha256 = "19mmhmafd1dhywc7pzkmd1nq0kjfvg57viny20jqa91hhprf2dv5";
    libPath = "src/lib.rs";
    dependencies = mapFeatures features ([
      (crates."phf_shared"."${deps."phf"."0.7.24"."phf_shared"}" deps)
    ]);
    features = mkFeatures (features."phf"."0.7.24" or {});
  };
  features_.phf."0.7.24" = deps: f: updateFeatures f (rec {
    phf = fold recursiveUpdate {} [
      { "0.7.24".default = (f.phf."0.7.24".default or true); }
      { "0.7.24".phf_macros =
        (f.phf."0.7.24".phf_macros or false) ||
        (f.phf."0.7.24".macros or false) ||
        (phf."0.7.24"."macros" or false); }
    ];
    phf_shared = fold recursiveUpdate {} [
      { "${deps.phf."0.7.24".phf_shared}"."core" =
        (f.phf_shared."${deps.phf."0.7.24".phf_shared}"."core" or false) ||
        (phf."0.7.24"."core" or false) ||
        (f."phf"."0.7.24"."core" or false); }
      { "${deps.phf."0.7.24".phf_shared}"."unicase" =
        (f.phf_shared."${deps.phf."0.7.24".phf_shared}"."unicase" or false) ||
        (phf."0.7.24"."unicase" or false) ||
        (f."phf"."0.7.24"."unicase" or false); }
      { "${deps.phf."0.7.24".phf_shared}".default = true; }
    ];
  }) [
    (features_.phf_shared."${deps."phf"."0.7.24"."phf_shared"}" deps)
  ];


# end
# phf_codegen-0.7.24

  crates.phf_codegen."0.7.24" = deps: { features?(features_.phf_codegen."0.7.24" deps {}) }: buildRustCrate {
    crateName = "phf_codegen";
    version = "0.7.24";
    authors = [ "Steven Fackler <sfackler@gmail.com>" ];
    sha256 = "0avkx97r4ph8rv70wwgniarlcfiq27yd74gmnxfdv3rx840cyf8g";
    dependencies = mapFeatures features ([
      (crates."phf_generator"."${deps."phf_codegen"."0.7.24"."phf_generator"}" deps)
      (crates."phf_shared"."${deps."phf_codegen"."0.7.24"."phf_shared"}" deps)
    ]);
  };
  features_.phf_codegen."0.7.24" = deps: f: updateFeatures f (rec {
    phf_codegen."0.7.24".default = (f.phf_codegen."0.7.24".default or true);
    phf_generator."${deps.phf_codegen."0.7.24".phf_generator}".default = true;
    phf_shared."${deps.phf_codegen."0.7.24".phf_shared}".default = true;
  }) [
    (features_.phf_generator."${deps."phf_codegen"."0.7.24"."phf_generator"}" deps)
    (features_.phf_shared."${deps."phf_codegen"."0.7.24"."phf_shared"}" deps)
  ];


# end
# phf_generator-0.7.24

  crates.phf_generator."0.7.24" = deps: { features?(features_.phf_generator."0.7.24" deps {}) }: buildRustCrate {
    crateName = "phf_generator";
    version = "0.7.24";
    authors = [ "Steven Fackler <sfackler@gmail.com>" ];
    sha256 = "1frn2jfydinifxb1fki0xnnsxf0f1ciaa79jz415r5qhw1ash72j";
    dependencies = mapFeatures features ([
      (crates."phf_shared"."${deps."phf_generator"."0.7.24"."phf_shared"}" deps)
      (crates."rand"."${deps."phf_generator"."0.7.24"."rand"}" deps)
    ]);
  };
  features_.phf_generator."0.7.24" = deps: f: updateFeatures f (rec {
    phf_generator."0.7.24".default = (f.phf_generator."0.7.24".default or true);
    phf_shared."${deps.phf_generator."0.7.24".phf_shared}".default = true;
    rand."${deps.phf_generator."0.7.24".rand}".default = true;
  }) [
    (features_.phf_shared."${deps."phf_generator"."0.7.24"."phf_shared"}" deps)
    (features_.rand."${deps."phf_generator"."0.7.24"."rand"}" deps)
  ];


# end
# phf_shared-0.7.24

  crates.phf_shared."0.7.24" = deps: { features?(features_.phf_shared."0.7.24" deps {}) }: buildRustCrate {
    crateName = "phf_shared";
    version = "0.7.24";
    authors = [ "Steven Fackler <sfackler@gmail.com>" ];
    sha256 = "1hndqn461jvm2r269ym4qh7fnjc6n8yy53avc2pb43p70vxhm9rl";
    libPath = "src/lib.rs";
    dependencies = mapFeatures features ([
      (crates."siphasher"."${deps."phf_shared"."0.7.24"."siphasher"}" deps)
    ]
      ++ (if features.phf_shared."0.7.24".unicase or false then [ (crates.unicase."${deps."phf_shared"."0.7.24".unicase}" deps) ] else []));
    features = mkFeatures (features."phf_shared"."0.7.24" or {});
  };
  features_.phf_shared."0.7.24" = deps: f: updateFeatures f (rec {
    phf_shared."0.7.24".default = (f.phf_shared."0.7.24".default or true);
    siphasher."${deps.phf_shared."0.7.24".siphasher}".default = true;
    unicase."${deps.phf_shared."0.7.24".unicase}".default = true;
  }) [
    (features_.siphasher."${deps."phf_shared"."0.7.24"."siphasher"}" deps)
    (features_.unicase."${deps."phf_shared"."0.7.24"."unicase"}" deps)
  ];


# end
# plugin-0.2.6

  crates.plugin."0.2.6" = deps: { features?(features_.plugin."0.2.6" deps {}) }: buildRustCrate {
    crateName = "plugin";
    version = "0.2.6";
    authors = [ "Jonathan Reem <jonathan.reem@gmail.com>" ];
    sha256 = "13byr5ilqcs83zlj3sm9chs70jim6n6dwgdrzmzjdk6jz35d376a";
    dependencies = mapFeatures features ([
      (crates."typemap"."${deps."plugin"."0.2.6"."typemap"}" deps)
    ]);
  };
  features_.plugin."0.2.6" = deps: f: updateFeatures f (rec {
    plugin."0.2.6".default = (f.plugin."0.2.6".default or true);
    typemap."${deps.plugin."0.2.6".typemap}".default = true;
  }) [
    (features_.typemap."${deps."plugin"."0.2.6"."typemap"}" deps)
  ];


# end
# proc-macro2-0.4.27

  crates.proc_macro2."0.4.27" = deps: { features?(features_.proc_macro2."0.4.27" deps {}) }: buildRustCrate {
    crateName = "proc-macro2";
    version = "0.4.27";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "1cp4c40p3hwn2sz72ssqa62gp5n8w4gbamdqvvadzp5l7gxnq95i";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."unicode_xid"."${deps."proc_macro2"."0.4.27"."unicode_xid"}" deps)
    ]);
    features = mkFeatures (features."proc_macro2"."0.4.27" or {});
  };
  features_.proc_macro2."0.4.27" = deps: f: updateFeatures f (rec {
    proc_macro2 = fold recursiveUpdate {} [
      { "0.4.27".default = (f.proc_macro2."0.4.27".default or true); }
      { "0.4.27".proc-macro =
        (f.proc_macro2."0.4.27".proc-macro or false) ||
        (f.proc_macro2."0.4.27".default or false) ||
        (proc_macro2."0.4.27"."default" or false); }
    ];
    unicode_xid."${deps.proc_macro2."0.4.27".unicode_xid}".default = true;
  }) [
    (features_.unicode_xid."${deps."proc_macro2"."0.4.27"."unicode_xid"}" deps)
  ];


# end
# quote-0.6.11

  crates.quote."0.6.11" = deps: { features?(features_.quote."0.6.11" deps {}) }: buildRustCrate {
    crateName = "quote";
    version = "0.6.11";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "0agska77z58cypcq4knayzwx7r7n6m756z1cz9cp2z4sv0b846ga";
    dependencies = mapFeatures features ([
      (crates."proc_macro2"."${deps."quote"."0.6.11"."proc_macro2"}" deps)
    ]);
    features = mkFeatures (features."quote"."0.6.11" or {});
  };
  features_.quote."0.6.11" = deps: f: updateFeatures f (rec {
    proc_macro2 = fold recursiveUpdate {} [
      { "${deps.quote."0.6.11".proc_macro2}"."proc-macro" =
        (f.proc_macro2."${deps.quote."0.6.11".proc_macro2}"."proc-macro" or false) ||
        (quote."0.6.11"."proc-macro" or false) ||
        (f."quote"."0.6.11"."proc-macro" or false); }
      { "${deps.quote."0.6.11".proc_macro2}".default = (f.proc_macro2."${deps.quote."0.6.11".proc_macro2}".default or false); }
    ];
    quote = fold recursiveUpdate {} [
      { "0.6.11".default = (f.quote."0.6.11".default or true); }
      { "0.6.11".proc-macro =
        (f.quote."0.6.11".proc-macro or false) ||
        (f.quote."0.6.11".default or false) ||
        (quote."0.6.11"."default" or false); }
    ];
  }) [
    (features_.proc_macro2."${deps."quote"."0.6.11"."proc_macro2"}" deps)
  ];


# end
# rand-0.3.23

  crates.rand."0.3.23" = deps: { features?(features_.rand."0.3.23" deps {}) }: buildRustCrate {
    crateName = "rand";
    version = "0.3.23";
    authors = [ "The Rust Project Developers" ];
    sha256 = "118rairvv46npqqx7hmkf97kkimjrry9z31z4inxcv2vn0nj1s2g";
    dependencies = mapFeatures features ([
      (crates."libc"."${deps."rand"."0.3.23"."libc"}" deps)
      (crates."rand"."${deps."rand"."0.3.23"."rand"}" deps)
    ]);
    features = mkFeatures (features."rand"."0.3.23" or {});
  };
  features_.rand."0.3.23" = deps: f: updateFeatures f (rec {
    libc."${deps.rand."0.3.23".libc}".default = true;
    rand = fold recursiveUpdate {} [
      { "${deps.rand."0.3.23".rand}".default = true; }
      { "0.3.23".default = (f.rand."0.3.23".default or true); }
      { "0.3.23".i128_support =
        (f.rand."0.3.23".i128_support or false) ||
        (f.rand."0.3.23".nightly or false) ||
        (rand."0.3.23"."nightly" or false); }
    ];
  }) [
    (features_.libc."${deps."rand"."0.3.23"."libc"}" deps)
    (features_.rand."${deps."rand"."0.3.23"."rand"}" deps)
  ];


# end
# rand-0.4.6

  crates.rand."0.4.6" = deps: { features?(features_.rand."0.4.6" deps {}) }: buildRustCrate {
    crateName = "rand";
    version = "0.4.6";
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
      { "0.4.6".default = (f.rand."0.4.6".default or true); }
      { "0.4.6".i128_support =
        (f.rand."0.4.6".i128_support or false) ||
        (f.rand."0.4.6".nightly or false) ||
        (rand."0.4.6"."nightly" or false); }
      { "0.4.6".libc =
        (f.rand."0.4.6".libc or false) ||
        (f.rand."0.4.6".std or false) ||
        (rand."0.4.6"."std" or false); }
      { "0.4.6".std =
        (f.rand."0.4.6".std or false) ||
        (f.rand."0.4.6".default or false) ||
        (rand."0.4.6"."default" or false); }
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
# rand-0.6.5

  crates.rand."0.6.5" = deps: { features?(features_.rand."0.6.5" deps {}) }: buildRustCrate {
    crateName = "rand";
    version = "0.6.5";
    authors = [ "The Rand Project Developers" "The Rust Project Developers" ];
    sha256 = "0zbck48159aj8zrwzf80sd9xxh96w4f4968nshwjpysjvflimvgb";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."rand_chacha"."${deps."rand"."0.6.5"."rand_chacha"}" deps)
      (crates."rand_core"."${deps."rand"."0.6.5"."rand_core"}" deps)
      (crates."rand_hc"."${deps."rand"."0.6.5"."rand_hc"}" deps)
      (crates."rand_isaac"."${deps."rand"."0.6.5"."rand_isaac"}" deps)
      (crates."rand_jitter"."${deps."rand"."0.6.5"."rand_jitter"}" deps)
      (crates."rand_pcg"."${deps."rand"."0.6.5"."rand_pcg"}" deps)
      (crates."rand_xorshift"."${deps."rand"."0.6.5"."rand_xorshift"}" deps)
    ]
      ++ (if features.rand."0.6.5".rand_os or false then [ (crates.rand_os."${deps."rand"."0.6.5".rand_os}" deps) ] else []))
      ++ (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([
      (crates."libc"."${deps."rand"."0.6.5"."libc"}" deps)
    ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."winapi"."${deps."rand"."0.6.5"."winapi"}" deps)
    ]) else []);

    buildDependencies = mapFeatures features ([
      (crates."autocfg"."${deps."rand"."0.6.5"."autocfg"}" deps)
    ]);
    features = mkFeatures (features."rand"."0.6.5" or {});
  };
  features_.rand."0.6.5" = deps: f: updateFeatures f (rec {
    autocfg."${deps.rand."0.6.5".autocfg}".default = true;
    libc."${deps.rand."0.6.5".libc}".default = (f.libc."${deps.rand."0.6.5".libc}".default or false);
    rand = fold recursiveUpdate {} [
      { "0.6.5".alloc =
        (f.rand."0.6.5".alloc or false) ||
        (f.rand."0.6.5".std or false) ||
        (rand."0.6.5"."std" or false); }
      { "0.6.5".default = (f.rand."0.6.5".default or true); }
      { "0.6.5".packed_simd =
        (f.rand."0.6.5".packed_simd or false) ||
        (f.rand."0.6.5".simd_support or false) ||
        (rand."0.6.5"."simd_support" or false); }
      { "0.6.5".rand_os =
        (f.rand."0.6.5".rand_os or false) ||
        (f.rand."0.6.5".std or false) ||
        (rand."0.6.5"."std" or false); }
      { "0.6.5".simd_support =
        (f.rand."0.6.5".simd_support or false) ||
        (f.rand."0.6.5".nightly or false) ||
        (rand."0.6.5"."nightly" or false); }
      { "0.6.5".std =
        (f.rand."0.6.5".std or false) ||
        (f.rand."0.6.5".default or false) ||
        (rand."0.6.5"."default" or false); }
    ];
    rand_chacha."${deps.rand."0.6.5".rand_chacha}".default = true;
    rand_core = fold recursiveUpdate {} [
      { "${deps.rand."0.6.5".rand_core}"."alloc" =
        (f.rand_core."${deps.rand."0.6.5".rand_core}"."alloc" or false) ||
        (rand."0.6.5"."alloc" or false) ||
        (f."rand"."0.6.5"."alloc" or false); }
      { "${deps.rand."0.6.5".rand_core}"."serde1" =
        (f.rand_core."${deps.rand."0.6.5".rand_core}"."serde1" or false) ||
        (rand."0.6.5"."serde1" or false) ||
        (f."rand"."0.6.5"."serde1" or false); }
      { "${deps.rand."0.6.5".rand_core}"."std" =
        (f.rand_core."${deps.rand."0.6.5".rand_core}"."std" or false) ||
        (rand."0.6.5"."std" or false) ||
        (f."rand"."0.6.5"."std" or false); }
      { "${deps.rand."0.6.5".rand_core}".default = true; }
    ];
    rand_hc."${deps.rand."0.6.5".rand_hc}".default = true;
    rand_isaac = fold recursiveUpdate {} [
      { "${deps.rand."0.6.5".rand_isaac}"."serde1" =
        (f.rand_isaac."${deps.rand."0.6.5".rand_isaac}"."serde1" or false) ||
        (rand."0.6.5"."serde1" or false) ||
        (f."rand"."0.6.5"."serde1" or false); }
      { "${deps.rand."0.6.5".rand_isaac}".default = true; }
    ];
    rand_jitter = fold recursiveUpdate {} [
      { "${deps.rand."0.6.5".rand_jitter}"."std" =
        (f.rand_jitter."${deps.rand."0.6.5".rand_jitter}"."std" or false) ||
        (rand."0.6.5"."std" or false) ||
        (f."rand"."0.6.5"."std" or false); }
      { "${deps.rand."0.6.5".rand_jitter}".default = true; }
    ];
    rand_os = fold recursiveUpdate {} [
      { "${deps.rand."0.6.5".rand_os}"."stdweb" =
        (f.rand_os."${deps.rand."0.6.5".rand_os}"."stdweb" or false) ||
        (rand."0.6.5"."stdweb" or false) ||
        (f."rand"."0.6.5"."stdweb" or false); }
      { "${deps.rand."0.6.5".rand_os}"."wasm-bindgen" =
        (f.rand_os."${deps.rand."0.6.5".rand_os}"."wasm-bindgen" or false) ||
        (rand."0.6.5"."wasm-bindgen" or false) ||
        (f."rand"."0.6.5"."wasm-bindgen" or false); }
      { "${deps.rand."0.6.5".rand_os}".default = true; }
    ];
    rand_pcg."${deps.rand."0.6.5".rand_pcg}".default = true;
    rand_xorshift = fold recursiveUpdate {} [
      { "${deps.rand."0.6.5".rand_xorshift}"."serde1" =
        (f.rand_xorshift."${deps.rand."0.6.5".rand_xorshift}"."serde1" or false) ||
        (rand."0.6.5"."serde1" or false) ||
        (f."rand"."0.6.5"."serde1" or false); }
      { "${deps.rand."0.6.5".rand_xorshift}".default = true; }
    ];
    winapi = fold recursiveUpdate {} [
      { "${deps.rand."0.6.5".winapi}"."minwindef" = true; }
      { "${deps.rand."0.6.5".winapi}"."ntsecapi" = true; }
      { "${deps.rand."0.6.5".winapi}"."profileapi" = true; }
      { "${deps.rand."0.6.5".winapi}"."winnt" = true; }
      { "${deps.rand."0.6.5".winapi}".default = true; }
    ];
  }) [
    (features_.rand_chacha."${deps."rand"."0.6.5"."rand_chacha"}" deps)
    (features_.rand_core."${deps."rand"."0.6.5"."rand_core"}" deps)
    (features_.rand_hc."${deps."rand"."0.6.5"."rand_hc"}" deps)
    (features_.rand_isaac."${deps."rand"."0.6.5"."rand_isaac"}" deps)
    (features_.rand_jitter."${deps."rand"."0.6.5"."rand_jitter"}" deps)
    (features_.rand_os."${deps."rand"."0.6.5"."rand_os"}" deps)
    (features_.rand_pcg."${deps."rand"."0.6.5"."rand_pcg"}" deps)
    (features_.rand_xorshift."${deps."rand"."0.6.5"."rand_xorshift"}" deps)
    (features_.autocfg."${deps."rand"."0.6.5"."autocfg"}" deps)
    (features_.libc."${deps."rand"."0.6.5"."libc"}" deps)
    (features_.winapi."${deps."rand"."0.6.5"."winapi"}" deps)
  ];


# end
# rand_chacha-0.1.1

  crates.rand_chacha."0.1.1" = deps: { features?(features_.rand_chacha."0.1.1" deps {}) }: buildRustCrate {
    crateName = "rand_chacha";
    version = "0.1.1";
    authors = [ "The Rand Project Developers" "The Rust Project Developers" ];
    sha256 = "0xnxm4mjd7wjnh18zxc1yickw58axbycp35ciraplqdfwn1gffwi";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."rand_core"."${deps."rand_chacha"."0.1.1"."rand_core"}" deps)
    ]);

    buildDependencies = mapFeatures features ([
      (crates."autocfg"."${deps."rand_chacha"."0.1.1"."autocfg"}" deps)
    ]);
  };
  features_.rand_chacha."0.1.1" = deps: f: updateFeatures f (rec {
    autocfg."${deps.rand_chacha."0.1.1".autocfg}".default = true;
    rand_chacha."0.1.1".default = (f.rand_chacha."0.1.1".default or true);
    rand_core."${deps.rand_chacha."0.1.1".rand_core}".default = (f.rand_core."${deps.rand_chacha."0.1.1".rand_core}".default or false);
  }) [
    (features_.rand_core."${deps."rand_chacha"."0.1.1"."rand_core"}" deps)
    (features_.autocfg."${deps."rand_chacha"."0.1.1"."autocfg"}" deps)
  ];


# end
# rand_core-0.3.1

  crates.rand_core."0.3.1" = deps: { features?(features_.rand_core."0.3.1" deps {}) }: buildRustCrate {
    crateName = "rand_core";
    version = "0.3.1";
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
      { "0.3.1".default = (f.rand_core."0.3.1".default or true); }
      { "0.3.1".std =
        (f.rand_core."0.3.1".std or false) ||
        (f.rand_core."0.3.1".default or false) ||
        (rand_core."0.3.1"."default" or false); }
    ];
  }) [
    (features_.rand_core."${deps."rand_core"."0.3.1"."rand_core"}" deps)
  ];


# end
# rand_core-0.4.0

  crates.rand_core."0.4.0" = deps: { features?(features_.rand_core."0.4.0" deps {}) }: buildRustCrate {
    crateName = "rand_core";
    version = "0.4.0";
    authors = [ "The Rand Project Developers" "The Rust Project Developers" ];
    sha256 = "0wb5iwhffibj0pnpznhv1g3i7h1fnhz64s3nz74fz6vsm3q6q3br";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."rand_core"."0.4.0" or {});
  };
  features_.rand_core."0.4.0" = deps: f: updateFeatures f (rec {
    rand_core = fold recursiveUpdate {} [
      { "0.4.0".alloc =
        (f.rand_core."0.4.0".alloc or false) ||
        (f.rand_core."0.4.0".std or false) ||
        (rand_core."0.4.0"."std" or false); }
      { "0.4.0".default = (f.rand_core."0.4.0".default or true); }
      { "0.4.0".serde =
        (f.rand_core."0.4.0".serde or false) ||
        (f.rand_core."0.4.0".serde1 or false) ||
        (rand_core."0.4.0"."serde1" or false); }
      { "0.4.0".serde_derive =
        (f.rand_core."0.4.0".serde_derive or false) ||
        (f.rand_core."0.4.0".serde1 or false) ||
        (rand_core."0.4.0"."serde1" or false); }
    ];
  }) [];


# end
# rand_hc-0.1.0

  crates.rand_hc."0.1.0" = deps: { features?(features_.rand_hc."0.1.0" deps {}) }: buildRustCrate {
    crateName = "rand_hc";
    version = "0.1.0";
    authors = [ "The Rand Project Developers" ];
    sha256 = "05agb75j87yp7y1zk8yf7bpm66hc0673r3dlypn0kazynr6fdgkz";
    dependencies = mapFeatures features ([
      (crates."rand_core"."${deps."rand_hc"."0.1.0"."rand_core"}" deps)
    ]);
  };
  features_.rand_hc."0.1.0" = deps: f: updateFeatures f (rec {
    rand_core."${deps.rand_hc."0.1.0".rand_core}".default = (f.rand_core."${deps.rand_hc."0.1.0".rand_core}".default or false);
    rand_hc."0.1.0".default = (f.rand_hc."0.1.0".default or true);
  }) [
    (features_.rand_core."${deps."rand_hc"."0.1.0"."rand_core"}" deps)
  ];


# end
# rand_isaac-0.1.1

  crates.rand_isaac."0.1.1" = deps: { features?(features_.rand_isaac."0.1.1" deps {}) }: buildRustCrate {
    crateName = "rand_isaac";
    version = "0.1.1";
    authors = [ "The Rand Project Developers" "The Rust Project Developers" ];
    sha256 = "10hhdh5b5sa03s6b63y9bafm956jwilx41s71jbrzl63ccx8lxdq";
    dependencies = mapFeatures features ([
      (crates."rand_core"."${deps."rand_isaac"."0.1.1"."rand_core"}" deps)
    ]);
    features = mkFeatures (features."rand_isaac"."0.1.1" or {});
  };
  features_.rand_isaac."0.1.1" = deps: f: updateFeatures f (rec {
    rand_core = fold recursiveUpdate {} [
      { "${deps.rand_isaac."0.1.1".rand_core}"."serde1" =
        (f.rand_core."${deps.rand_isaac."0.1.1".rand_core}"."serde1" or false) ||
        (rand_isaac."0.1.1"."serde1" or false) ||
        (f."rand_isaac"."0.1.1"."serde1" or false); }
      { "${deps.rand_isaac."0.1.1".rand_core}".default = (f.rand_core."${deps.rand_isaac."0.1.1".rand_core}".default or false); }
    ];
    rand_isaac = fold recursiveUpdate {} [
      { "0.1.1".default = (f.rand_isaac."0.1.1".default or true); }
      { "0.1.1".serde =
        (f.rand_isaac."0.1.1".serde or false) ||
        (f.rand_isaac."0.1.1".serde1 or false) ||
        (rand_isaac."0.1.1"."serde1" or false); }
      { "0.1.1".serde_derive =
        (f.rand_isaac."0.1.1".serde_derive or false) ||
        (f.rand_isaac."0.1.1".serde1 or false) ||
        (rand_isaac."0.1.1"."serde1" or false); }
    ];
  }) [
    (features_.rand_core."${deps."rand_isaac"."0.1.1"."rand_core"}" deps)
  ];


# end
# rand_jitter-0.1.3

  crates.rand_jitter."0.1.3" = deps: { features?(features_.rand_jitter."0.1.3" deps {}) }: buildRustCrate {
    crateName = "rand_jitter";
    version = "0.1.3";
    authors = [ "The Rand Project Developers" ];
    sha256 = "1cb4q73rmh1inlx3liy6rabapcqh6p6c1plsd2lxw6dmi67d1qc3";
    dependencies = mapFeatures features ([
      (crates."rand_core"."${deps."rand_jitter"."0.1.3"."rand_core"}" deps)
    ])
      ++ (if kernel == "darwin" || kernel == "ios" then mapFeatures features ([
      (crates."libc"."${deps."rand_jitter"."0.1.3"."libc"}" deps)
    ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."winapi"."${deps."rand_jitter"."0.1.3"."winapi"}" deps)
    ]) else []);
    features = mkFeatures (features."rand_jitter"."0.1.3" or {});
  };
  features_.rand_jitter."0.1.3" = deps: f: updateFeatures f (rec {
    libc."${deps.rand_jitter."0.1.3".libc}".default = true;
    rand_core = fold recursiveUpdate {} [
      { "${deps.rand_jitter."0.1.3".rand_core}"."std" =
        (f.rand_core."${deps.rand_jitter."0.1.3".rand_core}"."std" or false) ||
        (rand_jitter."0.1.3"."std" or false) ||
        (f."rand_jitter"."0.1.3"."std" or false); }
      { "${deps.rand_jitter."0.1.3".rand_core}".default = true; }
    ];
    rand_jitter."0.1.3".default = (f.rand_jitter."0.1.3".default or true);
    winapi = fold recursiveUpdate {} [
      { "${deps.rand_jitter."0.1.3".winapi}"."profileapi" = true; }
      { "${deps.rand_jitter."0.1.3".winapi}".default = true; }
    ];
  }) [
    (features_.rand_core."${deps."rand_jitter"."0.1.3"."rand_core"}" deps)
    (features_.libc."${deps."rand_jitter"."0.1.3"."libc"}" deps)
    (features_.winapi."${deps."rand_jitter"."0.1.3"."winapi"}" deps)
  ];


# end
# rand_os-0.1.3

  crates.rand_os."0.1.3" = deps: { features?(features_.rand_os."0.1.3" deps {}) }: buildRustCrate {
    crateName = "rand_os";
    version = "0.1.3";
    authors = [ "The Rand Project Developers" ];
    sha256 = "0ywwspizgs9g8vzn6m5ix9yg36n15119d6n792h7mk4r5vs0ww4j";
    dependencies = mapFeatures features ([
      (crates."rand_core"."${deps."rand_os"."0.1.3"."rand_core"}" deps)
    ])
      ++ (if abi == "sgx" then mapFeatures features ([
      (crates."rdrand"."${deps."rand_os"."0.1.3"."rdrand"}" deps)
    ]) else [])
      ++ (if kernel == "cloudabi" then mapFeatures features ([
      (crates."cloudabi"."${deps."rand_os"."0.1.3"."cloudabi"}" deps)
    ]) else [])
      ++ (if kernel == "fuchsia" then mapFeatures features ([
      (crates."fuchsia_cprng"."${deps."rand_os"."0.1.3"."fuchsia_cprng"}" deps)
    ]) else [])
      ++ (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([
      (crates."libc"."${deps."rand_os"."0.1.3"."libc"}" deps)
    ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."winapi"."${deps."rand_os"."0.1.3"."winapi"}" deps)
    ]) else [])
      ++ (if kernel == "wasm32-unknown-unknown" then mapFeatures features ([
]) else []);
  };
  features_.rand_os."0.1.3" = deps: f: updateFeatures f (rec {
    cloudabi."${deps.rand_os."0.1.3".cloudabi}".default = true;
    fuchsia_cprng."${deps.rand_os."0.1.3".fuchsia_cprng}".default = true;
    libc."${deps.rand_os."0.1.3".libc}".default = true;
    rand_core = fold recursiveUpdate {} [
      { "${deps.rand_os."0.1.3".rand_core}"."std" = true; }
      { "${deps.rand_os."0.1.3".rand_core}".default = true; }
    ];
    rand_os."0.1.3".default = (f.rand_os."0.1.3".default or true);
    rdrand."${deps.rand_os."0.1.3".rdrand}".default = true;
    winapi = fold recursiveUpdate {} [
      { "${deps.rand_os."0.1.3".winapi}"."minwindef" = true; }
      { "${deps.rand_os."0.1.3".winapi}"."ntsecapi" = true; }
      { "${deps.rand_os."0.1.3".winapi}"."winnt" = true; }
      { "${deps.rand_os."0.1.3".winapi}".default = true; }
    ];
  }) [
    (features_.rand_core."${deps."rand_os"."0.1.3"."rand_core"}" deps)
    (features_.rdrand."${deps."rand_os"."0.1.3"."rdrand"}" deps)
    (features_.cloudabi."${deps."rand_os"."0.1.3"."cloudabi"}" deps)
    (features_.fuchsia_cprng."${deps."rand_os"."0.1.3"."fuchsia_cprng"}" deps)
    (features_.libc."${deps."rand_os"."0.1.3"."libc"}" deps)
    (features_.winapi."${deps."rand_os"."0.1.3"."winapi"}" deps)
  ];


# end
# rand_pcg-0.1.2

  crates.rand_pcg."0.1.2" = deps: { features?(features_.rand_pcg."0.1.2" deps {}) }: buildRustCrate {
    crateName = "rand_pcg";
    version = "0.1.2";
    authors = [ "The Rand Project Developers" ];
    sha256 = "04qgi2ai2z42li5h4aawvxbpnlqyjfnipz9d6k73mdnl6p1xq938";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."rand_core"."${deps."rand_pcg"."0.1.2"."rand_core"}" deps)
    ]);

    buildDependencies = mapFeatures features ([
      (crates."autocfg"."${deps."rand_pcg"."0.1.2"."autocfg"}" deps)
    ]);
    features = mkFeatures (features."rand_pcg"."0.1.2" or {});
  };
  features_.rand_pcg."0.1.2" = deps: f: updateFeatures f (rec {
    autocfg."${deps.rand_pcg."0.1.2".autocfg}".default = true;
    rand_core."${deps.rand_pcg."0.1.2".rand_core}".default = true;
    rand_pcg = fold recursiveUpdate {} [
      { "0.1.2".default = (f.rand_pcg."0.1.2".default or true); }
      { "0.1.2".serde =
        (f.rand_pcg."0.1.2".serde or false) ||
        (f.rand_pcg."0.1.2".serde1 or false) ||
        (rand_pcg."0.1.2"."serde1" or false); }
      { "0.1.2".serde_derive =
        (f.rand_pcg."0.1.2".serde_derive or false) ||
        (f.rand_pcg."0.1.2".serde1 or false) ||
        (rand_pcg."0.1.2"."serde1" or false); }
    ];
  }) [
    (features_.rand_core."${deps."rand_pcg"."0.1.2"."rand_core"}" deps)
    (features_.autocfg."${deps."rand_pcg"."0.1.2"."autocfg"}" deps)
  ];


# end
# rand_xorshift-0.1.1

  crates.rand_xorshift."0.1.1" = deps: { features?(features_.rand_xorshift."0.1.1" deps {}) }: buildRustCrate {
    crateName = "rand_xorshift";
    version = "0.1.1";
    authors = [ "The Rand Project Developers" "The Rust Project Developers" ];
    sha256 = "0v365c4h4lzxwz5k5kp9m0661s0sss7ylv74if0xb4svis9sswnn";
    dependencies = mapFeatures features ([
      (crates."rand_core"."${deps."rand_xorshift"."0.1.1"."rand_core"}" deps)
    ]);
    features = mkFeatures (features."rand_xorshift"."0.1.1" or {});
  };
  features_.rand_xorshift."0.1.1" = deps: f: updateFeatures f (rec {
    rand_core."${deps.rand_xorshift."0.1.1".rand_core}".default = (f.rand_core."${deps.rand_xorshift."0.1.1".rand_core}".default or false);
    rand_xorshift = fold recursiveUpdate {} [
      { "0.1.1".default = (f.rand_xorshift."0.1.1".default or true); }
      { "0.1.1".serde =
        (f.rand_xorshift."0.1.1".serde or false) ||
        (f.rand_xorshift."0.1.1".serde1 or false) ||
        (rand_xorshift."0.1.1"."serde1" or false); }
      { "0.1.1".serde_derive =
        (f.rand_xorshift."0.1.1".serde_derive or false) ||
        (f.rand_xorshift."0.1.1".serde1 or false) ||
        (rand_xorshift."0.1.1"."serde1" or false); }
    ];
  }) [
    (features_.rand_core."${deps."rand_xorshift"."0.1.1"."rand_core"}" deps)
  ];


# end
# rdrand-0.4.0

  crates.rdrand."0.4.0" = deps: { features?(features_.rdrand."0.4.0" deps {}) }: buildRustCrate {
    crateName = "rdrand";
    version = "0.4.0";
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
      { "0.4.0".default = (f.rdrand."0.4.0".default or true); }
      { "0.4.0".std =
        (f.rdrand."0.4.0".std or false) ||
        (f.rdrand."0.4.0".default or false) ||
        (rdrand."0.4.0"."default" or false); }
    ];
  }) [
    (features_.rand_core."${deps."rdrand"."0.4.0"."rand_core"}" deps)
  ];


# end
# redox_syscall-0.1.51

  crates.redox_syscall."0.1.51" = deps: { features?(features_.redox_syscall."0.1.51" deps {}) }: buildRustCrate {
    crateName = "redox_syscall";
    version = "0.1.51";
    authors = [ "Jeremy Soller <jackpot51@gmail.com>" ];
    sha256 = "1a61cv7yydx64vpyvzr0z0hwzdvy4gcvcnfc6k70zpkngj5sz3ip";
    libName = "syscall";
  };
  features_.redox_syscall."0.1.51" = deps: f: updateFeatures f (rec {
    redox_syscall."0.1.51".default = (f.redox_syscall."0.1.51".default or true);
  }) [];


# end
# redox_termios-0.1.1

  crates.redox_termios."0.1.1" = deps: { features?(features_.redox_termios."0.1.1" deps {}) }: buildRustCrate {
    crateName = "redox_termios";
    version = "0.1.1";
    authors = [ "Jeremy Soller <jackpot51@gmail.com>" ];
    sha256 = "04s6yyzjca552hdaqlvqhp3vw0zqbc304md5czyd3axh56iry8wh";
    libPath = "src/lib.rs";
    dependencies = mapFeatures features ([
      (crates."redox_syscall"."${deps."redox_termios"."0.1.1"."redox_syscall"}" deps)
    ]);
  };
  features_.redox_termios."0.1.1" = deps: f: updateFeatures f (rec {
    redox_syscall."${deps.redox_termios."0.1.1".redox_syscall}".default = true;
    redox_termios."0.1.1".default = (f.redox_termios."0.1.1".default or true);
  }) [
    (features_.redox_syscall."${deps."redox_termios"."0.1.1"."redox_syscall"}" deps)
  ];


# end
# regex-0.2.11

  crates.regex."0.2.11" = deps: { features?(features_.regex."0.2.11" deps {}) }: buildRustCrate {
    crateName = "regex";
    version = "0.2.11";
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
      { "0.2.11".default = (f.regex."0.2.11".default or true); }
      { "0.2.11".pattern =
        (f.regex."0.2.11".pattern or false) ||
        (f.regex."0.2.11".unstable or false) ||
        (regex."0.2.11"."unstable" or false); }
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
# regex-syntax-0.5.6

  crates.regex_syntax."0.5.6" = deps: { features?(features_.regex_syntax."0.5.6" deps {}) }: buildRustCrate {
    crateName = "regex-syntax";
    version = "0.5.6";
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
# remove_dir_all-0.5.1

  crates.remove_dir_all."0.5.1" = deps: { features?(features_.remove_dir_all."0.5.1" deps {}) }: buildRustCrate {
    crateName = "remove_dir_all";
    version = "0.5.1";
    authors = [ "Aaronepower <theaaronepower@gmail.com>" ];
    sha256 = "1chx3yvfbj46xjz4bzsvps208l46hfbcy0sm98gpiya454n4rrl7";
    dependencies = (if kernel == "windows" then mapFeatures features ([
      (crates."winapi"."${deps."remove_dir_all"."0.5.1"."winapi"}" deps)
    ]) else []);
  };
  features_.remove_dir_all."0.5.1" = deps: f: updateFeatures f (rec {
    remove_dir_all."0.5.1".default = (f.remove_dir_all."0.5.1".default or true);
    winapi = fold recursiveUpdate {} [
      { "${deps.remove_dir_all."0.5.1".winapi}"."errhandlingapi" = true; }
      { "${deps.remove_dir_all."0.5.1".winapi}"."fileapi" = true; }
      { "${deps.remove_dir_all."0.5.1".winapi}"."std" = true; }
      { "${deps.remove_dir_all."0.5.1".winapi}"."winbase" = true; }
      { "${deps.remove_dir_all."0.5.1".winapi}"."winerror" = true; }
      { "${deps.remove_dir_all."0.5.1".winapi}".default = true; }
    ];
  }) [
    (features_.winapi."${deps."remove_dir_all"."0.5.1"."winapi"}" deps)
  ];


# end
# ring-0.13.5

  crates.ring."0.13.5" = deps: { features?(features_.ring."0.13.5" deps {}) }: buildRustCrate {
    crateName = "ring";
    version = "0.13.5";
    authors = [ "Brian Smith <brian@briansmith.org>" ];
    sha256 = "0b071zwzwhgmj0xyr7wqc55f4nppgjikfh53nb9m799l096s86j4";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."untrusted"."${deps."ring"."0.13.5"."untrusted"}" deps)
    ])
      ++ (if kernel == "redox" || (kernel == "linux" || kernel == "darwin") && !(kernel == "darwin" || kernel == "ios") then mapFeatures features ([
      (crates."lazy_static"."${deps."ring"."0.13.5"."lazy_static"}" deps)
    ]) else [])
      ++ (if kernel == "linux" then mapFeatures features ([
      (crates."libc"."${deps."ring"."0.13.5"."libc"}" deps)
    ]) else []);

    buildDependencies = mapFeatures features ([
      (crates."cc"."${deps."ring"."0.13.5"."cc"}" deps)
    ]);
    features = mkFeatures (features."ring"."0.13.5" or {});
  };
  features_.ring."0.13.5" = deps: f: updateFeatures f (rec {
    cc."${deps.ring."0.13.5".cc}".default = true;
    lazy_static."${deps.ring."0.13.5".lazy_static}".default = true;
    libc."${deps.ring."0.13.5".libc}".default = true;
    ring = fold recursiveUpdate {} [
      { "0.13.5".default = (f.ring."0.13.5".default or true); }
      { "0.13.5".dev_urandom_fallback =
        (f.ring."0.13.5".dev_urandom_fallback or false) ||
        (f.ring."0.13.5".default or false) ||
        (ring."0.13.5"."default" or false); }
      { "0.13.5".use_heap =
        (f.ring."0.13.5".use_heap or false) ||
        (f.ring."0.13.5".default or false) ||
        (ring."0.13.5"."default" or false) ||
        (f.ring."0.13.5".rsa_signing or false) ||
        (ring."0.13.5"."rsa_signing" or false); }
    ];
    untrusted."${deps.ring."0.13.5".untrusted}".default = true;
  }) [
    (features_.untrusted."${deps."ring"."0.13.5"."untrusted"}" deps)
    (features_.cc."${deps."ring"."0.13.5"."cc"}" deps)
    (features_.lazy_static."${deps."ring"."0.13.5"."lazy_static"}" deps)
    (features_.libc."${deps."ring"."0.13.5"."libc"}" deps)
  ];


# end
# route-recognizer-0.1.12

  crates.route_recognizer."0.1.12" = deps: { features?(features_.route_recognizer."0.1.12" deps {}) }: buildRustCrate {
    crateName = "route-recognizer";
    version = "0.1.12";
    authors = [ "wycats" ];
    sha256 = "16f2inl9zbr2c56idijwivh9hsnr188dv4ny6jmy1ralbs95f3ai";
  };
  features_.route_recognizer."0.1.12" = deps: f: updateFeatures f (rec {
    route_recognizer."0.1.12".default = (f.route_recognizer."0.1.12".default or true);
  }) [];


# end
# router-0.6.0

  crates.router."0.6.0" = deps: { features?(features_.router."0.6.0" deps {}) }: buildRustCrate {
    crateName = "router";
    version = "0.6.0";
    authors = [ "Jonathan Reem <jonathan.reem@gmail.com>" ];
    sha256 = "1nhw5gdslj02ww33czcbvpjlkjsq22bwzzylhbi2781cz0qp9s4w";
    dependencies = mapFeatures features ([
      (crates."iron"."${deps."router"."0.6.0"."iron"}" deps)
      (crates."route_recognizer"."${deps."router"."0.6.0"."route_recognizer"}" deps)
      (crates."url"."${deps."router"."0.6.0"."url"}" deps)
    ]);
  };
  features_.router."0.6.0" = deps: f: updateFeatures f (rec {
    iron."${deps.router."0.6.0".iron}".default = true;
    route_recognizer."${deps.router."0.6.0".route_recognizer}".default = true;
    router."0.6.0".default = (f.router."0.6.0".default or true);
    url."${deps.router."0.6.0".url}".default = true;
  }) [
    (features_.iron."${deps."router"."0.6.0"."iron"}" deps)
    (features_.route_recognizer."${deps."router"."0.6.0"."route_recognizer"}" deps)
    (features_.url."${deps."router"."0.6.0"."url"}" deps)
  ];


# end
# rustc-serialize-0.3.24

  crates.rustc_serialize."0.3.24" = deps: { features?(features_.rustc_serialize."0.3.24" deps {}) }: buildRustCrate {
    crateName = "rustc-serialize";
    version = "0.3.24";
    authors = [ "The Rust Project Developers" ];
    sha256 = "0rfk6p66mqkd3g36l0ddlv2rvnp1mp3lrq5frq9zz5cbnz5pmmxn";
  };
  features_.rustc_serialize."0.3.24" = deps: f: updateFeatures f (rec {
    rustc_serialize."0.3.24".default = (f.rustc_serialize."0.3.24".default or true);
  }) [];


# end
# ryu-0.2.7

  crates.ryu."0.2.7" = deps: { features?(features_.ryu."0.2.7" deps {}) }: buildRustCrate {
    crateName = "ryu";
    version = "0.2.7";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "0m8szf1m87wfqkwh1f9zp9bn2mb0m9nav028xxnd0hlig90b44bd";
    build = "build.rs";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."ryu"."0.2.7" or {});
  };
  features_.ryu."0.2.7" = deps: f: updateFeatures f (rec {
    ryu."0.2.7".default = (f.ryu."0.2.7".default or true);
  }) [];


# end
# safemem-0.2.0

  crates.safemem."0.2.0" = deps: { features?(features_.safemem."0.2.0" deps {}) }: buildRustCrate {
    crateName = "safemem";
    version = "0.2.0";
    authors = [ "Austin Bonander <austin.bonander@gmail.com>" ];
    sha256 = "058m251q202n479ip1h6s91yw3plg66vsk5mpaflssn6rs5hijdm";
  };
  features_.safemem."0.2.0" = deps: f: updateFeatures f (rec {
    safemem."0.2.0".default = (f.safemem."0.2.0".default or true);
  }) [];


# end
# safemem-0.3.0

  crates.safemem."0.3.0" = deps: { features?(features_.safemem."0.3.0" deps {}) }: buildRustCrate {
    crateName = "safemem";
    version = "0.3.0";
    authors = [ "Austin Bonander <austin.bonander@gmail.com>" ];
    sha256 = "0pr39b468d05f6m7m4alsngmj5p7an8df21apsxbi57k0lmwrr18";
    features = mkFeatures (features."safemem"."0.3.0" or {});
  };
  features_.safemem."0.3.0" = deps: f: updateFeatures f (rec {
    safemem = fold recursiveUpdate {} [
      { "0.3.0".default = (f.safemem."0.3.0".default or true); }
      { "0.3.0".std =
        (f.safemem."0.3.0".std or false) ||
        (f.safemem."0.3.0".default or false) ||
        (safemem."0.3.0"."default" or false); }
    ];
  }) [];


# end
# serde-1.0.89

  crates.serde."1.0.89" = deps: { features?(features_.serde."1.0.89" deps {}) }: buildRustCrate {
    crateName = "serde";
    version = "1.0.89";
    authors = [ "Erick Tryzelaar <erick.tryzelaar@gmail.com>" "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "14pidc6skkm92vhp431wi1aam5vv5g6rmsimik38wzb0qy72c71g";
    build = "build.rs";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."serde"."1.0.89" or {});
  };
  features_.serde."1.0.89" = deps: f: updateFeatures f (rec {
    serde = fold recursiveUpdate {} [
      { "1.0.89".default = (f.serde."1.0.89".default or true); }
      { "1.0.89".serde_derive =
        (f.serde."1.0.89".serde_derive or false) ||
        (f.serde."1.0.89".derive or false) ||
        (serde."1.0.89"."derive" or false); }
      { "1.0.89".std =
        (f.serde."1.0.89".std or false) ||
        (f.serde."1.0.89".default or false) ||
        (serde."1.0.89"."default" or false); }
      { "1.0.89".unstable =
        (f.serde."1.0.89".unstable or false) ||
        (f.serde."1.0.89".alloc or false) ||
        (serde."1.0.89"."alloc" or false); }
    ];
  }) [];


# end
# serde_derive-1.0.89

  crates.serde_derive."1.0.89" = deps: { features?(features_.serde_derive."1.0.89" deps {}) }: buildRustCrate {
    crateName = "serde_derive";
    version = "1.0.89";
    authors = [ "Erick Tryzelaar <erick.tryzelaar@gmail.com>" "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "0wxbxq9sccrd939pfnrgfzykkwl9gag2yf7vxhg2c2p9kx36d3wm";
    procMacro = true;
    dependencies = mapFeatures features ([
      (crates."proc_macro2"."${deps."serde_derive"."1.0.89"."proc_macro2"}" deps)
      (crates."quote"."${deps."serde_derive"."1.0.89"."quote"}" deps)
      (crates."syn"."${deps."serde_derive"."1.0.89"."syn"}" deps)
    ]);
    features = mkFeatures (features."serde_derive"."1.0.89" or {});
  };
  features_.serde_derive."1.0.89" = deps: f: updateFeatures f (rec {
    proc_macro2."${deps.serde_derive."1.0.89".proc_macro2}".default = true;
    quote."${deps.serde_derive."1.0.89".quote}".default = true;
    serde_derive."1.0.89".default = (f.serde_derive."1.0.89".default or true);
    syn = fold recursiveUpdate {} [
      { "${deps.serde_derive."1.0.89".syn}"."visit" = true; }
      { "${deps.serde_derive."1.0.89".syn}".default = true; }
    ];
  }) [
    (features_.proc_macro2."${deps."serde_derive"."1.0.89"."proc_macro2"}" deps)
    (features_.quote."${deps."serde_derive"."1.0.89"."quote"}" deps)
    (features_.syn."${deps."serde_derive"."1.0.89"."syn"}" deps)
  ];


# end
# serde_json-1.0.39

  crates.serde_json."1.0.39" = deps: { features?(features_.serde_json."1.0.39" deps {}) }: buildRustCrate {
    crateName = "serde_json";
    version = "1.0.39";
    authors = [ "Erick Tryzelaar <erick.tryzelaar@gmail.com>" "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "07ydv06hn8x0yl0rc94l2wl9r2xz1fqd97n1s6j3bgdc6gw406a8";
    dependencies = mapFeatures features ([
      (crates."itoa"."${deps."serde_json"."1.0.39"."itoa"}" deps)
      (crates."ryu"."${deps."serde_json"."1.0.39"."ryu"}" deps)
      (crates."serde"."${deps."serde_json"."1.0.39"."serde"}" deps)
    ]);
    features = mkFeatures (features."serde_json"."1.0.39" or {});
  };
  features_.serde_json."1.0.39" = deps: f: updateFeatures f (rec {
    itoa."${deps.serde_json."1.0.39".itoa}".default = true;
    ryu."${deps.serde_json."1.0.39".ryu}".default = true;
    serde."${deps.serde_json."1.0.39".serde}".default = true;
    serde_json = fold recursiveUpdate {} [
      { "1.0.39".default = (f.serde_json."1.0.39".default or true); }
      { "1.0.39".indexmap =
        (f.serde_json."1.0.39".indexmap or false) ||
        (f.serde_json."1.0.39".preserve_order or false) ||
        (serde_json."1.0.39"."preserve_order" or false); }
    ];
  }) [
    (features_.itoa."${deps."serde_json"."1.0.39"."itoa"}" deps)
    (features_.ryu."${deps."serde_json"."1.0.39"."ryu"}" deps)
    (features_.serde."${deps."serde_json"."1.0.39"."serde"}" deps)
  ];


# end
# siphasher-0.2.3

  crates.siphasher."0.2.3" = deps: { features?(features_.siphasher."0.2.3" deps {}) }: buildRustCrate {
    crateName = "siphasher";
    version = "0.2.3";
    authors = [ "Frank Denis <github@pureftpd.org>" ];
    sha256 = "1ganj1grxqnkvv4ds3vby039bm999jrr58nfq2x3kjhzkw2bnqkw";
  };
  features_.siphasher."0.2.3" = deps: f: updateFeatures f (rec {
    siphasher."0.2.3".default = (f.siphasher."0.2.3".default or true);
  }) [];


# end
# smallvec-0.6.9

  crates.smallvec."0.6.9" = deps: { features?(features_.smallvec."0.6.9" deps {}) }: buildRustCrate {
    crateName = "smallvec";
    version = "0.6.9";
    authors = [ "Simon Sapin <simon.sapin@exyr.org>" ];
    sha256 = "0p96l51a2pq5y0vn48nhbm6qslbc6k8h28cxm0pmzkqmj7xynz6w";
    libPath = "lib.rs";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."smallvec"."0.6.9" or {});
  };
  features_.smallvec."0.6.9" = deps: f: updateFeatures f (rec {
    smallvec = fold recursiveUpdate {} [
      { "0.6.9".default = (f.smallvec."0.6.9".default or true); }
      { "0.6.9".std =
        (f.smallvec."0.6.9".std or false) ||
        (f.smallvec."0.6.9".default or false) ||
        (smallvec."0.6.9"."default" or false); }
    ];
  }) [];


# end
# strsim-0.7.0

  crates.strsim."0.7.0" = deps: { features?(features_.strsim."0.7.0" deps {}) }: buildRustCrate {
    crateName = "strsim";
    version = "0.7.0";
    authors = [ "Danny Guo <dannyguo91@gmail.com>" ];
    sha256 = "0fy0k5f2705z73mb3x9459bpcvrx4ky8jpr4zikcbiwan4bnm0iv";
  };
  features_.strsim."0.7.0" = deps: f: updateFeatures f (rec {
    strsim."0.7.0".default = (f.strsim."0.7.0".default or true);
  }) [];


# end
# structopt-0.2.15

  crates.structopt."0.2.15" = deps: { features?(features_.structopt."0.2.15" deps {}) }: buildRustCrate {
    crateName = "structopt";
    version = "0.2.15";
    authors = [ "Guillaume Pinot <texitoi@texitoi.eu>" "others" ];
    sha256 = "0hjkdq0zgaiigbqsqazaz4avp5q272kzivb2bfy6s5181240hv2z";
    dependencies = mapFeatures features ([
      (crates."clap"."${deps."structopt"."0.2.15"."clap"}" deps)
      (crates."structopt_derive"."${deps."structopt"."0.2.15"."structopt_derive"}" deps)
    ]);
    features = mkFeatures (features."structopt"."0.2.15" or {});
  };
  features_.structopt."0.2.15" = deps: f: updateFeatures f (rec {
    clap = fold recursiveUpdate {} [
      { "${deps.structopt."0.2.15".clap}"."color" =
        (f.clap."${deps.structopt."0.2.15".clap}"."color" or false) ||
        (structopt."0.2.15"."color" or false) ||
        (f."structopt"."0.2.15"."color" or false); }
      { "${deps.structopt."0.2.15".clap}"."debug" =
        (f.clap."${deps.structopt."0.2.15".clap}"."debug" or false) ||
        (structopt."0.2.15"."debug" or false) ||
        (f."structopt"."0.2.15"."debug" or false); }
      { "${deps.structopt."0.2.15".clap}"."default" =
        (f.clap."${deps.structopt."0.2.15".clap}"."default" or false) ||
        (structopt."0.2.15"."default" or false) ||
        (f."structopt"."0.2.15"."default" or false); }
      { "${deps.structopt."0.2.15".clap}"."doc" =
        (f.clap."${deps.structopt."0.2.15".clap}"."doc" or false) ||
        (structopt."0.2.15"."doc" or false) ||
        (f."structopt"."0.2.15"."doc" or false); }
      { "${deps.structopt."0.2.15".clap}"."lints" =
        (f.clap."${deps.structopt."0.2.15".clap}"."lints" or false) ||
        (structopt."0.2.15"."lints" or false) ||
        (f."structopt"."0.2.15"."lints" or false); }
      { "${deps.structopt."0.2.15".clap}"."no_cargo" =
        (f.clap."${deps.structopt."0.2.15".clap}"."no_cargo" or false) ||
        (structopt."0.2.15"."no_cargo" or false) ||
        (f."structopt"."0.2.15"."no_cargo" or false); }
      { "${deps.structopt."0.2.15".clap}"."suggestions" =
        (f.clap."${deps.structopt."0.2.15".clap}"."suggestions" or false) ||
        (structopt."0.2.15"."suggestions" or false) ||
        (f."structopt"."0.2.15"."suggestions" or false); }
      { "${deps.structopt."0.2.15".clap}"."wrap_help" =
        (f.clap."${deps.structopt."0.2.15".clap}"."wrap_help" or false) ||
        (structopt."0.2.15"."wrap_help" or false) ||
        (f."structopt"."0.2.15"."wrap_help" or false); }
      { "${deps.structopt."0.2.15".clap}"."yaml" =
        (f.clap."${deps.structopt."0.2.15".clap}"."yaml" or false) ||
        (structopt."0.2.15"."yaml" or false) ||
        (f."structopt"."0.2.15"."yaml" or false); }
      { "${deps.structopt."0.2.15".clap}".default = (f.clap."${deps.structopt."0.2.15".clap}".default or false); }
    ];
    structopt."0.2.15".default = (f.structopt."0.2.15".default or true);
    structopt_derive = fold recursiveUpdate {} [
      { "${deps.structopt."0.2.15".structopt_derive}"."nightly" =
        (f.structopt_derive."${deps.structopt."0.2.15".structopt_derive}"."nightly" or false) ||
        (structopt."0.2.15"."nightly" or false) ||
        (f."structopt"."0.2.15"."nightly" or false); }
      { "${deps.structopt."0.2.15".structopt_derive}".default = true; }
    ];
  }) [
    (features_.clap."${deps."structopt"."0.2.15"."clap"}" deps)
    (features_.structopt_derive."${deps."structopt"."0.2.15"."structopt_derive"}" deps)
  ];


# end
# structopt-derive-0.2.15

  crates.structopt_derive."0.2.15" = deps: { features?(features_.structopt_derive."0.2.15" deps {}) }: buildRustCrate {
    crateName = "structopt-derive";
    version = "0.2.15";
    authors = [ "Guillaume Pinot <texitoi@texitoi.eu>" ];
    sha256 = "09rg6993ckyaklribdcqnw2v3516afdl5pa0z21lwrwz0bvxsf2n";
    procMacro = true;
    dependencies = mapFeatures features ([
      (crates."heck"."${deps."structopt_derive"."0.2.15"."heck"}" deps)
      (crates."proc_macro2"."${deps."structopt_derive"."0.2.15"."proc_macro2"}" deps)
      (crates."quote"."${deps."structopt_derive"."0.2.15"."quote"}" deps)
      (crates."syn"."${deps."structopt_derive"."0.2.15"."syn"}" deps)
    ]);
    features = mkFeatures (features."structopt_derive"."0.2.15" or {});
  };
  features_.structopt_derive."0.2.15" = deps: f: updateFeatures f (rec {
    heck."${deps.structopt_derive."0.2.15".heck}".default = true;
    proc_macro2 = fold recursiveUpdate {} [
      { "${deps.structopt_derive."0.2.15".proc_macro2}"."nightly" =
        (f.proc_macro2."${deps.structopt_derive."0.2.15".proc_macro2}"."nightly" or false) ||
        (structopt_derive."0.2.15"."nightly" or false) ||
        (f."structopt_derive"."0.2.15"."nightly" or false); }
      { "${deps.structopt_derive."0.2.15".proc_macro2}".default = true; }
    ];
    quote."${deps.structopt_derive."0.2.15".quote}".default = true;
    structopt_derive."0.2.15".default = (f.structopt_derive."0.2.15".default or true);
    syn."${deps.structopt_derive."0.2.15".syn}".default = true;
  }) [
    (features_.heck."${deps."structopt_derive"."0.2.15"."heck"}" deps)
    (features_.proc_macro2."${deps."structopt_derive"."0.2.15"."proc_macro2"}" deps)
    (features_.quote."${deps."structopt_derive"."0.2.15"."quote"}" deps)
    (features_.syn."${deps."structopt_derive"."0.2.15"."syn"}" deps)
  ];


# end
# syn-0.15.29

  crates.syn."0.15.29" = deps: { features?(features_.syn."0.15.29" deps {}) }: buildRustCrate {
    crateName = "syn";
    version = "0.15.29";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "0wrd6awgc6f1iwfn2v9fvwyd2yddgxdjv9s106kvwg1ljbw3fajw";
    dependencies = mapFeatures features ([
      (crates."proc_macro2"."${deps."syn"."0.15.29"."proc_macro2"}" deps)
      (crates."unicode_xid"."${deps."syn"."0.15.29"."unicode_xid"}" deps)
    ]
      ++ (if features.syn."0.15.29".quote or false then [ (crates.quote."${deps."syn"."0.15.29".quote}" deps) ] else []));
    features = mkFeatures (features."syn"."0.15.29" or {});
  };
  features_.syn."0.15.29" = deps: f: updateFeatures f (rec {
    proc_macro2 = fold recursiveUpdate {} [
      { "${deps.syn."0.15.29".proc_macro2}"."proc-macro" =
        (f.proc_macro2."${deps.syn."0.15.29".proc_macro2}"."proc-macro" or false) ||
        (syn."0.15.29"."proc-macro" or false) ||
        (f."syn"."0.15.29"."proc-macro" or false); }
      { "${deps.syn."0.15.29".proc_macro2}".default = (f.proc_macro2."${deps.syn."0.15.29".proc_macro2}".default or false); }
    ];
    quote = fold recursiveUpdate {} [
      { "${deps.syn."0.15.29".quote}"."proc-macro" =
        (f.quote."${deps.syn."0.15.29".quote}"."proc-macro" or false) ||
        (syn."0.15.29"."proc-macro" or false) ||
        (f."syn"."0.15.29"."proc-macro" or false); }
      { "${deps.syn."0.15.29".quote}".default = (f.quote."${deps.syn."0.15.29".quote}".default or false); }
    ];
    syn = fold recursiveUpdate {} [
      { "0.15.29".clone-impls =
        (f.syn."0.15.29".clone-impls or false) ||
        (f.syn."0.15.29".default or false) ||
        (syn."0.15.29"."default" or false); }
      { "0.15.29".default = (f.syn."0.15.29".default or true); }
      { "0.15.29".derive =
        (f.syn."0.15.29".derive or false) ||
        (f.syn."0.15.29".default or false) ||
        (syn."0.15.29"."default" or false); }
      { "0.15.29".parsing =
        (f.syn."0.15.29".parsing or false) ||
        (f.syn."0.15.29".default or false) ||
        (syn."0.15.29"."default" or false); }
      { "0.15.29".printing =
        (f.syn."0.15.29".printing or false) ||
        (f.syn."0.15.29".default or false) ||
        (syn."0.15.29"."default" or false); }
      { "0.15.29".proc-macro =
        (f.syn."0.15.29".proc-macro or false) ||
        (f.syn."0.15.29".default or false) ||
        (syn."0.15.29"."default" or false); }
      { "0.15.29".quote =
        (f.syn."0.15.29".quote or false) ||
        (f.syn."0.15.29".printing or false) ||
        (syn."0.15.29"."printing" or false); }
    ];
    unicode_xid."${deps.syn."0.15.29".unicode_xid}".default = true;
  }) [
    (features_.proc_macro2."${deps."syn"."0.15.29"."proc_macro2"}" deps)
    (features_.quote."${deps."syn"."0.15.29"."quote"}" deps)
    (features_.unicode_xid."${deps."syn"."0.15.29"."unicode_xid"}" deps)
  ];


# end
# tempdir-0.3.7

  crates.tempdir."0.3.7" = deps: { features?(features_.tempdir."0.3.7" deps {}) }: buildRustCrate {
    crateName = "tempdir";
    version = "0.3.7";
    authors = [ "The Rust Project Developers" ];
    sha256 = "0y53sxybyljrr7lh0x0ysrsa7p7cljmwv9v80acy3rc6n97g67vy";
    dependencies = mapFeatures features ([
      (crates."rand"."${deps."tempdir"."0.3.7"."rand"}" deps)
      (crates."remove_dir_all"."${deps."tempdir"."0.3.7"."remove_dir_all"}" deps)
    ]);
  };
  features_.tempdir."0.3.7" = deps: f: updateFeatures f (rec {
    rand."${deps.tempdir."0.3.7".rand}".default = true;
    remove_dir_all."${deps.tempdir."0.3.7".remove_dir_all}".default = true;
    tempdir."0.3.7".default = (f.tempdir."0.3.7".default or true);
  }) [
    (features_.rand."${deps."tempdir"."0.3.7"."rand"}" deps)
    (features_.remove_dir_all."${deps."tempdir"."0.3.7"."remove_dir_all"}" deps)
  ];


# end
# termion-1.5.1

  crates.termion."1.5.1" = deps: { features?(features_.termion."1.5.1" deps {}) }: buildRustCrate {
    crateName = "termion";
    version = "1.5.1";
    authors = [ "ticki <Ticki@users.noreply.github.com>" "gycos <alexandre.bury@gmail.com>" "IGI-111 <igi-111@protonmail.com>" ];
    sha256 = "02gq4vd8iws1f3gjrgrgpajsk2bk43nds5acbbb4s8dvrdvr8nf1";
    dependencies = (if !(kernel == "redox") then mapFeatures features ([
      (crates."libc"."${deps."termion"."1.5.1"."libc"}" deps)
    ]) else [])
      ++ (if kernel == "redox" then mapFeatures features ([
      (crates."redox_syscall"."${deps."termion"."1.5.1"."redox_syscall"}" deps)
      (crates."redox_termios"."${deps."termion"."1.5.1"."redox_termios"}" deps)
    ]) else []);
  };
  features_.termion."1.5.1" = deps: f: updateFeatures f (rec {
    libc."${deps.termion."1.5.1".libc}".default = true;
    redox_syscall."${deps.termion."1.5.1".redox_syscall}".default = true;
    redox_termios."${deps.termion."1.5.1".redox_termios}".default = true;
    termion."1.5.1".default = (f.termion."1.5.1".default or true);
  }) [
    (features_.libc."${deps."termion"."1.5.1"."libc"}" deps)
    (features_.redox_syscall."${deps."termion"."1.5.1"."redox_syscall"}" deps)
    (features_.redox_termios."${deps."termion"."1.5.1"."redox_termios"}" deps)
  ];


# end
# textwrap-0.10.0

  crates.textwrap."0.10.0" = deps: { features?(features_.textwrap."0.10.0" deps {}) }: buildRustCrate {
    crateName = "textwrap";
    version = "0.10.0";
    authors = [ "Martin Geisler <martin@geisler.net>" ];
    sha256 = "1s8d5cna12smhgj0x2y1xphklyk2an1yzbadnj89p1vy5vnjpsas";
    dependencies = mapFeatures features ([
      (crates."unicode_width"."${deps."textwrap"."0.10.0"."unicode_width"}" deps)
    ]);
  };
  features_.textwrap."0.10.0" = deps: f: updateFeatures f (rec {
    textwrap."0.10.0".default = (f.textwrap."0.10.0".default or true);
    unicode_width."${deps.textwrap."0.10.0".unicode_width}".default = true;
  }) [
    (features_.unicode_width."${deps."textwrap"."0.10.0"."unicode_width"}" deps)
  ];


# end
# thread_local-0.3.6

  crates.thread_local."0.3.6" = deps: { features?(features_.thread_local."0.3.6" deps {}) }: buildRustCrate {
    crateName = "thread_local";
    version = "0.3.6";
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
# traitobject-0.1.0

  crates.traitobject."0.1.0" = deps: { features?(features_.traitobject."0.1.0" deps {}) }: buildRustCrate {
    crateName = "traitobject";
    version = "0.1.0";
    authors = [ "Jonathan Reem <jonathan.reem@gmail.com>" ];
    sha256 = "10hi8pl361l539g4kg74mcrhn7grmwlar4jl528ddn2z2jvb7lw3";
  };
  features_.traitobject."0.1.0" = deps: f: updateFeatures f (rec {
    traitobject."0.1.0".default = (f.traitobject."0.1.0".default or true);
  }) [];


# end
# twoway-0.1.8

  crates.twoway."0.1.8" = deps: { features?(features_.twoway."0.1.8" deps {}) }: buildRustCrate {
    crateName = "twoway";
    version = "0.1.8";
    authors = [ "bluss" ];
    sha256 = "0svrdcy08h0gm884f220hx37g8fsp5z6abaw6jb6g3f7djw1ir1g";
    dependencies = mapFeatures features ([
      (crates."memchr"."${deps."twoway"."0.1.8"."memchr"}" deps)
    ]);
    features = mkFeatures (features."twoway"."0.1.8" or {});
  };
  features_.twoway."0.1.8" = deps: f: updateFeatures f (rec {
    memchr = fold recursiveUpdate {} [
      { "${deps.twoway."0.1.8".memchr}"."use_std" =
        (f.memchr."${deps.twoway."0.1.8".memchr}"."use_std" or false) ||
        (twoway."0.1.8"."use_std" or false) ||
        (f."twoway"."0.1.8"."use_std" or false); }
      { "${deps.twoway."0.1.8".memchr}".default = (f.memchr."${deps.twoway."0.1.8".memchr}".default or false); }
    ];
    twoway = fold recursiveUpdate {} [
      { "0.1.8".default = (f.twoway."0.1.8".default or true); }
      { "0.1.8".galil-seiferas =
        (f.twoway."0.1.8".galil-seiferas or false) ||
        (f.twoway."0.1.8".benchmarks or false) ||
        (twoway."0.1.8"."benchmarks" or false); }
      { "0.1.8".jetscii =
        (f.twoway."0.1.8".jetscii or false) ||
        (f.twoway."0.1.8".all or false) ||
        (twoway."0.1.8"."all" or false); }
      { "0.1.8".pattern =
        (f.twoway."0.1.8".pattern or false) ||
        (f.twoway."0.1.8".all or false) ||
        (twoway."0.1.8"."all" or false) ||
        (f.twoway."0.1.8".benchmarks or false) ||
        (twoway."0.1.8"."benchmarks" or false); }
      { "0.1.8".pcmp =
        (f.twoway."0.1.8".pcmp or false) ||
        (f.twoway."0.1.8".all or false) ||
        (twoway."0.1.8"."all" or false); }
      { "0.1.8".test-set =
        (f.twoway."0.1.8".test-set or false) ||
        (f.twoway."0.1.8".all or false) ||
        (twoway."0.1.8"."all" or false); }
      { "0.1.8".unchecked-index =
        (f.twoway."0.1.8".unchecked-index or false) ||
        (f.twoway."0.1.8".benchmarks or false) ||
        (twoway."0.1.8"."benchmarks" or false) ||
        (f.twoway."0.1.8".pcmp or false) ||
        (twoway."0.1.8"."pcmp" or false); }
      { "0.1.8".use_std =
        (f.twoway."0.1.8".use_std or false) ||
        (f.twoway."0.1.8".default or false) ||
        (twoway."0.1.8"."default" or false); }
    ];
  }) [
    (features_.memchr."${deps."twoway"."0.1.8"."memchr"}" deps)
  ];


# end
# typeable-0.1.2

  crates.typeable."0.1.2" = deps: { features?(features_.typeable."0.1.2" deps {}) }: buildRustCrate {
    crateName = "typeable";
    version = "0.1.2";
    authors = [ "Jonathan Reem <jonathan.reem@gmail.com>" ];
    sha256 = "0lvff10hwyy852m6r11msyv1rpgpnapn284i8dk0p0q5saqvbvnx";
  };
  features_.typeable."0.1.2" = deps: f: updateFeatures f (rec {
    typeable."0.1.2".default = (f.typeable."0.1.2".default or true);
  }) [];


# end
# typemap-0.3.3

  crates.typemap."0.3.3" = deps: { features?(features_.typemap."0.3.3" deps {}) }: buildRustCrate {
    crateName = "typemap";
    version = "0.3.3";
    authors = [ "Jonathan Reem <jonathan.reem@gmail.com>" ];
    sha256 = "1whvpcq2slamy310z5hd3hl214v91sdxmd9avlqa1bn3l258svkx";
    dependencies = mapFeatures features ([
      (crates."unsafe_any"."${deps."typemap"."0.3.3"."unsafe_any"}" deps)
    ]);
  };
  features_.typemap."0.3.3" = deps: f: updateFeatures f (rec {
    typemap."0.3.3".default = (f.typemap."0.3.3".default or true);
    unsafe_any."${deps.typemap."0.3.3".unsafe_any}".default = true;
  }) [
    (features_.unsafe_any."${deps."typemap"."0.3.3"."unsafe_any"}" deps)
  ];


# end
# typenum-1.10.0

  crates.typenum."1.10.0" = deps: { features?(features_.typenum."1.10.0" deps {}) }: buildRustCrate {
    crateName = "typenum";
    version = "1.10.0";
    authors = [ "Paho Lurie-Gregg <paho@paholg.com>" "Andre Bogus <bogusandre@gmail.com>" ];
    sha256 = "1v2cgg0mlzkg5prs7swysckgk2ay6bpda8m83c2sn3z77dcsx3bc";
    build = "build/main.rs";
    features = mkFeatures (features."typenum"."1.10.0" or {});
  };
  features_.typenum."1.10.0" = deps: f: updateFeatures f (rec {
    typenum."1.10.0".default = (f.typenum."1.10.0".default or true);
  }) [];


# end
# ucd-util-0.1.3

  crates.ucd_util."0.1.3" = deps: { features?(features_.ucd_util."0.1.3" deps {}) }: buildRustCrate {
    crateName = "ucd-util";
    version = "0.1.3";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" ];
    sha256 = "1n1qi3jywq5syq90z9qd8qzbn58pcjgv1sx4sdmipm4jf9zanz15";
  };
  features_.ucd_util."0.1.3" = deps: f: updateFeatures f (rec {
    ucd_util."0.1.3".default = (f.ucd_util."0.1.3".default or true);
  }) [];


# end
# unicase-1.4.2

  crates.unicase."1.4.2" = deps: { features?(features_.unicase."1.4.2" deps {}) }: buildRustCrate {
    crateName = "unicase";
    version = "1.4.2";
    authors = [ "Sean McArthur <sean.monstar@gmail.com>" ];
    sha256 = "0rbnhw2mnhcwrij3vczp0sl8zdfmvf2dlh8hly81kj7132kfj0mf";
    build = "build.rs";
    dependencies = mapFeatures features ([
]);

    buildDependencies = mapFeatures features ([
      (crates."version_check"."${deps."unicase"."1.4.2"."version_check"}" deps)
    ]);
    features = mkFeatures (features."unicase"."1.4.2" or {});
  };
  features_.unicase."1.4.2" = deps: f: updateFeatures f (rec {
    unicase = fold recursiveUpdate {} [
      { "1.4.2".default = (f.unicase."1.4.2".default or true); }
      { "1.4.2".heapsize =
        (f.unicase."1.4.2".heapsize or false) ||
        (f.unicase."1.4.2".heap_size or false) ||
        (unicase."1.4.2"."heap_size" or false); }
      { "1.4.2".heapsize_plugin =
        (f.unicase."1.4.2".heapsize_plugin or false) ||
        (f.unicase."1.4.2".heap_size or false) ||
        (unicase."1.4.2"."heap_size" or false); }
    ];
    version_check."${deps.unicase."1.4.2".version_check}".default = true;
  }) [
    (features_.version_check."${deps."unicase"."1.4.2"."version_check"}" deps)
  ];


# end
# unicode-bidi-0.3.4

  crates.unicode_bidi."0.3.4" = deps: { features?(features_.unicode_bidi."0.3.4" deps {}) }: buildRustCrate {
    crateName = "unicode-bidi";
    version = "0.3.4";
    authors = [ "The Servo Project Developers" ];
    sha256 = "0lcd6jasrf8p9p0q20qyf10c6xhvw40m2c4rr105hbk6zy26nj1q";
    libName = "unicode_bidi";
    dependencies = mapFeatures features ([
      (crates."matches"."${deps."unicode_bidi"."0.3.4"."matches"}" deps)
    ]);
    features = mkFeatures (features."unicode_bidi"."0.3.4" or {});
  };
  features_.unicode_bidi."0.3.4" = deps: f: updateFeatures f (rec {
    matches."${deps.unicode_bidi."0.3.4".matches}".default = true;
    unicode_bidi = fold recursiveUpdate {} [
      { "0.3.4".default = (f.unicode_bidi."0.3.4".default or true); }
      { "0.3.4".flame =
        (f.unicode_bidi."0.3.4".flame or false) ||
        (f.unicode_bidi."0.3.4".flame_it or false) ||
        (unicode_bidi."0.3.4"."flame_it" or false); }
      { "0.3.4".flamer =
        (f.unicode_bidi."0.3.4".flamer or false) ||
        (f.unicode_bidi."0.3.4".flame_it or false) ||
        (unicode_bidi."0.3.4"."flame_it" or false); }
      { "0.3.4".serde =
        (f.unicode_bidi."0.3.4".serde or false) ||
        (f.unicode_bidi."0.3.4".with_serde or false) ||
        (unicode_bidi."0.3.4"."with_serde" or false); }
    ];
  }) [
    (features_.matches."${deps."unicode_bidi"."0.3.4"."matches"}" deps)
  ];


# end
# unicode-normalization-0.1.8

  crates.unicode_normalization."0.1.8" = deps: { features?(features_.unicode_normalization."0.1.8" deps {}) }: buildRustCrate {
    crateName = "unicode-normalization";
    version = "0.1.8";
    authors = [ "kwantam <kwantam@gmail.com>" ];
    sha256 = "1pb26i2xd5zz0icabyqahikpca0iwj2jd4145pczc4bb7p641dsz";
    dependencies = mapFeatures features ([
      (crates."smallvec"."${deps."unicode_normalization"."0.1.8"."smallvec"}" deps)
    ]);
  };
  features_.unicode_normalization."0.1.8" = deps: f: updateFeatures f (rec {
    smallvec."${deps.unicode_normalization."0.1.8".smallvec}".default = true;
    unicode_normalization."0.1.8".default = (f.unicode_normalization."0.1.8".default or true);
  }) [
    (features_.smallvec."${deps."unicode_normalization"."0.1.8"."smallvec"}" deps)
  ];


# end
# unicode-segmentation-1.2.1

  crates.unicode_segmentation."1.2.1" = deps: { features?(features_.unicode_segmentation."1.2.1" deps {}) }: buildRustCrate {
    crateName = "unicode-segmentation";
    version = "1.2.1";
    authors = [ "kwantam <kwantam@gmail.com>" ];
    sha256 = "0pzydlrq019cdiqbbfq205cskxcspwi97zfdi02rma21br1kc59m";
    features = mkFeatures (features."unicode_segmentation"."1.2.1" or {});
  };
  features_.unicode_segmentation."1.2.1" = deps: f: updateFeatures f (rec {
    unicode_segmentation."1.2.1".default = (f.unicode_segmentation."1.2.1".default or true);
  }) [];


# end
# unicode-width-0.1.5

  crates.unicode_width."0.1.5" = deps: { features?(features_.unicode_width."0.1.5" deps {}) }: buildRustCrate {
    crateName = "unicode-width";
    version = "0.1.5";
    authors = [ "kwantam <kwantam@gmail.com>" ];
    sha256 = "0886lc2aymwgy0lhavwn6s48ik3c61ykzzd3za6prgnw51j7bi4w";
    features = mkFeatures (features."unicode_width"."0.1.5" or {});
  };
  features_.unicode_width."0.1.5" = deps: f: updateFeatures f (rec {
    unicode_width."0.1.5".default = (f.unicode_width."0.1.5".default or true);
  }) [];


# end
# unicode-xid-0.1.0

  crates.unicode_xid."0.1.0" = deps: { features?(features_.unicode_xid."0.1.0" deps {}) }: buildRustCrate {
    crateName = "unicode-xid";
    version = "0.1.0";
    authors = [ "erick.tryzelaar <erick.tryzelaar@gmail.com>" "kwantam <kwantam@gmail.com>" ];
    sha256 = "05wdmwlfzxhq3nhsxn6wx4q8dhxzzfb9szsz6wiw092m1rjj01zj";
    features = mkFeatures (features."unicode_xid"."0.1.0" or {});
  };
  features_.unicode_xid."0.1.0" = deps: f: updateFeatures f (rec {
    unicode_xid."0.1.0".default = (f.unicode_xid."0.1.0".default or true);
  }) [];


# end
# unsafe-any-0.4.2

  crates.unsafe_any."0.4.2" = deps: { features?(features_.unsafe_any."0.4.2" deps {}) }: buildRustCrate {
    crateName = "unsafe-any";
    version = "0.4.2";
    authors = [ "Jonathan Reem <jonathan.reem@gmail.com>" ];
    sha256 = "1zcvx5s71fbx4l691bg770g9yx947b8mmp4yf0mczcric07sh44s";
    dependencies = mapFeatures features ([
      (crates."traitobject"."${deps."unsafe_any"."0.4.2"."traitobject"}" deps)
    ]);
  };
  features_.unsafe_any."0.4.2" = deps: f: updateFeatures f (rec {
    traitobject."${deps.unsafe_any."0.4.2".traitobject}".default = true;
    unsafe_any."0.4.2".default = (f.unsafe_any."0.4.2".default or true);
  }) [
    (features_.traitobject."${deps."unsafe_any"."0.4.2"."traitobject"}" deps)
  ];


# end
# untrusted-0.6.2

  crates.untrusted."0.6.2" = deps: { features?(features_.untrusted."0.6.2" deps {}) }: buildRustCrate {
    crateName = "untrusted";
    version = "0.6.2";
    authors = [ "Brian Smith <brian@briansmith.org>" ];
    sha256 = "189ir1h2xgb290bhjchwczr9ygia1f3ipsydf6pwnnb95lb8fihg";
    libPath = "src/untrusted.rs";
  };
  features_.untrusted."0.6.2" = deps: f: updateFeatures f (rec {
    untrusted."0.6.2".default = (f.untrusted."0.6.2".default or true);
  }) [];


# end
# url-1.7.2

  crates.url."1.7.2" = deps: { features?(features_.url."1.7.2" deps {}) }: buildRustCrate {
    crateName = "url";
    version = "1.7.2";
    authors = [ "The rust-url developers" ];
    sha256 = "0qzrjzd9r1niv7037x4cgnv98fs1vj0k18lpxx890ipc47x5gc09";
    dependencies = mapFeatures features ([
      (crates."idna"."${deps."url"."1.7.2"."idna"}" deps)
      (crates."matches"."${deps."url"."1.7.2"."matches"}" deps)
      (crates."percent_encoding"."${deps."url"."1.7.2"."percent_encoding"}" deps)
    ]);
    features = mkFeatures (features."url"."1.7.2" or {});
  };
  features_.url."1.7.2" = deps: f: updateFeatures f (rec {
    idna."${deps.url."1.7.2".idna}".default = true;
    matches."${deps.url."1.7.2".matches}".default = true;
    percent_encoding."${deps.url."1.7.2".percent_encoding}".default = true;
    url = fold recursiveUpdate {} [
      { "1.7.2".default = (f.url."1.7.2".default or true); }
      { "1.7.2".encoding =
        (f.url."1.7.2".encoding or false) ||
        (f.url."1.7.2".query_encoding or false) ||
        (url."1.7.2"."query_encoding" or false); }
      { "1.7.2".heapsize =
        (f.url."1.7.2".heapsize or false) ||
        (f.url."1.7.2".heap_size or false) ||
        (url."1.7.2"."heap_size" or false); }
    ];
  }) [
    (features_.idna."${deps."url"."1.7.2"."idna"}" deps)
    (features_.matches."${deps."url"."1.7.2"."matches"}" deps)
    (features_.percent_encoding."${deps."url"."1.7.2"."percent_encoding"}" deps)
  ];


# end
# urlencoded-0.6.0

  crates.urlencoded."0.6.0" = deps: { features?(features_.urlencoded."0.6.0" deps {}) }: buildRustCrate {
    crateName = "urlencoded";
    version = "0.6.0";
    authors = [ "Patrick Tran <patrick.tran06@gmail.com>" "Jonathan Reem <jonathan.reem@gmail.com>" "Michael Sproul <micsproul@gmail.com>" ];
    sha256 = "0yc7kcm96ilydhq6h1riq1mr4p76sj8x45idn7m4zn20q77cqsmr";
    dependencies = mapFeatures features ([
      (crates."bodyparser"."${deps."urlencoded"."0.6.0"."bodyparser"}" deps)
      (crates."iron"."${deps."urlencoded"."0.6.0"."iron"}" deps)
      (crates."plugin"."${deps."urlencoded"."0.6.0"."plugin"}" deps)
      (crates."url"."${deps."urlencoded"."0.6.0"."url"}" deps)
    ]);
  };
  features_.urlencoded."0.6.0" = deps: f: updateFeatures f (rec {
    bodyparser."${deps.urlencoded."0.6.0".bodyparser}".default = true;
    iron."${deps.urlencoded."0.6.0".iron}".default = true;
    plugin."${deps.urlencoded."0.6.0".plugin}".default = true;
    url."${deps.urlencoded."0.6.0".url}".default = true;
    urlencoded."0.6.0".default = (f.urlencoded."0.6.0".default or true);
  }) [
    (features_.bodyparser."${deps."urlencoded"."0.6.0"."bodyparser"}" deps)
    (features_.iron."${deps."urlencoded"."0.6.0"."iron"}" deps)
    (features_.plugin."${deps."urlencoded"."0.6.0"."plugin"}" deps)
    (features_.url."${deps."urlencoded"."0.6.0"."url"}" deps)
  ];


# end
# urlencoding-1.0.0

  crates.urlencoding."1.0.0" = deps: { features?(features_.urlencoding."1.0.0" deps {}) }: buildRustCrate {
    crateName = "urlencoding";
    version = "1.0.0";
    authors = [ "Bertram Truong <b@bertramtruong.com>" ];
    sha256 = "0nc8ag5wfvq1bxwmss7kmcnyp7kda5d6ks77gkbfgyx7x336ykrh";
  };
  features_.urlencoding."1.0.0" = deps: f: updateFeatures f (rec {
    urlencoding."1.0.0".default = (f.urlencoding."1.0.0".default or true);
  }) [];


# end
# utf8-ranges-1.0.2

  crates.utf8_ranges."1.0.2" = deps: { features?(features_.utf8_ranges."1.0.2" deps {}) }: buildRustCrate {
    crateName = "utf8-ranges";
    version = "1.0.2";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" ];
    sha256 = "1my02laqsgnd8ib4dvjgd4rilprqjad6pb9jj9vi67csi5qs2281";
  };
  features_.utf8_ranges."1.0.2" = deps: f: updateFeatures f (rec {
    utf8_ranges."1.0.2".default = (f.utf8_ranges."1.0.2".default or true);
  }) [];


# end
# uuid-0.6.5

  crates.uuid."0.6.5" = deps: { features?(features_.uuid."0.6.5" deps {}) }: buildRustCrate {
    crateName = "uuid";
    version = "0.6.5";
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
      { "0.6.5".byteorder =
        (f.uuid."0.6.5".byteorder or false) ||
        (f.uuid."0.6.5".u128 or false) ||
        (uuid."0.6.5"."u128" or false); }
      { "0.6.5".default = (f.uuid."0.6.5".default or true); }
      { "0.6.5".md5 =
        (f.uuid."0.6.5".md5 or false) ||
        (f.uuid."0.6.5".v3 or false) ||
        (uuid."0.6.5"."v3" or false); }
      { "0.6.5".nightly =
        (f.uuid."0.6.5".nightly or false) ||
        (f.uuid."0.6.5".const_fn or false) ||
        (uuid."0.6.5"."const_fn" or false); }
      { "0.6.5".rand =
        (f.uuid."0.6.5".rand or false) ||
        (f.uuid."0.6.5".v3 or false) ||
        (uuid."0.6.5"."v3" or false) ||
        (f.uuid."0.6.5".v4 or false) ||
        (uuid."0.6.5"."v4" or false) ||
        (f.uuid."0.6.5".v5 or false) ||
        (uuid."0.6.5"."v5" or false); }
      { "0.6.5".sha1 =
        (f.uuid."0.6.5".sha1 or false) ||
        (f.uuid."0.6.5".v5 or false) ||
        (uuid."0.6.5"."v5" or false); }
      { "0.6.5".std =
        (f.uuid."0.6.5".std or false) ||
        (f.uuid."0.6.5".default or false) ||
        (uuid."0.6.5"."default" or false) ||
        (f.uuid."0.6.5".use_std or false) ||
        (uuid."0.6.5"."use_std" or false); }
    ];
  }) [
    (features_.cfg_if."${deps."uuid"."0.6.5"."cfg_if"}" deps)
    (features_.rand."${deps."uuid"."0.6.5"."rand"}" deps)
    (features_.serde."${deps."uuid"."0.6.5"."serde"}" deps)
  ];


# end
# vec_map-0.8.1

  crates.vec_map."0.8.1" = deps: { features?(features_.vec_map."0.8.1" deps {}) }: buildRustCrate {
    crateName = "vec_map";
    version = "0.8.1";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" "Jorge Aparicio <japaricious@gmail.com>" "Alexis Beingessner <a.beingessner@gmail.com>" "Brian Anderson <>" "tbu- <>" "Manish Goregaokar <>" "Aaron Turon <aturon@mozilla.com>" "Adolfo Ochagavía <>" "Niko Matsakis <>" "Steven Fackler <>" "Chase Southwood <csouth3@illinois.edu>" "Eduard Burtescu <>" "Florian Wilkens <>" "Félix Raimundo <>" "Tibor Benke <>" "Markus Siemens <markus@m-siemens.de>" "Josh Branchaud <jbranchaud@gmail.com>" "Huon Wilson <dbau.pp@gmail.com>" "Corey Farwell <coref@rwell.org>" "Aaron Liblong <>" "Nick Cameron <nrc@ncameron.org>" "Patrick Walton <pcwalton@mimiga.net>" "Felix S Klock II <>" "Andrew Paseltiner <apaseltiner@gmail.com>" "Sean McArthur <sean.monstar@gmail.com>" "Vadim Petrochenkov <>" ];
    sha256 = "1jj2nrg8h3l53d43rwkpkikq5a5x15ms4rf1rw92hp5lrqhi8mpi";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."vec_map"."0.8.1" or {});
  };
  features_.vec_map."0.8.1" = deps: f: updateFeatures f (rec {
    vec_map = fold recursiveUpdate {} [
      { "0.8.1".default = (f.vec_map."0.8.1".default or true); }
      { "0.8.1".serde =
        (f.vec_map."0.8.1".serde or false) ||
        (f.vec_map."0.8.1".eders or false) ||
        (vec_map."0.8.1"."eders" or false); }
    ];
  }) [];


# end
# version_check-0.1.5

  crates.version_check."0.1.5" = deps: { features?(features_.version_check."0.1.5" deps {}) }: buildRustCrate {
    crateName = "version_check";
    version = "0.1.5";
    authors = [ "Sergio Benitez <sb@sergio.bz>" ];
    sha256 = "1yrx9xblmwbafw2firxyqbj8f771kkzfd24n3q7xgwiqyhi0y8qd";
  };
  features_.version_check."0.1.5" = deps: f: updateFeatures f (rec {
    version_check."0.1.5".default = (f.version_check."0.1.5".default or true);
  }) [];


# end
# winapi-0.3.6

  crates.winapi."0.3.6" = deps: { features?(features_.winapi."0.3.6" deps {}) }: buildRustCrate {
    crateName = "winapi";
    version = "0.3.6";
    authors = [ "Peter Atashian <retep998@gmail.com>" ];
    sha256 = "1d9jfp4cjd82sr1q4dgdlrkvm33zhhav9d7ihr0nivqbncr059m4";
    build = "build.rs";
    dependencies = (if kernel == "i686-pc-windows-gnu" then mapFeatures features ([
      (crates."winapi_i686_pc_windows_gnu"."${deps."winapi"."0.3.6"."winapi_i686_pc_windows_gnu"}" deps)
    ]) else [])
      ++ (if kernel == "x86_64-pc-windows-gnu" then mapFeatures features ([
      (crates."winapi_x86_64_pc_windows_gnu"."${deps."winapi"."0.3.6"."winapi_x86_64_pc_windows_gnu"}" deps)
    ]) else []);
    features = mkFeatures (features."winapi"."0.3.6" or {});
  };
  features_.winapi."0.3.6" = deps: f: updateFeatures f (rec {
    winapi."0.3.6".default = (f.winapi."0.3.6".default or true);
    winapi_i686_pc_windows_gnu."${deps.winapi."0.3.6".winapi_i686_pc_windows_gnu}".default = true;
    winapi_x86_64_pc_windows_gnu."${deps.winapi."0.3.6".winapi_x86_64_pc_windows_gnu}".default = true;
  }) [
    (features_.winapi_i686_pc_windows_gnu."${deps."winapi"."0.3.6"."winapi_i686_pc_windows_gnu"}" deps)
    (features_.winapi_x86_64_pc_windows_gnu."${deps."winapi"."0.3.6"."winapi_x86_64_pc_windows_gnu"}" deps)
  ];


# end
# winapi-i686-pc-windows-gnu-0.4.0

  crates.winapi_i686_pc_windows_gnu."0.4.0" = deps: { features?(features_.winapi_i686_pc_windows_gnu."0.4.0" deps {}) }: buildRustCrate {
    crateName = "winapi-i686-pc-windows-gnu";
    version = "0.4.0";
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

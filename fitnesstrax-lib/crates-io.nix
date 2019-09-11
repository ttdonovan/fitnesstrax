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
# autocfg-0.1.6

  crates.autocfg."0.1.6" = deps: { features?(features_.autocfg."0.1.6" deps {}) }: buildRustCrate {
    crateName = "autocfg";
    version = "0.1.6";
    authors = [ "Josh Stone <cuviper@gmail.com>" ];
    sha256 = "1yzawpsmrcy3x60i59hfwwg7mfdwc74199m2lgkc4vam5ijy8mz7";
  };
  features_.autocfg."0.1.6" = deps: f: updateFeatures f (rec {
    autocfg."0.1.6".default = (f.autocfg."0.1.6".default or true);
  }) [];


# end
# cfg-if-0.1.9

  crates.cfg_if."0.1.9" = deps: { features?(features_.cfg_if."0.1.9" deps {}) }: buildRustCrate {
    crateName = "cfg-if";
    version = "0.1.9";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "13g9p2mc5b2b5wn716fwvilzib376ycpkgk868yxfp16jzix57p7";
  };
  features_.cfg_if."0.1.9" = deps: f: updateFeatures f (rec {
    cfg_if."0.1.9".default = (f.cfg_if."0.1.9".default or true);
  }) [];


# end
# chrono-0.4.9

  crates.chrono."0.4.9" = deps: { features?(features_.chrono."0.4.9" deps {}) }: buildRustCrate {
    crateName = "chrono";
    version = "0.4.9";
    authors = [ "Kang Seonghoon <public+rust@mearie.org>" "Brandon W Maister <quodlibetor@gmail.com>" ];
    sha256 = "0nw75j1q0idg5a57k68l87422nq8naq818cdxh390byws63a8yfj";
    dependencies = mapFeatures features ([
      (crates."libc"."${deps."chrono"."0.4.9"."libc"}" deps)
      (crates."num_integer"."${deps."chrono"."0.4.9"."num_integer"}" deps)
      (crates."num_traits"."${deps."chrono"."0.4.9"."num_traits"}" deps)
    ]
      ++ (if features.chrono."0.4.9".serde or false then [ (crates.serde."${deps."chrono"."0.4.9".serde}" deps) ] else [])
      ++ (if features.chrono."0.4.9".time or false then [ (crates.time."${deps."chrono"."0.4.9".time}" deps) ] else []))
      ++ (if cpu == "wasm32" && !(kernel == "emscripten") then mapFeatures features ([
]) else []);
    features = mkFeatures (features."chrono"."0.4.9" or {});
  };
  features_.chrono."0.4.9" = deps: f: updateFeatures f (rec {
    chrono = fold recursiveUpdate {} [
      { "0.4.9".clock =
        (f.chrono."0.4.9".clock or false) ||
        (f.chrono."0.4.9".default or false) ||
        (chrono."0.4.9"."default" or false); }
      { "0.4.9".default = (f.chrono."0.4.9".default or true); }
      { "0.4.9".js-sys =
        (f.chrono."0.4.9".js-sys or false) ||
        (f.chrono."0.4.9".wasmbind or false) ||
        (chrono."0.4.9"."wasmbind" or false); }
      { "0.4.9".time =
        (f.chrono."0.4.9".time or false) ||
        (f.chrono."0.4.9".clock or false) ||
        (chrono."0.4.9"."clock" or false); }
      { "0.4.9".wasm-bindgen =
        (f.chrono."0.4.9".wasm-bindgen or false) ||
        (f.chrono."0.4.9".wasmbind or false) ||
        (chrono."0.4.9"."wasmbind" or false); }
    ];
    libc."${deps.chrono."0.4.9".libc}".default = (f.libc."${deps.chrono."0.4.9".libc}".default or false);
    num_integer."${deps.chrono."0.4.9".num_integer}".default = (f.num_integer."${deps.chrono."0.4.9".num_integer}".default or false);
    num_traits."${deps.chrono."0.4.9".num_traits}".default = (f.num_traits."${deps.chrono."0.4.9".num_traits}".default or false);
    serde."${deps.chrono."0.4.9".serde}".default = true;
    time."${deps.chrono."0.4.9".time}".default = true;
  }) [
    (features_.libc."${deps."chrono"."0.4.9"."libc"}" deps)
    (features_.num_integer."${deps."chrono"."0.4.9"."num_integer"}" deps)
    (features_.num_traits."${deps."chrono"."0.4.9"."num_traits"}" deps)
    (features_.serde."${deps."chrono"."0.4.9"."serde"}" deps)
    (features_.time."${deps."chrono"."0.4.9"."time"}" deps)
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
# itoa-0.4.4

  crates.itoa."0.4.4" = deps: { features?(features_.itoa."0.4.4" deps {}) }: buildRustCrate {
    crateName = "itoa";
    version = "0.4.4";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "1fqc34xzzl2spfdawxd9awhzl0fwf1y6y4i94l8bq8rfrzd90awl";
    features = mkFeatures (features."itoa"."0.4.4" or {});
  };
  features_.itoa."0.4.4" = deps: f: updateFeatures f (rec {
    itoa = fold recursiveUpdate {} [
      { "0.4.4".default = (f.itoa."0.4.4".default or true); }
      { "0.4.4".std =
        (f.itoa."0.4.4".std or false) ||
        (f.itoa."0.4.4".default or false) ||
        (itoa."0.4.4"."default" or false); }
    ];
  }) [];


# end
# lazy_static-1.4.0

  crates.lazy_static."1.4.0" = deps: { features?(features_.lazy_static."1.4.0" deps {}) }: buildRustCrate {
    crateName = "lazy_static";
    version = "1.4.0";
    authors = [ "Marvin Löbel <loebel.marvin@gmail.com>" ];
    sha256 = "13h6sdghdcy7vcqsm2gasfw3qg7ssa0fl3sw7lq6pdkbk52wbyfr";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."lazy_static"."1.4.0" or {});
  };
  features_.lazy_static."1.4.0" = deps: f: updateFeatures f (rec {
    lazy_static = fold recursiveUpdate {} [
      { "1.4.0".default = (f.lazy_static."1.4.0".default or true); }
      { "1.4.0".spin =
        (f.lazy_static."1.4.0".spin or false) ||
        (f.lazy_static."1.4.0".spin_no_std or false) ||
        (lazy_static."1.4.0"."spin_no_std" or false); }
    ];
  }) [];


# end
# libc-0.2.62

  crates.libc."0.2.62" = deps: { features?(features_.libc."0.2.62" deps {}) }: buildRustCrate {
    crateName = "libc";
    version = "0.2.62";
    authors = [ "The Rust Project Developers" ];
    sha256 = "1vsb4pyn6gl6sri6cv5hin5wjfgk7lk2bshzmxb1xnkckjhz4gbx";
    build = "build.rs";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."libc"."0.2.62" or {});
  };
  features_.libc."0.2.62" = deps: f: updateFeatures f (rec {
    libc = fold recursiveUpdate {} [
      { "0.2.62".align =
        (f.libc."0.2.62".align or false) ||
        (f.libc."0.2.62".rustc-dep-of-std or false) ||
        (libc."0.2.62"."rustc-dep-of-std" or false); }
      { "0.2.62".default = (f.libc."0.2.62".default or true); }
      { "0.2.62".rustc-std-workspace-core =
        (f.libc."0.2.62".rustc-std-workspace-core or false) ||
        (f.libc."0.2.62".rustc-dep-of-std or false) ||
        (libc."0.2.62"."rustc-dep-of-std" or false); }
      { "0.2.62".std =
        (f.libc."0.2.62".std or false) ||
        (f.libc."0.2.62".default or false) ||
        (libc."0.2.62"."default" or false) ||
        (f.libc."0.2.62".use_std or false) ||
        (libc."0.2.62"."use_std" or false); }
    ];
  }) [];


# end
# linked-hash-map-0.5.2

  crates.linked_hash_map."0.5.2" = deps: { features?(features_.linked_hash_map."0.5.2" deps {}) }: buildRustCrate {
    crateName = "linked-hash-map";
    version = "0.5.2";
    authors = [ "Stepan Koltsov <stepan.koltsov@gmail.com>" "Andrew Paseltiner <apaseltiner@gmail.com>" ];
    sha256 = "17bpcphlhrxknzvikmihiqm690wwyr0zridyilh1dlxgmrxng7pd";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."linked_hash_map"."0.5.2" or {});
  };
  features_.linked_hash_map."0.5.2" = deps: f: updateFeatures f (rec {
    linked_hash_map = fold recursiveUpdate {} [
      { "0.5.2".default = (f.linked_hash_map."0.5.2".default or true); }
      { "0.5.2".heapsize =
        (f.linked_hash_map."0.5.2".heapsize or false) ||
        (f.linked_hash_map."0.5.2".heapsize_impl or false) ||
        (linked_hash_map."0.5.2"."heapsize_impl" or false); }
      { "0.5.2".serde =
        (f.linked_hash_map."0.5.2".serde or false) ||
        (f.linked_hash_map."0.5.2".serde_impl or false) ||
        (linked_hash_map."0.5.2"."serde_impl" or false); }
      { "0.5.2".serde_test =
        (f.linked_hash_map."0.5.2".serde_test or false) ||
        (f.linked_hash_map."0.5.2".serde_impl or false) ||
        (linked_hash_map."0.5.2"."serde_impl" or false); }
    ];
  }) [];


# end
# memchr-2.2.1

  crates.memchr."2.2.1" = deps: { features?(features_.memchr."2.2.1" deps {}) }: buildRustCrate {
    crateName = "memchr";
    version = "2.2.1";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" "bluss" ];
    sha256 = "1mj5z8lhz6jbapslpq8a39pwcsl1p0jmgp7wgcj7nv4pcqhya7a0";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."memchr"."2.2.1" or {});
  };
  features_.memchr."2.2.1" = deps: f: updateFeatures f (rec {
    memchr = fold recursiveUpdate {} [
      { "2.2.1".default = (f.memchr."2.2.1".default or true); }
      { "2.2.1".use_std =
        (f.memchr."2.2.1".use_std or false) ||
        (f.memchr."2.2.1".default or false) ||
        (memchr."2.2.1"."default" or false); }
    ];
  }) [];


# end
# num-integer-0.1.41

  crates.num_integer."0.1.41" = deps: { features?(features_.num_integer."0.1.41" deps {}) }: buildRustCrate {
    crateName = "num-integer";
    version = "0.1.41";
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
      { "0.1.41".default = (f.num_integer."0.1.41".default or true); }
      { "0.1.41".std =
        (f.num_integer."0.1.41".std or false) ||
        (f.num_integer."0.1.41".default or false) ||
        (num_integer."0.1.41"."default" or false); }
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
# num-traits-0.2.8

  crates.num_traits."0.2.8" = deps: { features?(features_.num_traits."0.2.8" deps {}) }: buildRustCrate {
    crateName = "num-traits";
    version = "0.2.8";
    authors = [ "The Rust Project Developers" ];
    sha256 = "1mnlmy35n734n9xlq0qkfbgzz33x09a1s4rfj30p1976p09b862v";
    build = "build.rs";

    buildDependencies = mapFeatures features ([
      (crates."autocfg"."${deps."num_traits"."0.2.8"."autocfg"}" deps)
    ]);
    features = mkFeatures (features."num_traits"."0.2.8" or {});
  };
  features_.num_traits."0.2.8" = deps: f: updateFeatures f (rec {
    autocfg."${deps.num_traits."0.2.8".autocfg}".default = true;
    num_traits = fold recursiveUpdate {} [
      { "0.2.8".default = (f.num_traits."0.2.8".default or true); }
      { "0.2.8".std =
        (f.num_traits."0.2.8".std or false) ||
        (f.num_traits."0.2.8".default or false) ||
        (num_traits."0.2.8"."default" or false); }
    ];
  }) [
    (features_.autocfg."${deps."num_traits"."0.2.8"."autocfg"}" deps)
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
# proc-macro2-1.0.3

  crates.proc_macro2."1.0.3" = deps: { features?(features_.proc_macro2."1.0.3" deps {}) }: buildRustCrate {
    crateName = "proc-macro2";
    version = "1.0.3";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    edition = "2018";
    sha256 = "0qv29h6pz6n0b4qi8w240l3xppsw26bk5ga2vcjk3nhji0nsplwk";
    libName = "proc_macro2";
    dependencies = mapFeatures features ([
      (crates."unicode_xid"."${deps."proc_macro2"."1.0.3"."unicode_xid"}" deps)
    ]);
    features = mkFeatures (features."proc_macro2"."1.0.3" or {});
  };
  features_.proc_macro2."1.0.3" = deps: f: updateFeatures f (rec {
    proc_macro2 = fold recursiveUpdate {} [
      { "1.0.3".default = (f.proc_macro2."1.0.3".default or true); }
      { "1.0.3".proc-macro =
        (f.proc_macro2."1.0.3".proc-macro or false) ||
        (f.proc_macro2."1.0.3".default or false) ||
        (proc_macro2."1.0.3"."default" or false); }
    ];
    unicode_xid."${deps.proc_macro2."1.0.3".unicode_xid}".default = true;
  }) [
    (features_.unicode_xid."${deps."proc_macro2"."1.0.3"."unicode_xid"}" deps)
  ];


# end
# quote-1.0.2

  crates.quote."1.0.2" = deps: { features?(features_.quote."1.0.2" deps {}) }: buildRustCrate {
    crateName = "quote";
    version = "1.0.2";
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
      { "1.0.2".default = (f.quote."1.0.2".default or true); }
      { "1.0.2".proc-macro =
        (f.quote."1.0.2".proc-macro or false) ||
        (f.quote."1.0.2".default or false) ||
        (quote."1.0.2"."default" or false); }
    ];
  }) [
    (features_.proc_macro2."${deps."quote"."1.0.2"."proc_macro2"}" deps)
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
# rand_core-0.4.2

  crates.rand_core."0.4.2" = deps: { features?(features_.rand_core."0.4.2" deps {}) }: buildRustCrate {
    crateName = "rand_core";
    version = "0.4.2";
    authors = [ "The Rand Project Developers" "The Rust Project Developers" ];
    sha256 = "18zpzwn4bl7lp9f36iacy8mvdnfrhfmzsl35gmln98dcindff2ly";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."rand_core"."0.4.2" or {});
  };
  features_.rand_core."0.4.2" = deps: f: updateFeatures f (rec {
    rand_core = fold recursiveUpdate {} [
      { "0.4.2".alloc =
        (f.rand_core."0.4.2".alloc or false) ||
        (f.rand_core."0.4.2".std or false) ||
        (rand_core."0.4.2"."std" or false); }
      { "0.4.2".default = (f.rand_core."0.4.2".default or true); }
      { "0.4.2".serde =
        (f.rand_core."0.4.2".serde or false) ||
        (f.rand_core."0.4.2".serde1 or false) ||
        (rand_core."0.4.2"."serde1" or false); }
      { "0.4.2".serde_derive =
        (f.rand_core."0.4.2".serde_derive or false) ||
        (f.rand_core."0.4.2".serde1 or false) ||
        (rand_core."0.4.2"."serde1" or false); }
    ];
  }) [];


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
# redox_syscall-0.1.56

  crates.redox_syscall."0.1.56" = deps: { features?(features_.redox_syscall."0.1.56" deps {}) }: buildRustCrate {
    crateName = "redox_syscall";
    version = "0.1.56";
    authors = [ "Jeremy Soller <jackpot51@gmail.com>" ];
    sha256 = "0jcp8nd947zcy938bz09pzlmi3vyxfdzg92pjxdvvk0699vwcc26";
    libName = "syscall";
  };
  features_.redox_syscall."0.1.56" = deps: f: updateFeatures f (rec {
    redox_syscall."0.1.56".default = (f.redox_syscall."0.1.56".default or true);
  }) [];


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
# ryu-1.0.0

  crates.ryu."1.0.0" = deps: { features?(features_.ryu."1.0.0" deps {}) }: buildRustCrate {
    crateName = "ryu";
    version = "1.0.0";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "0hysqba7hi31xw1jka8jh7qb4m9fx5l6vik55wpc3rpsg46cwgbf";
    build = "build.rs";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."ryu"."1.0.0" or {});
  };
  features_.ryu."1.0.0" = deps: f: updateFeatures f (rec {
    ryu."1.0.0".default = (f.ryu."1.0.0".default or true);
  }) [];


# end
# serde-1.0.100

  crates.serde."1.0.100" = deps: { features?(features_.serde."1.0.100" deps {}) }: buildRustCrate {
    crateName = "serde";
    version = "1.0.100";
    authors = [ "Erick Tryzelaar <erick.tryzelaar@gmail.com>" "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "1wlgfj5hc7yz7x1dmw210z26i1m47d9fp588d0rcl759gifiwncb";
    build = "build.rs";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."serde"."1.0.100" or {});
  };
  features_.serde."1.0.100" = deps: f: updateFeatures f (rec {
    serde = fold recursiveUpdate {} [
      { "1.0.100".default = (f.serde."1.0.100".default or true); }
      { "1.0.100".serde_derive =
        (f.serde."1.0.100".serde_derive or false) ||
        (f.serde."1.0.100".derive or false) ||
        (serde."1.0.100"."derive" or false); }
      { "1.0.100".std =
        (f.serde."1.0.100".std or false) ||
        (f.serde."1.0.100".default or false) ||
        (serde."1.0.100"."default" or false); }
    ];
  }) [];


# end
# serde_derive-1.0.100

  crates.serde_derive."1.0.100" = deps: { features?(features_.serde_derive."1.0.100" deps {}) }: buildRustCrate {
    crateName = "serde_derive";
    version = "1.0.100";
    authors = [ "Erick Tryzelaar <erick.tryzelaar@gmail.com>" "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "1qm470s8694qcn2yfm08cabdlsj4h50s8ipcx8f3jyf7540hz1j3";
    procMacro = true;
    dependencies = mapFeatures features ([
      (crates."proc_macro2"."${deps."serde_derive"."1.0.100"."proc_macro2"}" deps)
      (crates."quote"."${deps."serde_derive"."1.0.100"."quote"}" deps)
      (crates."syn"."${deps."serde_derive"."1.0.100"."syn"}" deps)
    ]);
    features = mkFeatures (features."serde_derive"."1.0.100" or {});
  };
  features_.serde_derive."1.0.100" = deps: f: updateFeatures f (rec {
    proc_macro2."${deps.serde_derive."1.0.100".proc_macro2}".default = true;
    quote."${deps.serde_derive."1.0.100".quote}".default = true;
    serde_derive."1.0.100".default = (f.serde_derive."1.0.100".default or true);
    syn = fold recursiveUpdate {} [
      { "${deps.serde_derive."1.0.100".syn}"."visit" = true; }
      { "${deps.serde_derive."1.0.100".syn}".default = true; }
    ];
  }) [
    (features_.proc_macro2."${deps."serde_derive"."1.0.100"."proc_macro2"}" deps)
    (features_.quote."${deps."serde_derive"."1.0.100"."quote"}" deps)
    (features_.syn."${deps."serde_derive"."1.0.100"."syn"}" deps)
  ];


# end
# serde_json-1.0.40

  crates.serde_json."1.0.40" = deps: { features?(features_.serde_json."1.0.40" deps {}) }: buildRustCrate {
    crateName = "serde_json";
    version = "1.0.40";
    authors = [ "Erick Tryzelaar <erick.tryzelaar@gmail.com>" "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "1wf8lkisjvyg4ghp2fwm3ysymjy66l030l8d7p6033wiayfzpyh3";
    dependencies = mapFeatures features ([
      (crates."itoa"."${deps."serde_json"."1.0.40"."itoa"}" deps)
      (crates."ryu"."${deps."serde_json"."1.0.40"."ryu"}" deps)
      (crates."serde"."${deps."serde_json"."1.0.40"."serde"}" deps)
    ]);
    features = mkFeatures (features."serde_json"."1.0.40" or {});
  };
  features_.serde_json."1.0.40" = deps: f: updateFeatures f (rec {
    itoa."${deps.serde_json."1.0.40".itoa}".default = true;
    ryu."${deps.serde_json."1.0.40".ryu}".default = true;
    serde."${deps.serde_json."1.0.40".serde}".default = true;
    serde_json = fold recursiveUpdate {} [
      { "1.0.40".default = (f.serde_json."1.0.40".default or true); }
      { "1.0.40".indexmap =
        (f.serde_json."1.0.40".indexmap or false) ||
        (f.serde_json."1.0.40".preserve_order or false) ||
        (serde_json."1.0.40"."preserve_order" or false); }
    ];
  }) [
    (features_.itoa."${deps."serde_json"."1.0.40"."itoa"}" deps)
    (features_.ryu."${deps."serde_json"."1.0.40"."ryu"}" deps)
    (features_.serde."${deps."serde_json"."1.0.40"."serde"}" deps)
  ];


# end
# syn-1.0.5

  crates.syn."1.0.5" = deps: { features?(features_.syn."1.0.5" deps {}) }: buildRustCrate {
    crateName = "syn";
    version = "1.0.5";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    edition = "2018";
    sha256 = "08qbk425r8c4q4rrpq1q9wkd3v3bji8nlfaxj8v4l7lkpjkh0xgs";
    dependencies = mapFeatures features ([
      (crates."proc_macro2"."${deps."syn"."1.0.5"."proc_macro2"}" deps)
      (crates."unicode_xid"."${deps."syn"."1.0.5"."unicode_xid"}" deps)
    ]
      ++ (if features.syn."1.0.5".quote or false then [ (crates.quote."${deps."syn"."1.0.5".quote}" deps) ] else []));
    features = mkFeatures (features."syn"."1.0.5" or {});
  };
  features_.syn."1.0.5" = deps: f: updateFeatures f (rec {
    proc_macro2 = fold recursiveUpdate {} [
      { "${deps.syn."1.0.5".proc_macro2}"."proc-macro" =
        (f.proc_macro2."${deps.syn."1.0.5".proc_macro2}"."proc-macro" or false) ||
        (syn."1.0.5"."proc-macro" or false) ||
        (f."syn"."1.0.5"."proc-macro" or false); }
      { "${deps.syn."1.0.5".proc_macro2}".default = (f.proc_macro2."${deps.syn."1.0.5".proc_macro2}".default or false); }
    ];
    quote = fold recursiveUpdate {} [
      { "${deps.syn."1.0.5".quote}"."proc-macro" =
        (f.quote."${deps.syn."1.0.5".quote}"."proc-macro" or false) ||
        (syn."1.0.5"."proc-macro" or false) ||
        (f."syn"."1.0.5"."proc-macro" or false); }
      { "${deps.syn."1.0.5".quote}".default = (f.quote."${deps.syn."1.0.5".quote}".default or false); }
    ];
    syn = fold recursiveUpdate {} [
      { "1.0.5".clone-impls =
        (f.syn."1.0.5".clone-impls or false) ||
        (f.syn."1.0.5".default or false) ||
        (syn."1.0.5"."default" or false); }
      { "1.0.5".default = (f.syn."1.0.5".default or true); }
      { "1.0.5".derive =
        (f.syn."1.0.5".derive or false) ||
        (f.syn."1.0.5".default or false) ||
        (syn."1.0.5"."default" or false); }
      { "1.0.5".parsing =
        (f.syn."1.0.5".parsing or false) ||
        (f.syn."1.0.5".default or false) ||
        (syn."1.0.5"."default" or false); }
      { "1.0.5".printing =
        (f.syn."1.0.5".printing or false) ||
        (f.syn."1.0.5".default or false) ||
        (syn."1.0.5"."default" or false); }
      { "1.0.5".proc-macro =
        (f.syn."1.0.5".proc-macro or false) ||
        (f.syn."1.0.5".default or false) ||
        (syn."1.0.5"."default" or false); }
      { "1.0.5".quote =
        (f.syn."1.0.5".quote or false) ||
        (f.syn."1.0.5".printing or false) ||
        (syn."1.0.5"."printing" or false); }
    ];
    unicode_xid."${deps.syn."1.0.5".unicode_xid}".default = true;
  }) [
    (features_.proc_macro2."${deps."syn"."1.0.5"."proc_macro2"}" deps)
    (features_.quote."${deps."syn"."1.0.5"."quote"}" deps)
    (features_.unicode_xid."${deps."syn"."1.0.5"."unicode_xid"}" deps)
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
# typenum-1.11.2

  crates.typenum."1.11.2" = deps: { features?(features_.typenum."1.11.2" deps {}) }: buildRustCrate {
    crateName = "typenum";
    version = "1.11.2";
    authors = [ "Paho Lurie-Gregg <paho@paholg.com>" "Andre Bogus <bogusandre@gmail.com>" ];
    sha256 = "0pdbfkqzp4hwj21b2gv79kh1s1sgr587bd4s039qzalg5jiniiz8";
    build = "build/main.rs";
    features = mkFeatures (features."typenum"."1.11.2" or {});
  };
  features_.typenum."1.11.2" = deps: f: updateFeatures f (rec {
    typenum."1.11.2".default = (f.typenum."1.11.2".default or true);
  }) [];


# end
# ucd-util-0.1.5

  crates.ucd_util."0.1.5" = deps: { features?(features_.ucd_util."0.1.5" deps {}) }: buildRustCrate {
    crateName = "ucd-util";
    version = "0.1.5";
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
    authors = [ "erick.tryzelaar <erick.tryzelaar@gmail.com>" "kwantam <kwantam@gmail.com>" ];
    sha256 = "1c85gb3p3qhbjvfyjb31m06la4f024jx319k10ig7n47dz2fk8v7";
    features = mkFeatures (features."unicode_xid"."0.2.0" or {});
  };
  features_.unicode_xid."0.2.0" = deps: f: updateFeatures f (rec {
    unicode_xid."0.2.0".default = (f.unicode_xid."0.2.0".default or true);
  }) [];


# end
# utf8-ranges-1.0.4

  crates.utf8_ranges."1.0.4" = deps: { features?(features_.utf8_ranges."1.0.4" deps {}) }: buildRustCrate {
    crateName = "utf8-ranges";
    version = "1.0.4";
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
# winapi-0.3.8

  crates.winapi."0.3.8" = deps: { features?(features_.winapi."0.3.8" deps {}) }: buildRustCrate {
    crateName = "winapi";
    version = "0.3.8";
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
      { "0.3.8".default = (f.winapi."0.3.8".default or true); }
      { "0.3.8".impl-debug =
        (f.winapi."0.3.8".impl-debug or false) ||
        (f.winapi."0.3.8".debug or false) ||
        (winapi."0.3.8"."debug" or false); }
    ];
    winapi_i686_pc_windows_gnu."${deps.winapi."0.3.8".winapi_i686_pc_windows_gnu}".default = true;
    winapi_x86_64_pc_windows_gnu."${deps.winapi."0.3.8".winapi_x86_64_pc_windows_gnu}".default = true;
  }) [
    (features_.winapi_i686_pc_windows_gnu."${deps."winapi"."0.3.8"."winapi_i686_pc_windows_gnu"}" deps)
    (features_.winapi_x86_64_pc_windows_gnu."${deps."winapi"."0.3.8"."winapi_x86_64_pc_windows_gnu"}" deps)
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

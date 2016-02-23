{ fetchurl, lib, nix }:
lib.overrideDerivation nix (drv: rec {
  name = "nix-1.11.2";
  src = fetchurl {
    url = "http://nixos.org/releases/nix/${name}/${name}.tar.xz";
    sha256 = "fc1233814ebb385a2a991c1fb88c97b344267281e173fea7d9acd3f9caf969d6";
  };
})

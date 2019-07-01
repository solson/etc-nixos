{ buildGoPackage, fetchFromGitHub, lib, fetchgit, ... }:
(buildGoPackage rec {
  name = "systemd-digitalocean-generator";
  goPackagePath = name;
  src = builtins.filterSource (path: type: lib.hasSuffix ".go" path) ./.;
  # src = ./.;
  # goDeps = import ./deps.nix { inherit fetchgit; };
  goDeps = ./deps.nix;
}).bin

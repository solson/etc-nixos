pkgs: let
  overrideURL = pkg: url: pkg.overrideDerivation (drv: {
    src = pkgs.fetchurl {
      inherit url;
      "${drv.src.outputHashAlgo}" = drv.src.outputHash;
    };
  });
in rec {
  # TODO: Remove this override once nixpkgs-unstable updates.
  pstree = overrideURL pkgs.pstree "http://distfiles.macports.org/pstree/${pstree.name}.tar.gz";

  # TODO: Remove this override once nixpkgs-unstable updates.
  nix = pkgs.lib.overrideDerivation pkgs.nix (drv: rec {
    name = "nix-1.11.2";
    src = pkgs.fetchurl {
      url = "http://nixos.org/releases/nix/${name}/${name}.tar.xz";
      sha256 = "fc1233814ebb385a2a991c1fb88c97b344267281e173fea7d9acd3f9caf969d6";
    };
  });

  vim = pkgs.vim_configurable.override {
    flags = [ "python" ];
  };
}

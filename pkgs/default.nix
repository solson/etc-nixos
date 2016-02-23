pkgs: let
  inherit (pkgs) callPackage;

  overrideURL = pkg: url: pkg.overrideDerivation (drv: {
    src = pkgs.fetchurl {
      inherit url;
      "${drv.src.outputHashAlgo}" = drv.src.outputHash;
    };
  });
in rec {
  # TODO: Remove these overrides once nixpkgs-unstable updates.
  pstree = overrideURL pkgs.pstree "http://distfiles.macports.org/pstree/${pstree.name}.tar.gz";
  nix = callPackage ./nix.nix { inherit (pkgs) nix; };
  nix-repl = callPackage ./nix-repl.nix { inherit (pkgs) nix-repl; };

  vim = pkgs.vim_configurable.override {
    flags = [ "python" ];
  };
}

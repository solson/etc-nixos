pkgs: let
  inherit (pkgs) callPackage;
in rec {
  # TODO: Remove these overrides once nixpkgs-unstable updates.
  nix = callPackage ./nix.nix { inherit (pkgs) nix; };
  nix-repl = callPackage ./nix-repl.nix { inherit (pkgs) nix-repl; };
}

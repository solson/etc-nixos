pkgs: let
  inherit (pkgs) callPackage;
in rec {
  format-duration = callPackage ./format-duration.nix {};
  nix-repl = callPackage ./nix-repl.nix { inherit (pkgs) nix-repl; };
  notify-run = callPackage ./notify-run.nix {};
  push-notify = callPackage ./push-notify.nix {};
}

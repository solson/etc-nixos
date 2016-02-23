{ fetchFromGitHub, lib, nix, nix-repl }:
let
  rev = "a52fd0dbd0200ba165d1da8a4bf2bc36a455a0d1";
in
(nix-repl.override { inherit nix; }).overrideDerivation (drv: {
  name = "nix-repl-${lib.getVersion nix}-${lib.substring 0 7 rev}";

  src = fetchFromGitHub {
    owner = "edolstra";
    repo = "nix-repl";
    inherit rev;
    sha256 = "000fsi06g5dga86xynhmhf49kw1xvimfilisqj76jali05nspmxj";
  };
})

{ pkgs, ... }:
{
  imports = [
    ./digitalocean.nix
    ./nginx.nix
  ];

  networking.hostName = "quark";
  i18n.defaultLocale = "en_CA.UTF-8";

  users.extraUsers.scott = {
    isNormalUser = true;
    description = "Scott Olson";
    extraGroups = [ "nginx" "wheel" ];
  };

  programs.fish.enable = true;
  environment.variables.EDITOR = "vim";
  environment.systemPackages = with pkgs; [
    # Tools
    atool autojump dropbox file fish gist gnupg htop keybase moreutils mosh
    nix-repl pstree ranger rlwrap tmux tree vim wget which

    # Programming
    # TODO: Add git-radar for fish rprompt.
    cloc gitFull git-hub man-pages neovim python silver-searcher
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.packageOverrides = import ./pkgs;

  # Propagate nixpkgs config globally. This causes package overrides here to
  # affect the entire system. (E.g. nix-shell -p vim will use the vim override
  # specified here.)
  environment.etc."nix/nixpkgs-config.nix".text = ''
    (import <nixpkgs/nixos> {}).config.nixpkgs.config
  '';
}

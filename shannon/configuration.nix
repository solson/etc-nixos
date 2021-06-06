# In future, if not using an existing snapshot (e.g. on Vultr), try using
# https://nixos.wiki/wiki/Creating_a_NixOS_live_CD with this configuration to
# generate an installation ISO for a new VPS.

{ config, pkgs, ... }:

let
  sshKey = builtins.readFile ./id_rsa.pub;
  identdPort = 113;
in

{
  imports = [
    ./hardware-configuration.nix
    ./nginx.nix
  ];

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/vda";
  };

  networking.hostName = "shannon";
  i18n.defaultLocale = "en_US.UTF-8";

  networking.firewall = {
    allowedTCPPorts = [ identdPort ];

    # These log messages are big and happen many times per minute, causing log
    # bloat and systemd-journald to use over 70 MiB of RAM.
    logRefusedConnections = false;
  };

  users.users = {
    root = {
      openssh.authorizedKeys.keys = [ sshKey ];
    };

    scott = {
      isNormalUser = true;
      description = "Scott Olson";
      extraGroups = [ config.services.nginx.group "wheel" ];
      openssh.authorizedKeys.keys = [ sshKey ];
    };
  };

  services.openssh = {
    enable = true;
    permitRootLogin = "prohibit-password";
  };

  services.thelounge = {
    enable = true;
    extraConfig = {
      public = false;
      reverseProxy = true;
      prefetch = true;
      fileUpload = {
        enable = true;
        maxFileSize = 100000;
      };
      leaveMessage = "bye";
    };
  };

  services.convos = {
    enable = true;
    listenAddress = "127.0.0.1";
    reverseProxy = true;
  };

  services.nullidentdmod = {
    enable = true;
    userid = "scott";
  };

  programs.mosh.enable = true;

  environment.variables.EDITOR = "nvim";
  environment.systemPackages = with pkgs; [
    git
    htop
    neovim
    psmisc
    tmux
    tree
    wget
    which
  ];

  system.autoUpgrade.enable = true;
  system.stateVersion = "19.03";
}

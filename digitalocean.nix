let
  nixpkgs = import <nixpkgs> { config = {}; };
  systemd-digitalocean = nixpkgs.fetchgit {
    url = "https://code.***REMOVED***.eu/***REMOVED***/systemd-digitalocean.git";
    rev = "63fd9c29de9f25f4c9ca9ee5fba5f40b1374f1ac";
    sha256 = "677765f6d6785deda033737ca31b6fde55dabd2de58f2211db9a4f3afd852b20";
  };
in
{
  imports = [
    <nixpkgs/nixos/modules/profiles/qemu-guest.nix>
    "${systemd-digitalocean}/module.nix"
  ];

  services.openssh.enable = true;

  fileSystems."/" = {
    device = "/dev/vda1";
    fsType = "ext4";
  };

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/vda";

  boot.kernelParams = [ "boot.shell_on_fail" ];
  boot.kernelModules = [ "kvm-intel" ];

  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "virtio_pci" ];
  boot.initrd.supportedFilesystems = [ "ext4" ];
}

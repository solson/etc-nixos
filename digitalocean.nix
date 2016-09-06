{
  imports = [
    <nixpkgs/nixos/modules/profiles/qemu-guest.nix>
    ./systemd-digitalocean/module.nix
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

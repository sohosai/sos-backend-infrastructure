{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/profiles/qemu-guest.nix")
    ];

  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "virtio_pci" "sr_mod" "virtio_blk" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  boot.growPartition = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.configurationLimit = 0;
  boot.loader.timeout = 0;

  fileSystems."/" =
    {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
      autoResize = true;
    };

  swapDevices = [ ];

  networking.useDHCP = false;
  # You may enable DHCP for the use in the shared segment
  networking.interfaces.ens3.useDHCP = lib.mkDefault false;

  services.openssh.enable = true;
  services.openssh.permitRootLogin = "prohibit-password";
  services.openssh.passwordAuthentication = lib.mkDefault false;
  services.openssh.challengeResponseAuthentication = lib.mkDefault false;

  users.users.root.initialHashedPassword = "";
}

{ config, pkgs, lib, ... }: {
imports = [ ./.. ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = false; # Disable systemd-boot because we're using GRUB
  boot.loader.grub.enable = true; # Whether to enable the GNU GRUB boot loader
  boot.loader.grub.device = "nodev"; # The special value nodev means that a GRUB boot menu will be generated, but GRUB itself will not actually be installed
  boot.loader.grub.efiSupport = true; # Whether GRUB should be built with EFI support
  boot.loader.grub.configurationLimit = 20; # Maximum of configurations in boot menu as GRUB has problems when there are too many entries.
  boot.loader.grub.gfxmodeEfi = "1920x1080"; # The gfxmode to pass to GRUB when loading a graphical boot interface under EFI
  boot.loader.grub.theme = with pkgs; grub2-theme-virtuaverse; # Use our custom theme
  boot.loader.grub.backgroundColor = "#000000"; # Background color to be used for GRUB to fill the areas the image isn't filling
  boot.kernelParams = [ "vga=0x034d" ]; # Set our vga resolution
  boot.initrd.postDeviceCommands = ''
    echo bfq > /sys/block/nvme0n1/queue/scheduler
  ''; # Set our io scheduler to Budget Fair Queueing
  boot.tmpOnTmpfs = true; # Enable /tmp on tmpfs because we have plenty of RAM

  fileSystems."/" = { options = [ "compress=zstd" ]; }; # Compress our btrfs filesystem with zstd

  networking.hostName = "nixos-workstation"; # The name of the machine

  powerManagement.enable = lib.mkDefault false; # Whether to enable power management, including support for suspend-to-RAM and powersave features on laptops

  modules.hardware.gpu.nvidia.enable = true; # Enable my nvidia module on this machine
}
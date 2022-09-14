{ config, pkgs, lib, ... }: {
  imports = [ ./.. ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true; # Enable systemd-boot, we're not using GRUB

  boot.initrd.postDeviceCommands = ''
    echo bfq > /sys/block/sda/queue/scheduler
  ''; # Set our io scheduler to Budget Fair Queueing
  boot.tmpOnTmpfs = false; # Disable /tmp on tmpfs because we're RAM constrained

  console.keyMap = "colemak"; # Set our console keymap to colemak

  fileSystems."/" = { options = [ "compress=zstd" ]; }; # Compress our btrfs filesystem with zstd

  networking.hostName = "nixos-laptop"; # The name of the machine

  modules.hardware.gpu.amd.enable = true; # Enable my AMD GPU module on this machine
}
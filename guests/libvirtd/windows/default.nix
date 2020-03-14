# guests/libvirtd/windows config
{ config, pkgs, lib, ... }:
{
  imports = [ ./.. ];

  boot.extraModprobeConfig = "options vfio-pci ids=10de:1c02,10de:10f1"; # GPU PCI-Passthrough
  boot.kernelParams = [
    "kvm.ignore_msrs=1" # Supposedly prevents crashes in Windows guests.
  ];

  environment.systemPackages = with pkgs; [
    # applications/virtualization
    looking-glass-client # A KVM Frame Relay (KVMFR) implementation
    win-virtio # Windows VirtIO Drivers
  ];
}

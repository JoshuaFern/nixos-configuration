# Libvirt Options
{ config, pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    looking-glass-client
    OVMF
    spice-gtk
    virtmanager
    virtio-win-iso
    win-virtio
  ];

  virtualisation = {
    libvirtd = {
      enable = true;
      #qemuPackage = with pkgs; qemu_kvm; # Saves disk space allowing to emulate only host architectures.
      qemuVerbatimConfig = ''
        vram = [ "${pkgs.OVMF}/FV/OVMF.fd:${pkgs.OVMF}/FV/OVMF_VARS.fd" ]
      '';
    };
  };
}

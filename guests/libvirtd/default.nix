# Libvirt Options
{ config, pkgs, lib, ... }:
{
  imports = [ ./.. ];

  boot.kernelModules = [
    "vfio_virqfd"
    "vfio_pci"
    "vfio_iommu_type1"
    "vfio"
  ];
  boot.kernelParams = [
    "intel_iommu=on"
    "iommu=pt"
    "vfio_iommu_type1.allow_unsafe_interrupts=1"
    "kvm.allow_unsafe_assigned_interrupts=1"
  ];

  environment.systemPackages = with pkgs; [
    # applications/virtualization
    virt-manager # Desktop user interface for managing virtual machines
  ];

  virtualisation.libvirtd.enable = true;
}

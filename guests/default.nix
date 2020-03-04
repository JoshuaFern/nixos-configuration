# Virtualization Global Config
{ config, pkgs, lib, ... }:
{
  imports = [
    ./pci-passthrough.nix
  ];
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
    "kvm.ignore_msrs=1" # Supposedly prevents crashes in Windows guests.
  ];
}

 # PCI-Passthrough Specific Config
 { config, pkgs, lib, ... }:
 {
   boot.extraModprobeConfig = "options vfio-pci ids=10de:1c02,10de:10f1"; # Allocate this GPU for the guest.
 }

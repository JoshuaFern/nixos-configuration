{ config, lib, pkgs, ... }:
with lib; {
  options.modules.hardware.cpu.amd = {
    enable = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Whether to enable AMD CPU support.
      '';
    };
  };

  config = mkIf config.modules.hardware.cpu.amd.enable {
    boot.kernelModules = [ 
      "kvm-amd"
      "zenpower" # Linux kernel driver for reading temperature, voltage(SVI2), current(SVI2) and power(SVI2) for AMD Zen family CPUs
      ]; # The set of kernel modules to be loaded in the second stage of the boot process

    environment.systemPackages = with pkgs; [
        zenmonitor # Monitoring software for AMD Zen-based CPUs
    ]; # The set of packages that appear in /run/current-system/sw. These packages are automatically available to all users, and are automatically updated every time you rebuild the system configuration

    hardware.cpu.amd.updateMicrocode = true; # Update the CPU microcode for AMD processors
  };
}

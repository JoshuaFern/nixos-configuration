{ config, lib, pkgs, ... }:
with lib; {
  options.modules.hardware.gpu.amd = {
    enable = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Whether to enable AMD GPU support.
      '';
    };
  };

  config = mkIf config.modules.hardware.gpu.amd.enable {

    environment.systemPackages = with pkgs; [
      radeon-profile # Application to read current clocks of AMD Radeon cards
      radeontop # Top-like tool for viewing AMD Radeon GPU utilization
    ];

    services.xserver.videoDrivers = lib.mkDefault [ "amdgpu" ]; # Video drivers that will be tried in order until one that supports your card is found

  };
}

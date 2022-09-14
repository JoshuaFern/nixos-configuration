{ config, lib, pkgs, ... }:{
  options.modules.hardware.bluetooth = {
    enable = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = ''
        Whether to enable bluetooth support.
      '';
    };
  };

  config = lib.mkIf config.modules.hardware.bluetooth.enable {
    environment.systemPackages = with pkgs; [ ldacbt ]; # AOSP libldac dispatcher

    hardware.bluetooth.settings.General.Enable = "Source,Sink,Media,Socket"; # Enable A2DP Sink
    hardware.bluetooth.enable = lib.mkDefault true; # Enable support for Bluetooth devices
    hardware.bluetooth.package = with pkgs; bluezFull; # Which BlueZ package to use
    hardware.enableAllFirmware = lib.mkDefault true; # Support more devices
    hardware.pulseaudio = lib.mkIf config.modules.services.pulseaudio.enable {
      extraConfig = ''
        # LDAC Standard Quality
        #load-module module-bluetooth-discover a2dp_config="ldac_eqmid=sq"
        # LDAC High Quality; Force LDAC/PA PCM sample format as Float32LE
        load-module module-bluetooth-discover a2dp_config="ldac_eqmid=hq ldac_fmt=f32"
        load-module module-bluetooth-policy \n
        load-module module-switch-on-connect \n
      ''; # Switch to the connected bluetooth device automatically.
      extraModules = with pkgs; [ pulseaudio-modules-bt ]; # Enable extra bluetooth modules, like APT-X codec.
      package = lib.mkDefault pkgs.pulseaudioFull; # Only the full build has Bluetooth support
    };

    services.blueman.enable = lib.mkDefault true; # Bluetooth management GUI, handy if you're not using a heavyweight desktop environment.
  };
}

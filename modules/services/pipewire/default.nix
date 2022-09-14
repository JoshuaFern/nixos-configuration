{ config, lib, pkgs, ... }:
with lib; {
  options.modules.services.pipewire = {
    enable = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Whether to enable PipeWire
      '';
    };
  };

  config = mkIf config.modules.services.pipewire.enable {

    environment.systemPackages = with pkgs; [ 
      easyeffects # Audio effects for PipeWire applications
      qpwgraph # Qt graph manager for PipeWire, similar to QjackCtl
    ];

    services.pipewire.enable = lib.mkDefault true; # Server and user space API to deal with multimedia pipelines
    services.pipewire.alsa.enable = lib.mkDefault true; # Whether to enable ALSA support
    services.pipewire.alsa.support32Bit = lib.mkDefault true; # Whether to enable 32-bit ALSA support on 64-bit systems
    services.pipewire.audio.enable = lib.mkDefault true; # Whether to use PipeWire as the primary sound server
    services.pipewire.pulse.enable = lib.mkDefault true; # Whether to enable PulseAudio server emulation
    services.pipewire.jack.enable = lib.mkDefault true; # Whether to enable JACK audio emulation
    services.pipewire.wireplumber.enable = lib.mkDefault true; # Whether to enable Wireplumber, a modular session / policy manager for PipeWire

    systemd.user.services.pipewire-pulse.serviceConfig.LimitMEMLOCK = lib.mkDefault "131072";
  };
}

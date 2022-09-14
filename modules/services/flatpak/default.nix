{ config, lib, pkgs, ... }:

with lib; {
  options.modules.services.flatpak = {
    enable = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Whether to enable Flatpak
      '';
    };
  };

  config = mkIf config.modules.services.flatpak.enable {
    services.flatpak.enable = true; # Whether to enable flatpak

    xdg.portal.enable = true; # Whether to enable xdg desktop integration
    xdg.portal.wlr.enable = true; # Whether to enable desktop portal for wlroots-based desktops This will add the xdg-desktop-portal-wlr package into the xdg.portal.extraPortals option, and provide the configuration file
  };
}

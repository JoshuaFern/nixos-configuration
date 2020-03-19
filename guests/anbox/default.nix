{ config, pkgs, lib, ... }: {
  imports = [ ./.. ];
  virtualisation.anbox.enable = true;
}

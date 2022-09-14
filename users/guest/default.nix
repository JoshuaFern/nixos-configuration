# Completely optional guest user, import this module to activate.
{ config, lib, pkgs, ... }:
{
  users.users.guest = {
    description = "Guest User"; # User description
    extraGroups = [
      "audio"
      "networkmanager"
      "video"
    ]; # The user's auxiliary groups
    password = "guest"; # Specifies the password for the user
    isNormalUser = true; # Indicates whether this is an account for a “real” user
    shell = with pkgs; zsh; # The path to the user's shell
    uid = 10000; # The account UID.If the UID is null, a free UID is picked on activation
  };

  fileSystems."/home/guest" = { fsType = "tmpfs"; }; # Make /home/guest temporary
}
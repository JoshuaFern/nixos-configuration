{ config, pkgs, lib, ... }:
let
  secrets = import ../../secrets.nix; # These are my secrets: hashed passwords, apikeys, etc... If you're making use of this config you'll have manage your own.
in {
  imports = [
    ./.. # Global User Config
  ];

  users.users.jdf.extraGroups = [
    "audio" # timidity
    "dialout" # arduino
    "libvirtd" # qemu
    "wheel" # sudo
  ]; # The user's auxiliary groups
  users.users.jdf.hashedPassword = secrets.accountPassword.jdf; # Specifies the hashed password for the user
  users.users.jdf.isNormalUser = true; # Indicates whether this is an account for a “real” user
  users.users.jdf.shell = with pkgs; zsh; # The path to the user's shell
  users.users.jdf.uid = 1000; # The account UID.If the UID is null, a free UID is picked on activation
}

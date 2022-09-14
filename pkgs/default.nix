{ config, pkgs, ... }:

{
  nixpkgs.overlays = [
    ( import ./pkgs.nix )
  ];
}

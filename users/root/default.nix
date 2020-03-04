{ pkgs, ... }:
{
  users.users.root = {
    createHome = false;
    home = "/root";
    password = "nix";
    shell = with pkgs; mksh;
  };
} 

{ pkgs, ... }:
let secrets = import ./secrets.nix;
in {
  users.users.root = {
    createHome = false;
    home = "/root";
    hashedPassword = secrets.accountPassword.root;
    shell = with pkgs; zsh;
    uid = 0;
  };
}
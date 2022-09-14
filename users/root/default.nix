{ pkgs, ... }:
let secrets = import ../../secrets.nix;
in {
  users.users.root.createHome = false; # Whether to create the home directory and ensure ownership as well as permissions to match the user
  users.users.root.home = "/root"; # The user's home directory
  users.users.root.hashedPassword = secrets.accountPassword.root; # Specifies the hashed password for the user
  users.users.root.shell = with pkgs; zsh; # The path to the user's shell
  users.users.root.uid = 0; # The account UID. If the UID is null, a free UID is picked on activation
}
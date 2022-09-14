{ config, ... }: {
  imports = [ ./root ];
  users.motd = "Welcome to ${config.networking.hostName}."; # Message of the day shown to users when they log in
  users.mutableUsers = false; # Careful you don't lock yourself out with this.
}

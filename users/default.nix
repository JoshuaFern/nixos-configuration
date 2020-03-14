# Global User Options
{ config, ... }:
{
  imports = [ ./root ];

   users.motd = ''Welcome to ${config.networking.hostName}, running NixOS ${config.system.stateVersion}.'';
   users.mutableUsers = false; # Careful you don't lock yourself out with this.
}

#               ,,
# `7MN.   `7MF' db               .g8""8q.    .M"""bgd
#   MMN.    M                  .dP'    `YM. ,MI    "Y
#   M YMb   M `7MM  `7M'   `MF'dM'      `MM `MMb.
#   M  `MN. M   MM    `VA ,V'  MM        MM   `YMMNq.
#   M   `MM.M   MM      XMX    MM.      ,MP .     `MM
#   M     YMM   MM    ,V' VA.  `Mb.    ,dP' Mb     dM
# .JML.    YM .JMML..AM.   .MA.  `"bmmd"'   P"Ybmmd"
#
# Help is available in the configuration.nix(5) man page and in
# the NixOS manual (accessible by running ‘nixos-help’).
#
# Options:      https://nixos.org/nixos/options.html
# Packages:     https://nixos.org/nixos/packages.html
# Nix Language: https://nixos.wiki/wiki/Nix_Expression_Language
#               https://learnxinyminutes.com/docs/nix/
{ config, ... }:
let ident = import ./ident.nix; # Your machine identifier/hostname, create the file yourself using the example
in { imports = [ "/etc/nixos/hosts/${ident.hostname}/default.nix" ]; # Import our host configuration
  networking.hostName = "${ident.hostname}"; # Set our hostname based on the identifier
}

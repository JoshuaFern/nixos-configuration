# Common host configuration.
{ config, pkgs, lib, ... }: {
  imports = [];
  boot.loader.timeout = 1; # Set timeout to 1 for faster boot speeds.
  boot.kernelModules = [ "tcp_bbr" "bfq" ];
  boot.kernel.sysctl = {
    "net.core.default_qdisc" = "fq";
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.ipv4.tcp_slow_start_after_idle" =
      "0"; # Should help to improve performance in some cases.
  };

  console.useXkbConfig = true; # Use keymap from xserver.

  environment.checkConfigurationOptions = true;
  environment.systemPackages =
    with pkgs; [ # Try to keep cli utils in this global config, we don't know if x11 or audio will be installed, or if this will be a server.
      # applications/editors
      vim # The most popular clone of the VI editor
      # applications/version-management
      gitAndTools.gitFull # Distributed version control system
      # os-specific/linux
      hdparm # A tool to get/set ATA/SATA drive parameters under Linux
      kexectools # Tools related to the kexec Linux feature
      psmisc # A set of small useful utilities that use the proc filesystem (such as fuser, killall and pstree)
      # shells
      dash # A POSIX-compliant implementation of /bin/sh that aims to be as small as possible
      mksh # MirBSD Korn Shell
      rc # The Plan 9 shell
      # tools/archivers
      p7zip # A port of the 7-zip archiver
      unzip # An extraction utility for archives compressed in .zip format
      zip # Compressor/archiver for creating and modifying zipfiles
      # tools/misc
      cloc # A program that counts lines of source code
      file # A program that shows the type of files
      mc # File Manager and User Shell for the GNU Project
      snore # sleep with feedback
      xclip # Tool to access the X clipboard from a console application
      # tools/networking
      curlFull # A command line tool for transferring files with URL syntax
      wget # Tool for retrieving files using HTTP, HTTPS, and FTP
      # tools/security
      mkpasswd # Overfeatured front-end to crypt, from the Debian whois package
      # tools/system
      htop # An interactive process viewer for Linux
      pciutils # A collection of programs for inspecting and manipulating configuration of PCI devices
    ];

  hardware.ksm.enable =
    true; # Kernel Same-Page Merging, can be suitable for more than Virtual Machine use, as it's useful for any application which generates many instances of the same data.

  location.provider = "geoclue2";

  networking.extraHosts = ''
    127.0.0.1 ${config.networking.hostName}
    ::1 ${config.networking.hostName}
  '';

  nix.autoOptimiseStore = true;
  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 30d";
  nix.maxJobs = lib.mkDefault 2;
  nix.trustedUsers = [ "root" "@wheel" ];

  nixpkgs.config = {
    packageOverrides = pkgs: {
      nur = import (builtins.fetchTarball
        "https://github.com/nix-community/NUR/archive/master.tar.gz") {
          inherit pkgs;
        };
    };
  };

  powerManagement.enable = lib.mkDefault false;

  programs.dconf.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  programs.mosh.enable = true;
  programs.nano.syntaxHighlight = true;
  programs.tmux.enable = true;
  programs.tmux.keyMode = "vi";

  security.hideProcessInformation = true;

  services.earlyoom.enable = true; # Enable early out of memory killing.
  services.earlyoom.freeMemThreshold = 3;
  services.fail2ban.enable = true;
  services.flatpak.enable = true;
  services.fstrim.enable = true;
  services.logind.extraConfig = ''
    KillUserProcesses=yes
        HandlePowerKey=ignore'';
  services.openssh.enable = true;
  services.timesyncd.enable = true;

  system.autoUpgrade.enable = true;
  system.stateVersion =
    "20.09"; # Check release notes before changing this. *insert scary warning here*

  systemd.extraConfig =
    "DefaultLimitNOFILE=1048576"; # Set limits for Esync: https://github.com/lutris/lutris/wiki/How-to:-Esync

  time.timeZone =
    "America/Los_Angeles"; # Set this to your local timezone: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
}

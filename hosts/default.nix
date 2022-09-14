# Common host configuration.
{ config, pkgs, lib, ... }: {
  imports = [ ../modules ../pkgs ../users/jdf ];

  boot.binfmt.registrations.go.fixBinary = false; # Whether to open the interpreter file as soon as the registration is loaded
  boot.binfmt.registrations.go.interpreter = "/run/current-system/sw/bin/gorun"; # The interpreter to invoke to run the program
  boot.binfmt.registrations.go.magicOrExtension = "go"; # The magic number or extension to match on
  boot.binfmt.registrations.go.matchCredentials = true; # Whether to launch with the credentials and security token of the binary, not the interpreter (e.g. setuid bit)
  boot.binfmt.registrations.go.openBinary = true; # Whether to pass the binary to the interpreter as an open file descriptor, instead of a path
  boot.binfmt.registrations.go.preserveArgvZero = false; # Whether to pass the original argv[0] to the interpreter
  boot.binfmt.registrations.go.recognitionType = "extension"; # Whether to recognize executables by magic number or extension
  boot.kernel.sysctl."net.core.default_qdisc" = "fq"; # BBR must be used with fq qdisc
  boot.kernel.sysctl."net.ipv4.tcp_congestion_control" = "bbr"; # TCP BBR congestion control
  boot.kernel.sysctl."net.ipv4.tcp_slow_start_after_idle" = "0"; # Should help to improve performance in some cases.
  boot.kernelModules = [ "tcp_bbr" "bfq" "v4l2loopback" ]; # Kernel modules to be loaded in the second stage of the boot process
  boot.kernelPackages = with pkgs; linuxPackages_zen; # This option allows you to override the Linux kernel used by NixOS
  boot.loader.efi.canTouchEfiVariables = true; # Allow modifying EFI boot variables
  boot.loader.efi.efiSysMountPoint = "/boot"; # Where the EFI System Partition is mounted
  boot.loader.timeout = 1; # Set timeout to 1 for faster boot speeds.

  console.font = "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz"; # The font used for the virtual consoles
  console.colors = [ "1C1B19" "EF2F27" "519F50" "FBB829" "2C78BF" "E02C6D" "0AAEB3" "918175" "2D2C29" "F75341" "98BC37" "FED06E" "68A8E4" "FF5C8F" "53FDE9" "FCE8C3" ]; # The 16 colors palette used by the virtual consoles

  environment.systemPackages = with pkgs; [
    gitAndTools.gitFull # Distributed version control system
    hdparm # A tool to get/set ATA/SATA drive parameters under Linux
    home-manager # A user environment configurator
    kexectools # Tools related to the kexec Linux feature
    vim # The most popular clone of the VI editor
  ]; # The set of packages that appear in /run/current-system/sw. These packages are automatically available to all users, and are automatically updated every time you rebuild the system configuration

  gtk.iconCache.enable = true; # Whether to build icon theme caches for GTK applications

  hardware.rtl-sdr.enable = true; # Software Defined Radio
  hardware.steam-hardware.enable = true; # Enable udev rules for Steam hardware such as the Steam Controller, other supported controllers and the HTC Vive
  hardware.ksm.enable = true; # Kernel Same-Page Merging, can be suitable for more than Virtual Machine use, as it's useful for any application which generates many instances of the same data

  location.provider = "geoclue2"; # The location provider to use for determining your location

  modules.hardware.bluetooth.enable = true; # Enable my module for Bluetooth support
  modules.hardware.cpu.amd.enable = true; # Enable my module for AMD CPU support
  modules.services.flatpak.enable = true; # Enable my module for flatpak support
  modules.services.pipewire.enable = true; # Enable my module for pipewire support
  modules.hardware.cpu.disableMitigations.enable = true; # Enable my module for disabling CPU mitigations

  networking.extraHosts = ''
    127.0.0.1 ${config.networking.hostName}
    ::1 ${config.networking.hostName}
  ''; # Additional verbatim entries to be appended to /etc/hosts
  networking.firewall.allowedTCPPorts = [
    27015 # srcds
  ]; # List of TCP ports on which incoming connections are accepted
  networking.defaultGateway.address = "192.168.50.2"; # The default gateway address
  networking.enableIPv6 = false; # Whether to enable support for IPv6, my ISP does not provide IPv6
  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ]; # Nameservers, first is cloudflare with google as a backup.
  networking.firewall.checkReversePath = false; # Performs a reverse path filter test on a packet. If a reply to the packet would not be sent via the same interface that the packet arrived on, it is refused
  networking.networkmanager.enable = true; # Whether to use NetworkManager to obtain an IP address and other configuration for all network interfaces that are not manually configured

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  ''; # Additional text appended to nix.conf
  nix.gc.automatic = true; # Automatically run the garbage collector at a specific time
  nix.gc.options = "--delete-older-than 30d"; # Options given to nix-collect-garbage when the garbage collector is run automatically
  #nix.package = pkgs.nixUnstable; # this is required until nix 2.4 is released
  nix.settings.auto-optimise-store = true; # Nix automatically detects files in the store that have identical contents, and replaces them with hard links to a single copy
  nix.settings.allowed-users = [ "root" "@wheel" ]; # Allowed to connect to the Nix daemon
  nix.settings.trusted-users = [ "root" "@wheel" ]; # A list of names of users that have additional rights when connecting to the Nix daemon

  nixpkgs.config.allowUnfree = true; # The configuration of the Nix Packages collection, allowUnfree

  programs.dconf.enable = true; # Whether to enable dconf
  programs.gnupg.agent.enable = true; # Enables GnuPG agent with socket-activation for every user session.
  programs.gnupg.agent.enableSSHSupport = true; # Enable SSH agent support in GnuPG agent
  programs.nano.syntaxHighlight = true; # Whether to enable syntax highlight for various languages
  programs.mtr.enable = true; # Whether to add mtr to the global environment and configure a setcap wrapper for it
  programs.steam.remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play

  security.pam.loginLimits = [{
    domain = "*";
    type = "hard";
    item = "nofile";
    value = "1048576";
  }]; # Define resource limits that should apply to users or groups
  security.pam.services.swaylock.text = ''
    auth include login
  ''; # Make swaylock work
  security.protectKernelImage = true; # Whether to prevent replacing the running kernel image
  security.rtkit.enable = true; # Give realtime process priority on demand
  security.sudo.wheelNeedsPassword = false; # Whether users of the wheel group must provide a password to run commands as super user via sudo
  security.virtualisation.flushL1DataCache = "never"; # Whether the hypervisor should flush the L1 data cache before entering guests, "never": disables L1 data cache flushing entirely. May be appropriate if all guests are trusted.

  services.accounts-daemon.enable = true; # A DBus service for accessing the list of user accounts and information
  services.earlyoom.enable = true; # Enable early out of memory killing.
  services.earlyoom.freeMemThreshold = 3; # Minimum available memory (in percent)
  services.fstrim.enable = true; # Whether to enable periodic SSD TRIM of mounted partitions in background
  services.gnome.gnome-keyring.enable = true; # Whether to enable GNOME Keyring daemon, a service designed to take care of the user's security credentials, such as user names and passwords
  services.gvfs.enable = true; # Userspace virtual filesystem
  services.logind.extraConfig = ''
    KillUserProcesses=yes
    HandlePowerKey=ignore
  ''; # Extra config options for systemd-logind
  services.openssh.enable = true; # Whether to enable the OpenSSH secure shell daemon, which allows secure remote logins
  services.psd.enable = true; # Profile Sync Daemon
  services.ratbagd.enable = true; # Configure gaming mice, check for your device here: https://github.com/libratbag/libratbag/tree/master/data/devices
  services.timesyncd.enable = true; # Enables the systemd NTP client daemon
  services.udev.extraRules = ''
    # HORIPAD S
    KERNEL=="hidraw*", ATTRS{idVendor}=="0f0d", ATTRS{idProduct}=="00c1", MODE="0666"
    # KEYBOARDIO
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="2302", SYMLINK+="Atreus2", ENV{ID_MM_DEVICE_IGNORE}:="1", ENV{ID_MM_CANDIDATE}:="0", TAG+="uaccess", TAG+="seat"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="2303", SYMLINK+="Atreus2", ENV{ID_MM_DEVICE_IGNORE}:="1", ENV{ID_MM_CANDIDATE}:="0", TAG+="uaccess", TAG+="seat"
    # Arduino
    KERNEL=="ttyUSB[0-9]*",MODE="0666"
    KERNEL=="ttyACM[0-9]*",MODE="0666"
  ''; # Additional udev rules. They'll be written into file 99-local.rules, thus they are read and applied after all other rules.
  services.usbmuxd.enable = true; # This daemon is in charge of multiplexing connections over USB to an iOS device
  services.xserver.enable = true; # Whether to enable the X server
  services.xserver.displayManager.sx.enable = true; # Whether to enable the "sx" pseudo-display manager, which allows users to start manually via the "sx" command from a vt shell
  services.xserver.displayManager.lightdm.enable = false; # Disable the default display manager

  sound.mediaKeys.enable = true; # Whether to enable volume and capture control with keyboard media keys

  system.stateVersion = "22.11"; # Check release notes before changing this. *insert scary warning here*

  time.timeZone = "America/Los_Angeles"; # Set this to your local timezone: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
}

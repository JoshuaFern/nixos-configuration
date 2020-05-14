{ config, pkgs, lib, ... }: {
  imports = [
    ./cachix-combined.nix
    ./..
    ../../users/jdf # "jdf" User Oprtions
  ];
  #boot.loader.efi.canTouchEfiVariables = true; # Allowed to modify EFI boot variables
  #boot.loader.generationsDir.copyKernels = true; # Copy necessary files into /boot so /nix/store is not needed by the boot loader
  boot.loader.systemd-boot.configurationLimit = 10; # Maximum configurations in boot menu
  boot.loader.systemd-boot.consoleMode = "max"; # Console resolution
  boot.loader.systemd-boot.enable = true; # systemd-boot (formerly gummiboot)
  boot.kernelPackages = with pkgs; linuxPackages_latest; # linux kernel selection
  boot.kernelParams = [
    "vga=0x034d" # 1080p 24bit framebuffer
    # Disable mitigations https://make-linux-fast-again.com
    #"noibrs"
    #"noibpb"
    #"nopti"
    #"nospectre_v2"
    #"nospectre_v1"
    #"l1tf=off"
    #"nospec_store_bypass_disable"
    #"no_stf_barrier"
    #"mds=off"
    #"mitigations=off"
  ];
  boot.postBootCommands = ''
    echo bfq > /sys/block/sda/queue/scheduler
    echo bfq > /sys/block/sdb/queue/scheduler
    echo kyber > /sys/block/sdc/queue/scheduler
  '';

  environment.systemPackages = with pkgs; [
    # tools/filesystems
    squashfsTools # Tool for creating and unpacking squashfs filesystems
    squashfuse # FUSE filesystem to mount squashfs archives
  ];

  fileSystems = {
    "/".options = [ "noatime" "nodiratime" ]; # SSD
    "/home".options = [ "noatime" "nodiratime" ]; # SSD
    "/mnt/hdd0".options = [ "noatime" "nodiratime" "defaults" ]; # HDD
  };

  fonts.enableDefaultFonts = true;
  fonts.enableFontDir = true;
  fonts.enableGhostscriptFonts = true;
  fonts.fontconfig.cache32Bit = true;
  fonts.fontconfig.defaultFonts.emoji = [ "Noto Color Emoji" ];
  fonts.fontconfig.defaultFonts.monospace = [ "Noto Mono" ];
  fonts.fontconfig.defaultFonts.sansSerif = [ "Noto Sans" ];
  fonts.fontconfig.defaultFonts.serif = [ "Noto Sans" ];
  fonts.fontconfig.enable = true;
  fonts.fontconfig.includeUserConf = true;
  fonts.fontconfig.penultimate.enable = true;
  fonts.fonts = with pkgs; [ cascadia-code dejavu_fonts font-awesome-ttf google-fonts liberation_ttf noto-fonts terminus_font terminus_font_ttf ubuntu_font_family ];

  gtk.iconCache.enable = true;

  #hardware.cpu.intel.updateMicrocode = true;
  hardware.cpu.amd.updateMicrocode = true;
  hardware.enableAllFirmware = true;
  #hardware.nvidia.modesetting.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.enable = true;
  hardware.opengl.extraPackages = with pkgs; [ gst_all_1.gst-vaapi libva-full vaapiVdpau libvdpau-va-gl libvdpau vdpauinfo ];
  hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ gst_all_1.gst-vaapi libva-full vaapiVdpau libvdpau-va-gl libvdpau vdpauinfo ];
  hardware.pulseaudio.support32Bit = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.daemon.logLevel = "error";
  hardware.pulseaudio.package = with pkgs; pulseaudioFull;
  hardware.pulseaudio.daemon.config = {
    flat-volumes = "no"; # Avoids damaging your hearing. https://www.reddit.com/r/linux/comments/2rjiaa/horrible_decisions_flat_volumes_in_pulseaudio_a/
  };
  hardware.steam-hardware.enable = true; # Sets udev rules for Steam Controller, among other devices

  networking.defaultGateway.address = "192.168.1.1";
  networking.enableIPv6 = false;
  networking.hosts."0.0.0.0" = [ # Block ads / tracking
    # Firefox
    "location.services.mozilla.com"
    "shavar.services.mozilla.com"
    "incoming.telemetry.mozilla.org"
    "ocsp.sca1b.amazontrust.com"
    # GameAnalytics
    "api.gameanalytics.com"
    "rubick.gameanalytics.com"
    # Google
    "www.google-analytics.com"
    "ssl.google-analytics.com"
    "www.googletagmanager.com"
    "www.googletagservices.com"
    # Redshell
    "api.redshell.io"
    "treasuredata.com"
    "api.treasuredata.com"
    "in.treasuredata.com"
    # Spotify
    "apresolve.spotify.com"
    "heads4-ak.spotify.com.edgesuite.net"
    "redirector.gvt1.com"
    # Unity Engine
    "config.uca.cloud.unity3d.com"
    "api.uca.cloud.unity3d.com"
    "cdp.cloud.unity3d.com"
    # Unreal Engine 4
    "tracking.epicgames.com"
    "tracking.unrealengine.com"
  ];
  networking.nameservers = [ "1.1.1.1" ];
  networking.networkmanager.enable = false;
  networking.firewall.allowedTCPPorts = [
    27036 # Steam Remote Play
    27037 # Steam Remote Play
  ];
  networking.firewall.allowedUDPPorts = [
    27031 # Steam Remote Play
    27036 # Steam Remote Play
  ];
  networking.firewall.checkReversePath = false;
  networking.interfaces.enp5s0.ipv4.addresses = [{
    address = "192.168.1.2";
    prefixLength = 24;
  }];
  networking.interfaces.enp5s0.useDHCP = false;
  networking.useDHCP = false;
  networking.useNetworkd = true;

  nix.allowedUsers = [ "@wheel" ];
  nix.gc.options = pkgs.lib.mkForce "--delete-older-than 15d";
  nix.trustedUsers = [ "root" "@wheel" ];

  nixpkgs.config = {
    allowBroken = true;
    allowUnfree = true;
    android_sdk.accept_license = true;
    permittedInsecurePackages = [ "openssl-1.0.2u" "p7zip-16.02" ];
  };

  powerManagement.cpuFreqGovernor = "performance";

  programs = {
    adb.enable = true; # Android Debugging
    chromium.extraOpts = { # This seems to affect certain other Chromium based browsers as well. https://cloud.google.com/docs/chrome-enterprise/policies/
      DefaultPluginsSetting = 3; # Click to run Flash.
      ExtensionInstallForcelist = [
        "nngceckbapebfimnlniiiahkandclblb;https://clients2.google.com/service/update2/crx" # Bitwarden
        "dcpihecpambacapedldabdbpakmachpb;https://raw.githubusercontent.com/iamadamdev/bypass-paywalls-chrome/master/updates.xml" # Bypass Paywalls
        "ldpochfccmkkmhdbclfhpagapcfdljkj;https://clients2.google.com/service/update2/crx" # Decentraleyes
        "aiimboljphncldaakcnapfolgnjonlea;https://clients2.google.com/service/update2/crx" # The FFZ Add-On Pack
        "fadndhdgpmmaapbmfcknlfgcflmmmieb;https://clients2.google.com/service/update2/crx" # FrankerFaceZ
        "dhdgffkkebhmkfjojejmpbldmpobfkfo;https://clients2.google.com/service/update2/crx" # Tampermonkey
        "hjdoplcnndgiblooccencgcggcoihigg;https://clients2.google.com/service/update2/crx" # Terms of Service; Didn't Read
        "cjpalhdlnbpafiamejdnhcphjbkeiagm;https://clients2.google.com/service/update2/crx" # uBlock Origin
        "pgdnlhfefecpicbbihgmbmffkjpaplco;https://clients2.google.com/service/update2/crx" # uBlock Origin Extra
      ];
      PasswordManagerEnabled = false; # We're using our own password manager.
    };
    java.enable = true;
    java.package = with pkgs; jdk;
    mtr.enable = true;
    nano.nanorc = ''
      set autoindent
      set casesensitive
      set historylog
      set morespace
      set noconvert
      set nohelp
      set smooth
      set softwrap
      set tabstospaces
      set tabsize 2
    '';
    npm.enable = true;
    qt5ct.enable = true;
    slock.enable = true;
    ssh.forwardX11 = true;
    ssh.setXAuthLocation = true;
    usbtop.enable = true;
  };

  security.chromiumSuidSandbox.enable = true; # May fix the "You are not adequately sandboxed!" issue
  security.pam.loginLimits = [{
    domain = "*";
    type = "hard";
    item = "nofile";
    value = "1048576";
  }];
  security.protectKernelImage = true;
  security.rtkit.enable = true; # Give realtime process priority on demand
  security.sudo.wheelNeedsPassword = false;
  security.virtualisation.flushL1DataCache = "never";

  services = {
    accounts-daemon.enable = true; # A DBus service for accessing the list of user accounts and information
    emacs.enable = true; # Use "emacsclient" to connect to the daemon
    emacs.package = with pkgs; emacs;
    gvfs.enable = true; # Userspace virtual filesystem
    #kmscon.enable = true; # A kms/dri-based userspace virtual terminal implementation
    netdata.enable = true;
    pipewire.enable = true; # Server and user space API to deal with multimedia pipelines
    ratbagd.enable = true; # Configure gaming mice, check for your device here: https://github.com/libratbag/libratbag/tree/master/data/devices
    xserver.enable = true;
    xserver.displayManager.defaultSession = "none+i3";
    #xserver.exportConfiguration = true; # Symlink the X server configuration under /etc/X11/xorg.conf
    xserver.windowManager.i3.enable = true;
    xserver.videoDrivers = [ "nvidiaBeta" ]; # Video drivers that will be tried in order until one that supports your card is found
  };

  sound.enable = true;
  sound.mediaKeys.enable = true;
  sound.mediaKeys.volumeStep = "1dB";

  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  xdg.portal.gtkUsePortal = true;
}


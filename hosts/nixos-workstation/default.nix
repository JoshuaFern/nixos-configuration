{ config, pkgs, lib, ... }:
let
  user = "nix"; # Flatpak
in
{
  imports = [
    ../default.nix # Global Host Options
    ../../guests # Virtualization Options
    ../../users/default.nix # Global User Options
    ../../users/nix/default.nix # "Nix" User Oprtions
  ];
  boot.blacklistedKernelModules = [
    "nouveau" # Disable Nvidia because we're doing PCI-Passthrough
  ];
  boot.consoleLogLevel = 3;
  #boot.loader.efi.canTouchEfiVariables = true; # Installation process is allowed to modify EFI boot variables.
  #boot.loader.generationsDir.copyKernels = true; # Copy necessary files into /boot so /nix/store is not needed by the boot loader.
  boot.loader.systemd-boot.configurationLimit = 10; # Maximum configurations in boot menu.
  boot.loader.systemd-boot.consoleMode = "max"; # The resolution of the console.
  boot.loader.systemd-boot.enable = true; # systemd-boot (formerly gummiboot)
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ehci_pci"
    "ahci"
    "usb_storage"
    "usbhid"
    "sd_mod"
  ];
  #boot.kernelPackages = with pkgs; linuxPackages_latest; # Use latest kernel.
  boot.extraModulePackages = [ ];
  boot.kernelParams = [
    "vga=0x034d" # 1080p 24bit framebuffer
    "i915.enable_hd_vgaarb=1"
    "intel_pstate=nohwp" # Disables Intel's HWP (Hardware-managed P-states) https://www.kernel.org/doc/html/v4.12/admin-guide/pm/intel_pstate.html
    # Disable mitigations https://make-linux-fast-again.com
    "noibrs"
    "noibpb"
    "nopti"
    "nospectre_v2"
    "nospectre_v1"
    "l1tf=off"
    "nospec_store_bypass_disable"
    "no_stf_barrier"
    "mds=off"
    "mitigations=off"
  ];
  boot.postBootCommands = ''
    echo bfq > /sys/block/sda/queue/scheduler
    echo bfq > /sys/block/sdb/queue/scheduler
    echo kyber > /sys/block/sdc/queue/scheduler
    '';

  console.colors = [
    "001100" "007700" "00bb00" "007700"
    "009900" "00bb00" "005500" "00bb00"
    "007700" "007700" "00bb00" "007700"
    "009900" "00bb00" "005500" "00ff00"
  ];

  environment.checkConfigurationOptions = true;
  environment.etc."mpv/mpv.conf".text = ''
    fs
    hwdec=auto
  '';
  environment.systemPackages = with pkgs; [
    # data/soundfonts
    soundfont-fluid # Frank Wen's pro-quality GM/GS soundfont
    # applications/audio
    cmus # Small, fast and powerful console music player for Linux and *BSD
    fluidsynth # Real-time software synthesizer based on the SoundFont 2 specifications
    mikmod # Tracker music player for the terminal
    moc # An ncurses console audio player designed to be powerful and easy to use
    mpg123 # Fast console MPEG Audio Player and decoder library
    schismtracker # Music tracker application, free reimplementation of Impulse Tracker
    vorbis-tools # Extra tools for Ogg-Vorbis audio codec
    # applications/misc
    calcurse # A calendar and scheduling application for the command line
    xst # Simple terminal fork that can load config from Xresources
    # applications/virtualization/driver
    win-virtio # Windows VirtIO Drivers
    # development/libraries
    libnotify # A library that sends desktop notifications to a notification daemon
    # development/mobile
    abootimg # Manipulate Android Boot Images
    # development/tools
    flatpak-builder # Tool to build flatpaks from source
    pkgconf # Package compiler and linker metadata toolkit
    # os-specific/linux
    hdparm # A tool to get/set ATA/SATA drive parameters under Linux
    kexectools # Tools related to the kexec Linux feature
    psmisc # A set of small useful utilities that use the proc filesystem (such as fuser, killall and pstree)
    # shells
    mksh # MirBSD Korn Shell
    # tools/archivers
    p7zip # A port of the 7-zip archiver
    unzip #
    xarchiver # GTK frontend to 7z,zip,rar,tar,bzip2, gzip,arj, lha, rpm and deb (open and extract only)
    zip # Compressor/archiver for creating and modifying zipfiles
    # tools/filesystems
    squashfsTools # Tool for creating and unpacking squashfs filesystems
    squashfuse # FUSE filesystem to mount squashfs archives
    # tools/misc
    abduco # Allows programs to be run independently from its controlling terminal
    cloc # A program that counts lines of source code
    dvtm # Dynamic virtual terminal manager
    entr # Run arbitrary commands when files change
    file # A program that shows the type of files
    mc # File Manager and User Shell for the GNU Project
    ncdu # Disk usage analyzer with an ncurses interface
    scanmem # Memory scanner for finding and poking addresses in executing processes
    snore # sleep with feedback
    #toybox # Lightweight implementation of some Unix command line utilities
    xclip # Tool to access the X clipboard from a console application
    # tools/system
    # tools/X11
    autocutsel # Tracks changes in the server's cutbuffer and CLIPBOARD selection
    ffcast # Run commands on rectangular screen regions
    keynav # Generate X11 mouse clicks from keyboard
    wmutils-core # Set of window manipulation tools
    wmutils-opt # Optional addons to wmutils
    xzoom # An X11 screen zoom tool
    #Temporary
    cantata
    grim
  ];
  environment.variables = {
    BROWSER = "firefox";
    EDITOR = "nano";
    MPV_HOME = "/etc/mpv";
    QT_QPA_PLATFORMTHEME = "qt5ct";
    TERM = "urxvt";
    VISUAL = "nano";
  };
  environment.sessionVariables = {
    WINEDEBUG = "-all"; # Increase Performance with WINE
  };

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
  fonts.fonts = with pkgs; [
    cascadia-code
    dejavu_fonts
    font-awesome-ttf
    google-fonts
    iosevka
    liberation_ttf
    noto-fonts
    terminus_font
    terminus_font_ttf
    ubuntu_font_family
  ];

  gtk.iconCache.enable = true;

  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.enable = true;
  hardware.opengl.extraPackages = with pkgs; [ gst_all_1.gst-vaapi libva-full  vaapiVdpau libvdpau-va-gl libvdpau vdpauinfo ];
  hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ gst_all_1.gst-vaapi libva-full  vaapiVdpau libvdpau-va-gl libvdpau vdpauinfo ];
  hardware.opengl.s3tcSupport = true;
  hardware.pulseaudio.support32Bit = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.daemon.logLevel = "error";
  hardware.pulseaudio.package = with pkgs; pulseaudioFull;
  hardware.pulseaudio.daemon.config = {
    flat-volumes = "no"; # Avoids damaging your hearing. https://www.reddit.com/r/linux/comments/2rjiaa/horrible_decisions_flat_volumes_in_pulseaudio_a/
  };
  #hardware.steam-hardware.enable = true; # Sets udev rules for Steam Controller, among other devices.

  location.latitude = 45.0; # Set this too precise and you reveal your exact location.
  location.longitude = -122.0; # Set this too precise and you reveal your exact location.
  location.provider = "manual";

  networking.defaultGateway.address = "192.168.1.1";
  networking.enableIPv6 = false;
  networking.extraHosts = ''
    127.0.0.1 ${config.networking.hostName}
    ::1 ${config.networking.hostName}
  '';
  networking.hostName = "nixos-workstation";
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
  networking.wireless.enable = false; # Enables wireless support via wpa_supplicant.
  networking.firewall.allowedTCPPorts = [
    69 # TFTP
    27036 # Steam Remote Play
    27037 # Steam Remote Play
  ];
  networking.firewall.allowedUDPPorts = [
    69 # TFTP
    27031 # Steam Remote Play
    27036 # Steam Remote Play
  ];
  networking.firewall.checkReversePath = false;
  networking.firewall.enable = true;
  networking.interfaces.enp2s0.ipv4.addresses = [ { address = "192.168.1.2"; prefixLength = 24; } ];
  networking.interfaces.enp2s0.useDHCP = false;
  networking.useDHCP = false;
  networking.useNetworkd = true;

  nix.allowedUsers = [ "@wheel" ];
  nix.binaryCaches = [ ];
  nix.buildCores = 0; # Some builds may become non-deterministic with this option; use with care!
  nix.gc.options = pkgs.lib.mkForce "--delete-older-than 15d";
  nix.maxJobs = 8; # You should generally set it to the total number of logical cores in your system (e.g., 16 for two CPUs with 4 cores each and hyper-threading). 
  nix.trustedUsers = [ "root" "@wheel" ];

  nixpkgs.config = {
    allowBroken = true;
    allowUnfree = true;
    android_sdk.accept_license = true;
    #firefox.enableAdobeFlash = true;
    #firefox.enableGoogleTalkPlugin = true;
    firefox.enableGTK3 = true;
    #firefox.ffmpegSupport= true;
    #firefox.jre = true;
    #firefox.enableMPlayer = true;
    #firefox.icedtea = true;
    packageOverrides = pkgs: {
      nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
        inherit pkgs;
      };
    };
    permittedInsecurePackages = [
      "openssl-1.0.2u"
    ];
                           
  };

  powerManagement.cpuFreqGovernor = "performance";

  programs = {
    adb.enable = true; # Android Debugging
    chromium.extraOpts = { # This seems to affect certain other Chromium based browsers as well. https://cloud.google.com/docs/chrome-enterprise/policies/
      DefaultPluginsSetting = 3; # Click to run Flash.
      DiskCacheDir = "/tmp/.chromium-\${user_name}";
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
    #firejail.enable = true;
    #gnome-disks.enable = true;
    #home-manager.enable = true;
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
    #slock.enable = true;
    ssh.forwardX11 = true;
    ssh.setXAuthLocation = true;
    sway.enable = true;
    usbtop.enable = true;
  };

  security.chromiumSuidSandbox.enable = true; # May fix the "You are not adequately sandboxed!" issue.
  security.pam.loginLimits = [{
    domain = "*";
    type = "hard";
    item = "nofile";
    value = "1048576";
  }];
  security.protectKernelImage = true;
  security.rtkit.enable = true; # Give realtime process priority on demand.
  security.sudo.wheelNeedsPassword = false;
  security.virtualisation.flushL1DataCache = "never";

  services = {
    # services/audio
    #jack.jackd.enable = true;
    #jack.jackd.package = with pkgs; jack1;
    #jack.loopback.enable = true; # Should help things like Steam to work.
    mpd.enable = true;
    mpd.extraConfig = ''
      password "AWQa*#77yiiT!o@read,add,control,admin"
      max_playlist_length "65535"
      max_command_list_size "65535"
    '';
    mpd.network.listenAddress = "any";
    # services/desktops
    #geoclue2.enable = true;
    #gvfs.enable = true; # GVfs, a userspace virtual filesystem.
    #pipewire.enable = true;
    # services/editors
    emacs.enable = true;
    emacs.package = with pkgs; emacs;
    # services/hardware
    #ratbagd.enable = true; # Config for gaming mice, check for your device here: https://github.com/libratbag/libratbag/tree/master/data/devices
    # services/networking
    #keybase.enable = true;
    openssh.enable = true;
    openssh.ports = [22];
    #openssh.forwardX11 = true;
    # services/network-filesystems
    #kbfs.enable = true;
    #kbfs.mountPoint = "/keybase";
    # services/printing
    #printing.enable = true; # Enable printing. On PAPER! How revoltingly archaic.
    # services/security
    fail2ban.enable = true;
    #tor.client.enable = true;
    #tor.enable = true;
    # services/system
    dbus.enable = true;
    earlyoom.enable = true; # Enable early out of memory killing.
    earlyoom.freeMemThreshold = 3;
    earlyoom.ignoreOOMScoreAdjust = true;
    earlyoom.notificationsCommand = "sudo -u nix DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus notify-send"; # https://github.com/rfjakob/earlyoom#notifications
    # services/torrent
    #btpd.enable = true; # Awaiting PR 56279
    #btpd.bandwidthLimitIn = 500 # Max 1500
    #btpd.bandwidthLimitOut = 25 # Max 188
    #btpd.maxUploads = 1
    # services/x11
    #compton.enable = true;
    #compton.fade = true;
    #compton.inactiveOpacity = "1.0";
    #compton.shadow = true;
    #compton.fadeDelta = 4;
    #redshift.enable = true;
    #xbanish.enable = true; # Hides the cursor while typing.
    #xserver.enable = true;
    #xserver.layout = "us";
    #xserver.displayManager.defaultSession = "none+i3";
    #xserver.displayManager.lightdm.background ="";
    #xserver.displayManager.startx.enable = true;
    #xserver.windowManager.bspwm.enable = true;
    #xserver.windowManager.bspwm.configFile = "/etc/bspwmrc";
    #xserver.windowManager.bspwm.sxhkd.configFile = "/etc/sxhkdrc";
    #xserver.windowManager.i3.enable = true;
    #xserver.windowManager.i3.package = with pkgs; i3-gaps;
    #xserver.windowManager.i3.extraPackages = with pkgs; [ dmenu i3status ];
    #xserver.xautolock.enable = true;
    #xserver.xautolock.locker = "${pkgs.slock}/bin/slock";
    #xserver.xautolock.nowlocker = "${pkgs.slock}/bin/slock";
    #xserver.xautolock.time = 15;
    # system/boot
    logind.lidSwitch = "ignore";
    #
    accounts-daemon.enable = true;
  };

  sound.enable = true;
  sound.mediaKeys.enable = true;
  sound.mediaKeys.volumeStep = "1dB";

  system.activationScripts.flatpak-install = import ../../scripts/flatpak-install.nix {
    inherit pkgs;
    inherit user;
    flatpakFlathubPackages = [
      "cc.retroshare.retroshare-gui" # RetroShare-gui - Secure communication for everyone
      "com.github.fabiocolacio.marker" # Marker - Powerful markdown editor
      "com.github.libresprite.LibreSprite" # LibreSprite - Animated sprite editor and pixel art tool
      "com.github.marktext.marktext" # Mark Text - Next generation markdown editor
      "com.github.miguelmota.Cointop" # Cointop - Terminal based application for tracking cryptocurrency
      "com.notepadqq.Notepadqq" # Notepadqq - An advanced text editor
      "com.obsproject.Studio" # OBS Studio - Live streaming and video recording software
      "com.valvesoftware.Steam" # Steam - Manage and play games distributed by Steam
      "com.visualstudio.code.oss" # Visual Studio Code - OSS - Visual Studio Code. Code editing. Redefined.
      "info.mumble.Mumble" # Mumble - Low latency encrypted VoIP client
      "io.howl.Editor" # Howl - Lightweight editor with keyboard-centric minimalistic interface
      "im.riot.Riot" # Riot - Create, share, communicate, chat and call securely, and bridge to other apps
      "net.minetest.Minetest" # Minetest - Multiplayer infinite-world block sandbox game
      "org.blender.Blender" # Blender - Free and open source 3D creation suite
      "org.DolphinEmu.dolphin-emu" # Dolphin Emulator - GameCube / Wii / Triforce Emulator
      "org.freedesktop.Platform.Icontheme.Adwaita"
      "org.geany.Geany" # Geany - A fast and lightweight IDE
      "org.gimp.GIMP" # GNU Image Manipulation Program - Create images and edit photographs
      "org.gnome.GHex" # GNOME Hex Editor - Inspect and edit binary files
      "org.godotengine.Godot" # Godot - Godot game engine editor
      "org.gtk.Gtk3theme.Adwaita-dark"
      "org.inkscape.Inkscape" # Inkscape - Vector Graphics Editor
      "org.jdownloader.JDownloader" # JDownloader - Download management tool
      #"org.kde.PlatformTheme.QGnomePlatform"
      "org.libreoffice.LibreOffice" # LibreOffice - The LibreOffice productivity suite
      "org.libretro.RetroArch" # RetroArch - Frontend for emulators, game engines and media players
      "org.shotcut.Shotcut" # Shotcut - Video editor
      "org.stellarium.Stellarium" # Stellarium - Desktop Planetarium
      "org.wxhexeditor.wxHexEditor" # wxHexEditor - Advanced large file hex editor
    ];
    flatpakKdeappsPackages = [
      "org.kde.kdenlive" # Kdenlive - Video Editor
      "org.kde.krita" # Krita - Digital Painting, Creative Freedom
      "org.kde.KStyle.Adwaita"
    ];
    flatpakFirefoxPackages = [
      "org.mozilla.FirefoxDevEdition"
    ];
  };

  virtualisation = {
    anbox = {
      #enable = true; # Android in a box.
      image = with pkgs; anbox.image; # Base Android image for Anbox.
    };
    docker = {
      autoPrune.enable = true;
      #enable = true;
      liveRestore = false;
    };
  };

  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  xdg.portal.gtkUsePortal = true;
}


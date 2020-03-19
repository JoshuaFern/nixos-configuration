{ config, pkgs, ... }:
let
  secrets = import ../secrets.nix;
  thisUser = "jdf";
  flatpakFlathubPackages = [
    "com.discordapp.Discord" # Discord - Chat client
    "org.freedesktop.Platform.Icontheme.Adwaita"
    "org.gtk.Gtk3theme.Adwaita-dark"
    "org.jdownloader.JDownloader" # JDownloader - Download management tool
  ];
in { imports = [ ./..
    (import(builtins.fetchGit{ref = "master";url = "https://github.com/rycee/home-manager";}){}).nixos # Home-Manger
  ];

  home-manager.users.jdf = { config, pkgs, lib, ... }: {
    nixpkgs.config = {
      allowUnfree = true;
      packageOverrides = pkgs: {
        nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
          inherit pkgs;
        };
      };
      permittedInsecurePackages = [
        "openssl-1.0.2u"
      ];
  };

    manual.html.enable = true;

    news.display = "silent";

    programs.chromium.enable = true;
    programs.firefox = {
      enable = true; # Whether to enable Firefox
      package = with pkgs; firefox-devedition-bin; # If state version ≥ 19.09 then this should be wrapped
      profiles.jdf = {
        #extraConfig = builtins.readFile (builtins.fetchurl "https://raw.githubusercontent.com/ghacksuserjs/ghacks-user.js/master/user.js"); # ghacks-user.js
        id = 0;
        isDefault = true;
        name = "jdf";
        settings = {
          "browser.display.background_color" = "#000000";
          "browser.newtabpage.activity-stream.feeds.topsites" = false;
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.telemetry.structuredIngestion" = false;
          "browser.newtabpage.activity-stream.telemetry.ut.events" = false;
          "browser.sessionstore.max_tabs_undo" = 1; # Even with Firefox set to not remember history, your closed tabs are stored temporarily
          "browser.startup.firstrunSkipsHomepage" = false;
          "browser.startup.homepage" = "https://www.startpage.com/do/mypage.pl?prfh=enable_stay_controlEEE0N1NsuggestionsEEE1N1Ngeo_mapEEE1N1Nwikipedia_iaEEE1N1Nother_iaEEE1N1Ndisable_open_in_new_windowEEE0N1Ndisable_video_family_filterEEE1N1Nenable_post_methodEEE1N1Nenable_proxy_safety_suggestEEE0N1Ndisable_family_filterEEE1N1Nconnect_to_serverEEEusN1NsslEEE1N1Nlanguage_uiEEEenglishN1NlanguageEEEenglishN1Nwt_unitEEEfahrenheitN1Nnum_of_resultsEEE20N1Nlang_homepageEEEs/nite/en/";
          "browser.translation.detectLanguage" = false;
          "browser.translation.engine" = "";
          "browser.translation.neverForLanguages" = "en,de";
          "browser.translation.ui.show" = false;
          "browser.urlbar.eventTelemetry.enabled" = false;
          "browser.urlbar.suggest.bookmark" = true;
          "browser.urlbar.suggest.history" = false;
          "browser.urlbar.suggest.openpage" = false;
          "datareporting.policy.firstRunURL" = "";
          "devtools.theme" = "dark";
          "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
          "extensions.pocket.enabled" = false;
          "extensions.recommendations.hideNotice" = true;
          "extensions.ui.dictionary.hidden" = false;
          "extensions.ui.locale.hidden" = false;
          "identity.fxaccounts.enabled" = false;
          "keyword.enabled" = true;
          "media.peerconnection.identity.timeout" = 1;
          "media.peerconnection.turn.disable" = true;
          "media.peerconnection.use_document_iceservers" = false;
          "media.peerconnection.video.enabled" = false;
          "privacy.clearOnShutdown.cookies" = false;
          "privacy.clearOnShutdown.openWindows" = false;
          "privacy.clearOnShutdown.siteSettings" = false;
          "privacy.trackingprotection.cryptomining.enabled" = true; # Blocks CryptoMining
          "privacy.trackingprotection.enabled" = false; # redundant if you are already using uBlock Origin 3rd party filters
          "privacy.trackingprotection.fingerprinting.enabled" = true; # Blocks Fingerprinting
          "privacy.trackingprotection.origin_telemetry.enabled" = false;
          "security.app_menu.recordEventTelemetry" = false;
          "security.certerrors.recordEventTelemetry" = false;
          "security.identitypopup.recordEventTelemetry" = false;
          "security.protectionspopup.recordEventTelemetry" = false;
          "signon.generation.enabled" = false; # Disable password generation
          "signon.management.page.breach-alerts.enabled" = false; # Disable password breach alerts
          "signon.rememberSignons" = false; # Disable built-in password manager
          "startup.homepage_welcome_url" = "";
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "toolkit.telemetry.debugSlowSql" = false;
          "toolkit.telemetry.ecosystemtelemetry.enabled" = false;
          "toolkit.telemetry.geckoview.streaming" = false;
          "toolkit.telemetry.isGeckoViewMode" = false;
          "toolkit.telemetry.shutdownPingSender.enabledFirstSession" = false;
          "toolkit.telemetry.testing.overrideProductsCheck" = false;
        };
        userChrome = ''
          .browserStack { /* letterbox color */
            background-color: rgb(0, 0, 0);
          }
          #navigator-toolbox { /* autohide toolbar */
            position: relative;
            height: 15px;
            margin-bottom: -5px;
            opacity: 0;
            overflow: hidden;
          }
          #navigator-toolbox:hover { /* autohide toolbar */
            height: auto;
            margin-bottom: 0px;
            opacity: 1;
            overflow: show;
          }
          #sidebar-header { /* autohide sidebar header */
            position: relative;
            height: 5px;
            margin-bottom: -5px;
            opacity: 0;
            overflow: hidden;
            background-color: rgb(0, 0, 0);
          }
          #sidebar-header:hover { /* autohide sidebar header */
            height: auto;
            margin-bottom: 0px;
            opacity: 1;
            overflow: show;
            background-color: rgb(0, 0, 0);
          }
          #sidebar-splitter { /* hide sidebar splitter */
            background-color: rgb(0, 0, 0) !imortant;
            border-color: rgb(0, 0, 0) !imortant;
            display: none;
          }
        '';
        userContent = ''
          *{scrollbar-width:none !important}
          @-moz-document url-prefix("about:blank") {
            body { background-color: rgb(0,0,0) !important; }
          }
          @-moz-document url-prefix("moz-extension://f0bfb93c-9488-4446-9105-286c8f91a446/") {
            body { background-color: rgb(0,0,0) !important; }
          }
        '';
      };
    };
    programs.git.enable = true;
    programs.git.lfs.enable = true;
    programs.git.package = with pkgs; gitAndTools.gitFull;
    programs.git.userEmail = "JoshuaFern@ProtonMail.com";
    programs.git.userName = "Joshua Fern";
    programs.home-manager.enable = true; # Let Home Manager install and manage itself
    #programs.home-manager.path = "$HOME/git/home-manager";
    programs.mpv.config.profile = "gpu-hq";
    programs.mpv.enable = true;
    programs.rofi.enable = true;
    programs.vscode.enable = true;
    programs.vscode.package = with pkgs; vscodium;
    programs.vscode.userSettings = {
      "update.channel" = "none";
      "[nix]"."editor.tabSize" = 2;
    };

    home = {
      activation = {
        flatpakActivation = ''
          echo [Flatpak] Start...
          ${pkgs.flatpak}/bin/flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
          ${pkgs.flatpak}/bin/flatpak install --user --noninteractive -y flathub ${toString flatpakFlathubPackages}
          ${pkgs.flatpak}/bin/flatpak update --user -y
          echo [Flatpak] Done.
        '';
        xdgActivation = ''
        ${pkgs.xdg-user-dirs}/bin/xdg-user-dirs-update
        '';
      };
      packages = with pkgs; [
        # applications/audio
        cmus # Small, fast and powerful console music player for Linux and *BSD
        fluidsynth # Real-time software synthesizer based on the SoundFont 2 specifications
        mikmod # Tracker music player for the terminal
        moc # An ncurses console audio player designed to be powerful and easy to use
        mpg123 # Fast console MPEG Audio Player and decoder library
        schismtracker # Music tracker application, free reimplementation of Impulse Tracker
        vorbis-tools # Extra tools for Ogg-Vorbis audio codec
        # applications/graphics
        dia # Gnome Diagram drawing software
        imv # Simple X11/Wayland Image Viewer
        nur.repos.joshuafern.steamgrid
        waifu2x-converter-cpp # Improved fork of Waifu2X C++ using OpenCL and OpenCV
        # applications/misc
        calcurse # A calendar and scheduling application for the command line
        et # Minimal libnotify-based (egg) timer
        mako # A lightweight Wayland notification daemon
        mps-youtube # Terminal based YouTube player and downloader
        mupdf # Lightweight PDF, XPS, and E-book viewer and toolkit written in portable C
        nnn # Small ncurses-based file browser forked from noice
        noice # Small ncurses-based file browser
        ranger # File manager with minimalistic curses interface
        rtv # Browse Reddit from your Terminal
        slmenu # A console dmenu-like tool
        tdrop # A Glorified WM-Independent Dropdown Creator
        treesheets # Free Form Data Organizer
        vym # Mind-mapping software
        wtf # The personal information dashboard for your terminal
        xst # Simple terminal fork that can load config from Xresources
        zathura # A highly customizable and functional PDF viewer
        # applications/networking
        hydroxide # A third-party, open-source ProtonMail bridge
        # applications/networking/browsers
        elinks # Full-featured text-mode web browser
        links2 # A small browser with some graphics support
        lynx # A text-mode web browser
        w3m # A text-mode web browser
        # applications/networking/instant-messengers
        weechat # A fast, light and extensible chat client
        # applications/networking/mailreaders
        mutt-with-sidebar # A small but very powerful text-based mail client
        # applications/networking/p2p
        transmission-remote-cli # Curses interface for the Transmission BitTorrent daemon
        # applications/networking/remote
        freerdp # A Remote Desktop Protocol Client
        # applications/radio
        aldo # Morse code training program
        unixcw # sound characters as Morse code on the soundcard or console speaker
        # applications/version-management
        gitAndTools.gitFull # Distributed version control system
        mercurialFull # A fast, lightweight SCM system for very large distributed projects
        # applications/video
        streamlink # CLI for extracting streams from various websites to video player of your choosing
        # applications/virtualization
        looking-glass-client # A KVM Frame Relay (KVMFR) implementation
        # build-support
        appimage-run
        #steam-run
        steam-run-native
        # data/icons
        hicolor-icon-theme # Default fallback theme used by implementations of the icon theme specification
        # data/soundfonts
        soundfont-fluid # Frank Wen's pro-quality GM/GS soundfont
        # desktops/gnome3
        gnome3.adwaita-icon-theme
        gnome-themes-extra
        # development/compilers
        go # The Go Programming language
        mono # Cross platform, open source .NET development framework
        # development/haskell-modules
        nixfmt # An opinionated formatter for Nix
        shellcheck # Shell script analysis tool
        # development/interpreters
        luajit # High-performance JIT compiler for Lua 5.1
        python2Full # A high-level dynamically-typed programming language
        python3Full # A high-level dynamically-typed programming language
        # development/libraries
        libnotify # A library that sends desktop notifications to a notification daemon
        # development/mobile
        abootimg # Manipulate Android Boot Images
        imgpatchtools # Tools to manipulate Android OTA archives
        nur.repos.joshuafern.qdl
        # development/python-modules
        python38Packages.nix-prefetch-github # Prefetch sources from github
        python38Packages.pywal # Generate and change colorschemes on the fly. A 'wal' rewrite in Python 3.
        python38Packages.virtualenvwrapper # Enhancements to virtualenv
        python38Packages.speedtest-cli # Command line interface for testing internet bandwidth using speedtest.net
        # development/tools
        apktool # A tool for reverse engineering Android apk files
        flatpak-builder # Tool to build flatpaks from source
        go2nix
        pkgconf # Package compiler and linker metadata toolkit
        solarus-quest-editor
        vgo2nix
        # games
        cataclysm-dda # A free, post apocalyptic, zombie infested rogue-like
        eidolon # A single TUI-based registry for drm-free, wine and steam games on linux, accessed through a rofi launch menu
        EmptyEpsilon # Open source bridge simulator based on Artemis
        freedroidrpg # Isometric 3D RPG similar to game Diablo
        mindustry # A sandbox tower defense game
        solarus # A Zelda-like ARPG game engine
        steam # A digital distribution platform
        steamcmd # Steam command-line tools
        # misc
        scrcpy # Display and control Android devices over USB or TCP/IP
        # misc/emulators
        nur.repos.joshuafern.dosbox-staging
        # misc/themes
        adwaita-qt # A style to bend Qt applications to look like they belong into GNOME Shell
        # misc/vim-plugins
        vimPlugins.vim-nix
        # os-specific/linux
        hdparm # A tool to get/set ATA/SATA drive parameters under Linux
        kexectools # Tools related to the kexec Linux feature
        psmisc # A set of small useful utilities that use the proc filesystem (such as fuser, killall and pstree)
        # servers/x11
        xorg.xinit
        # shells
        dash # A POSIX-compliant implementation of /bin/sh that aims to be as small as possible
        mksh # MirBSD Korn Shell
        rc # The Plan 9 shell
        # tools/archivers
        p7zip # A port of the 7-zip archiver
        unzip # An extraction utility for archives compressed in .zip format
        zip # Compressor/archiver for creating and modifying zipfiles
        # tools/audio
        pulsemixer # Cli and curses mixer for pulseaudio
        # tools/graphics
        grim # Grab images from a Wayland compositor
        # tools/misc
        abduco # Allows programs to be run independently from its controlling terminal
        cloc # A program that counts lines of source code
        dvtm # Dynamic virtual terminal manager
        entr # Run arbitrary commands when files change
        file # A program that shows the type of files
        mc # File Manager and User Shell for the GNU Project
        ncdu # Disk usage analyzer with an ncurses interface
        pfetch # A pretty system information tool written in POSIX sh
        scanmem # Memory scanner for finding and poking addresses in executing processes
        snore # sleep with feedback
        xclip # Tool to access the X clipboard from a console application
        youtube-dl # Command-line tool to download videos from YouTube.com and other sites
        # tools/networking
        bwm_ng # A small and simple console-based live network and disk io bandwidth monitor
        curlFull # A command line tool for transferring files with URL syntax
        tftp-hpa # TFTP tools - a lot of fixes on top of BSD TFTP
        wget # Tool for retrieving files using HTTP, HTTPS, and FTP
        ytcc # Command Line tool to keep track of your favourite YouTube channels without signing up for a Google account
        # tools/package-management
        appimagekit # A tool to package desktop applications as AppImages
        protontricks # A simple wrapper for running Winetricks commands for Proton-enabled games
        # tools/security
        mkpasswd # Overfeatured front-end to crypt, from the Debian whois package
        # tools/system
        htop # An interactive process viewer for Linux
        hwinfo # Hardware detection tool from openSUSE
        nq # Unix command line queue utility
        nvtop # A (h)top like like task monitor for NVIDIA GPUs
        pciutils # A collection of programs for inspecting and manipulating configuration of PCI devices
        plan9port # Plan 9 from User Space
        # tools/x11
        xdg-user-dirs # A tool to help manage well known user directories like the desktop folder and the music folder
      ];
      sessionVariables = {
        #BROWSER = "firefox";
        #EDITOR = "nano";
        #QT_QPA_PLATFORMTHEME = "qt5ct";
        #VISUAL = "nano";
        WINEDEBUG = "-all"; # Increase Performance with WINE
      };
      stateVersion = "20.03";
    };

    xdg.enable = true;

    xsession.enable = true;
    xsession.windowManager.i3 = {
      config = {
        #assigns = "5: steam" = [{ class = "^Firefox$"; }];
        modifier = "Mod4"; # Windows-key modifier
        terminal = "${pkgs.xst}/bin/xst -e ${pkgs.mksh}/bin/mksh";
      };
      enable = true;
    };
  };
  #home-manager.useGlobalPkgs = false; # Use the global pkgs instead of home-manager.users.<name>.nixpkgs
  home-manager.useUserPackages = false; # Install packages to /etc/profiles instead of ~/.nix-profile

  users.users.jdf = {
    createHome = true;
    description = "Joshua Fern";
    extraGroups = [ "adbusers" "adm" "audio" "containers" "docker" "fuse" "games" "input" "jackaudio" "kvm" "lp" "libvirtd" "netdev" "networkmanager" "plugdev" "scanner" "sudo" "sys" "tty" "uucp" "vboxusers" "video" "wheel" ];
    hashedPassword = secrets.accountPassword.jdf;
    home = "/home/jdf";
    isNormalUser = true;
    shell = with pkgs; mksh;
    uid = 1000;
  };
}

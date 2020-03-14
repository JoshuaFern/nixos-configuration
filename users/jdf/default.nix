{ config, pkgs, ... }:
let secrets = import ../secrets.nix;
in
{
  imports = [
    ./..
    <home-manager/nixos>
    ]; # nix-channel --add https://github.com/rycee/home-manager/archive/master.tar.gz home-manager

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

  programs = {
    chromium.enable = true;
    firefox = {
      enable = true; # Whether to enable Firefox
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [ # You must manually enable these in Firefox
        bitwarden # Password Manager
        decentraleyes # Local CDN Caching
        greasemonkey # Userscripts
        https-everywhere # HTTPS
        multi-account-containers # Web Containers
        reddit-enhancement-suite # Reddit Enhanced
        ublock-origin # Adblocking
        vimium # VIM Hotkeys
      ];
      package = with pkgs; firefox-devedition-bin; # If state version ≥ 19.09 then this should be wrapped
      profiles.jdf = {
        extraConfig = builtins.readFile (builtins.fetchurl "https://raw.githubusercontent.com/ghacksuserjs/ghacks-user.js/master/user.js"); # ghacks-user.js
        id = 0;
        isDefault = true;
        name = "jdf";
        settings = {
          "browser.display.background_color" = "#000000";
          "browser.newtabpage.activity-stream.feeds.topsites" = false;
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.telemetry.structuredIngestion" = false;
          "browser.newtabpage.activity-stream.telemetry.ut.events" = false;
          "browser.sessionstore.max_tabs_undo" = 1; # Even with Firefox set to not remember history, your closed tabs are stored temporaril
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
    git = {
      enable = true;
      lfs.enable = true;
      package = with pkgs; pkgs.gitAndTools.gitFull;
      userEmail = "JoshuaFern@ProtonMail.com";
      userName = "Joshua Fern";
    };
    home-manager = {
      enable = true; # Let Home Manager install and manage itself
      path = "$HOME/git/home-manager";
    };
    mpv = {
      config = {
        profile = "gpu-hq";
      };
      enable = true;
    };
  };

    home = {
      packages = with pkgs; [
       # applications/graphics
       dia # Gnome Diagram drawing software
       imv # Simple X11/Wayland Image Viewer
       waifu2x-converter-cpp # Improved fork of Waifu2X C++ using OpenCL and OpenCV
       # applications/misc
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
       mercurialFull # A fast, lightweight SCM system for very large distributed projects
       # applications/video
       streamlink # CLI for extracting streams from various websites to video player of your choosing
       # applications/virtualization
       looking-glass-client # A KVM Frame Relay (KVMFR) implementation
       # build-support
       appimage-run # Run appimages
       # data/icons
       hicolor-icon-theme # Default fallback theme used by implementations of the icon theme specification
       # desktops/gnome3
       gnome3.adwaita-icon-theme
       gnome-themes-extra
       # development/compilers
       go
       mono # Cross platform, open source .NET development framework
       # development/haskell-modules
       shellcheck # Shell script analysis tool
       # development/interpreters
       luajit # High-performance JIT compiler for Lua 5.1
       python2Full # A high-level dynamically-typed programming language
       python3Full # A high-level dynamically-typed programming language
       # development/mobile
       imgpatchtools # Tools to manipulate Android OTA archives
       # development/python-modules
       python38Packages.nix-prefetch-github # Prefetch sources from github
       python38Packages.pywal # Generate and change colorschemes on the fly. A 'wal' rewrite in Python 3.
       python38Packages.virtualenvwrapper # Enhancements to virtualenv
       python38Packages.speedtest-cli # Command line interface for testing internet bandwidth using speedtest.net
       # development/tools
       apktool # A tool for reverse engineering Android apk files
       go2nix
       solarus-quest-editor
       vgo2nix
       # games
       cataclysm-dda # A free, post apocalyptic, zombie infested rogue-like
       freedroidrpg # Isometric 3D RPG similar to game Diablo
       mindustry # A sandbox tower defense game
       solarus # A Zelda-like ARPG game engine
       # misc
       scrcpy # Display and control Android devices over USB or TCP/IP
       # misc/themes
       adwaita-qt # A style to bend Qt applications to look like they belong into GNOME Shell
       # misc/vim-plugins
       vimPlugins.vim-nix
       # tools/audio
       pulsemixer # Cli and curses mixer for pulseaudio
       # tools/graphics
       grim # Grab images from a Wayland compositor
       # tools/misc
       youtube-dl # Command-line tool to download videos from YouTube.com and other sites
       # tools/networking
       ytcc # Command Line tool to keep track of your favourite YouTube channels without signing up for a Google account
      ];
      sessionVariables = {
      };
      stateVersion = "20.03";
    };

    wayland.windowManager.sway = {
      config = {
        #assigns = "2: web" = [{ class = "^Firefox$"; }];
        modifier = "Mod4"; # Windows-key modifier
        terminal = "${pkgs.xst}/bin/xst -e ${pkgs.mksh}/bin/mksh";
      };
      enable = true;
      systemdIntegration = true;
      xwayland = true;
    };
  };
  #home-manager.useGlobalPkgs = false; # If true, use the global pkgs instead of home-manager.users.<name>.nixpkgs
  home-manager.useUserPackages = false; # If true, install packages to /etc/profiles instead of ~/.nix-profile

  users.users.jdf = {
    createHome = true;
    description = "Joshua Fern";
    extraGroups = [ "adbusers" "adm" "audio" "containers" "docker" "fuse" "games" "input" "jackaudio" "kvm" "lp" "libvirtd" "netdev" "networkmanager" "plugdev" "scanner" "sudo" "sys" "tty" "uucp" "vboxusers" "video" "wheel" ];
    hashedPassword = secrets.accountPassword.jdf;
    home = "/home/jdf";
    isNormalUser = true;
    packages = with pkgs; [
    ];
    shell = with pkgs; dash; # When dmenu launches applications they're forked from this shell. Dash is used here for speed and memory reasons, not intended to be used interactively.
    uid = 1000;
  };
}

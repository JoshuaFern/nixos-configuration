{ config, pkgs, lib, ... }:
let
  flathubApps = [
    "org.freedesktop.Platform.Icontheme.Adwaita" # Adwaita Icons
    "org.gtk.Gtk3theme.Adwaita-dark" # Adwaita Theme
    "com.discordapp.Discord" # Discord: Chat client
    "org.jdownloader.JDownloader" # JDownloader: Download management tool
  ];
  secrets = import ./secrets.nix;
  wal = lib.importJSON ./colors.json;
in {
  imports = [
    ./..
    (import (builtins.fetchTarball "https://github.com/rycee/home-manager/archive/master.tar.gz") { }).nixos # Home-Manger
  ];

  #console.colors = with wal.colors; [ color0 color1 color2 color3 color4 color5 color6 color7 color8 color9 color10 color11 color12 color13 color14 color15 ];

  home-manager = {
    useGlobalPkgs = false; # Use the global pkgs instead of home-manager.users.<name>.nixpkgs
    useUserPackages = false; # Install to /etc/profiles instead of ~/.nix-profile
    users.jdf = { config, pkgs, lib, ... }: {
      nixpkgs.config = {
        allowUnfree = true;
        packageOverrides = pkgs: {
          nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") { inherit pkgs; }; # Nix User Repository
          nixos-2003 = import (builtins.fetchTarball "https://github.com/nixos/nixpkgs-channels/archive/nixos-20.03.tar.gz") { };
          unstable = import (builtins.fetchTarball "https://github.com/nixos/nixpkgs-channels/archive/nixpkgs-unstable.tar.gz") { };
          master = import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/master.tar.gz") { };
        };
        permittedInsecurePackages = [ "p7zip-16.02" ];
      };
      news.display = "silent";
      programs.beets.enable = true;
      programs.beets.settings = {
        directory = "/mnt/hdd0/Music/"; # Todo, fix this directory for other hosts
        library = "/mnt/hdd0/Music/.beets_library.db"; # Todo, fix this directory for other hosts
        # Plugins may have dependencies, here's a list for refrence:
        # badfiles: mp3val flac
        # beatport: python37Packages.requests python37Packages.requests_oauthlib
        # chroma: chromaprint python37Packages.pyacoustid
        # discogs: python37Packages.discogs_client
        # fetchart: python37Packages.requests
        # lastgenre: python37Packages.pylast
        # lyrics: python37Packages.beautifulsoup4 python37Packages.langdetect python37Packages.requests
        plugins = "acousticbrainz badfiles chroma discogs fetchart ftintitle lastgenre lyrics missing scrub";
        import = {
          move = true;
          bell = true;
        };
        discogs = { user_token = "${secrets.apiKey.discogs}"; };
        lyrics = { google_API_key = "${secrets.apiKey.googleBeets}"; };
        original_date = true;
      };
      programs.firefox = {
        enable = true; # Whether to enable Firefox
        package = with pkgs; firefox-bin; # If state version ≥ 19.09 then this should be wrapped
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
            "browser.startup.homepage" =
              "https://www.startpage.com/do/mypage.pl?prfh=enable_stay_controlEEE0N1NsuggestionsEEE1N1Ngeo_mapEEE1N1Nwikipedia_iaEEE1N1Nother_iaEEE1N1Ndisable_open_in_new_windowEEE0N1Ndisable_video_family_filterEEE1N1Nenable_post_methodEEE1N1Nenable_proxy_safety_suggestEEE0N1Ndisable_family_filterEEE1N1Nconnect_to_serverEEEusN1NsslEEE1N1Nlanguage_uiEEEenglishN1NlanguageEEEenglishN1Nwt_unitEEEfahrenheitN1Nnum_of_resultsEEE20N1Nlang_homepageEEEs/nite/en/";
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
      programs.mpv.config = {
        deinterlace = "yes";
        dscale = "mitchell"; # This filter is very good at downscaling
        fullscreen = "yes";
        hwdec = "auto-safe";
        hwdec-codecs = "all";
        interpolation = "yes";
        msg-level = "vo=fatal"; # Prevent harmless warnings/errors when using hardware decoding
        audio-display = "no"; # No album art
        scale = "ewa_lanczossharp"; # If your hardware can run it, this is probably what you should use by default.
        scaler-resizes-only = "yes"; # Disable the scaler if the video image is not resized.
        tscale = "oversample"; # This filter is good at temporal interpolation
        video-sync = "display-vdrop"; # Drop or repeat video frames to compensate desyncing video.
        vo = "gpu"; # Enable hardware acceleration.
        ytdl-format = "bestvideo[height<=?720][fps<=?30][vcodec!=?vp9]+bestaudio/best";
      };
      programs.mpv.enable = true;
      programs.rofi.enable = true;
      programs.vscode.enable = true;
      programs.vscode.package = with pkgs; vscodium;
      programs.vscode.userSettings = {
        "editor.accessibilitySupport" = "off";
        "editor.cursorStyle" = "underline-thin";
        "editor.fontFamily" = "'Cascadia Code', Consolas, 'Courier New', monospace";
        "editor.fontLigatures" = true;
        "editor.fontSize" = 12;
        "extensions.showRecommendationsOnlyOnDemand" = true;
        "nixfmt.path" = "${pkgs.nixfmt}/bin/nixfmt -w 200";
        "terminal.integrated.shell.linux" = "${pkgs.zsh}/bin/zsh";
        "update.mode" = "none";
        "update.showReleaseNotes" = false;
        "wal.tokenColorTheme" = "Default Dark+";
        "workbench.colorTheme" = "Wal";
        "[nix]"."editor.tabSize" = 2;
      };
      programs.zsh.autocd = true;
      programs.zsh.defaultKeymap = "viins";
      programs.zsh.dotDir = ".config/zsh";
      programs.zsh.enable = true;
      programs.zsh.enableAutosuggestions = true;
      programs.zsh.envExtra = "";
      programs.zsh.history = { };
      programs.zsh.history.expireDuplicatesFirst = true;
      programs.zsh.history.extended = true;
      programs.zsh.history.ignoreDups = true;
      programs.zsh.history.ignoreSpace = true;
      programs.zsh.history.path = "${config.xdg.dataHome}/zsh/zsh_history";
      programs.zsh.history.save = 10000;
      programs.zsh.history.share = true;
      programs.zsh.history.size = 10000;
      programs.zsh.initExtra = "";
      programs.zsh.initExtraBeforeCompInit = "";
      programs.zsh.localVariables = { };
      programs.zsh.loginExtra = "";
      programs.zsh.logoutExtra = "";
      programs.zsh.oh-my-zsh = { };
      programs.zsh.oh-my-zsh.enable = true;
      programs.zsh.oh-my-zsh.custom = "";
      programs.zsh.oh-my-zsh.plugins = [ ];
      programs.zsh.oh-my-zsh.theme = "";
      programs.zsh.plugins = [
        {
          name = "zsh-autosuggestions";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-autosuggestions";
            rev = "v0.6.4";
            sha256 = "0h52p2waggzfshvy1wvhj4hf06fmzd44bv6j18k3l9rcx6aixzn6";
          };
        }
        {
          name = "enhancd";
          file = "init.sh";
          src = pkgs.fetchFromGitHub {
            owner = "b4b4r07";
            repo = "enhancd";
            rev = "v2.2.4";
            sha256 = "1smskx9vkx78yhwspjq2c5r5swh9fc5xxa40ib4753f00wk4dwpp";
          };
        }
      ];
      programs.zsh.profileExtra = "unsetopt share_history";
      programs.zsh.sessionVariables = { PATH = "$PATH:$HOME/.local/bin"; };
      programs.zsh.shellAliases = {
        "castget" = "castget --rcfile=/home/jdf/.config/castget --progress-bar --verbose";
        "synonym" = "() { ${pkgs.wordnet}/bin/wn $* -simsv | less }";
        ".." = "cd ..";
      };

      gtk.enable = true;
      gtk.gtk3.extraConfig = { gtk-application-prefer-dark-theme = "1"; };

      home = {
        activation = {
          flatpakActivation = ''
            echo [Flatpak] Start...
            ${pkgs.flatpak}/bin/flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
            ${pkgs.flatpak}/bin/flatpak install --user --noninteractive -y flathub ${toString flathubApps}
            ${pkgs.flatpak}/bin/flatpak update --user -y
            echo [Flatpak] Done.
          '';
          xdgActivation = ''
            ${pkgs.xdg-user-dirs}/bin/xdg-user-dirs-update
          '';
        };
        file = {
          # ~/
          # ~/.config/
          castget = {
            target = ".config/castget";
            text = ''
              # Global
              [*]
              filename=%(channel_title)-%(date)-%(title).mp3
              id3contenttype=Podcast
              playlist=/home/jdf/podcasts.m3u
              spool=/home/jdf/.cache/podcasts

              # Chris Fisher
              [chrislascast]
              url=https://chrislas.com/cast?format=rss
              [unfilter]
              url=https://unfilter.show/rss
              [worklifeandrv]
              url=http://worklifeandrv.com/episodes?format=rss

              # Jupiter Broadcasting
              [jupiterextras]
              url=https://extras.show/rss
              [linuxheadlines]
              url=https://linuxheadlines.show/rss
              [linuxunplugged]
              url=https://linuxunplugged.com/rss
              [selfhosted]
              url=https://selfhosted.show/rss
              [techsnap]
              url=https://techsnap.systems/rss

              # Other
              [lundukejournal]
              url=http://vault.lunduke.com/LundukeShowMP3.xml
            '';
          };
          # ~/.local/bin
          discord_runner = {
            executable = true;
            target = ".local/bin/discord_run";
            text = "${pkgs.flatpak}/bin/flatpak run com.discordapp.Discord --ignore-certificate-errors"; # Needed to work around certificate bug.
          };
          steam_bp = { # Steam Big Picture
            executable = true;
            target = ".local/bin/steam_bp";
            text = "${pkgs.steam}/bin/steam -console -silent -tenfoot";
          };
          steam_dev = { # Steam Skin Development
            executable = true;
            target = ".local/bin/steam_dev";
            text = "${pkgs.steam}/bin/steam -console -silent -developer";
          };
          steam_fixbeta = { # Steam Clear Beta
            executable = true;
            target = ".local/bin/steam_fixbeta";
            text = "${pkgs.steam}/bin/steam -console -silent -clearbeta";
          };
          steam_heavy = { # Steam
            executable = true;
            target = ".local/bin/steam_heavy";
            text = "${pkgs.steam}/bin/steam -console -silent";
          };
          steam_light = { # Steam No Browser
            executable = true;
            target = ".local/bin/steam_light";
            text = "${pkgs.steam}/bin/steam -console -silent -no-browser -compact";
          };
          steamgrid_runner = {
            executable = true;
            target = ".local/bin/steamgrid_run";
            text =
              "${pkgs.nur.repos.joshuafern.steamgrid}/bin/steamgrid -igdb ${secrets.apiKey.igdb} -steamgriddb ${secrets.apiKey.steamgriddb} -types animated,static -styles alternate,blurred,white_logo,material";
          };
          ytcc_autoplay = {
            executable = true;
            target = ".local/bin/ytcc_autoplay";
            text = "${pkgs.ytcc}/bin/ytcc -y";
          };
        };
        packages = with pkgs; [
          # applications/audio
          cava # C - Console-based Audio Visualizer for Alsa
          cmus # C - Small, fast and powerful console music player for Linux and *BSD
          fluidsynth # C - Real-time software synthesizer based on the SoundFont 2 specifications
          mikmod # C - Tracker music player for the terminal
          moc # C - An ncurses console audio player designed to be powerful and easy to use
          mpg123 # C - Fast console MPEG Audio Player and decoder library
          pianobar # C - A console front-end for Pandora.com
          schismtracker # C - Music tracker application, free reimplementation of Impulse Tracker
          vorbis-tools # C - Extra tools for Ogg-Vorbis audio codec

          # applications/editors
          aseprite-unfree # Animated sprite editor & pixel art tool

          # applications/graphics
          dia # C - Gnome Diagram drawing software
          imv # C - Simple X11/Wayland Image Viewer
          inkscape # C++ - Vector graphics editor
          waifu2x-converter-cpp # C++ - Improved fork of Waifu2X C++ using OpenCL and OpenCV

          # applications/misc
          calcurse # C - A calendar and scheduling application for the command line
          cheat # Go - Create and view interactive cheatsheets on the command-line
          glava # C - OpenGL audio spectrum visualizer
          lutris # Python - Open Source gaming platform for GNU/Linux
          mako # C - A lightweight Wayland notification daemon
          minder # Vala - Mind-mapping application for Elementary OS
          mps-youtube # Python - Terminal based YouTube player and downloader
          mupdf # C - Lightweight PDF, XPS, and E-book viewer and toolkit written in portable C
          nnn # C - Small ncurses-based file browser forked from noice
          sc-im # C - SC-IM - Spreadsheet Calculator Improvised - SC fork
          slmenu # C - A console dmenu-like tool
          styx # Haskell - Nix based static site generator
          tdrop # Shell - A Glorified WM-Independent Dropdown Creator
          wtf # Go - The personal information dashboard for your terminal
          xst # C - Simple terminal fork that can load config from Xresources
          zathura # C - A highly customizable and functional PDF viewer

          # applications/networking
          hydroxide # Go - A third-party, open-source ProtonMail bridge
          mumble # C++ - Low-latency, high quality voice chat software

          # applications/networking/browsers
          brave # JavaScript - Privacy-oriented browser for Desktop and Laptop computers
          elinks # C - Full-featured text-mode web browser
          links2 # C - A small browser with some graphics support
          lynx # C - A text-mode web browser
          surf # C - A simple web browser based on WebKit/GTK
          tor-browser-bundle-bin # Mixed - Tor Browser Bundle built by torproject.org
          vimb # C - A Vim-like browser
          w3m # C - A text-mode web browser

          # applications/networking/instant-messengers
          weechat # C - A fast, light and extensible chat client

          # applications/networking/mailreaders
          alpine # C - Console mail reader
          mutt-with-sidebar # C - A small but very powerful text-based mail client

          # applications/networking/p2p
          qbittorrent # C++ - Featureful free software BitTorrent client
          transmission-remote-cli # Python - Curses interface for the Transmission BitTorrent daemon

          # applications/networking/remote
          freerdp # C - A Remote Desktop Protocol Client

          # applications/office
          libreoffice-fresh # Comprehensive, professional-quality productivity suite, a variant of openoffice.org
          wordgrinder # C - Text-based word processor

          # applications/radio
          aldo # C++ - Morse code training program
          unixcw # C - Sound characters as Morse code on the soundcard or console speaker

          # applications/version-management
          gitAndTools.gitFull # C - Distributed version control system
          mercurialFull # C -  A fast, lightweight SCM system for very large distributed projects

          # applications/video
          streamlink # Python - CLI for extracting streams from various websites to video player of your choosing

          # applications/virtualization
          looking-glass-client # C - A KVM Frame Relay (KVMFR) implementation

          # build-support
          appimage-run
          iconConvTools # Tools for icon conversion specific to nix package manager
          nix-template-rpm # Create templates of nix expressions from RPM .spec files
          steam-run-native

          # build-support/rust
          carnix # Rust -
          toml2nix

          # data/icons
          hicolor-icon-theme # Default fallback theme used by implementations of the icon theme specification

          # data/misc
          nixos-icons

          # data/soundfonts
          soundfont-fluid # Frank Wen's pro-quality GM/GS soundfont

          # desktops/enlightenment
          enlightenment.terminology # C - Powerful terminal emulator based on EFL

          # desktops/gnome3
          gnome3.adwaita-icon-theme
          gnome-themes-extra

          # development/compilers
          egg2nix # Scheme - Generate nix-expression from CHICKEN scheme eggs
          crystal2nix # Utility to convert Crystal's shard.lock files to a Nix file
          go # Go - The Go Programming language
          mono # C# - Cross platform, open source .NET development framework

          # development/haskell-modules
          haskellPackages.arion-compose # Run docker-compose with help from Nix/NixOS
          #haskellPackages.autonix-deps # Library for Nix expression dependency generation
          #haskellPackages.autonix-deps-kf5 # Generate dependencies for KDE 5 Nix expressions
          #haskellPackages.bricks # Bricks is a lazy functional language based on Nix
          haskellPackages.cabal2nix # Convert Cabal files into Nix build instructions
          haskellPackages.cachix # Command line client for Nix binary cache hosting https://cachix.org
          #haskellPackages.dhall-nix # Dhall to Nix compiler
          haskellPackages.distribution-nixpkgs # Types and functions to manipulate the Nixpkgs distribution
          haskellPackages.elm2nix # Turn your Elm project into buildable Nix project
          #haskellPackages.funflow-nix # Utility functions for using funflow with nix
          #haskellPackages.haskell-overridez # Manage nix overrides for haskell packages
          #haskellPackages.hnix # Haskell implementation of the Nix language
          #haskellPackages.hnix-store-core # Core effects for interacting with the Nix store
          #haskellPackages.hnix-store-remote # Remote hnix store
          #haskellPackages.hocker # Interact with the docker registry and generate nix build instructions
          #haskellPackages.jenkinsPlugins2nix # Generate nix for Jenkins plugins
          haskellPackages.language-nix # Data types and functions to represent the Nix language
          haskellPackages.libnix # Bindings to the nix package manager
          haskellPackages.niv # Easy dependency management for Nix projects
          #haskellPackages.nix-delegate # Convenient utility for distributed Nix builds
          #haskellPackages.nix-deploy # Deploy Nix-built software to a NixOS machine
          haskellPackages.nix-derivation # Parse and render *.drv files
          haskellPackages.nix-diff # Explain why two Nix derivations differ
          #haskellPackages.nix-eval # Evaluate Haskell expressions using Nix to get packages
          #haskellPackages.nix-freeze-tree # Convert a tree of files into fixed-output derivations
          haskellPackages.nix-paths # Knowledge of Nix's installation directories
          #haskellPackages.nix-tools # cabal/stack to nix translation tools
          haskellPackages.nixfmt # An opinionated formatter for Nix
          #haskellPackages.nixfromnpm # Generate nix expressions from npm packages
          #haskellPackages.nixpkgs-update # Tool for semi-automatic updating of nixpkgs repository
          haskellPackages.ShellCheck # Shell script analysis tool
          #haskellPackages.simple-nix # Simple parsing/pretty printing for Nix expressions
          #haskellPackages.stack2nix # Convert stack.yaml files into Nix build instructions
          #haskellPackages.stackage2nix # Convert Stack files into Nix build instructions
          #haskellPackages.waddle # DOOM WAD file utilities

          # development/interpreters
          luajit # C - High-performance JIT compiler for Lua 5.1
          python2Full # A high-level dynamically-typed programming language
          python3Full # A high-level dynamically-typed programming language

          # development/libraries
          chromaprint # C++ - AcoustID audio fingerprinting library
          libnotify # C - A library that sends desktop notifications to a notification daemon
          nix-plugins # Collection of miscellaneous plugins for the nix expression language

          # development/misc
          loc # Rust - Count lines of code quickly

          # development/mobile
          abootimg # C - Manipulate Android Boot Images
          imgpatchtools # C++ - Tools to manipulate Android OTA archives

          # development/python-modules
          python38Packages.nix-prefetch-github # Prefetch sources from github
          python27Packages.nixpart # NixOS storage manager/partitioner
          python37Packages.nixpkgs-pytools # Tools for removing the tedious nature of creating nixpkgs derivations
          python38Packages.pywal # Generate and change colorschemes on the fly. A 'wal' rewrite in Python 3.
          python38Packages.speedtest-cli # Command line interface for testing internet bandwidth using speedtest.net
          python38Packages.ueberzug # An alternative for w3mimgdisplay
          python38Packages.virtualenvwrapper # Enhancements to virtualenv

          # development/r-modules
          rPackages.internetarchive # R

          # development/ruby-modules
          bundix # Ruby - Creates Nix packages from Gemfiles

          # development/tools
          apktool # Java - A tool for reverse engineering Android apk files
          dep2nix # Go - Convert `Gopkg.lock` files from golang dep into `deps.nix`
          flatpak-builder # C - Tool to build flatpaks from source
          go2nix # Go - Go apps packaging for Nix
          pkgconf # C - Package compiler and linker metadata toolkit
          pypi2nix # Python - Generate Nix expressions for Python packages
          rnix-lsp # Rust - A work-in-progress language server for Nix, with syntax checking and basic completion
          solarus-quest-editor # C++ - The editor for the Zelda-like ARPG game engine, Solarus
          vgo2nix # Go - Convert go.mod files to nixpkgs buildGoPackage compatible deps.nix files
          yarn2nix # Nix - Generate nix expressions from a yarn.lock file

          # development/tools/analysis
          #nix-linter # Linter for Nix(pkgs), based on hnix

          # development/tools/java
          visualvm # Java - A visual interface for viewing information about Java applications

          # development/tools/misc
          bin_replace_string # Edit precompiled binaries
          #hydra # Nix-based continuous build system
          kodi-cli # Bash - Kodi/XBMC bash script to send Kodi commands using JSON RPC. It also allows sending YouTube videos to Kodi
          luajitPackages.luarocks-nix # Lua - A package manager for Lua
          nixbang # Python - A special shebang to run scripts in a nix-shell
          strace # C - A system call tracer for Linux

          # games
          _2048-in-terminal # C - Animated console version of the 2048 game
          azimuth # C - A metroidvania game using only vectorial graphic
          banner # C - Print large banners to ASCII terminals
          braincurses # C++ - A version of the classic game Mastermind
          cataclysm-dda # C++ - A free, post apocalyptic, zombie infested rogue-like
          #devilutionx # C++ - Diablo build for modern operating systems
          dwarf-fortress # C++ - A single-player fantasy game with a randomly generated adventure world
          EmptyEpsilon # Lua - Open source bridge simulator based on Artemis
          freeciv_gtk # C - Multiplayer (or single player), turn-based strategy game
          freedroidrpg # C - Isometric 3D RPG similar to game Diablo
          freesweep # C - A console minesweeper-style game written in C for Unix-like systems
          hyperrogue # C++ - A roguelike game set in hyperbolic geometry
          icbm3d # C - 3D vector-based clone of the atari game Missile Command
          lgogdownloader # C++ - Unofficial downloader to GOG.com for Linux users. It uses the same API as the official GOGDownloader
          liberal-crime-squad # C++ - A humorous politically themed ncurses game
          minetest # C++ - Infinite-world block sandbox game
          multimc # C++ - A free, open source launcher for Minecraft
          nudoku # C - An ncurses based sudoku game
          openra # C# - Open-source re-implementation of Westwood Studios' 2D Command and Conquer games
          openspades # C++ - A compatible client of Ace of Spades 0.75
          openttd # C++ - Open source clone of the Microprose game "Transport Tycoon Deluxe"
          rogue # C - The final version of the original Rogue game developed for the UNIX operating system
          scummvm # C++ - Program to run certain classic graphical point-and-click adventure games (such as Monkey Island)
          solarus # C++ - A Zelda-like ARPG game engine
          steam # A digital distribution platform
          steamcmd # Steam command-line tools
          vectoroids # C - Clone of the classic arcade game Asteroids by Atari
          vitetris # C - Terminal-based Tetris clone by Victor Nilsson
          vkquake # C - Vulkan Quake port based on QuakeSpasm
          xonotic # C - A free fast-paced first-person shooter
          zeroad # C++ - A free, open-source game of ancient warfare

          # maintainers/scripts
          nix-generate-from-cpan # Utility to generate a Nix expression for a Perl package from CPAN
          nixpkgs-lint # A utility for Nixpkgs contributors to check Nixpkgs for common errors

          # misc
          documentation-highlighter # Highlight.js sources for the Nix Ecosystem's documentation.
          scrcpy # C - Display and control Android devices over USB or TCP/IP

          # misc/emulators
          ataripp # C++ - An enhanced, cycle-accurated Atari emulator
          atari800 # C - An Atari 8-bit emulator
          attract-mode # C++ - A frontend for arcade cabinets and media PCs
          blastem # C - The fast and accurate Genesis emulator
          caprice32 # C++ - A complete emulation of CPC464, CPC664 and CPC6128
          desmume # C++ - An open-source Nintendo DS emulator
          dolphinEmuMaster # C++ - Gamecube/Wii/Triforce emulator for x86_64 and ARMv8
          emulationstation # C++ - A flexible emulator front-end supporting keyboardless navigation and custom system themes
          fceux # C++ - A Nintendo Entertainment System (NES) Emulator
          fsuae # C++ - An accurate, customizable Amiga Emulator
          fuse-emulator # C - ZX Spectrum emulator
          hatari # C - Atari ST/STE/TT/Falcon emulator
          higan # C++ - An open-source, cycle-accurate Nintendo multi-system emulator
          mame # C++ - Is a multi-purpose emulation framework
          mednafen # C++ A portable, CLI-driven, SDL+OpenGL-based, multi-system emulator
          mednaffe # C - GTK-based frontend for mednafen emulator
          mgba # C - A modern GBA emulator with a focus on accuracy
          mupen64plus # C - A Nintendo 64 Emulator
          nestopia # C++ - NES emulator with a focus on accuracy
          openmsx # C++ - A MSX emulator
          pcsx2 # C++ - Playstation 2 emulator
          pcsxr # C - Playstation 1 emulator
          ppsspp # C++ - A PSP emulator for Android, Windows, Mac and Linux, written in C++
          retrofe # A frontend for arcade cabinets and media PCs
          rpcs3 # C++ - PS3 emulator/debugger
          snes9x-gtk # C++ - Super Nintendo Entertainment System (SNES) emulator
          stella # C++ - An open-source Atari 2600 VCS emulator
          uae # C++ - Ultimate/Unix/Unusable Amiga Emulator
          vbam # C++ - A merge of the original Visual Boy Advance forks
          vice # C - Commodore 64, 128 and other emulators
          winePackages.fonts # Data - Microsoft replacement fonts by the Wine project
          winePackages.staging # C - An Open Source implementation of the Windows API on top of X, OpenGL, and Unix
          winetricks # Shell - A script to install DLLs needed to work around problems in Wine
          wxmupen64plus # C++ GUI for the Mupen64Plus 2.0 emulato
          xcpc # C - A portable Amstrad CPC 464/664/6128 emulator written in C
          yabause # C - An open-source Sega Saturn emulator
          zsnes # Asm/C - A Super Nintendo Entertainment System Emulator

          # misc/themes
          adwaita-qt # C++ A style to bend Qt applications to look like they belong into GNOME Shell

          # misc/vim-plugins
          vimPlugins.vim-nix

          # os-specific/linux
          hdparm # A tool to get/set ATA/SATA drive parameters under Linux
          kexectools # Tools related to the kexec Linux feature
          libratbag # Configuration library for gaming mice
          psmisc # A set of small useful utilities that use the proc filesystem (such as fuser, killall and pstree)
          unstick # Silently eats chmod commands forbidden by Nix

          # servers/http
          nix-binary-cache # A set of scripts to serve the Nix store as a binary cache

          # servers/x11
          xorg.xcursorthemes
          xorg.transset
          xorg.xev
          xorg.xinit

          # shells
          dash # A POSIX-compliant implementation of /bin/sh that aims to be as small as possible
          ksh # KornShell Command And Programming Language
          mksh # MirBSD Korn Shell
          rc # The Plan 9 shell

          # tools/archivers
          p7zip # A port of the 7-zip archiver
          unzip # An extraction utility for archives compressed in .zip format
          zip # Compressor/archiver for creating and modifying zipfiles

          # tools/audio
          pulsemixer # Cli and curses mixer for pulseaudio

          # tools/compression
          zsync # File distribution system using the rsync algorithm

          # tools/filesystems
          boxfs # FUSE file system for box.com accounts
          gitfs # A FUSE filesystem that fully integrates with git
          httpfs2 # HTTPFS2, a FUSE-based HTTP file system for Linux
          mergerfs # A FUSE based union filesystem
          smbnetfs # A FUSE FS for mounting Samba shares
          sshfs # FUSE-based filesystem that allows remote filesystems to be mounted over SSH
          vmfs-tools # FUSE-based VMFS (vmware) file system tools
          wdfs # User-space filesystem that allows to mount a webdav share

          # tools/graphics
          grim # Grab images from a Wayland compositor
          scrot # A command-line screen capture utility

          # tools/misc
          abduco # Allows programs to be run independently from its controlling terminal
          bc # GNU software calculator
          byobu # Text-based window manager and terminal multiplexer
          cloc # A program that counts lines of source code
          dvtm # Dynamic virtual terminal manager
          entr # Run arbitrary commands when files change
          file # A program that shows the type of files
          lorri # Your project's nix-env
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

          # tools/nix
          nix-info
          nix-query-tree-viewer # GTK viewer for the output of `nix store --query --tree`
          nix-script # A shebang for running inside nix-shell.
          nix-store-gcs-proxy # A HTTP nix store that proxies requests to Google Storage
          nixdoc # Generate documentation for Nix functions
          nixos-generators # Collection of image builders
          nixpkgs-fmt # Nix code formatter for nixpkgs

          # tools/package-management
          appimagekit # A tool to package desktop applications as AppImages
          morph # Morph is a NixOS host manager written in Golang.
          niff # A program that compares two Nix expressions and determines which attributes changed
          nix # Powerful package manager that makes package management reliable and reproducible
          nix-bundle # Create bundles from Nixpkgs attributes
          #nix-du # A tool to determine which gc-roots take space in your nix store
          nix-index # A files database for nixpkgs
          nix-pin # nixpkgs development utility
          nix-prefetch # Prefetch any fetcher function call, e.g. package sources
          nix-prefetch-scripts # Collection of all the nix-prefetch-* scripts which may be used to obtain source hashes
          nix-serve # A utility for sharing a Nix store as a binary cache
          nix-top # Tracks what nix is building
          nix-universal-prefetch # Uses nixpkgs fetchers to figure out hashes
          nix-update-source # Utility to automate updating of nix derivation sources
          nixops # NixOS cloud provisioning and deployment tool
          nixops-dns # DNS server for resolving NixOps machines
          nixpkgs-review # Review pull-requests on https://github.com/NixOS/nixpkgs
          nixui # NodeWebkit user interface for Nix
          nox # Tools to make nix nicer to use
          protontricks # A simple wrapper for running Winetricks commands for Proton-enabled games

          # tools/package-management/disnix
          disnix # A Nix-based distributed service deployment tool
          disnixos # Provides complementary NixOS infrastructure deployment to Disnix
          DisnixWebService # A SOAP interface and client for Disnix
          dysnomia # Automated deployment of mutable components and services for Disnix

          # tools/security
          bitwarden # A secure and free password manager for all of your devices
          bitwarden-cli # A secure and free password manager for all of your devices.
          mkpasswd # Overfeatured front-end to crypt, from the Debian whois package
          vulnix # NixOS vulnerability scanner

          # tools/system
          htop # An interactive process viewer for Linux
          hwinfo # Hardware detection tool from openSUSE
          nq # Unix command line queue utility
          nvtop # A (h)top like like task monitor for NVIDIA GPUs
          pciutils # A collection of programs for inspecting and manipulating configuration of PCI devices
          plan9port # Plan 9 from User Space
          stress-ng # Stress test a computer system

          # tools/wayland
          ydotool # Generic Linux command-line automation tool

          # tools/x11
          xdg-user-dirs # A tool to help manage well known user directories like the desktop folder and the music folder
          xdg_utils # A set of command line tools that assist applications with a variety of desktop integration tasks
          xdotool # Fake keyboard/mouse input, window management, and more
          xkbvalidate # NixOS tool to validate X keyboard configuration

          # nur.repos.joshuafern
          nur.repos.joshuafern.citra # C++ - An open-source emulator for the Nintendo 3DS
          nur.repos.joshuafern.dosbox-staging # C++ - A modernized DOS emulator
          nur.repos.joshuafern.libspeedhack # C++ - A simple dynamic library to slowdown or speedup applications
          #nur.repos.joshuafern.minigalaxy # Python - A simple GOG client for Linux
          nur.repos.joshuafern.oblige # C++ - A random level generator for classic FPS games
          nur.repos.joshuafern.qdl # C - Qualcomm Download
          nur.repos.joshuafern.samrewritten # Allows you to unlock and relock your Steam achievements
          #nur.repos.joshuafern.sbase # C - suckless unix tools
          nur.repos.joshuafern.steamgrid # Go - Downloads images to fill your Steam grid view
          #nur.repos.joshuafern.ubase # C - suckless linux base utils
          nur.repos.joshuafern.vban # C - A simple audio over UDP protocol proposed by VB-Audio
          nur.repos.joshuafern.vkbasalt # C++ - A Vulkan post processing layer to enhance the visual graphics of games
          #nur.repos.joshuafern.yuzu # C++ - An experimental Nintendo Switch emulator

          # The NixOS package search is missing the expression path, so I'm not categorizing these new packages right now.
          blackbox # Safely store secrets in a VCS repo
          castget # A simple, command-line based RSS enclosure downloader
          cht-sh # CLI client for cheat.sh, a community driven cheat sheet
          chocolateDoom
          crispyDoom
          dhewm3
          python37Packages.discogs_client
          doom-bcc
          doomseeker
          enyo-doom
          eternity
          eureka-editor
          flac
          gimp-with-plugins
          gnome3.evolution
          #gnucash
          gzdoom
          homebank
          innoextract
          lgogdownloader # Unofficial downloader to GOG.com for Linux users. It uses the same API as the official GOGDownloader
          lm_sensors
          loadwatch
          qiv # Quick image viewer
          mp3val
          mythes
          gnome3.nautilus
          neomutt
          nyx
          odamex
          oneko # Creates a cute cat chasing around your mouse cursor
          openclonk # Free multiplayer action game in which you control clonks, small but witty and nimble humanoid beings
          opendungeons # An open source, real time strategy game sharing game elements with the Dungeon Keeper series and Evil Genius.
          python37Packages.pyacoustid
          python37Packages.pylast
          python37Packages.requests
          python37Packages.requests_oauthlib
          qgnomeplatform
          slade
          thunderbird
          translate-shell
          tree # Command to produce a depth indented directory listing
          wordnet # Ruby - Lexical database for the English language
          zandronum # Multiplayer oriented port, based off Skulltag, for Doom and Doom II by id Software
          zandronum-server # Multiplayer oriented port, based off Skulltag, for Doom and Doom II by id Software
          zdbsp # ZDoom's internal node builder for DOOM maps
          #zdoom # Enhanced port of the official DOOM source code
        ];
        sessionVariables = {
          # Defaults
          BROWSER = "${pkgs.firefox-bin}/bin/firefox";
          EDITOR = "${pkgs.vim}/bin/vim";
          READER = "${pkgs.zathura}/bin/zathura";
          TERMINAL = "${pkgs.xst}/bin/xst";
          #VISUAL = "nano";
          # Program Settings
          # Dotnet
          DOTNET_SYSTEM_GLOBALIZATION_INVARIANT = "true"; # Prevent common dotnet error
          # Java
          _JAVA_AWT_WM_NONREPARENTING = 1;
          # less
          LESSHISTFILE = "-";
          # nnn
          NNN_PLUG = "s:suedit;w:wall";
          # QT
          QT_QPA_PLATFORMTHEME = "qt5ct";
          # WINE
          WINEDEBUG = "-all"; # Increase Performance with WINE
        };
        stateVersion = "20.09";
      };

      qt.enable = true;
      qt.platformTheme = "gnome";

      services.dunst.enable = true;
      services.picom.enable = true;
      services.picom.experimentalBackends = true;
      services.picom.extraOptions = ''
        invert-color-include = [
            "class_g = 'JDownloader'"
        ];
      '';
      services.redshift.enable = true;
      services.redshift.provider = "geoclue2";
      services.screen-locker.enable = true;
      services.screen-locker.inactiveInterval = 60;
      services.screen-locker.lockCmd = "${pkgs.slock}/bin/slock";
      services.unclutter.enable = true;

      xdg.enable = true;

      xsession = {
        enable = true;
        initExtra = ''
          # TODO: Hardware Dependent
          ${pkgs.libratbag}/bin/ratbagctl 'Logitech Gaming Mouse G600' profile 0 button 00 action set button 1 # Left Click
          ${pkgs.libratbag}/bin/ratbagctl 'Logitech Gaming Mouse G600' profile 0 button 01 action set button 2 # Right Click
          ${pkgs.libratbag}/bin/ratbagctl 'Logitech Gaming Mouse G600' profile 0 button 02 action set button 3 # Middle Click
          ${pkgs.libratbag}/bin/ratbagctl 'Logitech Gaming Mouse G600' profile 0 button 03 action set button 4 # MWheel Left
          ${pkgs.libratbag}/bin/ratbagctl 'Logitech Gaming Mouse G600' profile 0 button 04 action set button 5 # MWheel Right
          ${pkgs.libratbag}/bin/ratbagctl 'Logitech Gaming Mouse G600' profile 0 button 05 action set macro KEY_F13 # Ring Click
          ${pkgs.libratbag}/bin/ratbagctl 'Logitech Gaming Mouse G600' profile 0 button 06 action set macro +KEY_LEFTSHIFT KEY_RESERVED -KEY_LEFTSHIFT #G07
          ${pkgs.libratbag}/bin/ratbagctl 'Logitech Gaming Mouse G600' profile 0 button 07 action set macro +KEY_LEFTMETA KEY_RESERVED -KEY_LEFTMETA #G08
          ${pkgs.libratbag}/bin/ratbagctl 'Logitech Gaming Mouse G600' profile 0 button 08 action set macro KEY_1 #G09
          ${pkgs.libratbag}/bin/ratbagctl 'Logitech Gaming Mouse G600' profile 0 button 09 action set macro KEY_2 #G10
          ${pkgs.libratbag}/bin/ratbagctl 'Logitech Gaming Mouse G600' profile 0 button 10 action set macro KEY_3 #G11
          ${pkgs.libratbag}/bin/ratbagctl 'Logitech Gaming Mouse G600' profile 0 button 11 action set macro KEY_4 #G12
          ${pkgs.libratbag}/bin/ratbagctl 'Logitech Gaming Mouse G600' profile 0 button 12 action set macro KEY_5 #G13
          ${pkgs.libratbag}/bin/ratbagctl 'Logitech Gaming Mouse G600' profile 0 button 13 action set macro KEY_6 #G14
          ${pkgs.libratbag}/bin/ratbagctl 'Logitech Gaming Mouse G600' profile 0 button 14 action set macro KEY_7 #G15
          ${pkgs.libratbag}/bin/ratbagctl 'Logitech Gaming Mouse G600' profile 0 button 15 action set macro KEY_8 #G16
          ${pkgs.libratbag}/bin/ratbagctl 'Logitech Gaming Mouse G600' profile 0 button 16 action set macro KEY_9 #G17
          ${pkgs.libratbag}/bin/ratbagctl 'Logitech Gaming Mouse G600' profile 0 button 17 action set macro KEY_0 #G18
          ${pkgs.libratbag}/bin/ratbagctl 'Logitech Gaming Mouse G600' profile 0 button 18 action set macro KEY_MINUS #G19
          ${pkgs.libratbag}/bin/ratbagctl 'Logitech Gaming Mouse G600' profile 0 button 19 action set macro KEY_EQUAL #G20
          ${pkgs.libratbag}/bin/ratbagctl 'Logitech Gaming Mouse G600' profile 0 dpi set 400
          ${pkgs.libratbag}/bin/ratbagctl 'Logitech Gaming Mouse G600' profile 0 led 0 set color 00ff00
          ${pkgs.libratbag}/bin/ratbagctl 'Logitech Gaming Mouse G600' profile 0 led 0 set mode on
          ${pkgs.libratbag}/bin/ratbagctl 'Logitech Gaming Mouse G600' profile 0 rate set 1000
          ${pkgs.libratbag}/bin/ratbagctl 'Logitech Gaming Mouse G600' profile active set 0
          ${pkgs.xorg.xset}/bin/xset m 0 0
        '';
        pointerCursor.name = "capitaine-cursors";
        pointerCursor.package = with pkgs; capitaine-cursors;
        windowManager.i3.enable = true;
        windowManager.i3.config = {
          #assigns = "4" = [{ class = "mpv"; }];
          colors.background = "$bg";
          colors.focused = {
            background = "$bg";
            border = "$bg";
            childBorder = "$bg";
            indicator = "$bg";
            text = "$fg";
          };
          colors.focusedInactive = {
            background = "$bg";
            border = "$bg";
            childBorder = "$bg";
            indicator = "$bg";
            text = "$fg";
          };
          colors.unfocused = {
            background = "$bg";
            border = "$bg";
            childBorder = "$bg";
            indicator = "$bg";
            text = "$fg";
          };
          colors.urgent = {
            background = "$bg";
            border = "$bg";
            childBorder = "$bg";
            indicator = "$bg";
            text = "$fg";
          };
          colors.placeholder = {
            background = "$bg";
            border = "$bg";
            childBorder = "$bg";
            indicator = "$bg";
            text = "$fg";
          };
          keybindings = lib.mkOptionDefault {
            #"${modifier}+d" = "exec dmenu_run -nb $bg -nf $fg -sb $fg -sf $bg";
          };
          keycodebindings = lib.mkOptionDefault {
            "Mod4+22" = "exec kill -9 `ps -ef | egrep '.exe'|awk '{print $2}'`"; # Backspace: Kill WINE
            "Mod4+110" = "exec echo 1.0 > /tmp/speedhack_pipe"; # HOME: Speedhack Reset
            "Mod4+117" = "exec echo $(echo $(tail -1 /tmp/speedhack_log | sed 's/[^0-9.]*//g')-0.1 | bc -l) > /tmp/speedhack_pipe"; # PGDOWN: Speedhack Decrease
            "Mod4+112" = "exec echo $(echo $(tail -1 /tmp/speedhack_log | sed 's/[^0-9.]*//g')+0.1 | bc -l) > /tmp/speedhack_pipe"; # PGUP: Speedhack Increase
            #"191" = "exec amixer -c2 cset numid=11 on"; # F13: Push-to-talk on
            #"--release 191" = "exec amixer -c2 cset numid=11 off"; # F13 (Release): Push-to-talk off
          };
          menu = "PATH=$PATH:~/.local/bin ${pkgs.dmenu}/bin/dmenu_run";
          modifier = "Mod4"; # Windows-key modifier
          terminal = "${pkgs.xst}/bin/xst -e ${pkgs.zsh}/bin/zsh"; # Start xst terminal with zsh shell
          window.titlebar = false;
        };
        #windowManager.i3.enable = true;
        windowManager.i3.extraConfig = ''
          set_from_resource $fg i3wm.color7 #f0f0f0
          set_from_resource $bg i3wm.color2 #f0f0f0
        '';
        windowManager.i3.package = with pkgs; i3-gaps;
        #windowManager.xmonad.enable = true;
        windowManager.xmonad.enableContribAndExtras = true;
        windowManager.xmonad.config = pkgs.writeText "xmonad.hs" ''
          import XMonad
          import XMonad.Hooks.DynamicLog

          main = xmonad =<< statusBar myBar myPP toggleStrutsKey myConfig

          myBar = "${pkgs.haskellPackages.xmobar}/bin/xmobar"

          myPP = xmobarPP { ppCurrent = xmobarColor "#429942" "" . wrap "<" ">" }

          toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)

          myConfig = defaultConfig
                { terminal    = "${pkgs.xst}/bin/xst -e ${pkgs.zsh}/bin/zsh"
                , modMask     = mod4Mask
                , borderWidth = 1
                }

        '';
        windowManager.xmonad.extraPackages = pk: with pk; [ xmobar ];
      };
    };
  };

  users.users.jdf = {
    createHome = true;
    description = "Joshua Fern";
    extraGroups = [
      "adbusers"
      "adm"
      "audio"
      "containers"
      "docker"
      "fuse"
      "games"
      "input"
      "jackaudio"
      "kvm"
      "lp"
      "libvirtd"
      "netdev"
      "networkmanager"
      "plugdev"
      "scanner"
      "sudo"
      "sys"
      "tty"
      "uucp"
      "vboxusers"
      "video"
      "wheel"
    ];
    hashedPassword = secrets.accountPassword.jdf;
    home = "/home/jdf";
    isNormalUser = true;
    shell = with pkgs; dash; # Every application started with dmenu is forked from this shell, I'm using dash for performance and memory reasons. Not intended for interactive use.
    uid = 1000;
  };
}

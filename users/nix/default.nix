{ pkgs, ... }:
let secrets = import ../secrets.nix;
in
{
  users.users.nix = {
    createHome = true;
    description = "nix";
    extraGroups = [ "adbusers" "adm" "audio" "containers" "docker" "fuse" "games" "input" "jackaudio" "kvm" "lp" "libvirtd" "netdev" "networkmanager" "plugdev" "scanner" "sudo" "sys" "tty" "uucp" "vboxusers" "video" "wheel" ];
    hashedPassword = secrets.accountPassword.nix;
    home = "/home/nix";
    isNormalUser = true;
    packages = with pkgs; [
     # applications/graphics
     dia # Gnome Diagram drawing software
     sxiv # Simple X Image Viewer
     waifu2x-converter-cpp # Improved fork of Waifu2X C++ using OpenCL and OpenCV
     # applications/misc
     dunst # Lightweight and customizable notification daemon
     mako # A lightweight Wayland notification daemon
     mps-youtube # Terminal based YouTube player and downloader
     mupdf # Lightweight PDF, XPS, and E-book viewer and toolkit written in portable C
     netsurf.browser # Free opensource web browser
     nnn # Small ncurses-based file browser forked from noice
     noice # Small ncurses-based file browser
     ranger # File manager with minimalistic curses interface
     roxterm # Tabbed, VTE-based terminal emulator
     rtv # Browse Reddit from your Terminal
     rxvt_unicode-with-plugins # A clone of the well-known terminal emulator rxvt
     sakura # A terminal emulator based on GTK and VTE
     slmenu # A console dmenu-like tool
     tdrop # A Glorified WM-Independent Dropdown Creator
     treesheets # Free Form Data Organizer
     vym # Mind-mapping software
     zathura # A highly customizable and functional PDF viewer
     # applications/networking
     flent
     pjsip # A multimedia communication library written in C, implementing standard based protocols such as SIP, SDP, RTP, STUN, TURN, and ICE
     # applications/networking/browsers
     dillo # A fast graphical web browser with a small footprint
     elinks # Full-featured text-mode web browser
     firefox # A web browser built from Firefox source tree
     links2 # A small browser with some graphics support
     lynx # A text-mode web browser
     surf # A simple web browser based on WebKit/GTK+
     w3m # A text-mode web browser
     # applications/networking/instant-messengers
     #bitlbee # IRC instant messaging gateway
     #centerim # Fork of CenterICQ, a curses instant messaging program
     #chatterino2 # A chat client for Twitch chat
     #mcabber # Small Jabber console client
     #ratox # FIFO based tox client
     #utox # Lightweight Tox client
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
     mpv # A media player that supports many video formats (MPlayer and mplayer2 fork)
     streamlink # CLI for extracting streams from various websites to video player of your choosing
     # applications/virtualization
     looking-glass-client # A KVM Frame Relay (KVMFR) implementation
     # build-support
     appimage-run
     # data/icons
     bibata-cursors # Material Based Cursor
     hicolor-icon-theme # Default fallback theme used by implementations of the icon theme specification
     # desktops/gnome3
     gnome3.adwaita-icon-theme
     gnome-themes-extra
     # desktops/lxde
     lxappearance-gtk3 # A lightweight program for configuring the theme and fonts of gtk applications
     # desktops/mate
     mate.caja-with-extensions # File manager for the MATE desktop
     mate.engrampa # Archive Manager for MATE
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
     # shells
     powershell # Cross-platform (Windows, Linux, and macOS) automation and configuration tool/framework
     # tools/audio
     pulsemixer # Cli and curses mixer for pulseaudio
     # tools/misc
     youtube-dl # Command-line tool to download videos from YouTube.com and other sites
     # tools/networking
     ytcc # Command Line tool to keep track of your favourite YouTube channels without signing up for a Google account
     # tools/security
     #keybase-gui # The Keybase official GUI
    ];
    shell = with pkgs; dash; # When dmenu launches applications they're forked from this shell. Dash is used here for speed and memory reasons.
    uid = 1000;
  };
} 

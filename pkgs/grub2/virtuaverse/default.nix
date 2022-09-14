{ lib, stdenv, fetchFromGitHub }:
let src = fetchFromGitHub {
    owner = "Patato777";
    repo = "dotfiles";
    rev = "e496309ff006d0fe4fca286aaa2ea8ed7222b88a";
    sha256 = "1IXMPDA1XoyyojDmueJ0JY6ve0xICYH0iF4UM4DJsek=";
  };
in
stdenv.mkDerivation {
  inherit src;

  name = "grub2-theme-virtuaverse";

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/
    cp -r $src/grub/themes/virtuaverse/* $out
  '';

  meta = with lib; {
    description = "grub2 theme Virtuverse";
    homepage = "https://github.com/Patato777/dotfiles";
  };
}

{ config, pkgs, ... }:

# define basic rofi configs here
let
  rofiThemes = pkgs.fetchFromGitHub {
    owner = "aleksanaa";
    repo = "rofi-themes-collection";
    rev = "30a1a63df15d52c18d3d467a8831f1631498070c";
    sha256 = "sha256-G2kBtD1EDVK1eLgEUdVFu6+SRx2lm7oZtzisDstYqSo=";
  };
in
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    terminal = "${pkgs.foot}/bin/foot";
    theme = "${rofiThemes}/themes/rounded-nord-dark.rasi";
    plugins = with pkgs; [ rofi-emoji ];
    extraConfig = {
      modi = "run,drun,emoji";
      font = "Noto Sans CJK SC Regular 10";
      show-icons = false;
    };
  };
}

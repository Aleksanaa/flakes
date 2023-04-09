{ config, pkgs, ... }:

# allow easily keybindings in desktop env
let
  rofiFinal = config.programs.rofi.finalPackage;
in
{
  home.packages = [
    (
      pkgs.writeShellScriptBin "rofi-launcher" ''
        ${rofiFinal}/bin/rofi -show drun -show-icons
      ''
    )
    (
      pkgs.writeShellScriptBin "rofi-runner" ''
        ${rofiFinal}/bin/rofi -show run
      ''
    )
    (
      pkgs.writeShellScriptBin "rofi-emoji" ''
        ${rofiFinal}/bin/rofi -show emoji
      ''
    )
    (
      pkgs.writeShellScriptBin "rofi-powermenu" ''
        ${rofiFinal}/bin/rofi -show p -modi p:${pkgs.rofi-power-menu}/bin/rofi-power-menu
      ''
    )
  ];
}

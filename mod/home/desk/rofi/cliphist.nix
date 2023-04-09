{ config, pkgs, ... }:

let
  rofi = config.programs.rofi.finalPackage;
  home = config.home.homeDirectory;
  clipChooser = pkgs.writeShellScript "clipchooser" ''
    if [[ -n $@ ]]; then
      if [[ $@ == "Clear clipboard" ]]; then
        rm -r ${home}/.cache/cliphist/db
      else
        echo $@ | ${pkgs.cliphist}/bin/cliphist decode | ${pkgs.wl-clipboard}/bin/wl-copy
        exit
      fi
    fi
    echo "Clear clipboard"
    ${pkgs.cliphist}/bin/cliphist list
  '';
  rofi-clipboard = pkgs.writeShellScriptBin "rofi-clipboard" ''
    ${rofi}/bin/rofi -show clipboard -modes "clipboard:${clipChooser}"
  '';
in
{
  home.packages = [ rofi-clipboard ];
}

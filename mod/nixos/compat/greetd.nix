{ pkgs, lib, ... }:

let
  greetdUserName = "greeter";
  # xdg-desktop-portal starts too early,
  # causing gtkgreet (all gtk programs) launches very slowly
  launchPortals = pkgs.writeShellScript "launchPortals" ''
    sleep 2
    killall xdg-desktop-portal-hyprland
    killall xdg-desktop-portal
    dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
    ${pkgs.xdg-desktop-portal-hyprland}/libexec/xdg-desktop-portal-hyprland &
    sleep 2
    ${pkgs.xdg-desktop-portal}/libexec/xdg-desktop-portal &
    ${pkgs.hyprland}/bin/hyprctl setcursor Adwaita 24
    export GTK_THEME=Colloid-Dark-Nord
    export XCURSOR_SIZE=24
    ${pkgs.greetd.gtkgreet}/bin/gtkgreet -l -c ${pkgs.hyprland}/bin/Hyprland; exit
  '';
  # /tmp/hypr will be created with the owner root. 
  # This will prevent hyprland start after login
  hyprConfig = pkgs.writeText "greetd-hypr-config" ''
    monitor=,preferred,auto,1.25
    input {
      follow_mouse = 1
    }
    exec-once = chmod 777 /tmp/hypr
    exec-once = ${launchPortals} >> /tmp/greetd-logs
  '';
in
{
  programs.hyprland.enable = true;
  services.greetd = {
    enable = true;
    vt = 1;
    settings.default_session = {
      command = "${pkgs.hyprland}/bin/Hyprland --config ${hyprConfig}";
      user = "${greetdUserName}";
    };
  };
  users.users."${greetdUserName}".packages = with pkgs; [
    colloid-gtk-theme
    gnome.adwaita-icon-theme
  ];
}

{ pkgs, lib, selfLib, ... }:

let
  inherit (selfLib.home.mkHyprConf) mkHyprlandVariables mkHyprlandBinds mkNumBinds;
  hyprlandVariables = mkHyprlandVariables {
    input = {
      touchpad = {
        disable_while_typing = false;
        natural_scroll = true;
      };
    };
    general = {
      gaps_in = 5;
      gaps_out = 10;
      border_size = 3;
      "col.active_border" = "rgba(88c0d0ee)";
      "col.inactive_border" = "rgba(2e3440aa)";
      layout = "dwindle";
    };
    decoration = {
      rounding = 8;
      blur_size = 5;
      dim_inactive = true;
      dim_strength = 0.1;
    };
    dwindle = {
      pseudotile = true;
    };
    gestures = {
      workspace_swipe = true;
      workspace_swipe_distance = 200;
    };
    misc = {
      focus_on_activate = true;
    };
  };
  hyprlandBinds = mkHyprlandBinds {
    monitor = {
      eDP-1 = "2240x1400,0x0,1.25";
      DP-2 = "3840x2160,2240x0,1.5";
    };
    animation = {
      global = "1,4,default";
    };
    bind = {
      "SUPER,C" = "killactive";
      "SUPER,V" = "togglefloating";
      "SUPER,Q" = "exec,foot";
      "SUPER,E" = "exec,nemo";
      "SUPER,R" = "exec,rofi-launcher";
      "SUPER,T" = "exec,rofi-runner";
      "SUPER,F" = "exec,rofi-emoji";
      "SUPER,X" = "exec,rofi-clipboard";
      "SUPER,M" = "exec,rofi-powermenu";
      ",XF86MonBrightnessUp" = "exec,${pkgs.brightnessctl}/bin/brightnessctl set 5%+";
      ",XF86MonBrightnessDown" = "exec,${pkgs.brightnessctl}/bin/brightnessctl set 5%-";
      ",XF86AudioRaiseVolume" = "exec,${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%";
      ",XF86AudioLowerVolume" = "exec,${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%";
      ",XF86AudioMute" = "exec,${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
      "SUPER,print" = "exec, grimblast --notify copysave active";
      ",print" = "exec, grimblast --notify copysave output";
      "SHIFT,print" = "exec, grimblast --notify copysave area";
    };
    bindm = {
      "SUPER,mouse:272" = "movewindow";
      "SUPER SHIFT,mouse272" = "resizewindow";
    };
    windowrule = [
      "float, ^(xfce-polkit)$"
      "float, class:^(nemo)$, title:^(.*)( Properties)$"
    ];
    exec-once = [
      "systemctl --user import-environment XDG_SESSION_ID DBUS_SESSION_BUS_ADDRESS"
      "hyprctl setcursor Adwaita 24"
      "${pkgs.xorg.xprop}/bin/xprop -root -f _XWAYLAND_GLOBAL_OUTPUT_SCALE 32c -set _XWAYLAND_GLOBAL_OUTPUT_SCALE 2"
      "rm -r /run/user/1000/gnupg/S.gpg-agent"
    ];
  };
  hyprlandWorkspaces = mkHyprlandBinds {
    bind = (mkNumBinds "SUPER," ",workspace,") ++ (mkNumBinds "SUPER SHIFT," ",movetoworkspace,");
  };
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    systemdIntegration = true;
    extraConfig =
  };
}

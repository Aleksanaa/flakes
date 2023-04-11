{ config, lib, pkgs, selfLib, ... }:

{
  systemd.user.services.waybar = selfLib.home.mkAutoStart {
    Desc = "Waybar keepalive service";
    Service = {
      ExecStart = "${pkgs.waybar}/bin/waybar";
      Restart = "on-failure";
    };
  };
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
    settings = {
      mainbar = {
        layer = "top";
        spacing = 6;
        margin = "0";
        ipc = true;
        fixed-center = true;

        modules-left = [
          "custom/menu"
          "wlr/workspaces"
          "cpu"
          "memory"
          "temperature"
          "custom/caffeine"
          "custom/playing"
        ];
        modules-center = [
          "clock"
          "custom/notification"
          "tray"
        ];
        modules-right = [
          "backlight"
          "pulseaudio"
          "network"
          "battery"
          "custom/powerprofiles"
        ];

        "custom/menu" = {
          format = "";
          tooltip = false;
          on-click = pkgs.writeShellScript "rofilauncher" ''
            ${config.programs.rofi.finalPackage}/bin/rofi -show drun -show-icons &
          '';
        };

        "wlr/workspaces" = {
          format = "{}";
          on-click = "activate";
          "all-outputs" = false;
        };

        "cpu" = {
          interval = 5;
          format = " {usage}%";
        };

        "memory" = {
          interval = 10;
          format = " {used:0.1f}G/{total:0.1f}G";
        };

        "temperature" = {
          interval = 5;
          hwmon-path = "/sys/class/hwmon/hwmon2/temp1_input";
          format = " {temperatureC}°C";
        };

        "custom/caffeine" = {
          exec = pkgs.writeShellScript "getnolock" ''
            while : ; do
              ${pkgs.systemd}/bin/systemctl is-active xautolock-session --user --quiet && echo '(´_ゝ`)' || echo '(•_ゝ•)'
              ${pkgs.coreutils-full}/bin/sleep 0.2
            done
          '';
          on-click = pkgs.writeShellScript "setnolock" ''
            if ${pkgs.systemd}/bin/systemctl is-active xautolock-session --user --quiet; then
              ${pkgs.systemd}/bin/systemctl stop xautolock-session --user
            else
              ${pkgs.systemd}/bin/systemctl start xautolock-session --user
            fi
          '';
          exec-on-event = true;
        };

        "custom/playing" = {
          exec = pkgs.writeShellScript "getplaying" ''
            ${pkgs.playerctl}/bin/playerctl metadata --follow --format '{{ status }} {{ trunc(title,8) }} | {{ trunc(artist,8) }}' | ${pkgs.gnused}/bin/sed -u 's/Playing//;s/Paused//;s/ | $//'
          '';
          on-click = pkgs.writeShellScript "switch" ''
            ${pkgs.playerctl}/bin/playerctl play-pause;
          '';
          on-scroll-up = pkgs.writeShellScript "scrollup" ''
            ${pkgs.playerctl}/bin/playerctl position 5-
          '';
          on-scroll-down = pkgs.writeShellScript "scrollup" ''
            ${pkgs.playerctl}/bin/playerctl position 5+
          '';
        };

        "clock" = {
          interval = 60;
          align = 0;
          rotate = 0;
          tooltip-format = "<big>{:%B %Y}</big>\n<tt><big>{calendar}</big></tt>";
          format = " {:%H:%M}";
          format-alt = " {:%a %b %d, %G}";
        };

        "custom/notification" = {
          tooltip = false;
          format = "{icon}";
          format-icons = {
            notification = " ";
            none = "";
            dnd-notification = " ";
            dnd-none = "";
          };
          return-type = "json";
          exec = pkgs.writeShellScript "execSwayNC" ''
            ${pkgs.swaynotificationcenter}/bin/swaync-client -swb
          '';
          on-click = pkgs.writeShellScript "toggleSwayNC" ''
            ${pkgs.swaynotificationcenter}/bin/swaync-client -op &
          '';
          on-click-right = pkgs.writeShellScript "dndSwayNC" ''
            if [[ $(${pkgs.swaynotificationcenter}/bin/swaync-client --get-dnd) == true ]]; then
              ${pkgs.swaynotificationcenter}/bin/swaync-client --dnd-off
            else
              ${pkgs.swaynotificationcenter}/bin/swaync-client --dnd-on
            fi
          '';
          escape = true;
        };

        "tray" = {
          icon-size = 16;
          spacing = 10;
        };

        "backlight" = {
          interval = 2;
          align = 0;
          rotate = 0;
          format = "{icon} {percent}%";
          format-icons = [ "" "" "" "" ];
          on-scroll-up = pkgs.writeShellScript "brightnessup" ''
            ${pkgs.brightnessctl}/bin/brightnessctl set 5%+
          '';
          on-scroll-down = pkgs.writeShellScript "brightnessdown" ''
            ${pkgs.brightnessctl}/bin/brightnessctl set 5%-
          '';
          smooth-scrolling-threshold = 1;
        };

        "pulseaudio" = {
          format = "{icon} {volume}%";
          format-muted = " Mute";
          format-bluetooth = " {volume}% {format_source}";
          format-bluetooth-muted = " Mute";
          format-source = " {volume}%";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [ "" "" "" ];
          };
          scroll-step = 5;
          on-click = "${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
          on-double-click-right = pkgs.writeShellScript "switchoutput" ''
            CURRENT_SINK="$(${pkgs.pulseaudio}/bin/pactl get-default-sink)"
            SINK_REGEX='^[[:digit:]]*[[:blank:]]([^ [:blank:]]*)[[:blank:]]'
            SETNEXT=0
            FIRST=""
            RESULT=""
            while read -r line; do
              if [[ "''${line}" =~ ''${SINK_REGEX} ]]; then
                current="''${BASH_REMATCH[1]}"
                if [[ "''${current}" =~ ''${CURRENT_SINK} ]]; then
                  SETNEXT=1
                elif [[ -z "''${FIRST}" ]]; then
                  FIRST="''${current}"
                elif [[ "''${SETNEXT}" == 1 ]]; then
                  RESULT="''${current}"
                fi
              fi
            done <<<"$(${pkgs.pulseaudio}/bin/pactl list short sinks)"
            if [[ -z "''${RESULT}" ]]; then
              RESULT="''${FIRST}"
            fi
            ${pkgs.pulseaudio}/bin/pactl set-default-sink "''${RESULT}"
          '';
          smooth-scrolling-threshold = 1;
        };

        "network" = {
          interval = 5;
          format-disconnected = "睊 Disconnected";
          format-disabled = "睊 Disabled";
          format = " {bandwidthUpBits} |  {bandwidthDownBits}";
          tooltip-format = " {ifname} via {gwaddr}";
        };

        "battery" = {
          interval = 15;
          full-at = 100;
          design-capacity = false;
          states = {
            good = 95;
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-plugged = " {capacity}%";
          format-full = "{icon} Full";
          format-alt = "{icon} {time}";
          format-icons = [ "" "" "" "" "" ];
          format-time = "{H}h {M}min";
          tooltip = true;
        };

        "custom/powerprofiles" = {
          interval = 5;
          exec = pkgs.writeShellScript "getpowerstat" ''
            ${pkgs.power-profiles-daemon}/bin/powerprofilesctl get
          '';
          on-scroll-up = pkgs.writeShellScript "switchpowerstat" ''
            UNSELECTED='^(.*)\:$'
            SELECTED='^\*[[:blank:]].*:$'
            SETNEXT=0
            RESULT=""
            FIRST=""
            while read -r line; do
              if [[ "''${line}" =~ ''${SELECTED} ]]; then
                SETNEXT=1
              elif [[ "''${line}" =~ ''${UNSELECTED} ]]; then
                if [ "''${SETNEXT}" == 1 ]; then
                  RESULT="''${BASH_REMATCH[1]}"
                  break
                elif [[ -z "''${FIRST}" ]]; then
                  FIRST="''${BASH_REMATCH[1]}"
                fi
              fi
            done <<<"$(${pkgs.power-profiles-daemon}/bin/powerprofilesctl list)"
            if [[ -z "''${RESULT}" && -n "''${FIRST}" ]]; then
              RESULT="''${FIRST}"
            fi
            ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set "''${RESULT}"
          '';
          smooth-scrolling-threshold = 10;
          exec-on-event = true;
          format = "𝆑 {}";
        };
      };
    };
    style = ''
      *{font-weight:700;font-size:12px;font-family:Noto Sans CJK SC,sans-serif}
      window#waybar{border-bottom:2px solid #313244;background-color:#1e1e2e;color:#1e1e2e;opacity:.8;transition-duration:.5s;transition-property:color}
      window#waybar.hidden{opacity:.5}
      #backlight{color:#cba6f7}
      #battery{color:#f9e2af}
      #clock{color:#a6e3a1}
      #cpu{color:#89dceb}
      #memory{color:#eba0ac}
      #temperature{color:#9ab48e}
      #tray{color:#383838}
      #tray>.passive{-gtk-icon-effect:dim}
      #pulseaudio{color:#fab387}
      #pulseaudio.bluetooth{color:#f5c2e7}
      #pulseaudio.muted{color:#313244;color:#cdd6f4}
      #network{color:#8fbcbb}
      #network.disabled,#network.disconnected{color:#cdd6f4}
      #custom-caffeine,#custom-menu,#custom-notification,#custom-playing,#custom-powerprofiles,#custom-updater,#custom-weather{margin:6px 0;padding:2px 8px;border-radius:8px;background-color:#2e3440}
      #custom-menu{margin-left:6px;padding:2px 6px;color:#f5c2e7;font-size:16px}
      #custom-powerprofiles{color:#e6ed7b}
      #custom-playing{color:#f5c2e7}
      #custom-notification{color:#e3e4a6}
      #custom-caffeine{color:#c3e276}
      #workspaces button.active{background-color:#363840}
      #backlight,#battery,#clock,#cpu,#memory,#mode,#mpd,#network,#pulseaudio,#temperature,#tray{margin:6px 0;padding:2px 8px;border-radius:8px;background-color:#2e3440}
    '';
  };
}

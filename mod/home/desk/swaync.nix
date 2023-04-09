{ pkgs, selfLib, ... }:

{
  home.file.".config/swaync/config.json".text = builtins.toJSON {
    "$schema" = "${pkgs.swaynotificationcenter}/etc/xdg/swaync/configSchema.json";
    positionX = "center";
    positionY = "top";
    control-center-margin-top = 0;
    control-center-margin-bottom = 0;
    control-center-margin-right = 0;
    control-center-margin-left = 0;
    notification-icon-size = 64;
    notification-body-image-height = 300;
    notification-body-image-width = 300;     
    timeout = 10;
    timeout-low = 5;
    timeout-critical = 0;
    fit-to-screen = false;
    control-center-width = 500;
    control-center-height = 600;
    notification-window-width = 400;
    notification-window-height = 400;
    keyboard-shortcuts = true;
    image-visibility = "when-available";
    transition-time = 200;
    hide-on-clear = false;
    hide-on-action = true;
    script-fail-notify = true;
    widgets = [ "title" "dnd" "notifications" ];
    widget-config = {
      title = {
        text = "Notifications";
        clear-all-button = true;
        button-text = "Clear All";
      };
      dnd = {
        text = "Do Not Disturb";
      };
      label = {
        max-lines = 5;
        text = "Label Text";
      };
      mpris = {
        image-size = 96;
        image-radius = 12;
      };
    };
  };
  home.file.".config/swaync/style.css".text = ''
    @define-color cc-bg rgb(40, 44, 52);@define-color control-border-color rgb(138, 173, 255);@define-color noti-border-color rgb(255, 255, 255);@define-color noti-bg rgb(44, 49, 61);@define-color noti-bg-hover rgb(58, 64, 75);@define-color noti-bg-focus rgba(58, 64, 75, 0.6);@define-color noti-close-bg rgba(255, 255, 255, 0.1);@define-color noti-close-bg-hover rgba(255, 255, 255, 0.15);@define-color bg-selected rgb(0, 128, 255);.notification-row{outline:0}
    .notification-row:focus,.notification-row:hover{background:@noti-bg-focus}
    .notification{margin:6px 12px;padding:0;border-width:2px;border-radius:8px;box-shadow:none}
    .critical{border-radius:12px;background:red;background:0 0}
    .close-button{margin-top:10px;margin-right:16px;padding:0;min-width:24px;min-height:24px;border:none;border-radius:100%;background:@noti-close-bg;box-shadow:none;color:#fff;text-shadow:none}
    .close-button:hover{border:none;background:@noti-close-bg-hover;box-shadow:none;transition:all .15s ease-in-out}
    .notification-action,.notification-default-action{margin:0;padding:4px;border:1px solid @noti-border-color;background:@noti-bg;box-shadow:none;color:#fff}
    .notification-action:hover,.notification-default-action:hover{background:@noti-bg-hover;-gtk-icon-effect:none}
    .notification-default-action{border-radius:12px}
    .notification-default-action:not(:only-child){border-bottom-right-radius:0;border-bottom-left-radius:0}
    .notification-action{border-top:none;border-right:none;border-radius:0}
    .notification-action:first-child{border-bottom-left-radius:10px}
    .notification-action:last-child{border-right:1px solid @noti-border-color;border-bottom-right-radius:10px}
    .body-image{margin-top:6px;border-radius:12px;background-color:#fff}
    .summary,.time{background:0 0;color:#fff;text-shadow:none;font-weight:700;font-size:16px}
    .time{margin-right:112px}
    .body{background:0 0;font-weight:400;font-size:15px}
    .body,.top-action-title{color:#fff;text-shadow:none}
    .control-center{border:2px solid @control-border-color;border-radius:12px;background:@cc-bg}
    .control-center-list,.floating-notifications{background:0 0}
    .blank-window{background:alpha(#000,.25)}
    .widget-title{margin:12px;font-size:1.5rem}
    .widget-title>button{border:1px solid @noti-border-color;border-radius:12px;background:@noti-bg;box-shadow:none;color:#fff;text-shadow:none;font-size:medium}
    .widget-title>button:hover{background:@noti-bg-hover}
    .widget-dnd{margin:12px;font-size:1.1rem}
    .widget-dnd>switch{border:1px solid @noti-border-color;border-radius:12px;background:@noti-bg;box-shadow:none;font-size:medium}
    .widget-dnd>switch:checked{background:@bg-selected}
    .widget-dnd>switch slider{border-radius:12px;background:@noti-bg-hover}
    .widget-label{margin:12px}
    .widget-label>label{font-size:1.1rem}
    .widget-mpris-player{margin:12px;padding:12px}
    .widget-mpris-title{font-weight:700;font-size:1.25rem}
    .widget-mpris-subtitle{font-size:1.1rem}  
  '';
  home.packages = [ pkgs.swaynotificationcenter ];
  systemd.user.services.swaync = selfLib.home.mkAutoStart {
    Description = "Sway notification center service";
    Service = {
      ExecStart = "${pkgs.swaynotificationcenter}/bin/swaync";
      Restart = "always";
    };
  };
}

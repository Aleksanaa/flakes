{ pkgs, ... }:

# systemctl --user import-environment XDG_SESSION_ID

let
  fakeXautolock = pkgs.writeShellScriptBin "xautolock" ''
    while [[ -n $1 ]] ;do
      case $1 in
      -time)
        TIMEOUT=$((60*$2))
        shift 2
        ;;
      -locker)
        LOCKER=$2
        shift 2
        ;;
      *)
        shift
        ;;
      esac
    done
    ${pkgs.swayidle}/bin/swayidle -w timeout "$TIMEOUT" "${pkgs.systemd}/bin/systemctl suspend"
  '';
in
{
  services.screen-locker = {
    enable = true;
    inactiveInterval = 5;
    lockCmd = "${pkgs.gtklock}/bin/gtklock";
    xautolock = {
      enable = true;
      package = fakeXautolock;
    };
  };
}

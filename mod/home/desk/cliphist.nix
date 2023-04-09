{ pkgs, selfLib, ... }:

let
  clipScript = pkgs.writeShellScript "clipscript" ''
    ${pkgs.wl-clipboard}/bin/wl-paste --watch ${pkgs.cliphist}/bin/cliphist store
  '';
in
{
  systemd.user.services.cliphist = selfLib.home.mkAutoStart {
    Description = "Cliphist clipboard store";
    Service = {
      ExecStart = "${clipScript}";
      Restart = "always";
    };
  };
}

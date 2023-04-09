{ selfPkgs, selfLib, ... }:

{
  home.packages = [ selfPkgs.swww ];
  systemd.user.services.swww = selfLib.home.mkAutoStart {
    Description = "Swww background service";
    Service = {
      ExecStart = "${selfPkgs.swww}/bin/swww init --no-daemon";
      ExecStartPost = "${selfPkgs.swww}/bin/swww img .local/share/background";
      Restart = "on-failure";
    };
  };
}

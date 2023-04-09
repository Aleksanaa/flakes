{ config, pkgs, selfLib, ... }:

# Set default gnome-keyring daemon and helper
{
  home.packages = [ pkgs.gnome.seahorse ];
  systemd.user.services.gnome-keyring = selfLib.home.mkAutoStart {
    Desc = "GNOME Keyring daemon process";
    Service = {
      ExecStartPre = "${pkgs.dbus}/bin/dbus-update-activation-environment --systemd DISPLAY";
      ExecStart = "${pkgs.gnome.gnome-keyring}/bin/gnome-keyring-daemon --start --foreground --components=pkcs11,secrets,ssh,gpg";
      Restart = "on-abort";
    };
  }
  home.sessionVariables = { SSH_AUTH_SOCK = "/run/user/1000/keyring/ssh"; };
  # All pinentries provided are shit
  services.gpg-agent.pinentryFlavor = null;
}

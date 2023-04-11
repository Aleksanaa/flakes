{ pkgs, lib, selfPkgs, selfLib, ... }:

let
  inherit (selfLib.home) mkNemoAction;
  changeWallpaper = pkgs.writeShellScript "changewallpaper" ''
    cp "$1" $HOME/.local/share/background
    ${selfPkgs.swww}/bin/swww img $HOME/.local/share/background --transition-type center
  '';
in
{
  home.packages = with pkgs.cinnamon; [ nemo-with-extensions ];
  dconf.settings = {
    "org/nemo/preferences/menu-config" = {
      background-menu-open-as-root = false;
      background-menu-open-in-terminal = false;
      selection-menu-open-as-root = false;
      selection-menu-open-in-terminal = false;
    };
    "org/nemo/preferences" = {
      executable-text-activation = "display";
      show-open-in-terminal-toolbar = false;
      thumbnail-limit = 10485760;
    };
  };
  home.file = lib.mkMerge [
    (mkNemoAction {
      fileName = "open_in_foot";
      action = {
        Name = "Open In Foot";
        Comment = "Open the foot terminal in the selected folder";
        Exec = "${pkgs.foot}/bin/foot --working-directory=%F";
        Icon-Name = "utilities-terminal-symbolic";
        Selection = "any";
        Extensions = "dir;";
      };
    })
    (mkNemoAction {
      fileName = "set_as_wallpaper";
      action = {
        Name = "Set As Wallpaper";
        Comment = "Set the chosen file as wallpaper";
        Exec = "${changeWallpaper} %F";
        Icon-Name = "preferences-desktop-wallpaper-symbolic";
        Selection = "single";
        Mimetypes = [
          "image/jpeg"
          "image/png"
          "image/tiff"
          "image/bmp"
        ];
      };
    })
    (mkNemoAction {
      fileName = "mount_archive";
      action = {
        Name = "Mount Archive";
        Comment = "Mount the archive as filesystems";
        Exec = "${pkgs.gvfs}/libexec/gvfsd-archive file=%F";
        Icon-Name = "gtk-cdrom";
        Selection = "single";
        Mimetypes = [
          "application/x-cd-image"
          "application/x-cpio"
        ];
      };
    })
    (mkNemoAction {
      fileName = "share_via_valent";
      action = {
        Name = "Share via Valent";
        Comment = "Share file with valent connect";
        Exec = "${pkgs.glib.bin}/bin/gapplication launch ca.andyholmes.Valent %F";
        Icon-Name = "phone";
        Selection = "multiple";
        Extensions = "nodirs";
      };
    })
  ];
}

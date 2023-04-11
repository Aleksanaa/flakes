{ config, userName, ... }:

let
  homeDir = config.home.homeDirectory;
in
{
  # Enable default XDG directories
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    extraConfig.XDG_SCREENSHOTS_DIR = "${homeDir}/Pictures/Screenshots";
  };
  # Add xdg directories bookmarks in supported file managers
  gtk.gtk3.bookmarks = let
    bookmarks = [
      "Documents"
      "Downloads"
      "Pictures"
      "Music"
      "Public"
      "Videos"
      "Templates"
      "works"
      "kdeconnect"
      "NixConfigs"
    ];
  in builtins.map (dir: "file://${homeDir}/${dir}") bookmarks;
}

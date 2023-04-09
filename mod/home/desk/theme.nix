{ pkgs, ... }:

let
  cursorConfig = {
    package = pkgs.gnome.adwaita-icon-theme;
    name = "Adwaita";
    size = 24;
  };
in
{
  home = {
    pointerCursor = cursorConfig;
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];
  };
  gtk = {
    enable = true;
    theme = {
      package = pkgs.colloid-gtk-theme;
      name = "Colloid-Dark-Nord";
    };
    iconTheme = {
      package = pkgs.papirus-icon-theme.override {
        color = "blue";
      };
      name = "Papirus-Dark";
    };
    cursorTheme = cursorConfig;
    font = {
      package = pkgs.noto-fonts-cjk-sans;
      name = "Noto Sans CJK SC";
      size = 10;
    };
    gtk3.extraConfig = {
      gtk-button-images = 1;
      gtk-menu-images = 1;
    };
  };
  # force apply gtk4 theme to libadwaita
  # "Don't theme my apps" is shit
  home.file = {
    ".config/gtk-4.0/assets" = {
      source = "${pkgs.colloid-gtk-theme}/share/themes/Colloid-Dark-Nord/gtk-4.0/assets";
      recursive = true;
    };
    ".config/gtk-4.0/gtk.css".source = "${pkgs.colloid-gtk-theme}/share/themes/Colloid-Dark-Nord/gtk-4.0/gtk.css";
    ".config/gtk-4.0/gtk-dark.css".source = "${pkgs.colloid-gtk-theme}/share/themes/Colloid-Dark-Nord/gtk-4.0/gtk-dark.css";
  };
  qt = {
    enable = true;
    platformTheme = "gtk";
  };
  fonts.fontconfig.enable = true;
  dconf.settings = {
    "org/gnome/desktop/wm/preferences".button-layout = "appmenu";
    "org/gnome/desktop/interface".monospace-font-name = "JetBrainsMono Nerd Font 10";
  };
  home.sessionVariables = {
    QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
    XCURSOR_SIZE = 24;
  };
}

{ ... }:

{
  programs.hyfetch = {
    enable = true;
    settings = {
      preset = "transgender";
      mode = "rgb";
      light_dark = "dark";
      lightness = 0.68;
      backend = "fastfetch";
      color_align.mode = "horizontal";
    };
  };
}

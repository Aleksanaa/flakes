{ ... }:

{
  programs.foot = {
    enable = true;
    settings = {
      main = {
        term = "xterm-256color";
        font = "monospace:size=10";
        dpi-aware = "auto";
        initial-window-size-chars = "96x27";
        initial-window-mode = "windowed";
        pad = "15x15";
        resize-delay-ms = "100";
      };
      scrollback = {
        lines=1000;
        multiplier=3.0;
      };
      url.launch = "xdg-open \${url}";
      cursor = {
        style = "beam";
        blink = "yes";
        color = "2e3440 d8dee9";
      };
      mouse = {
        hide-when-typing = "yes";
        alternate-scroll-mode = "yes";
      };
      colors = {
        alpha = "0.93";
        foreground = "d9e0ee";
        background = "1e1e2e";
        regular0 = "3b4252";  # black
        regular1 = "bf616a";  # red
        regular2 = "a3be8c";  # green
        regular3 = "ebcb8b";  # yellow
        regular4 = "81a1c1";  # blue
        regular5 = "b48ead";  # magenta
        regular6 = "88c0d0";  # cyan
        regular7 = "e5e9f0";  # white
        bright0 = "4c566a";   # bright black
        bright1 = "bf616a";   # bright red
        bright2 = "a3be8c";   # bright green
        bright3 = "ebcb8b";   # bright yellow
        bright4 = "81a1c1";   # bright blue
        bright5 = "b48ead";   # bright magenta
        bright6 = "8fbcbb";   # bright cyan
        bright7 = "eceff4";   # bright white
      };
    };
  };
}

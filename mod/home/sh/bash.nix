{ pkgs, ... }:

let
  aleksanaPS1 = pkgs.fetchFromGitHub {
    owner = "Aleksanaa";
    repo = "bash-theme";
    rev = "2d0931cd8dc7f61d769097e8c4674ce8b757ef2a";
    hash = "sha256-5fjMtcn/1DYQT3YFEsbCh6b4SNlc2yEyl74Xm+x6D7o=";
  };
  doas-completion = builtins.fetchurl {
    url = "https://raw.githubusercontent.com/Duncaen/OpenDoas/51f126a9a56cda5a291d5652b0685967133d7b90/doas.completion";
    sha256 = "0lklm6nx3qbg4rlcszp5zsql8x7vzyx37yx92hsy037qflap482a";
  };
in
{
  programs.bash = {
    enable = true;
    bashrcExtra = ''
      export GITSTATUS_PLUGIN_PATH=${pkgs.gitstatus}/share/gitstatus
      source ${aleksanaPS1}/aleksana
      source ${pkgs.blesh}/share/blesh/ble.sh
      source ${doas-completion}
    '';
  };
  home.file.".blerc".text = ''
    bleopt term_true_colors=none
    ble-face -s command_builtin_dot       fg=yellow,bold
    ble-face -s command_builtin           fg=yellow
    ble-face -s filename_directory        underline,fg=magenta
    ble-face -s filename_directory_sticky underline,fg=white,bg=magenta
    ble-face -s command_function          fg=blue
  '';
}

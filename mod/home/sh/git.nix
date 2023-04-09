{ ... }:

{
  programs.git = {
    enable = true;
    userName = "aleksana";
    userEmail = "me@aleksana.moe";
    extraConfig = {
      safe.directory = "/etc/nixos";
    };
  };
  # for nix config
  home.sessionVariables.GIT_DISCOVERY_ACROSS_FILESYSTEM = "1";
}

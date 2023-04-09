{ inputs, ... }:

{
  # enable nix-index-database (nix-locate and command-not-found)
  imports = [ inputs.nix-index-database.hmModules.nix-index ];
  programs.nix-index.enable = true;
}

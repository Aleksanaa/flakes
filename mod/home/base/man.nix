{ pkgs, ... }:

{
  programs.man = {
    enable = true;
    package = pkgs.mandoc;
  };
}

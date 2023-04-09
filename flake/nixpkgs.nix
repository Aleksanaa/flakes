{ config, inputs, lib, getSystem, ... }:

let
  inherit (config.flake.lib.flake.importPackage) customPackages customOverlays;
in
{
  imports = [ inputs.flake-parts.flakeModules.easyOverlay ];
  perSystem = { pkgs, ... }: {
    packages = customPackages { inherit pkgs; dir = ../pkgs; };
    overlayAttrs = customOverlays { inherit pkgs; dir = ../lay; };
  };
  #nixpkgs = {
  #  config.allowUnfree = true;
  #  overlays = [
  #    inputs.hyprland.overlays.default
  #  ];
  #};
}

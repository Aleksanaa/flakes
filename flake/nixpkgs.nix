{ config, inputs, lib, getSystem, ... }:

let
  inherit (config.flake.lib.flake.importPackage) customPackages customOverlays;
in
{
  imports = [ inputs.flake-parts.flakeModules.easyOverlay ];
  perSystem = { pkgs, system, ... }: {
    packages = customPackages { inherit pkgs; dir = ../pkgs; };
    overlayAttrs = customOverlays { inherit pkgs; dir = ../lay; };
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [ inputs.hyprland.overlays.default ];
    };
  };
}

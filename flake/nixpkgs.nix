{ config, inputs, lib, getSystem, ... }:

let
  inherit (config.flake.lib.flake.importPackage) customPackages customOverlays;
in
{
  perSystem = { pkgs, ... }: {
    packages = customPackages { inherit pkgs; dir = ../pkgs; };
    overlayAttrs = customOverlays { inherit pkgs; dir = ../lay; };
  };
}

{ inputs, lib, pkgs, ... }:

# This depends on lanzaboote.
{
  imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];
  boot = {
    loader.systemd-boot.enable = lib.mkForce false;
    initrd.systemd.enable = true;
    bootspec.enable = true;
    lanzaboote = {
      enable = true;
      pkiBundle = "/nix/persist/etc/secureboot";
    };
  };
  environment.systemPackages = [ pkgs.sbctl ];
}

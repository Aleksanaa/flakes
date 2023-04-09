{ config, self, inputs, lib, getSystem, ... }:

let
  userName = "aleksana";
  nixosSpecialArgs = {
    inherit inputs self user;
    inherit (config.flake) nixosModules nixosSuites;
    selfLib = config.flake.lib;
    selfPkgs = config.flake.packages;
  };
  mkHost = {
    name,
    configurationName ? name,
    system,
    extraModules ? [],
  }: {
    ${name} = nixosSystem {
      inherit system;
      inherit ((getSystem system).allModuleArgs) pkgs;
      specialArgs = nixosSpecialArgs;
      modules = (
        commonNixosModules
        ++ extraModules
        ++ lib.optional (configurationName != null) ../nixos/hosts/${configurationName}
        ++ [({lib, ...}: {networking.hostName = lib.mkDefault name;})]
      );
      # keep consistency of nixos-rebuild and colmena,
      # without interfering with the colmena deployment
      extraModules = [colmena.nixosmodules.deploymentoptions];
    };
  };
{
  flake.nixosConfigurations = lib.mkMerge [
    (mkHost {
      name = "Aleksana-Laptop";
      system = "x86_64-linux";
    })
  ]
}

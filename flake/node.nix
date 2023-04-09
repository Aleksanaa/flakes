{ config, inputs, lib, getSystem, ... }:

let
  userName = "aleksana";
  nixosSpecialArgs = {
    inherit inputs userName;
    inherit (config.flake) nixosModules nixosSuites;
    selfLib = config.flake.lib;
    selfPkgs = config.flake.packages;
  };
  commonNixosModules = config.flake.nixosSuites.osBase;
  mkHost = {
    name,
    configurationName ? name,
    system,
    extraModules ? [],
  }: {
    ${name} = inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      inherit ((getSystem system).allModuleArgs) pkgs;
      specialArgs = nixosSpecialArgs;
      modules = (
        commonNixosModules
        ++ extraModules
        ++ lib.optional (configurationName != null) ../node/${configurationName}
        ++ [({lib, ...}: {networking.hostName = lib.mkDefault name;})]
      );
      # keep consistency of nixos-rebuild and colmena,
      # without interfering with the colmena deployment
      extraModules = [inputs.colmena.nixosModules.deploymentOptions];
    };
  };
in
{
  flake.nixosConfigurations = lib.mkMerge [
    (mkHost {
      name = "Aleksana-Laptop";
      system = "x86_64-linux";
    })
  ];
}

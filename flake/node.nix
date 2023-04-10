{ config, inputs, lib, getSystem, ... }:

let
  userName = "aleksana";
  inherit (config.flake) nixosProfiles nixosSuites;
  commonNixosModules = nixosSuites.osBase;
  mkHost = {
    name,
    configurationName ? name,
    system,
    extraModules ? [],
  }: {
    ${name} = inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      inherit ((getSystem system).allModuleArgs) pkgs;
      specialArgs = {
        inherit inputs userName;
        profiles = nixosProfiles;
        suites = nixosSuites;
        selfLib = config.flake.lib;
        selfPkgs = (getSystem system).packages;
      };
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

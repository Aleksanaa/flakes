{ inputs, userName, selfLib, selfPkgs, nixosModules, nixosSuites, ... }:

{
  imports = [ inputs.home-manager.nixosModules.home-manager ];
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs userName selfLib selfPkgs nixosModules nixosSuites;
    };
  };
}

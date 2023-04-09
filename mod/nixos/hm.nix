{ inputs, userName, selfLib, selfPkgs, nixosModules, nixosSuites, ... }:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs userName selfLib selfPkgs nixosModules nixosSuites;
    };
  };
}

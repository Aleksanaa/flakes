{ inputs, userName, selfLib, selfPkgs, profiles, suites, ... }:

{
  imports = [ inputs.home-manager.nixosModules.home-manager ];
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs userName selfLib selfPkgs profiles suites;
    };
  };
}

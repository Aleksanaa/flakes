{ config, inputs, lib, ... }:

let
  inherit (config.flake.lib.flake.importers) flattenTree rakeLeaves;
  inherit (config.flake.lib.flake) buildSuites;
  extract = set: lib.attrValues (flattenTree set);
in
{
  flake = rec {
    nixosModules = rakeLeaves ../mod;
    nixosSuites = buildSuites nixosModules (modules: suites: {
      osBase = with modules.nixos; [ doas doc nix time user ];
      osInter = with modules.nixos; [
        pipewire
        hm
        compat.fcitx5
        compat.keyring
        compat.greetd
        compat.gtklock
      ];
      osBoot = with modules.nixos.boot; [ lanza persist plymth ];
      osDesk = suites.osBase ++ suites.osInter ++ suites.osBoot;

      homeBase = extract modules.home.base;
      homeDesk = extract modules.home.desk;
      homeShell = extract modules.home.sh;
      homeAll = suites.homeBase ++ suites.homeDesk ++ suites.homeShell;
    });
  };
}

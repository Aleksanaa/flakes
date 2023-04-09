{ config, inputs, lib }:

let
  inherit (config.flake.lib.flake.importers) flattenTree rakeLeaves;
  inherit (config.flake.lib.flake) buildSuites;
  extract = set: lib.attrValues (flattenTree set);
in
{
  flake = {
    nixosModules = rakeLeaves ../mod;
    nixosSuites = buildSuites nixosModules (modules: suites: {
      osBase = with modules.nixos; [ doas doc nix time ];
      osInter = with modules.nixos.compat; [ fcitx5 keyring pipewire nixos.hm greetd gtklock ];
      osBoot = with modules.nixos.boot; [ lanza persist plymth ];
      osDesk = suites.osBase ++ suites.osInter ++ suites.osBoot;

      homeBase = extract modules.home.base;
      homeDesk = extract modules.home.desk;
      homeShell = extract modules.home.sh;
      homeAll = suites.homeBase ++ suites.homeDesk ++ suites.homeShell;
    });
  };
}

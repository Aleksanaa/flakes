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
      osBase = with nixos; [ doas doc nix time ];
      osInter = with nixos.compat; [ fcitx5 keyring pipewire nixos.hm greetd gtklock ];
      osBoot = with nixos.boot; [ lanza persist plymth ];
      osDesk = osBase ++ osInter ++ osBoot;

      homeBase = extract home.base;
      homeDesk = extract home.desk;
      homeShell = extract home.sh;
      homeAll = homeBase ++ homeDesk ++ homeShell;
    })
  };
}

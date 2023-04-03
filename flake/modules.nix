{ config, inputs, lib }:

let
  inherit (config.flake.lib.flake.importers) rakeLeaves;
{
  flake.nixosModules = rakeLeaves ../mod;
  # Suites definition here
}

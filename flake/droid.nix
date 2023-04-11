{ config, inputs, self, lib, ... }:

let
  inherit (self.nix-on-droid.lib) nixOnDroidConfiguration;
in
{
  flake.nixOnDroidConfigurations.default = nixOnDroidConfiguration {
    modules = [ ];
  };
}

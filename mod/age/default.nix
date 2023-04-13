{ config, inputs, pkgs, selfLib, ... }:

let
  inherit (selfLib.nixos.agenix) identityFiles secretFiles;
  hostName = config.networking.hostName;
in
{
  imports = with inputs;[
    agenix.nixosModules.default
    agenix-rekey.nixosModules.default
  ];
  rekey = {
    agePlugins = [ pkgs.age-plugin-yubikey ];
    masterIdentities = identityFiles ./identities;
    secrets = secretFiles ./secrets;
    hostPubkey = ./pubkeys/${hostName}.pub;
  };
}

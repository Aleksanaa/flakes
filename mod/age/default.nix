{ config, inputs, pkgs, ... }:

let
  hostName = config.networking.hostName;
in
{
  imports = with inputs; [
    agenix.nixosModules.default
    agenix-rekey.nixosModules.default
  ];
  rekey = {
    masterIdentities = [ ./identities/yubikey-1e94e772.pub ];
    agePlugins = [ pkgs.age-plugin-yubikey ];
    secrets.devHashedPassword.file = ./secrets/devHashedPassword.age;
    hostPubkey = ./pubkeys/${hostName}.pub;
  };
}

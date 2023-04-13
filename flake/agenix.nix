{ self, config, inputs, ... }:

{
  # nix run .#{rekey,rekey-save-outputs,edit-secret}
  # https://github.com/oddlama/agenix-rekey/blob/main/apps/rekey.nix
  perSystem = { pkgs, ... }: {
    apps = inputs.agenix-rekey.defineApps self pkgs self.nixosConfigurations;
  };
}

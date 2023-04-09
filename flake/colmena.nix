{ config, self, inputs, ... }:

# add colmena compatibility
# from https://github.com/zhaofengli/colmena/issues/60#issuecomment-1047199551
{
  colmena = {
    meta = {
      description = "my personal machines";
      # This can be overriden by node nixpkgs
      nixpkgs = import inputs.nixpkgs { system = "x86_64-linux"; };
    }
  } // builtins.mapAttrs (name: value: {
    nixpkgs.system = value.config.nixpkgs.system;
    imports = value._module.args.modules;
  }) (self.nixosConfigurations);
}

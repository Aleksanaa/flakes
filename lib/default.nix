{ inputs, lib }:

lib.makeExtensible (self: {
  mkAutoStartService = import ./mkAutoStartService.nix;
  mkNemoAction = (import ./mkNemoAction.nix { inherit lib; }).func;
  mkHyprlandConf = import ./mkHyprlandConf.nix;
})

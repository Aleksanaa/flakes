{ lib, ... }:

let
  inherit (import ./importers.nix { inherit lib; }) rakeLeaves flattenTree;
in
{
  customPackages = { pkgs, dir }: (
    builtins.mapAttrs (name: path: pkgs.callPackage path) (flattenTree (rakeLeaves dir))
  );

  customOverlays = { pkgs, dir }: (
    builtins.mapAttrs (name: path: import path {prev = pkgs;}) (flattenTree (rakeLeaves dir))
  );
}

{ inputs, lib }:

let
  # Yes this is copied from callPackage!
  unwrapFunc = f: f (builtins.intersectAttrs (builtins.functionArgs f) { inherit inputs lib; });

  extractFunc = set:
    if (builtins.length (builtins.attrNames set)) == 1 && (builtins.hasAttr "func" set)
    then set.func
    else set;

  filterNix = dir:
    let
      importers = import ./flake/importers.nix { inherit lib; };
      inherit (importers) flattenTree rakeLeaves;
    in
    flattenTree (rakeLeaves dir);
in
{
  func = dir: builtins.mapAttrs (_: f: extractFunc (unwrapFunc (import f))) (filterNix dir);
}

{ inputs, lib }:

let
  # Yes this is copied from callPackage!
  unWrapFunc = f: f (builtins.intersectAttrs (builtins.functionArgs f) { inherit inputs lib; });
  extractFunc = set: if (length set) == 1 && (builtins.hasAttr func) then set.func else set;
  filterNix = dir: lib.filterAttrs (name: _: lib.hasSuffix ".nix" name) (builtins.readDir dir);
in
{
  func = dir: builtins.mapAttrs (_: f: extractFunc (unwrapFunc f)) (filterNix dir);
}

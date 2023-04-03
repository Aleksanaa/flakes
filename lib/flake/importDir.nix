{ lib, ... }:

let
  inherit (import ./importers.nix { inherit lib; }) rakeLeaves flattenTree;
in
{
  func = dir: lib.attrValues (flattenTree (rakeLeaves dir));
}

{ inputs, lib }:

let
  importFunc = (import ./importFunc.nix { inherit inputs lib; }).func;
  importDict = builtins.mapAttrs
    (name: value: importFunc ./${name})
    (lib.filterAttrs
      (name: value: value == "directory")
      (builtins.readDir ./.));
in
lib.makeExtensible (self: importDict)

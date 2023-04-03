{ inputs, lib }:

let
  importFunc = (import ./importFunc.nix { inherit inputs lib; }).func;
in
lib.makeExtensible (self: {
  flake = importFunc ./flake;
  home = importFunc ./home;
})

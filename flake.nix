{
  description = "Aleksana's flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    flake-parts.url = "github:hercules-ci/flake-parts";
    impermanence.url = "github:nix-community/impermanence";
    home-manager = {
      url = "github:pasqui23/home-manager/nixos-late-start";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland/v0.22.0beta";
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    colmena.url = "github:zhaofengli/colmena";
    nix-on-droid = {
      url = "github:t184256/nix-on-droid";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { flake-parts, ... }: flake-parts.lib.mkFlake { inherit inputs; } (
    # Copied from https://github.com/linyinfeng/dotfiles/blob/main/flake.nix
    { self, lib, ... }:
    let
      selfLib = import ./lib { inherit inputs lib; };
    in {
      systems = [ "x86_64-linux" "aarch64-linux" ];
      flake.lib = selfLib;
      imports = [
        inputs.flake-parts.flakeModules.easyOverlay
      ] ++ selfLib.flake.importDir ./flake;
    }
  );
}

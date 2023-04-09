{ inputs, lib, ... }:

{
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" "repl-flake" ];
      # This imports all attributes of inputs.
      # for example, :l <nur>
      nix-path = lib.mapAttrsToList (name: path: "${name}=${path}") inputs;
      substituters = [
        "https://mirrors.iscas.ac.cn/nix-channels/store"
        "https://mirrors.bfsu.edu.cn/nix-channels/store"
      ];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    # This is important. It locks nixpkgs registry used in nix shell
    # to the same of flakes. Saves time.
    registry.nixpkgs.flake = inputs.nixpkgs;
    # Not very useful anyway.
    extraOptions = "preallocate-contents = false";    
  };
}

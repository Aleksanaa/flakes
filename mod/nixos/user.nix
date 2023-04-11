{ userName, ... }:

{
  users = {
    mutableUsers = false;
    users = {
      ${userName} = {
        isNormalUser = true;
        extraGroups = [ "wheel" "nix-config" ];
      };
      root.extraGroups = [ "nix-config" ];
    };
    groups = { nix-config = { }; };
  };
}

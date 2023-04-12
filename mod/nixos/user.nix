{ userName, ... }:

{
  users = {
    mutableUsers = false;
    users = {
      ${userName} = {
        isNormalUser = true;
        extraGroups = [ "wheel" "nix-config" ];
        # force user id to allow modifying /run directory
        uid = 1000;
      };
      root.extraGroups = [ "nix-config" ];
    };
    groups = { nix-config = { }; };
  };
}

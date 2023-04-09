{ lib, userName, ... }:

{
  home = {
    username = userName;
    homeDirectory = lib.mkForce "/home/${userName}";
  };
}

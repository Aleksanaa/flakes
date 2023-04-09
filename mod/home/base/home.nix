{ userName, ... }:

{
  home = {
    username = userName;
    homeDirectory = "/home/${userName}";
  };
}

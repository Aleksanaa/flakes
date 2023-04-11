{ lib }:

# Generate Nemo Action from Nix expressions
let
  customToINI = with lib; generators.toINI {
    mkKeyValue = generators.mkKeyValueDefault {
      mkValueString = v:
        if isList v then (builtins.concatStringsSep ";" v) + ";"
        else generators.mkValueStringDefault {} v;
    } "=";
  };
in
{
  func = { fileName, action }: {
    ".local/share/nemo/actions/${fileName}.nemo_action" = {
      text = customToINI {
        "Nemo Action" = action;
      };
    };
  };
}

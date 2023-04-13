{ lib, ... }:

{
  identityFiles = dir: builtins.map
    (path: dir + path)
    (lib.attrNames
      (builtins.readDir dir));

  secretFiles = dir: lib.mapAttrs'
    (file': type:
      {
        name = lib.removeSuffix ".age" file';
        value = { file = dir + "/${file'}"; };
      })
    (lib.filterAttrs
      (file: type: type == "regular" && lib.hasSuffix ".age" file)
      (builtins.readDir dir));
}

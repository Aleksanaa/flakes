{ lib, ... }:

{
  func = profiles: f: lib.mapAttrs (_: lib.flatten) (lib.fix (f profiles));
}

{ ... }:

# Copied from https://github.com/hyprwm/Hyprland/pull/870#issuecomment-1319448768
# Generates hyprland config
rec {
  mkValueString = value:(
    if builtins.isBool value then (
      if value then "true" else "false"
    )
    else if (builtins.isFloat value || builtins.isInt value) then (
      builtins.toString value
    )
    else if builtins.isString value then (
      value
    )
    else if (
      (builtins.isList value) &&
      ((builtins.length value) == 2) &&
      ((builtins.isFloat (builtins.elemAt value 0)) || (builtins.isFloat (builtins.elemAt value 0))) &&
      ((builtins.isFloat (builtins.elemAt value 1)) || (builtins.isFloat (builtins.elemAt value 1)))
    ) then (
      builtins.toString (builtins.elemAt value 0) + " " + builtins.toString (builtins.elemAt value 1)
    )
    else abort "Unhandled value type ${builtins.typeOf value}"
  );

  concatAttrs = arg: func: (
    assert builtins.isAttrs arg;
    builtins.concatStringsSep "\n" (lib.attrsets.mapAttrsToList func arg)
  );

  mkHyprlandVariables = arg: (
    concatAttrs arg (
      name: value: name + (
        if builtins.isAttrs value then (
          " {\n" + (mkHyprlandVariables value) + "\n}"
        )
        else " = " + mkValueString value
      )
    )
  );

  mkHyprlandBinds = arg: (
    concatAttrs arg (
      name: value: (
        if builtins.isList value then (
          builtins.concatStringsSep "\n" (builtins.map (x: name + " = " + x) value)
        )
        else concatAttrs value (
          name2: value2: name + " = " + name2 + "," + (assert builtins.isString value2; value2)
        )
      )
    )
  );
}

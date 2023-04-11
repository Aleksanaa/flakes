prev: {
  waybar = prev.waybar.overrideAttrs (oldAttrs: {
    postPatch = ''
      sed -i 's|zext_workspace_handle_v1_activate(workspace_handle_);|const std::string command = "${prev.hyprland}/bin/hyprctl dispatch workspace " + name_;\n\tsystem(command.c_str());|g' src/modules/wlr/workspace_manager.cpp
    '';
    mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
  });
}

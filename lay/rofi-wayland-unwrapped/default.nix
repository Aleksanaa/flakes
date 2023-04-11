prev: {
  rofi-wayland-unwrapped = prev.rofi-wayland-unwrapped.overrideAttrs (
    old: {
      patches = [
        ./rofi-icons-scale-by-2.patch
        ./rofi-fix-redraw.patch
      ];
    }
  );
}

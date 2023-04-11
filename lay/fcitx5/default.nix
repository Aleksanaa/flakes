prev: {
  fcitx5 = prev.fcitx5.overrideAttrs (
    old: { patches = [ ./fcitx5-avoid-save-group.patch ]; }
  );
}

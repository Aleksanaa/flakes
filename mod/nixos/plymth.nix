{ ... }:

{
  boot = {
    kernelParams = [
      "vt.global_cursor_default=0"
      "quiet"
      "splash"
    ];
    plymouth.enable = true;
  };
}

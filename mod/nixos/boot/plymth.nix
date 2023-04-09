{ ... }:

{
  boot = {
    kernelParams = [
      "vt.global_cursor_default=0"
      "quiet"
      "splash"
    ];
    initrd.systemd.enable = true;
    plymouth.enable = true;
  };
}

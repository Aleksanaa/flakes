prev: {
  blesh = prev.blesh.overrideAttrs (old: {
    version = "0.4.0-devel3";
    src = prev.fetchzip {
      url = "https://github.com/akinomyoga/ble.sh/releases/download/v0.4.0-devel3/ble-0.4.0-devel3.tar.xz";
      hash = "sha256-kGLp8RaInYSrJEi3h5kWEOMAbZV/gEPFUjOLgBuMhCI=";
    };
  });
}

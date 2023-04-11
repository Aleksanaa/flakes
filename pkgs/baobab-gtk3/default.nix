{ stdenv
, lib
, gettext
, fetchurl
, vala
, desktop-file-utils
, meson
, ninja
, pkg-config
, python3
, gtk3
, libhandy
, glib
, libxml2
, wrapGAppsHook
, itstool
}:

stdenv.mkDerivation rec {
  pname = "baobab-gtk3";
  version = "41.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/baobab-${version}.tar.xz";
    sha256 = "ytYnjS3MgMhLVxBapbtY2KMM6Y1vq9dnUZ3bhshX6FU=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    glib
    itstool
    libxml2
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook
    # Prevents “error: Package `libhandy-1' not found in specified Vala API
    # directories or GObject-Introspection GIR directories” with strictDeps,
    # even though it should only be a runtime dependency.
    libhandy
  ];

  buildInputs = [
    gtk3
    libhandy
    glib
  ];

  doCheck = false;

  meta = with lib; {
    description = "Graphical application to analyse disk usage in any GNOME environment";
    homepage = "https://wiki.gnome.org/Apps/DiskUsageAnalyzer";
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}

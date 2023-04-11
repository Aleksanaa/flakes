{ stdenv
, lib
, fetchurl
, meson
, ninja
, pkg-config
, glib
, gtk3
, wrapGAppsHook
, gettext
, itstool
, libhandy
, libxml2
, libxslt
, docbook_xsl
, docbook_xml_dtd_43
, systemd
, python3
, gsettings-desktop-schemas
}:

stdenv.mkDerivation rec {
  pname = "gnome-logs-gtk3";
  version = "42.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-logs/${lib.versions.major version}/gnome-logs-${version}.tar.xz";
    sha256 = "TV5FFp1r9DkC16npoHk8kW65LaumuoWzXI629nLNq9c=";
  };

  nativeBuildInputs = [
    python3
    meson
    ninja
    pkg-config
    wrapGAppsHook
    gettext
    itstool
    libxml2
    libxslt
    docbook_xsl
    docbook_xml_dtd_43
  ];

  buildInputs = [
    glib
    gtk3
    libhandy
    systemd
    gsettings-desktop-schemas
  ];

  mesonFlags = [
    "-Dman=true"
  ];

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

  doCheck = false;

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/Logs";
    description = "A log viewer for the systemd journal";
    maintainers = teams.gnome.members;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}

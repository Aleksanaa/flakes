{ ... }:

# enable gnome keyring in the system level
{
  security.pam.services.greetd.enableGnomeKeyring = true;
  services.gnome.gnome-keyring.enable = true;
}

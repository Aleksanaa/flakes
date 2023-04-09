{ ... }:

# allow gtklock to interact with pam
{
  security.pam.services.gtklock.text = "auth include login\n";
}

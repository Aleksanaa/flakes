{ ... }:

# Generating hostkeys is important for agenix
{
  services.openssh = {
    enable = true;
    hostKeys = [
      {
        path = "/nix/persist/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };
}

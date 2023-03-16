{ ... }:

# This depends on impermanence.
{
  environment.persistence."/nix/persist" = {
    directories = [
      "/etc/nixos"
      "/etc/NetworkManager/system-connections"
      "/var/lib"
      "/etc/secureboot"
    ];
  };
  # Systemd produces a large amount of logs
  # Can't place them in persist, as they will still getting bigger over time
  services.journald.extraConfig = "compress=yes\nSystemMaxUse=200M";
}

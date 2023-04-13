{ config, inputs, pkgs, userName, profiles, suites, selfPkgs, ... }:

{
  imports = with profiles; [
    nixos.fstrim
    nixos.firewall.kdeconnect
    age
  ] ++ suites.osDesk ++ [ ./hardware.nix ];

  boot = {
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs.linuxPackages_zen;
    kernelParams = [
      "transparent_hugepage=madvise"
      "cgroup_no_v1=net_cls,net_prio"
    ];
    # AMD cpu watchdog
    extraModprobeConfig = ''
      blacklist sp5100_tco
    '';
  };

  hardware.cpu.amd.updateMicrocode = true;

  networking.networkmanager.enable = true;

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  services.printing.enable = true;

  virtualisation.docker.enable = true;

  services.gvfs.enable = true;

  services.power-profiles-daemon.enable = true;

  # Yubikey oauth
  services.pcscd.enable = true;

  security = {
    pam.mount = {
      enable = true;
      logoutKill = true;
    };
    tpm2 = {
      enable = true;
      pkcs11.enable = true;
    };
  };

  users.users.${userName} = {
    pamMount = {
      path = "/dev/disk/by-partuuid/77b1e56a-27b2-46e3-b2ef-d2efa6fae9c9";
      fstype = "crypt";
      options = "compress=lzo,nofail";
    };
    shell = pkgs.bash;
    passwordFile = config.rekey.secrets.devHashedPassword.path;
  };

  home-manager.users.${userName} = {
    imports = suites.homeAll;
    home.packages = with pkgs; [
      firefox
      bleachbit
      ghostwriter
      gnome.dconf-editor
      gnome.file-roller
      gthumb
      evince
      tdesktop
      cawbird
      tuba
      libreoffice-fresh
      go-musicfox
      gtkcord4
      gnome.gnome-boxes
      gnome-online-accounts
      gnome.geary
      selfPkgs.gnome-logs-gtk3
      selfPkgs.baobab-gtk3
      selfPkgs.grimblast
      neovim-gtk
      remmina
      valent
      yubioath-flutter
      tree
      selfPkgs.fastfetch
      dig
      payload-dumper-go
      lazygit
      speedtest-go
      nali
      gnupg
      shellcheck
      yubikey-manager
    ];
  };
}

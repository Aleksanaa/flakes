{ config, pkgs, ... }:

let
  rofi = config.programs.rofi.finalPackage;
  pinentryRofi = pkgs.stdenvNoCC.mkDerivation {
    name = "anypinentry-rofi";
    src = fetchFromGitHub {
      owner = "phenax";
      repo = "any-pinentry";
      rev = "1b958661c9081ac92f417ce44da7a55a76360db6";
      hash = "sha256-jVkh/s4VO+5xB2cqPK1DxQYknH9nPbMCky06STugacY=";
    };
    patches = [
      (fetchpatch {
        url = "https://github.com/phenax/any-pinentry/commit/887662597b9a5db113303bfc13121fcffa446190.patch";
        hash = "sha256-pdPoe84Ksyp7H9ndgtHALHIU77Xgrh/7JMiw0AGmL98=";
      })
      (fetchpatch {
        url = "https://github.com/phenax/any-pinentry/pull/5/commits/4f5ed2ab1256af9b41a94091cdea5cf7c2eaa341.patch";
        hash = "sha256-SNkPGqClnOGyrH0BQ6RhHoDT6pukqVus21dO+WXLJvA=";
      })
    ];
    buildPhase = ''
      sed -i 's|dmenu -p|${rofi}/bin/rofi -dmenu -p|' anypinentry
      sed -i 's|dmenu -P|${rofi}/bin/rofi -dmenu -password|' anypinentry
      sed -i 's|notify-send|${pkgs.libnotify}/bin/notify-send|' anypinentry
    '';
    installPhase = ''
      install -Dm755 anypinentry $out
    '';
  };
in
{
  services.gpg-agent.extraConfig = ''
    pinentry-program ${pinentryRofi}
    max-cache-ttl 240
    default-cache-ttl 180
  '';
}

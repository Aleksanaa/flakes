{ pkgs, lib, ... }:

let
  customToINI = with lib; generators.toINI {
    mkKeyValue = generators.mkKeyValueDefault
      {
        mkValueString = v:
          if v == true then "True"
          else if v == false then "False"
          else if isString v then "${v}"
          else generators.mkValueStringDefault { } v;
      } "=";
  };
  customToKV = lib.generators.toKeyValue { };
  nordLightTheme = pkgs.fetchFromGitHub {
    owner = "tonyfettes";
    repo = "fcitx5-nord";
    rev = "bdaa8fb723b8d0b22f237c9a60195c5f9c9d74d1";
    hash = "sha256-qVo/0ivZ5gfUP17G29CAW0MrRFUO0KN1ADl1I/rvchE=";
  };
in
{
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-chinese-addons
    ];
  };
  home.file = {
    ".local/share/fcitx5/pinyin/dictionaries/zhwiki-20221230.dict".source = builtins.fetchurl {
      url = "https://github.com/felixonmars/fcitx5-pinyin-zhwiki/releases/download/0.2.4/zhwiki-20221230.dict";
      sha256 = "sha256:0jn7c17ny6g06l7pvp21yhv4w4hcd29wkidnahb7dvwbv1c3mv9j";
    };
    ".local/share/fcitx5/pinyin/dictionaries/moegirl.dict".source = builtins.fetchurl {
      url = "https://github.com/outloudvi/mw2fcitx/releases/download/20230114/moegirl.dict";
      sha256 = "sha256:0i12zgjl1ps2631q7lygznzm1g3pp5mxns5009fnrsb5aadv35af";
    };
    ".local/share/fcitx5/themes/Nord-Light/" = {
      source = "${nordLightTheme}/Nord-Light";
      recursive = true;
    };
    ".config/fcitx5/config".text = customToINI {
      "Hotkey"."EnumerateWithTriggerKeys" = true;
      "Hotkey/AltTriggerKeys"."0" = "Shift_L";
      "Hotkey/EnumerateForwardKeys"."0" = "Shift+Shift_L";
      "Hotkey/EnumerateBackwardKeys"."0" = "Shift+Shift_R";
    };
    ".config/fcitx5/conf/classicui.conf".text = customToKV {
      "Font" = "Noto Sans CJK SC 10";
      "MenuFont" = "Noto Sans CJK SC 10";
      "TrayFont" = "Noto Sans CJK SC Bold 10";
      "Theme" = "Nord-Light";
    };
    ".config/fcitx5/profile".text = customToINI {
      "Groups/0" = {
        "Name" = "Default";
        "Default Layout" = "us";
        "DefaultIM" = "pinyin";
      };
      "Groups/0/Items/0" = {
        "Name" = "keyboard-us";
      };
      "Groups/0/Items/1" = {
        "Name" = "pinyin";
      };
      "GroupOrder"."0" = "default";
    };
  };
}

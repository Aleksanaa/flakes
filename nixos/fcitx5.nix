{ pkgs, ... }:

# fcitx5 needs to be in system configuration
# so the env can be set to make it work correctly
{
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [ fcitx5-chinese-addons ];
  };
}

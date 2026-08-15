{ config, pkgs, ... }:

{

  services.xserver.desktopManager.runXdgAutostartIfNone = true;

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-gtk
      qt6Packages.fcitx5-chinese-addons
      fcitx5-rime
      
    ];
    fcitx5.waylandFrontend = true;
  };

}

{ config, pkgs, lib, ... }:

let
  apps = [
    # {
    #   name = "idea-ce";
    #   desktopName = "IntelliJ IDEA Community Edition";
    #   home = "/home/agamotto/apps/idea";
    #   exec = "bin/idea.sh %f";
    #   icon = "bin/idea.svg";
    #   comment = "IDE para Kotlin/Java";
    #   categories = [ "Development" "IDE" ];
    #   startupWMClass = "jetbrains-idea-ce";
    #   mimeTypes = [ "text/x-java" "text/x-kotlin" ];
    # }
    # {
    #   name = "otra-app";
    #   desktopName = "Otra App";
    #   home = "/home/agamotto/apps/otra-app";
    #   exec = "bin/otra-app.sh";
    #   icon = "bin/icon.svg";
    #   comment = "Descripción";
    #   categories = [ "Utility" ];
    # }
  ];

  mkApp = a: pkgs.makeDesktopItem {
    inherit (a) name desktopName comment categories;
    exec = "${a.home}/${a.exec}";
    icon = "${a.home}/${a.icon}";
    terminal = false;
    startupWMClass = a.startupWMClass or null;
    mimeTypes = a.mimeTypes or [ ];
  };
in
{
  environment.systemPackages = map mkApp apps;
}

{ config, pkgs, ... }:

{
    users.users.agamotto = {
      isNormalUser = true;
      description = "agamotto";
      extraGroups = [ "networkmanager" "wheel" "video" "docker" ];
      packages = with pkgs; [];
    };

    virtualisation.docker.enable = true;

}

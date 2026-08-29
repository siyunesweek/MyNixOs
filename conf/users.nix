{ config, pkgs, ... }:

{
    users.users.agamotto = {
    isNormalUser = true;
    description = "agamotto";
    extraGroups = [ "networkmanager" "wheel" "video" ];
    packages = with pkgs; [];
    };
}

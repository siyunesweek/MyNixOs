{ config, pkgs, ... }:

let
  autofirma-nix = builtins.getFlake "github:nix-community/autofirma-nix";
in
{
  imports = [ autofirma-nix.nixosModules.default ];

  programs.autofirma = {
    enable = true;
    firefoxIntegration.enable = true;
  };

  services.pcscd.enable = true;
}

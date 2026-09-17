  { config, pkgs, ... }:

{

  nixpkgs.config.permittedInsecurePackages = [
    "elasticsearch-7.17.27"
  ];

  services.elasticsearch = {
    enable = true;
    package = pkgs.elasticsearch7;
  };

}

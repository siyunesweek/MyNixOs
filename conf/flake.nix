{
  description = "Configuración NixOS de agamotto";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    handy.url = "github:cjpais/Handy";
    handy.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, handy, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit handy; };
      modules = [
        ./configuration.nix
      ];
    };
  };
}

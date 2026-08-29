{
  description = "Configuración NixOS de agamotto";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    handy.url = "github:cjpais/Handy";

    noctalia.url = "github:noctalia-dev/noctalia-shell";
  };

  outputs = { self, nixpkgs, handy, noctalia, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit handy noctalia; };
      modules = [
        ./configuration.nix
      ];
    };
  };
}

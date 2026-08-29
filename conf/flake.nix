{
  description = "Configuración NixOS de agamotto";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixos-25.11";

    handy.url = "github:cjpais/Handy";
    handy.inputs.bun2nix.inputs.nixpkgs.follows = "nixpkgs-darwin";

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

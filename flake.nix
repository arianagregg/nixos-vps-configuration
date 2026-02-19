{
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs@{ self, nixpkgs, disko, ... }: {
    nixosConfigurations = {
      wendy = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = with inputs; [
          ./disko.nix
          ./system.nix

          disko.nixosModules.disko
        ];
      };
    };
  };
}

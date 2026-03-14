{
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-25.11";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence = {
      url = "github:nix-community/impermanence";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs@{ self, nixpkgs, disko, impermanence, ... }: {
    nixosConfigurations = {
      wendy = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = with inputs; [
          ./disko.nix
          ./system.nix
	  ./impermanence.nix

          disko.nixosModules.disko
	  impermanence.nixosModules.impermanence
        ];
      };
    };
  };
}

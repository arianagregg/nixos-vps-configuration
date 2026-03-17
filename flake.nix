{
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence = {
      url = "github:nix-community/impermanence";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tranquil = {
      url = "git+https://tangled.org/tranquil.farm/tranquil-pds?ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs@{ self, nixpkgs, disko, ... }: {
    nixosConfigurations = {
      wendy = let
        hostname = "wendy";
      in nixpkgs.lib.nixosSystem {
        specialArgs = { inherit hostname; inherit inputs; };

        system = "x86_64-linux";

        modules = with inputs; [
          ./disko.nix
          ./system.nix
	  ./impermanence.nix
	  ./tranquil.nix

	  # Wendy-specific modules
	  ./wendy.nix

          disko.nixosModules.disko
	  impermanence.nixosModules.impermanence
          tranquil.nixosModules.tranquil-pds
        ];
      };
    };
  };
}

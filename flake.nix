{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wrappers.url = "github:lassulus/wrappers";
    
    home-manager = {
    url = "github:nix-community/home-manager";
    inputs.nixpkgs.follows = "nixpkgs";
    };

    #nixcats.url = "github:BirdeeHub/nixCats-nvim";
    nixcats.url = "./nixcats";
  };

  outputs = { nixpkgs, home-manager, ... } @ inputs: 
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
  in
  {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
	];
    };

    homeConfigurations.alex = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      modules = [ ./home.nix ];

      extraSpecialArgs = { inherit inputs; };
    };

    packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;
    
  };
}

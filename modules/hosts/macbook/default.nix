{ self, inputs, ... }:
{
  flake.darwinConfigurations.macbook = inputs.nix-darwin.lib.darwinSystem {
    system = "aarch64-darwin";
    modules = [
      self.darwinModules.macbookConfiguration
    ];
  };
}

/*
        darwinConfigurations.macbook = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            ./hosts/darwin/configuration.nix
            home-manager.darwinModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                #users.alex = ./darwinhome.nix;
                users.alex = ./hosts/darwin/home.nix;
              };
            }
          ];

          specialArgs = { inherit inputs; };
        };
*/

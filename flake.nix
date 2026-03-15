{
  description = "i love cock";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wrappers.url = "github:lassulus/wrappers";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mnw.url = "github:Gerg-L/mnw";

  };

  outputs =
    {
      nixpkgs,
      mnw,
      spicetify-nix,
      self,
      home-manager,
      nix-darwin,
      ...
    }@inputs:
    let
      system = "aarch64-darwin";
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      unfreePkgs = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/nixos/configuration.nix
        ];
      };

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

      #homeConfigurations.alex = home-manager.lib.homeManagerConfiguration {
      #  inherit pkgs;

      #  modules = [ ./home.nix ];

      #  extraSpecialArgs = { inherit inputs; };
      #};

      packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;

      packages.aarch64-darwin.default = self.packages.aarch64-darwin.neovim;

      packages.aarch64-darwin.neovim = mnw.lib.wrap {
        inherit inputs pkgs;
      } ./nvim.nix;

      dev = self.packages.aarch64-darwin.default.devMode;
      packages.aarch64-darwin.less = pkgs.symlinkJoin {
        name = "lesswrap";
        paths = [ pkgs.less ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/less \
            --set LESS '--RAW-CONTROL-CHARS --clear-screen' \
            --set LESSKEY_CONTENT 'h left-scroll'
        '';
        meta.mainProgram = "less";
      };
      # nixos.org/manual/nixpkgs/stable/
      #callpackage
      #symlinkjoin

    };
}

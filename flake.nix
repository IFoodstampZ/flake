{
  description = "alex nix flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    nixflix = {
      url = "github:kiriwalawren/nixflix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    inputs:
    # https://flake.parts/module-arguments.html
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      top@{
        config,
        withSystem,
        moduleWithSystem,
        ...
      }:
      {
        imports = [
          # Optional: use external flake logic, e.g.
          # inputs.foo.flakeModules.default
          (inputs.import-tree ./modules)
        ];
        flake = {
          # Put your original flake attributes here.
        };
        systems = [
          # systems for which you want to build the `perSystem` attributes
          "x86_64-linux"
          "aarch64-darwin"
          # ...
        ];
        perSystem =
          {
            config,
            pkgs,
            ...
          }:
          {
            # Recommended: move all package definitions here.
            # e.g. (assuming you have a nixpkgs input)
            # packages.foo = pkgs.callPackage ./foo/package.nix { };
            # packages.bar = pkgs.callPackage ./bar/package.nix {
            #   foo = config.packages.foo;
            # };
          };
      }
    );

}
/*
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

        inputs.flake-parts.lib.mkFlake { inherit inputs; }
         (import-tree ./modules):

        packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;

        packages.aarch64-darwin.default = self.packages.aarch64-darwin.neovim;

        packages.aarch64-darwin.neovim = mnw.lib.wrap {
          inherit inputs pkgs;
        } ./nvim.nix;

        packages.x86_64-linux.neovim = mnw.lib.wrap {
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
*/

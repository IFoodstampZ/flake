{ self, inputs, ... }:
{
  flake.nixosConfigurations.nixtop = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.nixtopConfiguration
    ];
  };
}

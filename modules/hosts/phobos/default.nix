{ self, inputs, ... }:
{
  flake.nixosConfigurations.phobos = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.phobosConfiguration
      inputs.sops-nix.nixosModules.sops
      inputs.nixflix.nixosModules.default
    ];
  };
}

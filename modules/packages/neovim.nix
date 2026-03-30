{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.neovim = inputs.mnw.lib.wrap {
        inherit inputs pkgs;
      } ../../packages/neovim/default.nix;
    };
}

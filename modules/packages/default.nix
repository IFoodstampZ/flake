{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.default = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.neovim;
    };
}

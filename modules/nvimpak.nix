{ inputs, ...}: {
  perSystem = { pkgs, ... }: {
    packages.myPackage = pkgs.stdenv.mkDerivation {
      pname = "myPackage";
      version = "1.0.0";
    };
  };
}

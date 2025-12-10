# declarative package management without nixos
# use nix profile install .#

{
  inputs = {
    # Grab a static nixpkgs or the one from your registry
  };

  outputs = {nixpkgs, ...}: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    packages.${system}.default = pkgs.buildEnv {
      name = "my-packages";
      paths = with pkgs; [
        aspell
        bc
        coreutils
        gdb
        ffmpeg
        nixUnstable
        emscripten
        jq
        nox
        silver-searcher
      ];
    };
  };
}

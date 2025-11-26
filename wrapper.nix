( wrappers.lib.wrapPackage {
  inherit pkgs;
  package = pkgs.neovim;
  flags = {
    "--empty-flag" = {};
    "--flag-with-value" = "value";
  };
  env = {
    VARIABLE = "hello";
  };
}
)

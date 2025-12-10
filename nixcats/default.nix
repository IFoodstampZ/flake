{ config, lib, inputs, ... }: let
  utils = inputs.nixCats.utils;
in {
  imports = [
    inputs.nixCats.nixosModules.default
  ];
  config = {
    # this value, nixCats is the defaultPackageName you pass to mkNixosModules
    # it will be the namespace for your options.
    nixCats = {
      enable = true;
      # nixpkgs_version = inputs.nixpkgs;
      # this will add an overlay for any plugins
      # in inputs named "plugins-pluginName" to pkgs.neovimPlugins
      # It will not apply to overall system, just nixCats.
      addOverlays = [
        (utils.standardPluginOverlay inputs)
      ];
      # see the packageDefinitions below.
      # This says which of those to install.
      packageNames = [ "nixCatsModule" ];

      luaPath = ./.;

      # the .replace vs .merge options are for modules based on existing configurations,
      # they refer to how multiple categoryDefinitions get merged together by the module.
      # for useage of this section, refer to :h nixCats.flake.outputs.categories
      categoryDefinitions.replace = ({ pkgs, settings, categories, extra, name, mkPlugin, ... }@packageDef: {
        lspsAndRuntimeDeps = {
          general = with pkgs; [
            universal-ctags
            ripgrep
            fd
          ];
        };
        lint = with pkgs; [
        ];
        debug = with pkgs; {
          go = [ delve ];
        };
        go = with pkgs; [
          gopls
          gotools
          go-tools
          gccgo
        ];
        format = with pkgs; [
        ];
        neonixdev = {
          inherit (pkgs) nix-doc lua-language-server nixd;
        };

        startupPlugins = {
          debug = with pkgs.vimPlugins; [
            nvim-nio
          ];
          general = with pkgs.vimPlugins; {
            always = [
              lzextras
              vim-repeat
              plenary-nvim
              (nvim-notify.overrideAttrs { doCheck = false; })
            ];
            extra = [
              oil-nvim
              nvim-web-devicons
            ];
          };

          themer = with pkgs.vimPlugins; [
            # you can even make subcategories based on categories and settings sets!
            (builtins.getAttr (packageDef.categories.colorscheme) {
                "onedark" = onedark-vim;
                "catppuccin" = catppuccin-nvim;
                "catppuccin-mocha" = catppuccin-nvim;
                "tokyonight" = tokyonight-nvim;
                "tokyonight-day" = tokyonight-nvim;
              }
            )
          ];
        };
        optionalPlugins = {
          debug = with pkgs.vimPlugins; {
            default = [
              nvim-dap
              nvim-dap-ui
              nvim-dap-virtual-text
            ];
            go = [ nvim-dap-go ];
          };
          lint = with pkgs.vimPlugins; [
            nvim-lint
          ];
          format = with pkgs.vimPlugins; [
            conform-nvim
          ];
          markdown = with pkgs.vimPlugins; [
            markdown-preview-nvim
            render-markdown-nvim
          ];
          neonixdev = with pkgs.vimPlugins; [
            lazydev-nvim
          ];
          general = {
            blink = with pkgs.vimPlugins; [
              luasnip
              cmp-cmdline
              blink-cmp
              blink-compat
              colorful-menu-nvim
            ];
            treesitter = with pkgs.vimPlugins; [
              nvim-treesitter-textobjects
              nvim-treesitter.withAllGrammars
            ];
            telescope = with pkgs.vimPlugins; [
              telescope-fzf-native-nvim
              telescope-ui-select-nvim
              telescope-nvim
            ];
            always = with pkgs.vimPlugins; [
              nvim-lspconfig
              lualine-nvim
              gitsigns-nvim
              vim-sleuth
              vim-fugitive
              vim-rhubarb
              nvim-surround
            ];
            extra = with pkgs.vimPlugins; [
              fidget-nvim
              which-key-nvim
              comment-nvim
              undotree
              indent-blankline-nvim
              vim-startuptime
            ];
          };
        };
        # shared libraries to be added to LD_LIBRARY_PATH
        # variable available to nvim runtime
        sharedLibraries = {
          general = with pkgs; [
            # libgit2
          ];
        };
        environmentVariables = {
          test = {
            CATTESTVAR = "It worked!";
          };
        };
        extraWrapperArgs = {
          test = [
            '' --set CATTESTVAR2 "It worked again!"''
          ];
        };
        # lists of the functions you would have passed to
        # python.withPackages or lua.withPackages

        # get the path to this python environment
        # in your lua config via
        # vim.g.python3_host_prog
        # or run from nvim terminal via :!<packagename>-python3
        python3.libraries = {
          test = (_:[]);
        };
        # populates $LUA_PATH and $LUA_CPATH
        extraLuaPackages = {
          test = [ (_:[]) ];
        };
      });

      # see :help nixCats.flake.outputs.packageDefinitions
      packageDefinitions.replace = {
        # These are the names of your packages
        # you can include as many as you wish.
        nixCatsModule = {pkgs, name, ... }: {
          # they contain a settings set defined above
          # see :help nixCats.flake.outputs.settings
          settings = {
            suffix-path = true;
            suffix-LD = true;
            wrapRc = true;
            # unwrappedCfgPath = "/path/to/config";
            # IMPORTANT:
            # your alias may not conflict with your other packages.
            aliases = [ "nvim" ];
            # neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.neovim;
          };
          # and a set of categories that you want
          # (and other information to pass to lua)
          categories = {
            general = true;
            markdown = true;
            lint = true;
            format = true;
            neonixdev = true;
            test = {
              subtest1 = true;
            };
            lspDebugMode = false;
            themer = true;
            colorscheme = "onedark";
          };
        };
      };

      # you can do it per user as well
      # users.REPLACE_ME = {
      #   enable = true;
      #   packageNames = [ "REPLACE_MEs_VIM" ];
      #   categoryDefinitions.replace = ({ pkgs, settings, categories, extra, name, mkPlugin, ... }@packageDef: {});
      #   packageDefinitions.replace = {
      #     REPLACE_MEs_VIM = {pkgs, name, ...}: {
      #       settings = {};
      #       categories = {};
      #     };
      #   };
      # };
    };
  };
}

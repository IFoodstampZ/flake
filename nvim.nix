{ inputs, pkgs, ... }:
let
  #pkgs = inputs.nixpkgs.legacyPackages.${system};
in
{
  neovim = pkgs.neovim-unwrapped;
  luaFiles = [
    ./init.lua
  ];
  extraBinPath = with pkgs; [
    nixd
    nil
    lua-language-server
    tinymist
    stylua
    nixfmt-rfc-style
    clang-tools
  ];
  plugins = {
    start = with pkgs.vimPlugins; [
      # essential
      oil-nvim
      blink-cmp
      conform-nvim
      fzf-lua
      lualine-lsp-progress
      nvim-lspconfig
      lualine-nvim
      auto-session
      nvim-autopairs
      nvim-surround
      rainbow-delimiters-nvim
      colorful-menu-nvim
      which-key-nvim
      mini-nvim
      nvim-highlight-colors
      lz-n
      lazydev-nvim
      nvim-treesitter.withAllGrammars
      # colorscheme
      catppuccin-nvim
      # bullshit
      typst-preview-nvim
      nvim-web-devicons
      luasnip
    ];
    dev.config = {
      pure = ./nvim;
      impure =
        # This is a hack it should be a absolute path
        # here it'll only work from this directory
        "/Users/alex/flake/nvim";
    };
  };

}

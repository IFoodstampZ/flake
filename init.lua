require("init")
require("lz.n").load("lazy")

vim.lsp.enable({
  "clangd",
  "nil_ls",
  "lua_ls",
  "tinymist",
  "nixd",
});

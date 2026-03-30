-- Global variable for access elsewhere
-- Check the value with:
-- :tabnew Colors|pu=execute(':=colors')
-- Putting it in a buffer lets it be colorized with our hexcode previewer
-- TODO: add an alias to do this easily
-- colors = require("catppuccin.colors").setup()

vim.cmd.colorscheme "catppuccin"

-- Colorize hex codes
require("nvim-highlight-colors").setup({})

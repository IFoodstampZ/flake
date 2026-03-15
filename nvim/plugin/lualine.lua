require("lualine").setup({
  extensions = {
    "fzf",
    "fugitive",
		"oil",
	},

	sections = {
		lualine_b = { "branch" },
		
		lualine_c = {
			{
				"filename",
				path = 1,

				fmt = function(filename)
					if filename:match("^/nix/store") then
						return vim.fn.expand("%:t")
					end
					return filename
				end,
			},
		},
		lualine_x = {
			{
				"lsp_status",
				icon = "",
				color = { fg = "Gray" },
			},
		},
		lualine_y = { "filetype" },
		lualine_z = { "location" },
	},
})
		



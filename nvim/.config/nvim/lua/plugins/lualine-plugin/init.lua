require("lualine").setup({
	options = {
		icons_enabled = true,
		theme = "auto",
		component_separators = "|",
		section_separators = "",
		disabled_filetypes = {},
		always_divide_middle = false,
	},
	sections = {
		lualine_a = {
			{
				"mode",
				fmt = function(str)
					-- only show first character of mode
					return str:sub(1, 1)
				end,
			},
		},
		lualine_b = { { "filename", path = 1 } },
		lualine_c = {},
		lualine_x = { "branch", "diff", "diagnostics" },
		lualine_y = { "encoding", "filetype" },
		lualine_z = { "location" },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = { { "filename", path = 1 } },
		lualine_c = {},
		lualine_x = {},
		lualine_y = { "encoding", "filetype" },
		lualine_z = {},
	},
	tabline = {},
})

local gps = require("nvim-gps")

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
					-- only show first character of modeq
					return str:sub(1, 1)
				end,
			},
		},
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = {
			{
				"filename",
				path = 1,
			},
			{ gps.get_location, cond = gps.is_available },
		},
		lualine_x = { "encoding", "filetype" },
		lualine_y = {},
		lualine_z = { "location" },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {},
	extensions = { "fugitive" },
})

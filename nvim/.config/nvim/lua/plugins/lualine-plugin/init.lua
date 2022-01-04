local status_ok, gps = pcall(require, "nvim-gps")
if not status_ok then
	return
end

require("lualine").setup({
	options = {
		icons_enabled = true,
		theme = "auto",
		component_separators = "｜",
		section_separators = "｜",
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
		lualine_b = {},
		lualine_c = {
			{ gps.get_location, cond = gps.is_available },
		},
		lualine_x = { "branch", "diff", "diagnostics" },
		lualine_y = { "encoding", "filetype" },
		lualine_z = { "location" },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = {},
		lualine_y = { "encoding", "filetype" },
		lualine_z = {},
	},
	tabline = {},
	extensions = { "fugitive" },
})

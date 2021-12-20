require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"javascript",
		"html",
		"css",
		"bash",
		"lua",
		"json",
		"python",
		"vim",
		"toml",
		"yaml",
		"rust",
		"dockerfile",
	},
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
	indent = {
		enable = true,
	},
	rainbow = { enable = true, extended_mode = true },
})

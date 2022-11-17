require("nvim-treesitter.configs").setup({
	ensure_installed = "all",
	highlight = { enable = true },
	indent = {
		enable = true,
		disable = { "python" }, -- https://github.com/nvim-treesitter/nvim-treesitter/issues/1573
	},
	rainbow = { enable = true, extended_mode = true },
})

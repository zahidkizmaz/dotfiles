local tag_file_location = "~/.cache/tags/" .. string.gsub(vim.fn.getcwd(), "/", "-"):sub(2) .. "-tags"
require("fzf-lua").setup({
	height = 0.95,
	fzf_opts = { ["--layout"] = "default" },
	winopts = {
		preview = { layout = "vertical", vertical = "up:70%" },
	},
	tags = { ctags_file = tag_file_location },
	btags = { ctags_file = tag_file_location },
	lsp = { async_or_timeout = 10000 },
	previewers = {
		builtin = {
			-- use `viu` for image previews
			extensions = {
				-- neovim terminal only supports `viu` block output
				["png"] = { "viu", "-b" },
				["jpg"] = { "viu", "-b" },
				["gif"] = { "viu", "-b" },
			},
		},
	},
})

require("nvim-tree").setup({
	disable_netrw = true,
	hijack_netrw = true,
	open_on_setup = false,
	open_on_tab = false,
	update_to_buf_dir = {
		enable = true,
		auto_open = true,
	},
	diagnostics = {
		enable = true,
	},
	auto_close = false,
	hijack_cursor = false,
	update_cwd = false,
	update_focused_file = {
		enable = true,
		update_cwd = false,
		ignore_list = { "fzf", "help", "git" },
	},
	ignore_ft_on_setup = { "git", "man", "help" },
	system_open = {
		cmd = nil,
		args = {},
	},
	filters = {
		dotfiles = false,
		custom = { ".git", "node_modules", "dist" },
	},
	view = {
		width = 40,
		side = "left",
		auto_resize = true,
		mappings = {
			custom_only = false,
		},
	},
	git = {
		enable = true,
		ignore = true,
		timeout = 400,
	},
	icons = {
		default = "",
		git = {
			unstaged = "✗",
			staged = "✓",
			unmerged = "",
			renamed = "➜",
			untracked = "★",
		},
		folder = {
			default = "",
			open = "",
		},
	},
})

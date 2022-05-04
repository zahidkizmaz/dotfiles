vim.g.neo_tree_remove_legacy_commands = 1

require("neo-tree").setup({
	indent = {
		indent_size = 2,
		padding = 0, -- no extra padding on left hand side
	},
	filesystem = {
		follow_current_file = true,
	},
})

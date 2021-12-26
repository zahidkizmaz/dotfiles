local wk = require("which-key")

------------------------
-- Telescope Bindings --
------------------------
wk.register({
	["<leader>f"] = {
		name = "Telescope",
		f = { "<cmd>Telescope find_files<cr>", "Find File" },
		g = { "<cmd>Telescope git_files<cr>", "Find Git File" },
		s = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Current File Fuzzy Search" },
		r = { "<cmd>Telescope lsp_references<cr>", "Find References" },
		h = { "<cmd>Telescope help_tags<cr>", "Telescope Help Tags" },
	},
})
wk.register({
	["<leader>rg"] = { "<cmd>Telescope live_grep<cr>", "Ripgrep Search" },
	["<leader>gs"] = { "<cmd>Telescope grep_string<cr>", "Ripgrep Current Word" },
	["<leader>ca"] = {
		"<cmd>lua require'telescope.builtin'.lsp_code_actions(require('telescope.themes').get_cursor({ previewer = false }))<cr>",
		"LSP Code Actions",
	},
})

--------------
-- NvimTree --
--------------
wk.register({ ["<C-n>"] = { "<cmd>NvimTreeToggle<cr>", "Toggle NvimTree" } })

--------------
-- FloaTerm --
--------------
wk.register({ ["<C-t>"] = { "<cmd>FloatermToggle<cr>", "Toggle Terminal" } })

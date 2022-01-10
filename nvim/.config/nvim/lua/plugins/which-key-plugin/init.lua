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
		S = { "<cmd>Telescope lsp_document_symbols<cr>", "Current File Symbol Search" },
		r = { "<cmd>Telescope lsp_references<cr>", "Find References" },
		h = { "<cmd>Telescope help_tags<cr>", "Telescope Help Tags" },
		b = { "<cmd>Telescope buffers<cr>", "Telescope Buffers" },
		d = {
			"<cmd>lua require'telescope.builtin'.diagnostics(require('telescope.themes').get_cursor({ previewer = false }))<cr>",
			"LSP Document Diagnostics",
		},
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

--------------
-- TrueZen --
--------------
wk.register({ ["<leader>zm"] = { "<cmd>TZAtaraxis<cr>", "Toggle Zen Mode" } })

----------------
-- Tabs --
----------------
wk.register({
	["<leader>t"] = {
		name = "Tab Movement",
		t = { "<cmd>tabnew<cr>", "Create New Tab" },
		c = { "<cmd>tabclose<cr>", "Close Tab" },
		n = { "<cmd>tabnext<cr>", "Next Tab" },
		p = { "<cmd>tabprevious<cr>", "Previous Tab" },
	},
})

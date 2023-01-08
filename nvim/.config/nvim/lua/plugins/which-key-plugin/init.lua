local wk = require("which-key")

------------------------
-- FzfLua Bindings --
------------------------
wk.register({
	["<leader>f"] = {
		name = "FzfLua",
		l = { "<cmd>FzfLua<cr>", "FzfLua" },
		f = { "<cmd>FzfLua files<cr>", "Find File" },
		g = { "<cmd>FzfLua git_files<cr>", "Find Git File" },
		s = { "<cmd>FzfLua btags<cr>", "Current File Fuzzy Search" },
		r = { "<cmd>FzfLua lsp_references<cr>", "Find References" },
		t = { "<cmd>FzfLua tags<cr>", "FzfLua Tags" },
		h = { "<cmd>FzfLua help_tags<cr>", "FzfLua Help Tags" },
		b = { "<cmd>FzfLua buffers<cr>", "FzfLua Buffers" },
		d = { "<cmd>FzfLua lsp_definitions<cr>", "FzfLua Definitions" },
	},
})
wk.register({
	["<leader>rg"] = { "<cmd>FzfLua live_grep<cr>", "Ripgrep Search" },
	["<leader>gs"] = { "<cmd>FzfLua grep_cword<cr>", "Ripgrep Current Word" },
	["<leader>ca"] = { "<cmd>FzfLua lsp_code_actions<cr>", "LSP Code Actions" },
	["<leader>bl"] = { "<cmd>FzfLua blines<cr>", "Buffer Line Search" },
	["<leader>ds"] = { "<cmd>FzfLua lsp_document_symbols<cr>", "Document Symbols" },
})

--------------
-- Neotree --
--------------
wk.register({ ["<C-n>"] = {
	function()
		vim.cmd("Neotree toggle")
		vim.cmd("wincmd =")
	end,
	"Toggle Neotree",
} })
wk.register({ ["<leader>ng"] = { "<cmd>Neotree float git_status<cr>", "Neotree Git Status" } })

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

-------------
-- Packages -
-------------
wk.register({ ["<leader>ps"] = { "<cmd>Lazy sync<cr>", "Lazy Sync" } })

----------------
-- Winshift --
----------------
wk.register({
	["<C-W>"] = {
		name = "Window Movement",
		m = { "<cmd>WinShift<cr>", "Run WinShift" },
		["<C-m>"] = { "<cmd>WinShift<cr>", "Run WinShift" },
	},
})

--------------
-- Undotree --
--------------
wk.register({ ["<leader>uu"] = { "<cmd>UndotreeToggle | UndotreeFocus<cr>", "Undotree Toggle" } })
wk.register({ ["<leader>uf"] = { "<cmd>UndotreeFocus<cr>", "Undotree Focus" } })

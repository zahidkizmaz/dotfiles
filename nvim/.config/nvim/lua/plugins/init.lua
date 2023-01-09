require("plugins.init_lazy")
require("lazy").setup({
	{
		"catppuccin/nvim",
		name = "catppuccin",
		config = function()
			require("plugins.catpuccin-plugin")
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "kyazdani42/nvim-web-devicons" },
		event = "VeryLazy",
		config = function()
			require("plugins.lualine-plugin")
		end,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		event = "BufReadPre",
		config = function()
			require("plugins.indent-blankline-plugin")
		end,
	},
	{ "norcalli/nvim-colorizer.lua", config = true, event = "BufReadPre" },
	{ "kylechui/nvim-surround", config = true, event = "InsertEnter" },
	{
		"iamcco/markdown-preview.nvim",
		ft = "markdown",
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
	},
	{
		"sindrets/winshift.nvim",
		keys = {
			{ "<C-W>m", "<cmd>WinShift<cr>", desc = "Run WinShift" },
			{ "<C-W><C-m>", "<cmd>WinShift<cr>", desc = "Run WinShift" },
		},
	},
	{
		"mbbill/undotree",
		keys = {
			{ "<leader>uf", "<cmd>UndotreeFocus<cr>", desc = "Undotree Focus" },
			{ "<leader>uu", "<cmd>UndotreeToggle | UndotreeFocus<cr>", desc = "Undotree Toggle" },
		},
	},
	---------------------

	-----------------
	-- Git Plugins --
	-----------------
	{
		"rhysd/committia.vim", -- nice commit setup,
		config = function()
			vim.g.committia_open_only_vim_starting = 0
		end,
	},
	{
		"ruifm/gitlinker.nvim", -- Open current working line in remove git host
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("plugins.gitlinker-plugin")
		end,
		keys = {
			{
				"<leader>hh",
				'<cmd>lua require"gitlinker".get_buf_range_url("n")<cr>',
				desc = "Create VCS remote link for line",
				mode = "n",
			},
			{
				"<leader>hh",
				'<cmd>lua require"gitlinker".get_buf_range_url("v")<cr>',
				desc = "Create VCS remote link for line",
				mode = "v",
			},
		},
	},
	{
		"lewis6991/gitsigns.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("plugins.gitsigns-plugin")
		end,
	},
	-----------------

	---------------------
	-- Auto Completion --
	---------------------
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			{ "hrsh7th/cmp-path" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-nvim-lua" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-nvim-lsp-signature-help" },
			{ "saadparwaiz1/cmp_luasnip" },
			{
				"tzachar/cmp-tabnine",
				build = "./install.sh",
				config = function()
					require("plugins.cmp-plugin.tabnine")
				end,
			},
			{
				"L3MON4D3/LuaSnip",
				config = function()
					require("luasnip.loaders.from_vscode").load({})
				end,
			},
			{ "rafamadriz/friendly-snippets" },
		},
		config = function()
			require("plugins.cmp-plugin")
		end,
	},
	---------------------

	-------------------------
	-- LSP Related Plugins --
	-------------------------
	{ "neovim/nvim-lspconfig" },
	{ "williamboman/mason.nvim", config = true },
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("lsp")
		end,
	},
	{
		"ibhagwan/fzf-lua",
		config = function()
			require("plugins.fzf-lua-plugin")
		end,
		keys = {
			{ "<leader>fl", "<cmd>FzfLua<cr>", desc = "FzfLua" },
			{ "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Find File" },
			{ "<leader>fg", "<cmd>FzfLua git_files<cr>", desc = "Find Git File" },
			{ "<leader>fs", "<cmd>FzfLua btags<cr>", desc = "Current File Fuzzy Search" },
			{ "<leader>fr", "<cmd>FzfLua lsp_references<cr>", desc = "Find References" },
			{ "<leader>ft", "<cmd>FzfLua tags<cr>", desc = "FzfLua Tags" },
			{ "<leader>fh", "<cmd>FzfLua help_tags<cr>", desc = "FzfLua Help Tags" },
			{ "<leader>fb", "<cmd>FzfLua buffers<cr>", desc = "FzfLua Buffers" },
			{ "<leader>fd", "<cmd>FzfLua lsp_definitions<cr>", desc = "FzfLua Definitions" },
			{ "<leader>rg", "<cmd>FzfLua live_grep<cr>", desc = "Ripgrep Search" },
			{ "<leader>gs", "<cmd>FzfLua grep_cword<cr>", desc = "Ripgrep Current Word" },
			{ "<leader>ca", "<cmd>FzfLua ls_code_actions<cr>", desc = "LSP Code Actions" },
			{ "<leader>bl", "<cmd>FzfLua blines<cr>", desc = "Buffer Line Search" },
			{ "<leader>ds", "<cmd>FzfLua ls_document_symbols<cr>", desc = "Document Symbols" },
		},
	},
	-------------------------------

	-----------------------------
	-- Dev Environment Plugins --
	-----------------------------
	{ "gpanders/editorconfig.nvim" },
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("plugins.treesitter-plugin")
		end,
	},
	{ "nvim-treesitter/nvim-treesitter-textobjects", event = "BufReadPre" },
	{ "nvim-treesitter/nvim-treesitter-context", event = "BufReadPre" },
	{ "p00f/nvim-ts-rainbow", event = "VeryLazy" },
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v2.x",
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{ "kyazdani42/nvim-web-devicons" },
			{ "MunifTanjim/nui.nvim" },
		},
		config = function()
			require("plugins.neotree-plugin")
		end,
		keys = {
			{ "<C-n>", "<cmd>Neotree toggle<cr>", desc = "Toggle Neotree" },
		},
	},
	{
		"jose-elias-alvarez/null-ls.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("plugins.null-ls-plugin")
		end,
	},
	{
		"numToStr/Comment.nvim",
		event = "VeryLazy",
		config = true,
	},
	{
		"Pocco81/TrueZen.nvim",
		config = function()
			require("plugins.true-zen-plugin")
		end,
		keys = {
			{ "<leader>zm", "<cmd>TZAtaraxis<cr>", desc = "Toggle Zen Mode" },
		},
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("plugins.autopairs-plugin")
		end,
	},
	{
		"danymat/neogen",
		cmd = { "Neogen" },
		config = function()
			require("plugins.neogen-plugin")
		end,
	},
	{
		"ludovicchabant/vim-gutentags",
		config = function()
			require("plugins.gutentags-plugin")
		end,
	},
	{
		"j-hui/fidget.nvim",
		event = "VeryLazy",
		config = function()
			require("plugins.fidget-plugin")
		end,
	},
})

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
		config = function()
			require("plugins.lualine-plugin")
		end,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			require("plugins.indent-blankline-plugin")
		end,
	},
	{ "norcalli/nvim-colorizer.lua", config = true },
	{
		"folke/which-key.nvim",
		config = function()
			require("plugins.which-key-plugin")
		end,
	},
	{ "kylechui/nvim-surround", config = true, event = "InsertEnter" },
	{
		"iamcco/markdown-preview.nvim",
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
	},
	{ "sindrets/winshift.nvim" },
	{
		"mbbill/undotree",
		cmd = { "UndotreeToggle" },
	},
	---------------------

	-----------------
	-- Git Plugins --
	-----------------
	{ "rhysd/committia.vim" }, -- nice commit setup,
	{
		"ruifm/gitlinker.nvim", -- Open current working line in remove git host
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("plugins.gitlinker-plugin")
		end,
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
		cmd = { "FzfLua" },
		config = function()
			require("plugins.fzf-lua-plugin")
		end,
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
	{ "nvim-treesitter/nvim-treesitter-textobjects" },
	{ "nvim-treesitter/nvim-treesitter-context" },
	{ "p00f/nvim-ts-rainbow" },
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v2.x",
		cmd = { "Neotree" },
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{ "kyazdani42/nvim-web-devicons" },
			{ "MunifTanjim/nui.nvim" },
		},
		config = function()
			require("plugins.neotree-plugin")
		end,
	},
	{
		"jose-elias-alvarez/null-ls.nvim",
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
		cmd = { "TZAtaraxis", "TZMinimalist", "TZFocus" },
		config = function()
			require("plugins.true-zen-plugin")
		end,
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
		config = function()
			require("plugins.fidget-plugin")
		end,
	},
})
